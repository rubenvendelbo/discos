local icons = require "icons"
local colors = require("colors").sections.calendar
local settings = require "settings"
local press = require "helpers.press"

local cal = sbar.add("item", "calendar", {
  icon = {
    padding_left = 8,
    padding_right = 4,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
    },
  },
  label = {
    string = icons.separators.left .. " " .. icons.calendar,
    color = colors.label,
    align = "left",
    padding_right = 8,
  },
  padding_left = 10,
  position = "right",
  update_freq = 30,
  click_script = "open -a 'Calendar'",
})

cal:subscribe("mouse.clicked", function()
  press(cal, { 10, 4 })
end)

cal:subscribe({ "forced", "routine", "system_woke" }, function()
  cal:set { icon = os.date "%H:%M" }
end)
