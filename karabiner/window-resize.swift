// CLI to cycle the frontmost window through placements on its display.
//   window-resize "<anchor>,<wRatio>,<hRatio>[,<maxW>,<maxH>];..."
// (anchor: left|center|right; maxW/maxH cap the size in pixels)
// Build: deno task build-resizer (swiftc, see deno.jsonc)
// Talks to the Accessibility API directly so position/size updates land
// back-to-back with no visible staging — unlike System Events scripting,
// where each step is a separate Apple Event round trip.
// The calling process (karabiner_console_user_server when invoked from
// Karabiner-Elements) needs Accessibility permission.

import Cocoa
import ApplicationServices

// gap in pt at the screen edges; the seam between tiled windows is derived
// from this in placementRect so the *visible* gap matches once borders draw
let GAP: CGFloat = 8
// JankyBorders (~/.config/borders/bordersrc) draws a border this wide straddling
// each window's frame, so it reaches BORDER_WIDTH/2 past the frame — keep in sync
let BORDER_WIDTH: CGFloat = 8
// apps may snap their size to an internal grid (terminal cell size etc.),
// so match the current frame against placement rects with this tolerance
let TOLERANCE: CGFloat = 25

struct Placement {
  let anchor: String
  let w: CGFloat
  let h: CGFloat
  let maxW: CGFloat?
  let maxH: CGFloat?
}

func fail(_ message: String) -> Never {
  FileHandle.standardError.write(Data((message + "\n").utf8))
  exit(1)
}

guard CommandLine.arguments.count > 1 else {
  fail("usage: window-resize \"<anchor>,<wRatio>,<hRatio>;...\"")
}
let placements: [Placement] = CommandLine.arguments[1].split(separator: ";").map {
  let part = $0.split(separator: ",")
  guard part.count == 3 || part.count == 5,
    let w = Double(part[1]), let h = Double(part[2])
  else {
    fail("invalid placement: \($0)")
  }
  let maxW = part.count == 5 ? Double(part[3]) : nil
  let maxH = part.count == 5 ? Double(part[4]) : nil
  return Placement(
    anchor: String(part[0]), w: CGFloat(w), h: CGFloat(h),
    maxW: maxW.map { CGFloat($0) }, maxH: maxH.map { CGFloat($0) })
}

guard let app = NSWorkspace.shared.frontmostApplication else {
  fail("no frontmost application")
}
let appEl = AXUIElementCreateApplication(app.processIdentifier)

var winValue: CFTypeRef?
guard AXUIElementCopyAttributeValue(appEl, kAXFocusedWindowAttribute as CFString, &winValue) == .success,
  let winValue, CFGetTypeID(winValue) == AXUIElementGetTypeID()
else {
  fail("cannot get focused window (is Accessibility permission granted?)")
}
let win = unsafeBitCast(winValue, to: AXUIElement.self)

func axFrame(of win: AXUIElement) -> CGRect? {
  var posValue: CFTypeRef?
  var sizeValue: CFTypeRef?
  guard AXUIElementCopyAttributeValue(win, kAXPositionAttribute as CFString, &posValue) == .success,
    AXUIElementCopyAttributeValue(win, kAXSizeAttribute as CFString, &sizeValue) == .success,
    let posValue, let sizeValue
  else { return nil }
  var pos = CGPoint.zero
  var size = CGSize.zero
  guard AXValueGetValue(unsafeBitCast(posValue, to: AXValue.self), .cgPoint, &pos),
    AXValueGetValue(unsafeBitCast(sizeValue, to: AXValue.self), .cgSize, &size)
  else { return nil }
  return CGRect(origin: pos, size: size)
}

guard let current = axFrame(of: win) else {
  fail("cannot read window frame")
}

// Accessibility coordinates have a top-left origin on the primary screen
// while AppKit uses bottom-left, so y values are flipped between the two.
let primaryH = NSScreen.screens[0].frame.height

// pick the screen actually containing the window — this process has no key
// window, so NSScreen.main would just report the primary screen
let centerCocoa = CGPoint(x: current.midX, y: primaryH - current.midY)
let screen = NSScreen.screens.first { $0.frame.contains(centerCocoa) } ?? NSScreen.screens[0]
// visibleFrame excludes the menu bar and the Dock
let vf = screen.visibleFrame

func placementRect(_ p: Placement) -> CGRect {
  // Inset every window edge from its fractional boundary on the visible frame:
  // a full GAP where the edge meets the screen, a wider INNER inset where it
  // borders another tiled window. A window border reaches BORDER_WIDTH/2 past
  // the frame; at the screen edge only one border spends that reach, but at a
  // seam both windows' borders do — so widen the inner inset to make the seam's
  // visible gap (2*inner − both reaches) equal the edge's (GAP − one reach).
  let inner = (GAP + BORDER_WIDTH / 2) / 2

  // fractional horizontal span [x0, x1] of the visible frame for this anchor
  let x0: CGFloat, x1: CGFloat
  switch p.anchor {
  case "left": x0 = 0; x1 = p.w
  case "right": x0 = 1 - p.w; x1 = 1
  default: x0 = (1 - p.w) / 2; x1 = (1 + p.w) / 2  // centered
  }
  // vertical span is always centered
  let y0 = (1 - p.h) / 2, y1 = (1 + p.h) / 2

  // an edge at fraction 0 or 1 touches the screen (full GAP); otherwise it
  // borders another window (GAP/2)
  var left = vf.minX + x0 * vf.width + (x0 <= 0 ? GAP : inner)
  let right = vf.minX + x1 * vf.width - (x1 >= 1 ? GAP : inner)
  var bottom = vf.minY + y0 * vf.height + (y0 <= 0 ? GAP : inner)  // Cocoa y
  let top = vf.minY + y1 * vf.height - (y1 >= 1 ? GAP : inner)
  var w = right - left
  var h = top - bottom

  // cap the size, keeping the anchored edge fixed (left/right) or staying centered
  if let maxW = p.maxW, w > maxW {
    switch p.anchor {
    case "left": break
    case "right": left += w - maxW
    default: left += (w - maxW) / 2
    }
    w = maxW
  }
  if let maxH = p.maxH, h > maxH {
    bottom += (h - maxH) / 2  // vertically centered
    h = maxH
  }

  // Accessibility uses a top-left origin, so flip the Cocoa top edge
  let y = primaryH - (bottom + h)
  return CGRect(x: left.rounded(), y: y.rounded(), width: w.rounded(), height: h.rounded())
}
let rects = placements.map(placementRect)

// The window's current frame decides the cycle position: on a match the next
// placement is applied, otherwise the first one — so a newly targeted window
// always starts the cycle from the first placement.
func near(_ a: CGFloat, _ b: CGFloat) -> Bool { abs(a - b) <= TOLERANCE }
let matched = rects.firstIndex {
  near(current.minX, $0.minX) && near(current.minY, $0.minY)
    && near(current.width, $0.width) && near(current.height, $0.height)
}
let target = rects[((matched ?? -1) + 1) % rects.count]

// when AXEnhancedUserInterface is enabled on the app (left behind by Raycast,
// VoiceOver, AppleScript GUI scripting...), AX-driven moves animate with edge
// ghosting; disable it right before the writes
AXUIElementSetAttributeValue(appEl, "AXEnhancedUserInterface" as CFString, kCFBooleanFalse)

var pos = target.origin
var size = CGSize(width: target.width, height: target.height)
AXUIElementSetAttributeValue(win, kAXPositionAttribute as CFString, AXValueCreate(.cgPoint, &pos)!)
AXUIElementSetAttributeValue(win, kAXSizeAttribute as CFString, AXValueCreate(.cgSize, &size)!)
