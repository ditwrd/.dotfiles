-- Keybinds + submaps.
-- https://wiki.hyprland.org/Configuring/Binds/
local d = require("config.defaults")
local mainMod = "ALT"

local function bind(key, action, desc, opts)
	opts = opts or {}
	opts.description = desc
	hl.bind(key, action, opts)
end

local function exec(key, cmd, desc, opts)
	bind(key, hl.dsp.exec_cmd(cmd), desc, opts)
end

-- ── Apps ──
exec(mainMod .. " + RETURN", d.terminal, "Opens your preferred terminal emulator")
exec(mainMod .. " + E", d.filemanager, "Opens your preferred filemanager")
exec(mainMod .. " + SPACE", d.applauncher, "Runs your application launcher")

-- ── Window actions ──
bind(mainMod .. " + Q", hl.dsp.window.close(), "Closes (not kill) current window")
bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), "Switches current window between floating and tiling mode")
bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }), "Toggles current window fullscreen mode")
bind(mainMod .. " + Y", hl.dsp.window.pin({ action = "toggle" }), "Pin current window (shows on all workspaces)")
bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), "Toggles current window split mode") -- dwindle

exec(mainMod .. " + SHIFT + M", 'loginctl terminate-user ""', "Exits Hyprland by terminating the user sessions")

-- ── Screenshots ──
exec(mainMod .. " + SHIFT + S", d.shot_region, "Creates a screenshot of an area")
exec("CTRL + Print", d.shot_window, "Creates a screenshot of the active window")
exec("ALT + Print", d.shot_screen, "Creates a screenshot of the active display")

-- ── Groups ──
bind(mainMod .. " + Tab", hl.dsp.group.next(), "Switches to the next window in the group")

-- ── Volume (wob pipe) ──
local wob = "/tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
exec("XF86AudioRaiseVolume", table.concat({
	"pactl set-sink-volume @DEFAULT_SINK@ +5%",
	"pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | awk '{if($1>100) system(\"pactl set-sink-volume @DEFAULT_SINK@ 100%\")}'",
	"pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | awk '{print $1}' | head -1 > " .. wob,
}, " && "), "Raise Volume", { locked = true, repeating = true })
exec("XF86AudioLowerVolume", table.concat({
	"pactl set-sink-volume @DEFAULT_SINK@ -5%",
	"pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | awk '{print $1}' | head -1 > " .. wob,
}, " && "), "Lower Volume", { locked = true, repeating = true })
exec("XF86AudioMute", "amixer sset Master toggle | sed -En '/\\[on\\]/ s/.*\\[([0-9]+)%\\].*/\\1/ p; /\\[off\\]/ s/.*/0/p' | head -1 > " .. wob, "Mutes player audio", { locked = true, repeating = true })

-- ── Playback / brightness / misc ──
exec("XF86AudioPlay", "playerctl play-pause", "Toggles play/pause", { locked = true })
exec("XF86AudioNext", "playerctl next", "Next track", { locked = true })
exec("XF86AudioPrev", "playerctl previous", "Previous track", { locked = true })

exec("XF86MonBrightnessUp", "brightnessctl s +5%", "Increases brightness 5%", { locked = true, repeating = true })
exec("XF86MonBrightnessDown", "brightnessctl s 5%-", "Decreases brightness 5%", { locked = true, repeating = true })

exec("SUPER + L", "swaylock-fancy -e -K -p 10 -f Hack-Regular", "Lock the screen")
exec(mainMod .. " + O", "killall -SIGUSR2 waybar", "Reload/restarts Waybar")

-- ── Mouse: drag to move/resize ──
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), "Drag window", { drag = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), "Resize the window", { drag = true })

-- ── Move windows ──
-- vim keys: H/J/K/L
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	bind(mainMod .. " + SHIFT + " .. key:upper(), hl.dsp.window.move({ direction = dir }), "Move active window to the " .. dir)
end

-- ── Move focus ──
bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), "Move focus to the left")
bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), "Move focus to the right")
bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), "Move focus upwards")
bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), "Move focus downwards")

-- ── Resize: interactive submap ──
bind(mainMod .. " + R", hl.dsp.submap("resize"), "Activates window resizing mode")
hl.define_submap("resize", function()
	local resizes = {
		{ "right", 15, 0, "Resize to the right" },
		{ "left", -15, 0, "Resize to the left" },
		{ "up", 0, -15, "Resize upwards" },
		{ "down", 0, 15, "Resize downwards" },
		{ "l", 15, 0, "Resize to the right" },
		{ "h", -15, 0, "Resize to the left" },
		{ "k", 0, -15, "Resize upwards" },
		{ "j", 0, 15, "Resize downwards" },
	}
	for _, r in ipairs(resizes) do
		bind(r[1], hl.dsp.window.resize({ x = r[2], y = r[3], relative = true }), r[4] .. " (resizing mode)", { repeating = true })
	end
	bind("escape", hl.dsp.submap("reset"), "Ends window resizing mode")
end)

-- Quick resize (mainMod uses CTRL+SHIFT since CTRL+SHIFT alone selects words in editors)
local quick = {
	{ "right", 15, 0, "Resize to the right" },
	{ "left", -15, 0, "Resize to the left" },
	{ "up", 0, -15, "Resize upwards" },
	{ "down", 0, 15, "Resize downwards" },
	{ "l", 15, 0, "Resize to the right" },
	{ "h", -15, 0, "Resize to the left" },
	{ "k", 0, -15, "Resize upwards" },
	{ "j", 0, 15, "Resize downwards" },
}
for _, r in ipairs(quick) do
	bind(mainMod .. " + CTRL + SHIFT + " .. r[1], hl.dsp.window.resize({ x = r[2], y = r[3], relative = true }), r[4])
end

-- ── Workspaces: switch ──
for i = 1, 10 do
	bind(mainMod .. " + " .. (i % 10), hl.dsp.focus({ workspace = tostring(i) }), "Switch to workspace " .. i)
end
bind(mainMod .. " + PERIOD", hl.dsp.focus({ workspace = "e+1" }), "Scroll through workspaces incrementally")
bind(mainMod .. " + COMMA", hl.dsp.focus({ workspace = "e-1" }), "Scroll through workspaces decrementally")
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Scroll through workspaces incrementally")
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Scroll through workspaces decrementally")
bind(mainMod .. " + slash", hl.dsp.focus({ workspace = "previous" }), "Switch to the previous workspace")

-- ── Workspaces: move windows ──
for i = 1, 10 do
	bind(mainMod .. " + CTRL + " .. (i % 10), hl.dsp.window.move({ workspace = tostring(i) }), "Move window and switch to workspace " .. i)
	bind(mainMod .. " + SHIFT + " .. (i % 10), hl.dsp.window.move({ workspace = tostring(i), follow = false }), "Move window silently to workspace " .. i)
end
bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ workspace = "-1" }), "Move window and switch to the next workspace")
bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ workspace = "+1" }), "Move window and switch to the previous workspace")

-- ── Special workspaces (scratchpads) ──
bind(mainMod .. " + minus", hl.dsp.window.move({ workspace = "special" }), "Move active window to Special workspace")
bind(mainMod .. " + equal", hl.dsp.workspace.toggle_special("special"), "Toggles the Special workspace")
bind(mainMod .. " + F1", hl.dsp.workspace.toggle_special("scratchpad"), "Call special workspace scratchpad")
bind(mainMod .. " + ALT + SHIFT + F1", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }), "Move active window to special workspace scratchpad")

-- ── Cursor submap (mouse mode, like Sway) ──
bind(mainMod .. " + SHIFT + F", hl.dsp.submap("cursor"), "Activates cursor mode")
exec(mainMod .. " + C", "hyprctl keyword cursor:inactive_timeout 0; hyprctl keyword cursor:hide_on_key_press false; hyprctl dispatch submap cursor", "Activates cursor mode")
hl.define_submap("cursor", function()
	-- Jump cursor to a position via wl-kbptr (exits and re-enters the submap)
	exec("f", "hyprctl dispatch submap reset && wl-kbptr -c ~/.config/hypr/wl-kbptr.config && hyprctl dispatch submap cursor", "Jump cursor to a position")

	-- Cursor movement
	exec("j", "wlrctl pointer move 0 10", "Move cursor down", { repeating = true })
	exec("k", "wlrctl pointer move 0 -10", "Move cursor up", { repeating = true })
	exec("l", "wlrctl pointer move 10 0", "Move cursor right", { repeating = true })
	exec("h", "wlrctl pointer move -10 0", "Move cursor left", { repeating = true })

	-- Clicks
	exec("i", "wlrctl pointer click left", "Left click")
	exec("o", "wlrctl pointer click middle", "Middle click")
	exec("p", "wlrctl pointer click right", "Right click")

	-- Scroll
	exec("e", "wlrctl pointer scroll 10 0", "Scroll up", { repeating = true })
	exec("r", "wlrctl pointer scroll -10 0", "Scroll down", { repeating = true })
	exec("t", "wlrctl pointer scroll 0 -10", "Scroll left", { repeating = true })
	exec("g", "wlrctl pointer scroll 0 10", "Scroll right", { repeating = true })

	-- Exit (restores cursor timeout/hide)
	exec("escape", "hyprctl keyword cursor:inactive_timeout 3; hyprctl keyword cursor:hide_on_key_press true; hyprctl dispatch submap reset", "Exit cursor mode")
end)
