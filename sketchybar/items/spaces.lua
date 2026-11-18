-- Workspaces from OmniWM (needs ipcEnabled = true in omniwm/settings.toml).
local colors = require("colors").sections.spaces
local icons = require "icons"
local icon_map = require "helpers.icon_map"
local press = require "helpers.press"

sbar.add("event", "omniwm_update")

-- Forward OmniWM IPC events into sketchybar. The watcher outlives this
-- process, so replace any instance left over from a previous load.
sbar.exec [[pkill -f 'omniwmctl watch .*omniwm_update'; nohup omniwmctl watch active-workspace,windows-changed,layout-changed --reconnect --exec sketchybar --trigger omniwm_update >/dev/null 2>&1 &]]

local spaces_indicator = sbar.add("item", "spaces.indicator", {
  icon = {
    padding_left = 8,
    padding_right = 9,
    string = icons.switch.on,
    color = colors.indicator,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
  },
  padding_right = 8,
})

local spaces = {}
local focused = nil

-- Workspaces show up asynchronously (and possibly later, if OmniWM starts
-- after the bar), so each one is moved in before the indicator.
local function add_space(ws)
  local name = ws.rawName
  local space = sbar.add("item", "space." .. name, {
    icon = {
      string = name .. " " .. icons.separators.right,
      color = colors.icon.color,
      highlight_color = colors.icon.highlight,
      padding_left = 8,
      padding_right = 4,
    },
    label = {
      font = "sketchybar-app-font:Regular:14.0",
      string = " —",
      color = colors.label.color,
      highlight_color = colors.label.highlight,
      y_offset = -1,
      padding_right = 12,
    },
    click_script = "omniwmctl command switch-workspace " .. ws.number,
  })
  space:subscribe("mouse.clicked", function()
    press(space)
  end)
  sbar.exec("sketchybar --move " .. space.name .. " before " .. spaces_indicator.name)
  spaces[name] = space
  return space
end

local function update()
  sbar.exec("omniwmctl query workspaces --format json", function(ws_res)
    if type(ws_res) ~= "table" or not ws_res.ok then return end
    sbar.exec("omniwmctl query windows --fields app,workspace --format json", function(win_res)
      local apps = {}
      if type(win_res) == "table" and win_res.ok then
        for _, win in ipairs(win_res.result.payload.windows) do
          if win.workspace and win.app then
            local key = win.workspace.rawName
            apps[key] = (apps[key] or "") .. " " .. (icon_map[win.app.name] or icon_map["default"])
          end
        end
      end

      for _, ws in ipairs(ws_res.result.payload.workspaces) do
        local name = ws.rawName
        local space = spaces[name] or add_space(ws)
        -- isFocused tracks window focus and lags behind; isVisible is the
        -- workspace actually shown on its monitor.
        local selected = ws.isVisible == true
        space:set {
          icon = { highlight = selected },
          label = { highlight = selected },
        }
        sbar.animate("tanh", 10, function()
          space:set { label = apps[name] or " —" }
        end)
        if selected and focused ~= name then
          focused = name
          press(space)
        end
      end
    end)
  end)
end

spaces_indicator:subscribe({ "omniwm_update", "system_woke" }, update)

spaces_indicator:subscribe("swap_menus_and_spaces", function()
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set {
    icon = currently_on and icons.switch.off or icons.switch.on,
  }
end)

spaces_indicator:subscribe("mouse.clicked", function()
  press(spaces_indicator, { 4, 8 })
  sbar.trigger "swap_menus_and_spaces"
end)

update()
