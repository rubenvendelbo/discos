local icons = require "icons"
local colors = require("colors").sections.widgets.wifi
local settings = require "settings"

local iface = settings.wifi_interface
local popup_width = 250

local wifi = sbar.add("item", "widgets.wifi", {
  position = "right",
  icon = { color = colors.icon },
  label = { drawing = false },
  background = { drawing = false },
  popup = {
    align = "center",
    height = 30,
    y_offset = 2,
  },
  padding_left = 0,
  padding_right = 0,
})

local function detail(title)
  return sbar.add("item", {
    position = "popup." .. wifi.name,
    icon = {
      align = "left",
      string = title,
      width = popup_width / 2,
    },
    label = {
      string = "???.???.???.???",
      width = popup_width / 2,
      align = "right",
    },
    background = { drawing = false },
  })
end

local ip = detail "IP:"
local mask = detail "Subnet mask:"
local router = detail "Router:"

wifi:subscribe({ "wifi_change", "system_woke" }, function()
  -- The SSID is redacted on recent macOS, but it's still non-empty when connected.
  sbar.exec("ipconfig getsummary " .. iface .. [[ | awk -F ' SSID : '  '/ SSID : / {print $2}']], function(ssid)
    local connected = ssid ~= ""
    wifi:set {
      icon = {
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color = colors.icon,
      },
    }

    sbar.exec([[sleep 2; scutil --nwi | grep -m1 'utun' | awk '{ print $1 }']], function(vpn)
      if vpn ~= "" then
        wifi:set { icon = { string = icons.wifi.vpn, color = colors.vpn } }
      end
    end)
  end)
end)

wifi:subscribe("mouse.clicked", function()
  if wifi:query().popup.drawing == "on" then
    wifi:set { popup = { drawing = false } }
    return
  end

  wifi:set { popup = { drawing = true } }
  sbar.exec("ipconfig getifaddr " .. iface, function(result)
    ip:set { label = result }
  end)
  sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
    mask:set { label = result }
  end)
  sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
    router:set { label = result }
  end)
end)

local function copy_label_to_clipboard(env)
  local label = sbar.query(env.NAME).label.value
  sbar.exec('echo "' .. label .. '" | pbcopy')
  sbar.set(env.NAME, { label = { string = icons.clipboard, align = "center" } })
  sbar.delay(1, function()
    sbar.set(env.NAME, { label = { string = label, align = "right" } })
  end)
end

ip:subscribe("mouse.clicked", copy_label_to_clipboard)
mask:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)
