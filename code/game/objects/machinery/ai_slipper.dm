/obj/machinery/ai_slipper
	name = "AI Liquid Dispenser"
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "motion3"
	layer = 3
	anchored = TRUE
	var/uses = 20
	var/disabled = 1
	var/lethal = 0
	var/locked = 1
	var/cooldown_time = 0
	var/cooldown_timeleft = 0
	var/cooldown_on = 0
	req_access = list(ACCESS_AI_UPLOAD)

/obj/machinery/ai_slipper/power_change()
	if(stat & BROKEN)
		return
	else
		if(powered())
			stat &= ~NOPOWER
		else
			icon_state = "motion0"
			stat |= NOPOWER

/obj/machinery/ai_slipper/proc/setState(enabled, uses)
	src.disabled = disabled
	src.uses = uses
	src.power_change()

/obj/machinery/ai_slipper/attackby(obj/item/W, mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	if(issilicon(user))
		return src.attack_hand(user)
	else // trying to unlock the interface
		if(src.allowed(usr))
			locked = !locked
			to_chat(user, "You [ locked ? "lock" : "unlock"] the device.")
			if(locked)
				if(user.machine == src)
					user.unset_machine()
					user << browse(null, "window=ai_slipper")
			else
				if(user.machine == src)
					src.attack_hand(usr)
		else
			FEEDBACK_ACCESS_DENIED(user)
			return
	return

/obj/machinery/ai_slipper/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/ai_slipper/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(get_dist(src, user) > 1)
		if(!issilicon(user))
			to_chat(user, "Too far away.")
			user.unset_machine()
			user << browse(null, "window=ai_slipper")
			return

	user.set_machine(src)
	var/loc = src.loc
	if(isturf(loc))
		loc = loc:loc
	if(!isarea(loc))
		to_chat(user, "Turret badly positioned - loc.loc is [loc].")
		return
	var/area/area = loc
	var/t = "<TT><B>AI Liquid Dispenser</B> ([area.name])<HR>"

	if(src.locked && (!issilicon(user)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += "Dispenser [src.disabled ? "deactivated" : "activated"] - <A href='?src=\ref[src];toggleOn=1'>[src.disabled ? "Enable" : "Disable"]?</a><br>\n"
		t += "Uses Left: [uses]. <A href='?src=\ref[src];toggleUse=1'>Activate the dispenser?</A><br>\n"

	user << browse(t, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/ai_slipper/Topic(href, href_list)
	..()
	if(src.locked)
		if(!issilicon(usr))
			to_chat(usr, "Control panel is locked!")
			return
	if(href_list["toggleOn"])
		src.disabled = !src.disabled
		icon_state = src.disabled ? "motion0" : "motion3"
	if(href_list["toggleUse"])
		if(cooldown_on || disabled)
			return
		else
			new /obj/effect/foam(src.loc)
			src.uses--
			cooldown_on = 1
			cooldown_time = world.timeofday + 100
			slip_process()
			return

	src.attack_hand(usr)
	return

/obj/machinery/ai_slipper/proc/slip_process()
	while(cooldown_time - world.timeofday > 0)
		var/ticksleft = cooldown_time - world.timeofday

		if(ticksleft > 1e5)
			cooldown_time = world.timeofday + 10	// midnight rollover

		cooldown_timeleft = (ticksleft / 10)
		sleep(5)
	if(uses <= 0)
		return
	if(uses >= 0)
		cooldown_on = 0
	src.power_change()
	return