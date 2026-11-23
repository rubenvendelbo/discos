# Map a macOS bundle id or app name to a Nerd Font icon (from adriankarlen/dots).
app_icon() {
  case "$1" in
  # Browsers
  "com.apple.Safari" | Safari) echo " " ;;
  "org.mozilla.firefox" | Firefox) echo " " ;;
  "app.zen-browser.zen" | Zen) echo " " ;;
  "com.google.Chrome" | "Google Chrome") echo " " ;;
  "net.imput.helium" | Helium) echo "󰛄 " ;;
  "com.brave.Browser" | Brave*) echo " " ;;
  "org.mozilla.firefoxdeveloperedition" | \
    "Firefox Developer Edition") echo " " ;;

  # Terminals
  "com.apple.Terminal" | Terminal) echo " " ;;
  "com.googlecode.iterm2" | iTerm2) echo " " ;;
  Ghostty | "com.mitchellh.ghostty") echo "󱙝 " ;;
  "net.kovidgoyal.kitty" | kitty) echo "󰄛 " ;;
  "io.alacritty" | Alacritty) echo " " ;;
  "org.wezfurlong.wezterm" | WezTerm) echo " " ;;

  # Editors / IDE
  "com.jetbrains.intellij" | IntelliJ*) echo " " ;;
  "com.jetbrains.pycharm" | PyCharm*) echo " " ;;
  "com.jetbrains.webstorm" | WebStorm*) echo " " ;;
  "com.sublimetext.4" | "Sublime Text") echo " " ;;
  "com.apple.dt.Xcode" | Xcode) echo " " ;;
  "dev.zed.Zed" | Zed) echo "ℤ " ;;

  # Chat / meetings
  Discord | "com.hnc.Discord") echo " " ;;
  "com.tinyspeck.slackmacgap" | Slack) echo " " ;;
  "us.zoom.xos" | zoom.us | Zoom) echo " " ;;
  "com.apple.FaceTime" | FaceTime) echo " " ;;
  "com.apple.iChat" | "com.apple.MobileSMS" | Messages) echo "󰭹 " ;;
  "com.apple.mail" | Mail) echo " " ;;

  # Music / media
  Spotify | "com.spotify.client") echo " " ;;
  "com.apple.Music" | Music) echo " " ;;
  "com.apple.TV" | TV) echo " " ;;
  "com.apple.QuickTimePlayerX" | QuickTime*) echo " " ;;
  "org.videolan.vlc" | VLC) echo " " ;;

  # Apple / system
  "com.apple.finder" | Finder) echo " " ;;
  "com.apple.systempreferences" | \
    "com.apple.SystemSettings" | \
    "System Preferences" | "System Settings") echo " " ;;
  "com.apple.ActivityMonitor" | Activity\ Monitor) echo " " ;;
  "com.apple.Console" | Console) echo " " ;;
  "com.apple.DiskUtility" | Disk\ Utility) echo " " ;;
  "com.apple.TimeMachine" | Time\ Machine) echo " " ;;
  "com.apple.AppStore" | App\ Store) echo " " ;;
  "com.apple.Preview" | Preview) echo " " ;;
  "com.apple.Photos" | Photos) echo " " ;;
  "com.apple.Calculator" | Calculator) echo " " ;;
  "com.apple.iCal" | Calendar) echo " " ;;
  "com.apple.Notes" | Notes) echo " " ;;
  "com.apple.Reminders" | Reminders) echo " " ;;
  "com.apple.Maps" | Maps) echo " " ;;
  "com.apple.Dictionary" | Dictionary) echo " " ;;
  "com.apple.TextEdit" | TextEdit) echo " " ;;
  "com.apple.Stickies" | Stickies) echo " " ;;
  "com.apple.FontBook" | Font\ Book) echo " " ;;
  "com.apple.Screenshot" | Screenshot) echo " " ;;
  "com.apple.ImageCapture" | Image\ Capture) echo " " ;;
  "com.apple.Automator" | Automator) echo " " ;;
  "com.apple.Shortcuts" | Shortcuts) echo " " ;;
  "com.apple.Home" | Home) echo " " ;;
  "com.apple.Books" | Books) echo " " ;;
  "com.apple.News" | News) echo " " ;;
  "com.apple.Poddcasts" | Podcasts | \
    "com.apple.podcasts") echo " " ;;

  # Cloud / notes / productivity
  "com.notion.id" | Notion) echo " " ;;
  "com.electron.logseq" | Logseq) echo " " ;;
  "md.obsidian" | Obsidian) echo " " ;;
  "com.todoist.mac.Todoist" | Todoist) echo " " ;;
  "com.apple.iWork.Pages" | Pages) echo " " ;;
  "com.apple.iWork.Numbers" | Numbers) echo " " ;;
  "com.apple.iWork.Keynote" | Keynote) echo " " ;;

  # Dev tools
  "com.apple.SafariTechnologyPreview" | \
    "Safari Technology Preview") echo " " ;;
  "com.postmanlabs.mac" | Postman) echo " " ;;
  "com.docker.docker" | Docker) echo " " ;;
  "com.tinyspeck.slackmacgap" | Slack) echo " " ;;
  "com.jgraph.drawio.desktop" | draw.io) echo " " ;;

  # Media tools
  "com.canva.affinity" | Affinity) echo " " ;;

  *)
    echo " "
    ;;
  esac
}
