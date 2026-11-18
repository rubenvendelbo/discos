-- Section colors for the bar, driven by the discOS palette
-- (discos/templates/sketchybar.lua.tmpl). Slot choices follow
-- adriankarlen/dots, so on rose-pine-moon this reproduces the original.
local ok, p = pcall(dofile, os.getenv("HOME") .. "/.config/discos/current-theme/sketchybar.lua")
if not (ok and type(p) == "table" and p.base) then
  p = {
    base = 0xff232136, surface = 0xff2a273f, overlay = 0xff393552, muted = 0xff6e6a86,
    subtle = 0xff908caa, text = 0xffe0def4, shadow = 0xff232136, red = 0xffeb6f92,
    orange = 0xfff6c177, yellow = 0xffea9a97, green = 0xff3e8fb0, cyan = 0xff9ccfd8,
    blue = 0xffc4a7e7, magenta = 0xfff6c177,
  }
end

local function with_alpha(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then
    return color
  end
  return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

local transparent = 0x00000000

return {
  palette = p,
  with_alpha = with_alpha,
  sections = {
    bar = {
      bg = with_alpha(p.surface, 0.8),
      border = transparent,
    },
    item = {
      bg = p.overlay,
      border = p.shadow,
      text = p.text,
    },
    apple = p.yellow,
    spaces = {
      icon = { color = p.subtle, highlight = p.text },
      label = { color = p.subtle, highlight = p.orange },
      indicator = p.blue,
    },
    media = { label = p.subtle },
    widgets = {
      battery = { low = p.red, mid = p.orange, high = p.green },
      wifi = { icon = p.yellow, vpn = p.green },
      volume = {
        icon = p.cyan,
        popup = { item = p.subtle, highlight = p.text },
        slider = { highlight = p.cyan, bg = p.muted, border = p.shadow },
      },
      messages = { icon = p.red },
    },
    calendar = { label = p.subtle },
  },
}
