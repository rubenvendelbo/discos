-- App menus in the bar, swapped in place of the spaces via the indicator.
-- Adapted from FelixKratz/dotfiles (GPL-3.0) and adriankarlen/dots.
local settings = require "settings"
local menus_bin = "$CONFIG_DIR/helpers/menus/bin/menus"
local max_items = 15

local menu_watcher = sbar.add("item", {
  drawing = false,
  updates = false,
})
local space_menu_swap = sbar.add("item", {
  drawing = false,
  updates = true,
})
sbar.add("event", "swap_menus_and_spaces")

local menu_items = {}
for i = 1, max_items do
  menu_items[i] = sbar.add("item", "menu." .. i, {
    drawing = false,
    icon = { drawing = false },
    background = { drawing = false },
    label = {
      font = {
        style = settings.font.style_map[i == 1 and "Heavy" or "Semibold"],
      },
      padding_left = 6,
      padding_right = 6,
    },
    click_script = menus_bin .. " -s " .. i,
  })
end

sbar.add("bracket", { "/menu\\..*/" }, {})

local menu_padding = sbar.add("item", "menu.padding", {
  drawing = false,
  width = 5,
})

local function update_menus()
  sbar.exec(menus_bin .. " -l", function(menus)
    sbar.set("/menu\\..*/", { drawing = false })
    menu_padding:set { drawing = true }
    local id = 1
    for menu in string.gmatch(menus, "[^\r\n]+") do
      if id > max_items then break end
      menu_items[id]:set { label = menu, drawing = true }
      id = id + 1
    end
  end)
end

menu_watcher:subscribe("front_app_switched", update_menus)

space_menu_swap:subscribe("swap_menus_and_spaces", function()
  local drawing = menu_items[1]:query().geometry.drawing == "on"
  if drawing then
    menu_watcher:set { updates = false }
    sbar.set("/menu\\..*/", { drawing = false })
    sbar.set("/space\\..*/", { drawing = true })
  else
    menu_watcher:set { updates = true }
    sbar.set("/space\\..*/", { drawing = false })
    update_menus()
  end
end)
