-- Gaps, borders and window decorations.
-- https://wiki.hyprland.org/Configuring/Variables/#decoration
hl.config({
	general = {
		gaps_in = 8,
		gaps_out = 16,
		border_size = 1,
		col = {
			active_border = { colors = { "rgba(ffffff20)", "rgba(0080ff30)" }, angle = 45 },
			inactive_border = "rgba(ffffff08)",
		},
		layout = "dwindle",
		resize_on_border = true,
		extend_border_grab_area = 15,
	},

	decoration = {
		rounding = 12,
		active_opacity = 0.98,
		inactive_opacity = 0.85,

		shadow = {
			enabled = true,
			range = 25,
			render_power = 3,
			color = "rgba(000000cc)",
			offset = { 0, 8 },
		},

		blur = {
			enabled = true,
			size = 8,
			passes = 3,
			new_optimizations = true,
			xray = false,
			ignore_opacity = false,
			noise = 0.02,
			contrast = 1.1,
			brightness = 1.0,
			vibrancy = 0.3,
			vibrancy_darkness = 0.5,
			popups = true,
			popups_ignorealpha = 0.6,
		},

		dim_inactive = true,
		dim_strength = 0.1,
		dim_special = 0.4,
		dim_around = 0.6,
	},
})
