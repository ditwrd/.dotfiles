-- Autostart. Runs once per compositor start.
local d = require("config.defaults")

local function once(cmd, rules)
	hl.on("hyprland.start", function()
		hl.exec_cmd(cmd, rules)
	end)
end

once("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
once("swaybg -o \\* -i /home/dit/Downloads/wallpaper.png")
once("waybar")
once("fcitx5 -d")
once("mako")
once("syncthing")
once("nm-applet --indicator")
once('bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown"')
once("/usr/lib/polkit-kde-authentication-agent-1")

once("hyprsunset")
once("udiskie")

-- Idle
once(d.idlehandler)

once("clipse -listen")
once("systemctl --user start vicinae")

-- Pre-warmed apps on fixed workspaces
once("kitty", { workspace = "1 silent" })
once("zen-browser", { workspace = "2 silent" })
once("easyeffects", { workspace = "5 silent" })
