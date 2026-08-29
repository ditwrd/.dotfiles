-- Window rules. One rule per app group; effects applied where they match.
-- https://wiki.hyprland.org/Configuring/Window-Rules/
local function rule(match, props)
	props.match = match
	hl.window_rule(props)
end

-- Waypaper (wallpaper setter)
rule({ class = "^(waypaper)$" }, {
	float = true, center = true, size = "1100 750",
	border_size = 0, rounding = 16, opacity = "0.95 0.9", stay_focused = true,
})

-- File manager (Nautilus, Thunar, Dolphin)
rule({ class = "^(org.gnome.Nautilus|Thunar|dolphin|pcmanfm)$" }, {
	float = true, center = true, size = "1300 850",
	border_size = 1, rounding = 14, opacity = "0.96 0.88",
})

-- Settings apps
rule({ class = "^(gnome-control-center|lxappearance|pavucontrol|qt5ct|qt6ct)$" }, {
	float = true, center = true, size = "1100 750",
	border_size = 1, rounding = 12, opacity = "0.95 0.87", stay_focused = true,
})

-- Chat / messaging
rule({ class = "^(discord|TelegramDesktop|slack|teams|whatsapp-for-linux)$" }, {
	float = true, center = true, size = "1400 900",
	border_size = 1, rounding = 12, opacity = "0.97 0.89",
})

-- Floating terminal popups
rule({ title = "^(float-term|popup-term)$" }, {
	float = true, center = true, size = "1100 650",
	border_size = 1, rounding = 12, opacity = "0.94 0.86",
})

-- System utilities
rule({ class = "^(gnome-calculator|galculator|qalculate-gtk|htop|btop|nvtop)$" }, {
	float = true, center = true, rounding = 10, opacity = "0.94 0.85", border_size = 1,
})

-- Image/media viewers
rule({ class = "^(eog|gwenview|feh|imv|mpv|vlc)$" }, {
	float = true, center = true, rounding = 10, opacity = "0.98 0.92",
})

-- App launchers & menus (Rofi, wofi, Vicinae)
rule({ class = "^(rofi|wofi|tofi|vicinae)$" }, {
	float = true, center = true, rounding = 12, opacity = "0.93 0.85", stay_focused = true,
})

-- Picture-in-picture for browsers
rule({ title = "^(Picture-in-Picture|PiP)$" }, {
	float = true, pin = true, rounding = 8, opacity = "0.98", size = "480 270",
})

-- Splash screens and loading dialogs
rule({ class = "^(\\..*-wrapped)$" }, {
	float = true, center = true, rounding = 12, opacity = "0.95",
})

-- zen-browser opens on workspace 2
rule({ class = "^(zen)$" }, { workspace = "2" })
