-- Animations (macOS-like curves).
-- https://wiki.hyprland.org/Configuring/Animations/
hl.curve("macEase", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })
hl.curve("macPop", { type = "bezier", points = { { 0.2, 0.8 }, { 0.4, 1.1 } } })
hl.curve("macSmooth", { type = "bezier", points = { { 0.4, 0.0 }, { 0.2, 1.0 } } })
hl.curve("macBounce", { type = "bezier", points = { { 0.68, -0.55 }, { 0.265, 1.55 } } })

local function anim(leaf, speed, curve, style)
	hl.animation({ leaf = leaf, enabled = true, speed = speed, bezier = curve, style = style })
end

hl.config({ animations = { enabled = true } })

-- Windows (styles allowed on the base leaf only)
anim("windows", 1, "macEase", "popin 90%")
anim("windowsIn", 1, "macPop")
anim("windowsOut", 1, "macEase")
anim("windowsMove", 1, "macSmooth")

-- Layers
anim("layers", 1, "macSmooth", "fade")
anim("layersIn", 1, "macEase")
anim("layersOut", 1, "macSmooth")

-- Fade
anim("fade", 1, "macSmooth")
anim("fadeIn", 1, "macSmooth")
anim("fadeOut", 1, "macSmooth")
anim("fadeSwitch", 1, "macEase")
anim("fadeShadow", 1, "macSmooth")
anim("fadeDim", 1, "macSmooth")
anim("fadeLayers", 1, "macSmooth")

-- Borders
anim("border", 1, "macEase")
anim("borderangle", 1, "macSmooth", "loop")

-- Workspaces
anim("workspaces", 1, "macEase", "slidefade 20%")
anim("workspacesIn", 1, "macEase")
anim("workspacesOut", 1, "macEase")

anim("specialWorkspace", 1, "macBounce", "slidefadevert 15%")
anim("specialWorkspaceIn", 1, "macEase")
anim("specialWorkspaceOut", 1, "macEase")
