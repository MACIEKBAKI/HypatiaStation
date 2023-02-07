/*
 * Base Controller Datum
 */
GLOBAL_GLOBL_LIST_NEW(controllers)

/datum/controller
	// The controller's name.
	var/name
	// The clickable stat() panel button object.
	var/obj/clickable_stat/stat_click

/datum/controller/New()
	. = ..()
	GLOBL.controllers += src

/datum/controller/Destroy()
	GLOBL.controllers -= src
	return ..()

/datum/controller/proc/setup()

/datum/controller/proc/process()

/datum/controller/proc/stat_controller()
	if(!stat_click)
		stat_click = new /obj/clickable_stat(null, name, src)
	stat(stat_click)