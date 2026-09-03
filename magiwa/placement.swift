// Tunables, the window placement geometry they feed, and the Accessibility
// primitives that apply it — all shared by the CLI and the daemon in
// main.swift. AX is driven directly so position/size updates land back-to-back
// with no visible staging, unlike System Events scripting where each step is a
// separate Apple Event round trip.

import Cocoa
import ApplicationServices

// gap in pt at the screen edges; the seam between tiled windows is derived
// from this in placementRect so the *visible* gap matches once borders draw
var GAP: CGFloat = 8
// JankyBorders draws a border this wide straddling each window's frame, so it
// reaches BORDER_WIDTH/2 past the frame. nix/magiwa.nix feeds this value and
// services.jankyborders.width from the same place, so they cannot drift.
var BORDER_WIDTH: CGFloat = 8
// apps may snap their size to an internal grid (terminal cell size etc.),
// so match the current frame against placement rects with this tolerance
let TOLERANCE: CGFloat = 25

struct Placement {
  // hyphen-joined screen edges the window is pinned to: "left", "top-right",
  // "center". An axis with no edge named stays centered.
  let anchor: String
  let w: CGFloat
  let h: CGFloat
  var maxW: CGFloat? = nil
  var maxH: CGFloat? = nil

  // the whole visible frame, inset by the gap — what the green button applies
  static let full = Placement(anchor: "center", w: 1, h: 1)
}

func note(_ message: String) {
  FileHandle.standardError.write(Data((message + "\n").utf8))
}

func fail(_ message: String) -> Never {
  note(message)
  exit(1)
}

// "<anchor>,<wRatio>,<hRatio>[,<maxW>,<maxH>];..."
func parsePlacements(_ spec: String) -> [Placement] {
  spec.split(separator: ";").map {
    let part = $0.split(separator: ",")
    guard part.count == 3 || part.count == 5,
      let w = Double(part[1]), let h = Double(part[2])
    else {
      fail("invalid placement: \($0)")
    }
    return Placement(
      anchor: String(part[0]), w: CGFloat(w), h: CGFloat(h),
      maxW: part.count == 5 ? Double(part[3]).map { CGFloat($0) } : nil,
      maxH: part.count == 5 ? Double(part[4]).map { CGFloat($0) } : nil)
  }
}

func copyElement(_ el: AXUIElement, _ attr: String) -> AXUIElement? {
  var value: CFTypeRef?
  guard AXUIElementCopyAttributeValue(el, attr as CFString, &value) == .success,
    let value, CFGetTypeID(value) == AXUIElementGetTypeID()
  else { return nil }
  return unsafeBitCast(value, to: AXUIElement.self)
}

func axFrame(of el: AXUIElement) -> CGRect? {
  var posValue: CFTypeRef?
  var sizeValue: CFTypeRef?
  guard AXUIElementCopyAttributeValue(el, kAXPositionAttribute as CFString, &posValue) == .success,
    AXUIElementCopyAttributeValue(el, kAXSizeAttribute as CFString, &sizeValue) == .success,
    let posValue, let sizeValue
  else { return nil }
  var pos = CGPoint.zero
  var size = CGSize.zero
  guard AXValueGetValue(unsafeBitCast(posValue, to: AXValue.self), .cgPoint, &pos),
    AXValueGetValue(unsafeBitCast(sizeValue, to: AXValue.self), .cgSize, &size)
  else { return nil }
  return CGRect(origin: pos, size: size)
}

// when AXEnhancedUserInterface is enabled on the app (left behind by Raycast,
// VoiceOver, AppleScript GUI scripting...), AX-driven moves animate with edge
// ghosting; disable it right before the writes
func disableEnhancedUI(_ app: AXUIElement) {
  AXUIElementSetAttributeValue(app, "AXEnhancedUserInterface" as CFString, kCFBooleanFalse)
}

func writeFrame(_ rect: CGRect, of win: AXUIElement) {
  var pos = rect.origin
  var size = CGSize(width: rect.width, height: rect.height)
  AXUIElementSetAttributeValue(win, kAXPositionAttribute as CFString, AXValueCreate(.cgPoint, &pos)!)
  AXUIElementSetAttributeValue(win, kAXSizeAttribute as CFString, AXValueCreate(.cgSize, &size)!)
}

func setFrame(_ rect: CGRect, of win: AXUIElement, in app: AXUIElement) {
  disableEnhancedUI(app)
  writeFrame(rect, of: win)
}

func lerp(_ a: CGRect, _ b: CGRect, _ t: CGFloat) -> CGRect {
  CGRect(
    x: a.minX + (b.minX - a.minX) * t, y: a.minY + (b.minY - a.minY) * t,
    width: a.width + (b.width - a.width) * t, height: a.height + (b.height - a.height) * t)
}

// Accessibility coordinates have a top-left origin on the primary screen while
// AppKit uses bottom-left, so y values are flipped between the two. Read this
// per call rather than once at launch: the daemon outlives display changes.
func primaryHeight() -> CGFloat { NSScreen.screens[0].frame.height }

// pick the screen actually containing the window — this process has no key
// window, so NSScreen.main would just report the primary screen
func screen(containing axRect: CGRect) -> NSScreen {
  let centerCocoa = CGPoint(x: axRect.midX, y: primaryHeight() - axRect.midY)
  return NSScreen.screens.first { $0.frame.contains(centerCocoa) } ?? NSScreen.screens[0]
}

// `vf` is a Cocoa (bottom-left) visible frame — the screen minus menu bar and Dock.
// The returned rect is in Accessibility (top-left) coordinates.
func placementRect(_ p: Placement, in vf: CGRect, primaryHeight: CGFloat) -> CGRect {
  // Inset every window edge from its fractional boundary on the visible frame:
  // a full GAP where the edge meets the screen, a wider INNER inset where it
  // borders another tiled window. A window border reaches BORDER_WIDTH/2 past
  // the frame; at the screen edge only one border spends that reach, but at a
  // seam both windows' borders do — so widen the inner inset to make the seam's
  // visible gap (2*inner − both reaches) equal the edge's (GAP − one reach).
  let inner = (GAP + BORDER_WIDTH / 2) / 2

  // fractional span of the visible frame on each axis. An axis with no edge
  // named in the anchor stays centered, so "left" is still a full-height half.
  let edges = Set(p.anchor.split(separator: "-").map(String.init))
  func span(_ ratio: CGFloat, _ low: String, _ high: String) -> (CGFloat, CGFloat) {
    if edges.contains(low) { return (0, ratio) }
    if edges.contains(high) { return (1 - ratio, 1) }
    return ((1 - ratio) / 2, (1 + ratio) / 2)
  }
  let (x0, x1) = span(p.w, "left", "right")
  let (y0, y1) = span(p.h, "bottom", "top")  // Cocoa y grows upward

  // an edge at fraction 0 or 1 touches the screen (full GAP); otherwise it
  // borders another window (GAP/2)
  var left = vf.minX + x0 * vf.width + (x0 <= 0 ? GAP : inner)
  let right = vf.minX + x1 * vf.width - (x1 >= 1 ? GAP : inner)
  var bottom = vf.minY + y0 * vf.height + (y0 <= 0 ? GAP : inner)  // Cocoa y
  let top = vf.minY + y1 * vf.height - (y1 >= 1 ? GAP : inner)
  var w = right - left
  var h = top - bottom

  // cap the size, keeping any anchored edge fixed and centering the rest
  if let maxW = p.maxW, w > maxW {
    if !edges.contains("left") { left += edges.contains("right") ? w - maxW : (w - maxW) / 2 }
    w = maxW
  }
  if let maxH = p.maxH, h > maxH {
    if !edges.contains("bottom") { bottom += edges.contains("top") ? h - maxH : (h - maxH) / 2 }
    h = maxH
  }

  // Accessibility uses a top-left origin, so flip the Cocoa top edge
  let y = primaryHeight - (bottom + h)
  return CGRect(x: left.rounded(), y: y.rounded(), width: w.rounded(), height: h.rounded())
}

func placementRect(_ p: Placement, on screen: NSScreen) -> CGRect {
  placementRect(p, in: screen.visibleFrame, primaryHeight: primaryHeight())
}

func near(_ a: CGFloat, _ b: CGFloat) -> Bool { abs(a - b) <= TOLERANCE }

func near(_ a: CGRect, _ b: CGRect) -> Bool {
  near(a.minX, b.minX) && near(a.minY, b.minY)
    && near(a.width, b.width) && near(a.height, b.height)
}

// MARK: - Edge snapping

// how close to a screen edge a drag has to end for the window to snap there.
// The system effectively requires the pointer to reach the edge and stop there,
// so anything above zero is already looser than the native gesture.
var SNAP_EDGE: CGFloat = 12
// band at the top and bottom of a side that snaps to a quarter rather than a
// half, as a fraction of the screen height
var SNAP_CORNER: CGFloat = 0.25
// pointer travel before a press counts as a drag rather than a click
var DRAG_SLOP: CGFloat = 6
// band at the top of a window frame treated as its title bar. AX exposes no
// rect for it and apps vary — 28pt is standard, unified toolbars are taller.
var TITLE_BAR_HEIGHT: CGFloat = 30
// roughly how long Cocoa takes to animate its own window frames. AX writes are
// synchronous IPC, so an app that relayouts slowly drops frames here — set to 0
// to go back to a single instant write.
var ANIMATION_DURATION: TimeInterval = 0.18
// NSVisualEffectView exposes no blur radius — the material fixes it, so fading
// the whole snap preview is the one knob left: the blurred layer turns
// translucent and what is really behind shows through under it.
var PREVIEW_ALPHA: CGFloat = 0.7

// screen rect in Accessibility (top-left) coordinates. Unlike visibleFrame this
// includes the menu bar, which is itself a snap target.
func axScreenFrame(_ screen: NSScreen) -> CGRect {
  let f = screen.frame
  return CGRect(x: f.minX, y: primaryHeight() - f.maxY, width: f.width, height: f.height)
}

func screen(containing axPoint: CGPoint) -> NSScreen? {
  let cocoa = CGPoint(x: axPoint.x, y: primaryHeight() - axPoint.y)
  // grown by a point because CGRect.contains excludes maxX/maxY: a pointer at
  // the menu bar reads y == 0 in AX coordinates, which maps exactly onto the
  // screen top and would otherwise match no screen at all — losing the very
  // gesture that snaps a window to fill
  return NSScreen.screens.first { $0.frame.insetBy(dx: -1, dy: -1).contains(cocoa) }
}

// Where a drag released at `point` should land, mirroring macOS's own edge
// tiling: the sides give halves, the corners give quarters, the menu bar gives
// fill, and the bottom edge on its own does nothing.
func snapPlacement(at point: CGPoint, on screen: NSScreen) -> Placement? {
  let s = axScreenFrame(screen)
  let corner = s.height * SNAP_CORNER
  let atLeft = point.x - s.minX <= SNAP_EDGE
  let atRight = s.maxX - point.x <= SNAP_EDGE
  // the whole menu bar is the fill target, matching the system: a drag fills
  // when it reaches the menu bar, not when it reaches the top row of pixels
  let menuBar = max(SNAP_EDGE, screen.frame.maxY - screen.visibleFrame.maxY)
  let atTop = point.y - s.minY <= menuBar

  // corners take precedence: the top-left corner is a quarter, not a fill
  if atLeft || atRight {
    let side = atLeft ? "left" : "right"
    if point.y - s.minY <= corner { return Placement(anchor: "top-\(side)", w: 0.5, h: 0.5) }
    if s.maxY - point.y <= corner { return Placement(anchor: "bottom-\(side)", w: 0.5, h: 0.5) }
    return Placement(anchor: side, w: 0.5, h: 1)
  }
  if atTop { return .full }
  return nil
}

// AX (top-left) rect back to Cocoa (bottom-left), for handing a placement to
// AppKit — the snap preview panel is positioned in Cocoa coordinates
func cocoaRect(fromAX r: CGRect) -> CGRect {
  CGRect(x: r.minX, y: primaryHeight() - r.maxY, width: r.width, height: r.height)
}

// MARK: - Config

// Tunables come from ~/.config/magiwa/config.json so they can be changed
// without a rebuild — rebuilding re-signs the bundle and restarts the agent,
// which is a slow loop for values that only get settled by feel. A missing
// file, an unreadable one, or an absent key each keep the default above.
func loadConfig() {
  let path = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".config/magiwa/config.json")
  guard let data = try? Data(contentsOf: path),
    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
  else { return }

  func number(_ key: String) -> CGFloat? {
    (json[key] as? NSNumber).map { CGFloat($0.doubleValue) }
  }
  if let v = number("gap") { GAP = v }
  if let v = number("borderWidth") { BORDER_WIDTH = v }
  if let v = number("snapEdge") { SNAP_EDGE = v }
  if let v = number("snapCorner") { SNAP_CORNER = v }
  if let v = number("dragSlop") { DRAG_SLOP = v }
  if let v = number("titleBarHeight") { TITLE_BAR_HEIGHT = v }
  if let v = number("animationDuration") { ANIMATION_DURATION = TimeInterval(v) }
  if let v = number("previewAlpha") { PREVIEW_ALPHA = v }
}
