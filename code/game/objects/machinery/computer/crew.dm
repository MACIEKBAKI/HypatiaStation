/obj/machinery/computer/crew
	name = "Crew monitoring computer"
	desc = "Used to monitor active health sensors built into most of the crew's uniforms."
	icon_state = "crew"
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/circuitboard/crew
	var/list/tracked = list(  )

	light_color = "#315ab4"

/obj/machinery/computer/crew/New()
	tracked = list()
	..()

/obj/machinery/computer/crew/attack_ai(mob/user)
	attack_hand(user)
	ui_interact(user)

/obj/machinery/computer/crew/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/crew/update_icon()

	if(stat & BROKEN)
		icon_state = "crewb"
	else
		if(stat & NOPOWER)
			src.icon_state = "c_unpowered"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER

/obj/machinery/computer/crew/Topic(href, href_list)
	if(..())
		return
	if(src.z > 6)
		usr << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
		return 0
	if(href_list["close"])
		var/mob/user = usr
		var/datum/nanoui/ui = nanomanager.get_open_ui(user, src, "main")
		usr.unset_machine()
		ui.close()
		return 0
	if(href_list["update"])
		src.updateDialog()
		return 1

/obj/machinery/computer/crew/interact(mob/user)
	ui_interact(user)

/obj/machinery/computer/crew/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	src.scan()
	var/list/data = list()
	var/list/crewmembers = list()

	for(var/obj/item/clothing/under/C in src.tracked)
		var/turf/pos = get_turf(C)
		if((C) && (C.has_sensor) && (pos) && (pos.z == src.z) && C.sensor_mode)
			if(ishuman(C.loc))

				var/mob/living/carbon/human/H = C.loc

				var/list/crewmemberData = list()

				crewmemberData["sensor_type"] = C.sensor_mode
				crewmemberData["dead"] = H.stat > 1
				crewmemberData["oxy"] = round(H.getOxyLoss(), 1)
				crewmemberData["tox"] = round(H.getToxLoss(), 1)
				crewmemberData["fire"] = round(H.getFireLoss(), 1)
				crewmemberData["brute"] = round(H.getBruteLoss(), 1)
				crewmemberData["name"] = (H.wear_id ? H.wear_id.name : "Unknown")
				crewmemberData["area"] = get_area(H)
				crewmemberData["x"] = pos.x
				crewmemberData["y"] = pos.y

				// Works around list += list2 merging lists; it's not pretty but it works
				crewmembers += "temporary item"
				crewmembers[length(crewmembers)] = crewmemberData

	crewmembers = sortByKey(crewmembers, "name")

	data["crewmembers"] = crewmembers

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		ui = new(user, src, ui_key, "crew_monitor.tmpl", "Crew Monitoring Computer", 900, 600)
		ui.set_initial_data(data)
		ui.open()
		// should make the UI auto-update; doesn't seem to?
		ui.set_auto_update()

/obj/machinery/computer/crew/proc/scan()
	for(var/mob/living/carbon/human/H in GLOBL.mob_list)
		if(istype(H.w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/C = H.w_uniform
			if(C.has_sensor)
				tracked |= C
	return 1