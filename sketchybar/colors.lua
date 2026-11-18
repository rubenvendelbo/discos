local ok, c = pcall(dofile, os.getenv("HOME") .. "/.config/discos/current-theme/sketchybar.lua")
if ok and c then return c end
return { bar = 0xff1e1e1e, item_bg = 0xff2a2a2a, border = 0xff3a3a3a, text = 0xffdddddd,
         subtext = 0xffaaaaaa, muted = 0xff777777, accent = 0xff6699cc,
         warn = 0xffddbb55, error = 0xffdd6666, success = 0xff88bb66 }
