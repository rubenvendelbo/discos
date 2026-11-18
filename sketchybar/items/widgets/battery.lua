local icons = require "icons"
local colors = require("colors").sections.widgets.battery

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  label = { drawing = false },
  background = { drawing = false },
  padding_left = 8,
  padding_right = 4,
  update_freq = 180,
  popup = { align = "center", y_offset = 4 },
})

local remaining_time = sbar.add("item", {
  position = "popup." .. battery.name,
  icon = {
    string = "Time remaining:",
    width = 100,
    align = "left",
  },
  label = {
    string = "??:??h",
    width = 100,
    align = "right",
  },
  background = { drawing = false },
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = "!"
    local color = colors.high
    local charge = tonumber(batt_info:match "(%d+)%%")

    if batt_info:find "AC Power" then
      icon = icons.battery.charging
    elseif not charge then
      color = colors.low
    elseif charge > 80 then
      icon = icons.battery._100
    elseif charge > 60 then
      icon = icons.battery._75
    elseif charge > 40 then
      icon = icons.battery._50
    elseif charge > 30 then
      icon = icons.battery._50
      color = colors.mid
    elseif charge > 20 then
      icon = icons.battery._25
      color = colors.mid
    else
      icon = icons.battery._0
      color = colors.low
    end

    battery:set { icon = { string = icon, color = color } }
  end)
end)

battery:subscribe("mouse.clicked", function()
  local drawing = battery:query().popup.drawing
  battery:set { popup = { drawing = "toggle" } }

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local remaining = batt_info:match " (%d+:%d+) remaining"
      remaining_time:set { label = remaining and remaining .. "h" or "No estimate" }
    end)
  end
end)
