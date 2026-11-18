-- Device switching in the popup needs `brew install switchaudio-osx`.
local colors = require("colors").sections.widgets.volume
local icons = require "icons"

local popup_width = 250

local volume_icon = sbar.add("item", "widgets.volume", {
  position = "right",
  icon = { color = colors.icon },
  label = { drawing = false },
  background = { drawing = false },
  popup = {
    align = "center",
    y_offset = 2,
  },
  padding_right = 8,
})

local volume_slider = sbar.add("slider", popup_width, {
  position = "popup." .. volume_icon.name,
  slider = {
    highlight_color = colors.slider.highlight,
    background = {
      height = 12,
      corner_radius = 6,
      color = colors.slider.bg,
      border_color = colors.slider.border,
      border_width = 2,
    },
    knob = {
      string = "􀀁",
      drawing = true,
    },
  },
  background = { drawing = false },
  click_script = 'osascript -e "set volume output volume $PERCENTAGE"',
})

volume_icon:subscribe("volume_change", function(env)
  local volume = tonumber(env.INFO) or 0
  local icon = icons.volume._0
  if volume > 60 then
    icon = icons.volume._100
  elseif volume > 30 then
    icon = icons.volume._66
  elseif volume > 10 then
    icon = icons.volume._33
  elseif volume > 0 then
    icon = icons.volume._10
  end

  volume_icon:set { icon = icon }
  volume_slider:set { slider = { percentage = volume } }
end)

local function volume_collapse_details()
  if volume_icon:query().popup.drawing ~= "on" then
    return
  end
  volume_icon:set { popup = { drawing = false } }
  sbar.remove "/volume.device\\.*/"
end

local function volume_toggle_details(env)
  if env.BUTTON == "right" then
    sbar.exec "open 'x-apple.systempreferences:com.apple.Sound-Settings.extension'"
    return
  end

  if volume_icon:query().popup.drawing == "on" then
    volume_collapse_details()
    return
  end

  volume_icon:set { popup = { drawing = true } }
  sbar.exec("SwitchAudioSource -t output -c", function(result)
    local current = result:sub(1, -2)
    sbar.exec("SwitchAudioSource -a -t output", function(available)
      local counter = 0
      for device in string.gmatch(available, "[^\r\n]+") do
        local color = current == device and colors.popup.highlight or colors.popup.item
        sbar.add("item", "volume.device." .. counter, {
          position = "popup." .. volume_icon.name,
          width = popup_width,
          align = "center",
          label = { string = device, color = color },
          background = { drawing = false },
          click_script = 'SwitchAudioSource -s "'
            .. device
            .. '" && sketchybar --set /volume.device\\.*/ label.color='
            .. colors.popup.item
            .. " --set $NAME label.color="
            .. colors.popup.highlight,
        })
        counter = counter + 1
      end
    end)
  end)
end

volume_icon:subscribe("mouse.clicked", volume_toggle_details)
volume_icon:subscribe("mouse.scrolled", function(env)
  sbar.exec(
    'osascript -e "set volume output volume (output volume of (get volume settings) + ' .. env.SCROLL_DELTA .. ')"'
  )
end)
