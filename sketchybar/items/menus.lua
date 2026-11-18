-- App menus in the bar. Adapted from FelixKratz/dotfiles (GPL-3.0).
local colors = require("colors")
local menus_bin = "$CONFIG_DIR/helpers/menus/bin/menus"
local max_items = 15

local watcher = sbar.add("item", { drawing = false, updates = true })
sbar.add("event", "discos_toggle_menus")

local items = {}
for i = 1, max_items do
  items[i] = sbar.add("item", "menu." .. i, {
    drawing = false,
    icon = { drawing = false },
    label = {
      color = i == 1 and colors.accent or colors.text,
      padding_left = 6,
      padding_right = 6,
    },
    click_script = menus_bin .. " -s " .. i,
  })
end

local function update()
  sbar.exec(menus_bin .. " -l", function(out)
    sbar.set("/menu\\..*/", { drawing = false })
    local id = 1
    for name in string.gmatch(out, "[^\r\n]+") do
      if id > max_items then break end
      items[id]:set({ label = name, drawing = true })
      id = id + 1
    end
  end)
end

watcher:subscribe("front_app_switched", update)

local shown = true
watcher:subscribe("discos_toggle_menus", function()
  shown = not shown
  watcher:set({ updates = shown })
  if shown then update() else sbar.set("/menu\\..*/", { drawing = false }) end
end)

update()
