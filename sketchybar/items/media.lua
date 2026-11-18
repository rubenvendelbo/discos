-- Now playing. sketchybar's media_change event and nowplaying-cli stopped
-- working in macOS 15.4, so this polls `media-control` (brew install media-control).
local icons = require "icons"
local colors = require("colors").sections.media
local press = require "helpers.press"

local whitelist = { ["com.spotify.client"] = true, ["com.apple.Music"] = true }

local media_playback = sbar.add("item", "media", {
  position = "right",
  drawing = false,
  updates = true,
  update_freq = 3,
  icon = {
    max_chars = 50,
    padding_left = 8,
  },
  label = {
    string = icons.separators.left .. " " .. icons.music,
    padding_right = 8,
    color = colors.label,
  },
  popup = {
    horizontal = true,
    align = "center",
    y_offset = 2,
  },
  padding_right = 8,
})

local controls = {
  { icons.media.back, "media-control previous-track" },
  { icons.media.play_pause, "media-control toggle-play-pause" },
  { icons.media.forward, "media-control next-track" },
}
for _, c in ipairs(controls) do
  sbar.add("item", {
    position = "popup." .. media_playback.name,
    padding_left = 6,
    padding_right = 6,
    icon = { string = c[1] },
    label = { drawing = false },
    background = { drawing = false },
    click_script = c[2],
  })
end

media_playback:subscribe({ "routine", "forced", "system_woke" }, function()
  sbar.exec("command -v media-control >/dev/null && media-control get", function(info)
    if type(info) ~= "table" then
      media_playback:set { drawing = false }
      return
    end
    local drawing = info.playing == true and whitelist[info.bundleIdentifier] == true
    media_playback:set {
      drawing = drawing,
      icon = (info.artist or "?") .. " - " .. (info.title or "?"),
    }
  end)
end)

media_playback:subscribe("mouse.clicked", function()
  press(media_playback, { 4, 8 })
  media_playback:set { popup = { drawing = "toggle" } }
end)
