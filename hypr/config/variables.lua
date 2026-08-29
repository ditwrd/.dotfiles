-- Layout/behavior variables.
-- https://wiki.hyprland.org/Configuring/Variables/
hl.config({
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,

		vrr = 2,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		always_follow_on_dnd = true,
		layers_hog_keyboard_focus = true,
		animate_manual_resizes = true,
		animate_mouse_windowdragging = true,
		disable_autoreload = false,

		focus_on_activate = true,
		mouse_move_focuses_monitor = true,

		allow_session_lock_restore = true,
		background_color = "rgb(000000)",
		close_special_on_empty = true,
		initial_workspace_tracking = 1,
		middle_click_paste = true,

		enable_swallow = true,
		swallow_regex = "^(Alacritty|kitty|footclient|wezterm|ghostty)$",
		swallow_exception_regex = "^(wev)$",
	},

	debug = {
		vfr = true,
	},

	render = {
		direct_scanout = true,
	},

	dwindle = {
		preserve_split = true,
		permanent_direction_override = false,
		special_scale_factor = 0.95,
		split_width_multiplier = 1.2,
		use_active_for_splits = true,
		default_split_ratio = 1.2,
	},

	master = {
		new_status = "master",
		new_on_top = false,
		orientation = "left",
		smart_resizing = true,
		drop_at_cursor = false,
		mfact = 0.5,
	},

	binds = {
		allow_workspace_cycles = true,
		workspace_back_and_forth = true,
		workspace_center_on = true,
		movefocus_cycles_fullscreen = true,
		window_direction_monitor_fallback = true,
	},
})
