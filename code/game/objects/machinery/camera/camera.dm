/obj/machinery/camera
	name = "security camera"
	desc = "It's used to monitor rooms."
	icon = 'icons/obj/machines/monitors.dmi'
	icon_state = "camera"
	use_power = 2
	idle_power_usage = 5
	active_power_usage = 10
	layer = 5

	var/list/network = list("SS13")
	var/c_tag = null
	var/c_tag_order = 999
	var/status = 1.0
	anchored = TRUE
	var/panel_open = 0 // 0 = Closed / 1 = Open
	var/invuln = null
	var/bugged = 0
	var/obj/item/camera_assembly/assembly = null

	// WIRES
	var/datum/wires/camera/wires = null // Wires datum

	//OTHER
	var/view_range = 7
	var/short_range = 2

	var/light_disabled = 0
	var/alarm_on = 0
	var/busy = 0

/obj/machinery/camera/New()
	wires = new(src)
	assembly = new(src)
	assembly.state = 4
	/* // Use this to look for cameras that have the same c_tag.
	for(var/obj/machinery/camera/C in cameranet.cameras)
		var/list/tempnetwork = C.network&src.network
		if(C != src && C.c_tag == src.c_tag && length(tempnetwork))
			world.log << "[src.c_tag] [src.x] [src.y] [src.z] conflicts with [C.c_tag] [C.x] [C.y] [C.z]"
	*/
	if(!length(network))
		if(loc)
			error("[src.name] in [get_area(src)] (x:[src.x] y:[src.y] z:[src.z] has errored. [src.network ? "Empty network list" : "Null network list"]")
		else
			error("[src.name] in [get_area(src)]has errored. [src.network ? "Empty network list" : "Null network list"]")
		ASSERT(src.network)
		ASSERT(length(network))
	..()

/obj/machinery/camera/Destroy()
	deactivate(null, 0) //kick anyone viewing out
	qdel(wires)
	wires = null
	if(assembly)
		qdel(assembly)
		assembly = null
	return ..()

/obj/machinery/camera/emp_act(severity)
	if(!isEmpProof())
		if(prob(100 / severity))
			icon_state = "[initial(icon_state)]emp"
			var/list/previous_network = network
			network = list()
			global.CTcameranet.removeCamera(src)
			stat |= EMPED
			set_light(0)
			triggerCameraAlarm()
			spawn(900)
				network = previous_network
				icon_state = initial(icon_state)
				stat &= ~EMPED
				cancelCameraAlarm()
				if(can_use())
					global.CTcameranet.addCamera(src)
			for(var/mob/O in GLOBL.mob_list)
				if(istype(O.machine, /obj/machinery/computer/security))
					var/obj/machinery/computer/security/S = O.machine
					if(S.current == src)
						O.unset_machine()
						O.reset_view(null)
						to_chat(O, "The screen bursts into static.")
			..()

/obj/machinery/camera/ex_act(severity)
	if(src.invuln)
		return
	else
		..(severity)
	return

/obj/machinery/camera/blob_act()
	return

/obj/machinery/camera/proc/setViewRange(num = 7)
	src.view_range = num
	global.CTcameranet.updateVisibility(src, 0)

/obj/machinery/camera/proc/shock(mob/living/user)
	if(!istype(user))
		return
	user.electrocute_act(10, src)

/obj/machinery/camera/attack_hand(mob/living/carbon/human/user as mob)
	if(!istype(user))
		return

	if(user.species.can_shred(user))
		status = 0
		visible_message(SPAN_WARNING("\The [user] slashes at [src]!"))
		playsound(src, 'sound/weapons/slash.ogg', 100, 1)
		icon_state = "[initial(icon_state)]1"
		add_hiddenprint(user)
		deactivate(user, 0)

/obj/machinery/camera/attackby(W as obj, mob/living/user as mob)
	// DECONSTRUCTION
	if(isscrewdriver(W))
		//user << "<span class='notice'>You start to [panel_open ? "close" : "open"] the camera's panel.</span>"
		//if(toggle_panel(user)) // No delay because no one likes screwdrivers trying to be hip and have a duration cooldown
		panel_open = !panel_open
		user.visible_message(
			SPAN_WARNING("[user] screws the camera's panel [panel_open ? "open" : "closed"]!"),
			SPAN_NOTICE("You screw the camera's panel [panel_open ? "open" : "closed"].")
		)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)

	else if((iswirecutter(W) || ismultitool(W)) && panel_open)
		interact(user)

	else if(iswelder(W) && wires.CanDeconstruct())
		if(weld(W, user))
			if(assembly)
				assembly.loc = src.loc
				assembly.state = 1
			qdel(src)

	// OTHER
	else if((istype(W, /obj/item/paper) || istype(W, /obj/item/device/pda)) && isliving(user))
		var/mob/living/U = user
		var/obj/item/paper/X = null
		var/obj/item/device/pda/P = null

		var/itemname = ""
		var/info = ""
		if(istype(W, /obj/item/paper))
			X = W
			itemname = X.name
			info = X.info
		else
			P = W
			itemname = P.name
			info = P.notehtml
		to_chat(U, "You hold \a [itemname] up to the camera...")
		for(var/mob/living/silicon/ai/O in GLOBL.living_mob_list)
			if(!O.client)
				continue
			if(U.name == "Unknown")
				to_chat(O, "<b>[U]</b> holds \a [itemname] up to one of your cameras...")
			else
				to_chat(O, "<b><a href='byond://?src=\ref[O];track2=\ref[O];track=\ref[U]'>[U]</a></b> holds \a [itemname] up to one of your cameras...")
			O << browse("<HTML><HEAD><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>", "window=[itemname]")
		for(var/mob/O in GLOBL.player_list)
			if(istype(O.machine, /obj/machinery/computer/security))
				var/obj/machinery/computer/security/S = O.machine
				if(S.current == src)
					to_chat(O, "[U] holds \a [itemname] up to one of the cameras...")
					O << browse("<HTML><HEAD><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>", "window=[itemname]")
	else if(istype(W, /obj/item/camera_bug))
		if(!src.can_use())
			to_chat(user, SPAN_INFO("Camera non-functional."))
			return
		if(src.bugged)
			to_chat(user, SPAN_INFO("Camera bug removed."))
			src.bugged = 0
		else
			to_chat(user, SPAN_INFO("Camera bugged."))
			src.bugged = 1
	else if(istype(W, /obj/item/melee/energy/blade))//Putting it here last since it's a special case. I wonder if there is a better way to do these than type casting.
		deactivate(user, 2)//Here so that you can disconnect anyone viewing the camera, regardless if it's on or off.
		var/datum/effect/system/spark_spread/spark_system = new /datum/effect/system/spark_spread()
		spark_system.set_up(5, 0, loc)
		spark_system.start()
		playsound(loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(loc, "sparks", 50, 1)
		visible_message(SPAN_INFO("The camera has been sliced apart by [] with an energy blade!"))
		qdel(src)
	else
		..()
	return

/obj/machinery/camera/proc/deactivate(user as mob, choice = 1)
	if(choice == 1)
		status = !src.status
		if(!src.status)
			visible_message(SPAN_WARNING("[user] has deactivated [src]!"))
			playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
			icon_state = "[initial(icon_state)]1"
			add_hiddenprint(user)
		else
			visible_message(SPAN_WARNING("[user] has reactivated [src]!"))
			playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
			icon_state = initial(icon_state)
			add_hiddenprint(user)
	// now disconnect anyone using the camera
	//Apparently, this will disconnect anyone even if the camera was re-activated.
	//I guess that doesn't matter since they can't use it anyway?
	for(var/mob/O in GLOBL.player_list)
		if(istype(O.machine, /obj/machinery/computer/security))
			var/obj/machinery/computer/security/S = O.machine
			if(S.current == src)
				O.unset_machine()
				O.reset_view(null)
				to_chat(O, "The screen bursts into static.")

/obj/machinery/camera/proc/triggerCameraAlarm()
	alarm_on = 1
	for(var/mob/living/silicon/S in GLOBL.mob_list)
		S.triggerAlarm("Camera", get_area(src), list(src), src)

/obj/machinery/camera/proc/cancelCameraAlarm()
	alarm_on = 0
	for(var/mob/living/silicon/S in GLOBL.mob_list)
		S.cancelAlarm("Camera", get_area(src), src)

/obj/machinery/camera/proc/can_use()
	if(!status)
		return 0
	if(stat & EMPED)
		return 0
	return 1

/obj/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(src)
	if(isXRay())
		see = range(view_range, pos)
	else
		see = hear(view_range, pos)
	return see

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/simulated/wall/T = null
	for(var/i = 1, i <= 8; i += i)
		T = get_ranged_target_turf(src, i, 1)
		if(istype(T))
			//If someone knows a better way to do this, let me know. -Giacom
			switch(i)
				if(NORTH)
					src.set_dir(SOUTH)
				if(SOUTH)
					src.set_dir(NORTH)
				if(WEST)
					src.set_dir(EAST)
				if(EAST)
					src.set_dir(WEST)
			break

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(mob/M)
	for(var/obj/machinery/camera/C in oview(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/proc/near_range_camera(mob/M)
	for(var/obj/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/obj/machinery/camera/proc/weld(obj/item/weldingtool/WT, mob/user)
	if(busy)
		return 0
	if(!WT.isOn())
		return 0

	// Do after stuff here
	to_chat(user, SPAN_NOTICE("You start to weld the [src]..."))
	playsound(src, 'sound/items/Welder.ogg', 50, 1)
	WT.eyecheck(user)
	busy = 1
	if(do_after(user, 100))
		busy = 0
		if(!WT.isOn())
			return 0
		return 1
	busy = 0
	return 0

/obj/machinery/camera/interact(mob/living/user as mob)
	if(!panel_open || isAI(user))
		return

	user.set_machine(src)
	wires.Interact(user)