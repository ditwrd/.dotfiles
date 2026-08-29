-- Shared app defaults (was defaults.conf)
return {
	filemanager = "dolphin",
	applauncher = "vicinae toggle",
	terminal = "kitty",
	idlehandler = "swayidle -w timeout 300 'swaylock -f -c 000000' before-sleep 'swaylock -f -c 000000'",

	shot_region = "grimblast edit area",
	shot_window = "grimblast copy active",
	shot_screen = "grimblast copy output",
}
