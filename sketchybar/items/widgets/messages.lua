-- Unread iMessage indicator. Reading chat.db needs Full Disk Access for
-- sketchybar; without it the icon just stays hidden.
local icons = require "icons"
local colors = require("colors").sections.widgets.messages

local messages = sbar.add("item", "widgets.messages", {
  position = "right",
  icon = {
    color = colors.icon,
    string = icons.message,
    padding_right = 4,
    drawing = false,
  },
  label = { drawing = false },
  background = { drawing = false },
  updates = true,
  update_freq = 30,
  padding_left = -4,
  padding_right = 0,
})

messages:subscribe({ "routine", "front_app_switched", "space_change", "space_windows_change" }, function()
  sbar.exec(
    [[sqlite3 ~/Library/Messages/chat.db "SELECT COUNT(guid) FROM message WHERE NOT(is_read) AND NOT(is_from_me) AND text !=''" 2>/dev/null]],
    function(out)
      local unread = (tonumber(out) or 0) > 0
      messages:set {
        icon = { drawing = unread },
        padding_right = unread and 4 or 0,
      }
    end
  )
end)

messages:subscribe("mouse.clicked", function()
  sbar.exec "open -a 'Messages'"
end)
