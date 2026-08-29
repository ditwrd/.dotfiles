-- Environment variables.
-- Third arg true = also push into the systemd/dbus activation environment (old `envd`).
hl.env("HYPRCURSOR_SIZE", "24", true)
hl.env("XCURSOR_SIZE", "24", true)
hl.env("QT_CURSOR_SIZE", "24", true)

hl.env("GRIMBLAST_EDITOR", "swappy -f")
