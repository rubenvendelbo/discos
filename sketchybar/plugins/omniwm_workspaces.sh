#!/usr/bin/env bash
# Workspace highlight + app icons from OmniWM (needs ipcEnabled = true in
# omniwm/settings.toml). App icons are Nerd Font glyphs from helpers/app_icon.sh.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/helpers/app_icon.sh"
source "$CONFIG_DIR/colors.sh"

WS_DATA="$(omniwmctl query workspaces --format json 2>/dev/null)" || exit 0
WIN_DATA="$(omniwmctl query windows --fields app,workspace --format json 2>/dev/null)"
[ -z "$WIN_DATA" ] && WIN_DATA='{}'

# One line per workspace: rawName, visible, unique bundle ids (\x1f separated).
# isFocused tracks window focus and lags behind; isVisible is the workspace
# actually shown on its monitor.
rows=$(printf '%s\n' "$WS_DATA" | jq -r --argjson win "$WIN_DATA" '
  ($win.result.payload.windows // []) as $w
  | .result.payload.workspaces[]
  | .rawName as $n
  | [$n, (.isVisible | tostring),
     ([$w[] | select(.workspace.rawName == $n) | (.app.bundleId // .app.name)] | unique | join("\u001f"))]
  | @tsv')

args=()
while IFS=$'\t' read -r name visible bundle_ids; do
  icons=""
  if [ -n "$bundle_ids" ]; then
    IFS=$'\x1f' read -ra list <<<"$bundle_ids"
    for bid in "${list[@]}"; do
      icons+=$(app_icon "$bid")
    done
  fi

  args+=(--set "omniwm_space.$name")

  # The visible workspace's icon and app icons take JankyBorders' color
  if [ "$visible" = "true" ]; then
    args+=(icon.highlight=on label.color=0xff${HIGHLIGHT:2})
  else
    args+=(icon.highlight=off label.color=0xff${FG_PRIMARY:2})
  fi

  if [ -n "$icons" ]; then
    args+=(label="$icons" label.drawing=on label.padding_left=0 label.padding_right=7)
  else
    args+=(label.drawing=off)
  fi
done <<<"$rows"

[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}" 2>/dev/null
exit 0
