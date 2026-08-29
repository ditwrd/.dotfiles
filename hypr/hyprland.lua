-- Hyprland configuration entry point (Lua).
-- Docs: https://wiki.hypr.land/Configuring/
-- Loaded from ~/.config/hypr/hyprland.lua; modules live in ~/.config/hypr/config/.

require("config.monitor")
require("config.environment")
require("config.autostart")
require("config.input")
require("config.variables")
require("config.animations")
require("config.decorations")
require("config.keybinds")
require("config.windowrules")

-- hyprwhspr - toggle speech-to-text (press once to start, again to stop)
hl.bind("CTRL + SHIFT + SPACE", hl.dsp.exec_cmd("/usr/lib/hyprwhspr/config/hyprland/hyprwhspr-tray.sh record"), {
	description = "Speech-to-text",
})
