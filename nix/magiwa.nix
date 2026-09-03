# Tunables for magiwa (../magiwa), written out by home-manager as
# ~/.config/magiwa/config.json and read at startup.
#
# They are not compile-time constants because changing one would then mean a
# rebuild and a re-sign, which risks dropping the Accessibility grant.
#
# borderWidth has to match services.jankyborders.width in nix-darwin: the
# border straddles each window frame, and magiwa subtracts that reach so the
# seam between two tiled windows looks as wide as the gap at the screen edge.
# home-manager is a standalone configuration here and cannot read nix-darwin's
# config, so both sides import this file instead.
{
  gap = 8.0; # margin at the screen edges, in pt
  borderWidth = 8.0; # JankyBorders border width, in pt
  snapEdge = 12.0; # how close to an edge a drag has to end to snap, in pt
  snapCorner = 0.25; # top/bottom band that snaps to a quarter, as a height fraction
  dragSlop = 6.0; # pointer travel before a press counts as a drag, in pt
  titleBarHeight = 30.0; # band at the top of a window treated as its title bar, in pt
  animationDuration = 0.18; # seconds the green button takes to resize, 0 for instant
  previewAlpha = 0.7; # snap preview opacity, lower shows more of what is behind
}
