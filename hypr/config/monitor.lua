-- Monitors + env needed before apps spawn.
-- https://wiki.hyprland.org/Configuring/Monitors/
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

-- Electron apps: auto-detect Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
