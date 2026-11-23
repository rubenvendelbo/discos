# Bar colors, driven by the discOS palette (discos/templates/sketchybar.sh.tmpl).
# Role names follow adriankarlen/dots (Rosé Pine), so on rose-pine this
# reproduces the original. Sourced by sketchybarrc and plugins.

if ! source "${DISCOS_HOME:-$HOME/.config/discos}/current-theme/sketchybar.sh" 2>/dev/null; then
  THEME_VARIANT="dark"
  BASE="0x191724" SURFACE="0x1f1d2e" OVERLAY="0x26233a" MUTED="0x6e6a86"
  SUBTLE="0x908caa" TEXT="0xe0def4" RED="0xeb6f92" ORANGE="0xf6c177"
  YELLOW="0xebbcba" GREEN="0x31748f" CYAN="0x9ccfd8" BLUE="0xc4a7e7"
  MAGENTA="0xf6c177" ACTIVE="0xc4a7e7"
  ACCENTS="$RED $BLUE $YELLOW $CYAN $GREEN $ORANGE"
fi

# Base colors
BG_BASE=$BASE
BG_SURFACE=$SURFACE
BG_OVERLAY=$OVERLAY

# Accent colors
IRIS=$BLUE
LOVE=$RED
FOAM=$CYAN
PINE=$GREEN
GOLD=$ORANGE
ROSE=$YELLOW

# Text colors
FG_PRIMARY=$TEXT
FG_SECONDARY=$SUBTLE
FG_DIM=$MUTED

# Highlight for the visible workspace, shared with JankyBorders
HIGHLIGHT=$ACTIVE

# close <0xRRGGBB> <0xRRGGBB>: succeeds when the two are hard to tell apart
# ("redmean" weighted RGB distance, squared)
close() {
  local a=$(($1)) b=$(($2))
  local r1=$((a >> 16 & 255)) g1=$((a >> 8 & 255)) b1=$((a & 255))
  local r2=$((b >> 16 & 255)) g2=$((b >> 8 & 255)) b2=$((b & 255))
  local rm=$(((r1 + r2) / 2)) dr=$((r1 - r2)) dg=$((g1 - g2)) db=$((b1 - b2))
  (((((512 + rm) * dr * dr) >> 8) + 4 * dg * dg + (((767 - rm) * db * db) >> 8) < SPACE_COLOR_MIN_DIST ** 2))
}
SPACE_COLOR_MIN_DIST=${SPACE_COLOR_MIN_DIST:-60}

# Workspace colors (RRGGBB): accents in upstream's order, minus any that would
# look like the highlight, vanish into the bar, or duplicate an earlier pick.
# Text colors are a last resort for palettes with few distinct accents.
SPACE_COLORS=()
for c in $ACCENTS $FG_PRIMARY $FG_SECONDARY; do
  close "$c" "$HIGHLIGHT" && continue
  close "$c" "$BG_BASE" && continue
  for s in "${SPACE_COLORS[@]}"; do
    close "$c" "0x$s" && continue 2
  done
  SPACE_COLORS+=("${c:2}")
done
[ ${#SPACE_COLORS[@]} -eq 0 ] && SPACE_COLORS=("${FG_PRIMARY:2}")
