/decl/move_intent
	var/name
	var/move_delay = 1
	var/hud_icon_state

// Walking
/decl/move_intent/walk
	name = "Walk"
	hud_icon_state = "walking"

/decl/move_intent/walk/New()
	. = ..()
	move_delay = CONFIG_GET(walk_speed) + 7

// Running
/decl/move_intent/run
	name = "Run"
	hud_icon_state = "running"

/decl/move_intent/run/New()
	. = ..()
	move_delay = CONFIG_GET(walk_speed) + 1