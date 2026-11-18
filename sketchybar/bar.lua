local colors = require("colors").sections.bar

-- Floating, rounded bar. OmniWM's outer top gap must clear
-- y_offset + height (see omniwm/settings.toml [gaps.outer]).
sbar.bar {
  topmost = "window",
  height = 40,
  color = colors.bg,
  padding_right = 4,
  padding_left = 4,
  margin = 10,
  corner_radius = 12,
  y_offset = 4,
  border_color = colors.border,
  border_width = 0,
  blur_radius = 40,
}
