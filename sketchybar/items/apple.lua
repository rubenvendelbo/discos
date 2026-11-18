local colors = require("colors").sections
local icons = require "icons"
local press = require "helpers.press"

local apple = sbar.add("item", "apple", {
  icon = {
    font = { size = 16 },
    string = icons.apple,
    padding_right = 15,
    padding_left = 15,
    color = colors.apple,
  },
  label = { drawing = false },
  click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

apple:subscribe("mouse.clicked", function()
  press(apple)
end)
