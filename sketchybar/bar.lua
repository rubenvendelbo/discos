local colors = require("colors")

sbar.bar({
  position = "top",
  height = 32,
  color = colors.bar,
  padding_left = 8,
  padding_right = 8,
})

sbar.default({
  icon  = { font = "JetBrains Mono:Bold:13.0", color = colors.text },
  label = { font = "JetBrains Mono:Medium:13.0", color = colors.text },
  padding_left = 4,
  padding_right = 4,
})
