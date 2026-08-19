// magiwa — window placement for macOS.
//
//   magiwa "<anchor>,<wRatio>,<hRatio>[,<maxW>,<maxH>];..."
//        cycle the frontmost window through placements on its display
//        (anchor: left|center|right; maxW/maxH cap the size in pixels)
//   magiwa
//        run as a daemon: the green button maximizes with a gap on the current
//        desktop instead of moving the window to its own Space
//   magiwa --selftest
//        check the gap math
//
// Build: magiwa/build.sh
// Both modes need Accessibility permission. The daemon holds its own, granted
// to Magiwa.app — TCC keys that to CFBundleIdentifier, so rebuilds keep it.
// The CLI is spawned by Karabiner-Elements, which TCC likely treats as the
// responsible process and covers with karabiner_console_user_server's grant.

import Cocoa
import ApplicationServices

// MARK: - CLI

func runCLI(_ spec: String) {
  guard let app = NSWorkspace.shared.frontmostApplication else {
    fail("no frontmost application")
  }
  let appEl = AXUIElementCreateApplication(app.processIdentifier)
  guard let win = copyElement(appEl, kAXFocusedWindowAttribute) else {
    fail("cannot get focused window (is Accessibility permission granted?)")
  }
  guard let current = axFrame(of: win) else {
    fail("cannot read window frame")
  }

  let rects = parsePlacements(spec).map { placementRect($0, on: screen(containing: current)) }
  // The window's current frame decides the cycle position: on a match the next
  // placement is applied, otherwise the first one — so a newly targeted window
  // always starts the cycle from the first placement.
  let matched = rects.firstIndex { near(current, $0) }
  setFrame(rects[((matched ?? -1) + 1) % rects.count], of: win, in: appEl)
}

// MARK: - Daemon

// AXUIElement is a CFType, so identity comparison is CFEqual — no need for the
// private _AXUIElementGetWindow to key windows by their CGWindowID.
struct WindowKey: Hashable {
  let el: AXUIElement
  init(_ el: AXUIElement) { self.el = el }
  static func == (a: Self, b: Self) -> Bool { CFEqual(a.el, b.el) }
  func hash(into hasher: inout Hasher) { hasher.combine(CFHash(el)) }
}

final class Daemon {
  private struct Target {
    let app: AXUIElement
    let win: AXUIElement
    let button: CGRect
  }

  // Roughly how long Cocoa takes to animate its own window frames. AX writes
  // are synchronous IPC, so an app that relayouts slowly drops frames here —
  // set to 0 to go back to a single instant write.
  private static let animationDuration: TimeInterval = 0.18

  private struct Animation {
    let timer: Timer
    let key: WindowKey
    let app: AXUIElement
    let to: CGRect
    let startButton: CGRect  // where the green button sat when we started
    let buttonOffset: CGPoint  // button origin relative to the window origin
    var frame: CGRect  // last frame written

    var button: CGRect {
      CGRect(
        x: frame.minX + buttonOffset.x, y: frame.minY + buttonOffset.y,
        width: startButton.width, height: startButton.height)
    }
  }

  private var tap: CFMachPort?
  private var pending = false
  private var animation: Animation?
  // ponytail: entries for windows closed while maximized are never reaped —
  // a few dozen bytes each. Add an AXObserver on kAXUIElementDestroyedNotification
  // if a long-lived daemon ever shows up in memory.
  private var restore: [WindowKey: CGRect] = [:]

  // Never AXIsProcessTrustedWithOptions(prompt: true) and never exit when the
  // grant is missing: as a launchd agent, exiting puts launchd right back here
  // and every restart pops another focus-stealing dialog. Wait quietly instead,
  // and pick the grant up whenever it arrives.
  func run() {
    if !start() {
      note("waiting for Accessibility permission — add Magiwa.app in")
      note("System Settings > Privacy & Security > Accessibility")
      Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] timer in
        if self?.start() == true { timer.invalidate() }
      }
    }
    CFRunLoopRun()
  }

  private func start() -> Bool {
    guard AXIsProcessTrusted() else { return false }

    let mask =
      (1 << CGEventType.leftMouseDown.rawValue) | (1 << CGEventType.leftMouseUp.rawValue)
    guard
      let tap = CGEvent.tapCreate(
        tap: .cgSessionEventTap, place: .headInsertEventTap,
        options: .defaultTap,  // .listenOnly could not swallow the click
        eventsOfInterest: CGEventMask(mask),
        callback: { _, type, event, refcon in
          let daemon = Unmanaged<Daemon>.fromOpaque(refcon!).takeUnretainedValue()
          return daemon.handle(type, event)
        },
        userInfo: Unmanaged.passUnretained(self).toOpaque())
    else { return false }
    self.tap = tap

    CFRunLoopAddSource(
      CFRunLoopGetMain(), CFMachPortCreateRunLoopSource(nil, tap, 0), .commonModes)
    CGEvent.tapEnable(tap: tap, enable: true)
    note("event tap active")
    return true
  }

  private func handle(_ type: CGEventType, _ event: CGEvent) -> Unmanaged<CGEvent>? {
    let pass = Unmanaged.passUnretained(event)
    switch type {
    case .tapDisabledByTimeout, .tapDisabledByUserInput:
      // the system drops a tap whose callback ran long or that the user
      // interrupted; nothing is delivered until it is switched back on
      if let tap { CGEvent.tapEnable(tap: tap, enable: true) }
      return pass

    case .leftMouseDown:
      // leave modified clicks to the system: Option+green is its own
      // Space-less zoom, and the rest belong to the app
      guard event.flags.intersection([.maskCommand, .maskAlternate, .maskControl, .maskShift])
        .isEmpty,
        let target = zoomTarget(at: event.location)
      else {
        pending = false
        return pass
      }
      // acted on here rather than on mouse-up: during an animation the button
      // moves under the pointer, so a release-still-over-the-button check would
      // reject the very clicks the swept hit test below exists to catch
      pending = true
      toggle(target)
      return nil  // swallowed, so the system never starts its full-screen transition

    case .leftMouseUp:
      guard pending else { return pass }
      pending = false
      return nil  // the release belongs to a press we took

    default:
      return pass
    }
  }

  // Only the frontmost app's focused window is claimed. Clicking the green
  // button of any other window falls through to the system, which keeps the
  // focus change that swallowing the click would otherwise eat.
  // ponytail: so a green button on a background window still goes full-screen.
  // To cover those, hit-test the click against CGWindowListCopyWindowInfo,
  // resolve the owning pid, and raise the window before applying the frame.
  private func zoomTarget(at point: CGPoint) -> Target? {
    // While our own animation is running, the app's AX server is busy serving
    // the frame writes and the queries below hit their 0.1s timeout — and a
    // miss falls through to the system, which full-screens the window. So
    // track the moving button ourselves, with no IPC at all.
    if let animation {
      // the app redraws behind our writes, so the button the user sees can be
      // anywhere along the path it has travelled — accept the swept area
      let swept = animation.startButton.union(animation.button)
      if swept.insetBy(dx: -3, dy: -3).contains(point) {
        return Target(app: animation.app, win: animation.key.el, button: animation.button)
      }
    }

    guard let app = NSWorkspace.shared.frontmostApplication else { return nil }
    let appEl = AXUIElementCreateApplication(app.processIdentifier)
    // AX calls are synchronous IPC; a hung app would stall this callback past
    // the tap's own timeout and get the tap disabled
    AXUIElementSetMessagingTimeout(appEl, 0.1)
    // AXZoomButton and AXFullScreenButton resolve to the same element, but apps
    // without full-screen support expose only the former
    guard let win = copyElement(appEl, kAXFocusedWindowAttribute),
      let button = copyElement(win, kAXZoomButtonAttribute),
      let rect = axFrame(of: button),
      rect.insetBy(dx: -3, dy: -3).contains(point)
    else { return nil }
    return Target(app: appEl, win: win, button: rect)
  }

  private func toggle(_ target: Target) {
    let key = WindowKey(target.win)
    let inFlight = animation?.key == key ? animation : nil
    // mid-flight, use the frame we last wrote rather than querying the busy app
    guard let current = inFlight?.frame ?? axFrame(of: target.win) else { return }
    // that frame sits somewhere in between and matches no placement, so judge
    // against where it was headed — otherwise a click during the animation
    // would save the halfway frame as the window's original size
    let settled = inFlight?.to ?? current
    let full = placementRect(.full, on: screen(containing: settled))
    let destination: CGRect
    if near(settled, full), let original = restore.removeValue(forKey: key) {
      destination = original
    } else {
      restore[key] = settled
      destination = full
    }
    animate(target, from: current, to: destination)
  }

  private func animate(_ target: Target, from: CGRect, to: CGRect) {
    if let previous = animation {
      // clicking the same window mid-flight just retargets from wherever it got
      // to, but another window would be left sitting at a partial frame
      previous.timer.invalidate()
      if previous.key != WindowKey(target.win) { writeFrame(previous.to, of: previous.key.el) }
      animation = nil
    }
    guard Self.animationDuration > 0 else { return setFrame(to, of: target.win, in: target.app) }

    disableEnhancedUI(target.app)  // once, not per frame
    let start = CACurrentMediaTime()
    let timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60, repeats: true) {
      [weak self] timer in
      let progress = min((CACurrentMediaTime() - start) / Self.animationDuration, 1)
      // ease-out cubic: most of the travel up front, like Cocoa's own moves
      let eased = 1 - pow(1 - progress, 3)
      let frame = progress >= 1 ? to : lerp(from, to, CGFloat(eased))
      writeFrame(frame, of: target.win)
      self?.animation?.frame = frame
      if progress >= 1 {
        timer.invalidate()
        self?.animation = nil
      }
    }
    animation = Animation(
      timer: timer, key: WindowKey(target.win), app: target.app, to: to,
      startButton: target.button,
      buttonOffset: CGPoint(
        x: target.button.minX - from.minX, y: target.button.minY - from.minY),
      frame: from)
  }
}

// MARK: - Self-test

func selfTest() {
  // a 1000x1000 primary screen with no menu bar or Dock keeps the arithmetic legible
  let vf = CGRect(x: 0, y: 0, width: 1000, height: 1000)
  func rect(_ p: Placement) -> CGRect { placementRect(p, in: vf, primaryHeight: 1000) }

  // maximized: one full GAP on every edge
  precondition(
    rect(.full) == CGRect(x: GAP, y: GAP, width: 1000 - 2 * GAP, height: 1000 - 2 * GAP),
    "full: \(rect(.full))")

  // the seam between two halves must *look* like the screen edge once borders
  // draw: each border eats BORDER_WIDTH/2, two of them at a seam and one at an edge
  let left = rect(Placement(anchor: "left", w: 0.5, h: 1))
  let right = rect(Placement(anchor: "right", w: 0.5, h: 1))
  precondition(
    right.minX - left.maxX - BORDER_WIDTH == GAP - BORDER_WIDTH / 2,
    "seam \(right.minX - left.maxX) vs edge \(left.minX)")

  // a capped placement stays pinned to its anchor and centers vertically
  let capped = rect(Placement(anchor: "right", w: 1, h: 1, maxW: 400, maxH: 400))
  precondition(capped.maxX == 1000 - GAP, "capped right edge: \(capped)")
  precondition(capped.midY == 500, "capped not vertically centered: \(capped)")

  print("ok")
}

// MARK: - Entry

switch CommandLine.arguments.dropFirst().first {
case .none: Daemon().run()
case "--selftest": selfTest()
case .some(let spec): runCLI(spec)
}
