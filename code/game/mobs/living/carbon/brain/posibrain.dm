/obj/item/device/mmi/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/items/assemblies/assemblies.dmi'
	icon_state = "posibrain"
	w_class = 3
	origin_tech = list(
		RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_BLUESPACE = 2,
		RESEARCH_TECH_PROGRAMMING = 4
	)

	construction_cost = list(MATERIAL_METAL = 500, MATERIAL_GLASS = 500, MATERIAL_SILVER = 200, MATERIAL_GOLD = 200, MATERIAL_PLASMA = 100, MATERIAL_DIAMOND = 10)
	construction_time = 75

	req_access = list(ACCESS_ROBOTICS)
	locked = 0
	mecha = null//This does not appear to be used outside of reference in mecha.dm.

	brainmob = null

	var/searching = 0
	var/askDelay = 10 * 60 * 1

/obj/item/device/mmi/posibrain/New()
	src.brainmob = new(src)
	src.brainmob.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	src.brainmob.real_name = src.brainmob.name
	src.brainmob.loc = src
	src.brainmob.container = src
	src.brainmob.stat = 0
	src.brainmob.silent = 0
	src.brainmob.brain_op_stage = 4.0
	GLOBL.dead_mob_list -= src.brainmob

	..()

/obj/item/device/mmi/posibrain/attack_self(mob/user as mob)
	if(brainmob && !brainmob.key && searching == 0)
		//Start the process of searching for a new user.
		user << "\blue You carefully locate the manual activation switch and start the positronic brain's boot process."
		icon_state = "posibrain-searching"
		src.searching = 1
		src.request_player()
		spawn(600)
			reset_search()

/obj/item/device/mmi/posibrain/proc/request_player()
	for(var/mob/dead/observer/O in GLOBL.player_list)
		if(O.has_enabled_antagHUD == 1 && CONFIG_GET(antag_hud_restricted))
			continue
		if(jobban_isbanned(O, "pAI"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_PAI)
				question(O.client)

/obj/item/device/mmi/posibrain/proc/question(var/client/C)
	spawn(0)
		if(!C)	return
		var/response = alert(C, "Someone is requesting a personality for a positronic brain. Would you like to play as one?", "Positronic brain request", "Yes", "No", "Never for this round")
		if(!C || brainmob.key || 0 == searching)	return		//handle logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
		if(response == "Yes")
			transfer_personality(C.mob)
		else if (response == "Never for this round")
			C.prefs.be_special ^= BE_PAI

/obj/item/device/mmi/posibrain/transfer_identity(mob/living/carbon/H)
	name = "positronic brain ([H])"
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Positronic Brain"
	if(H.mind)
		H.mind.transfer_to(brainmob)
	brainmob << "\blue You feel slightly disoriented. That's normal when you're just a metal cube."
	icon_state = "posibrain-occupied"
	return

/obj/item/device/mmi/posibrain/proc/transfer_personality(mob/candidate)
	src.searching = 0
	src.brainmob.mind = candidate.mind
	//src.brainmob.key = candidate.key
	src.brainmob.ckey = candidate.ckey
	src.name = "positronic brain ([src.brainmob.name])"

	src.brainmob << "<b>You are a positronic brain, brought into existence on [station_name()].</b>"
	src.brainmob << "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>"
	src.brainmob << "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>"
	src.brainmob << "<b>Use say :b to speak to other artificial intelligences.</b>"
	src.brainmob.mind.assigned_role = "Positronic Brain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue The positronic brain chimes quietly.")
	icon_state = "posibrain-occupied"

/obj/item/device/mmi/posibrain/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	if(src.brainmob && src.brainmob.key) return

	src.searching = 0
	icon_state = "posibrain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue The positronic brain buzzes quietly, and the golden lights fade away. Perhaps you could try again?")

/obj/item/device/mmi/posibrain/examine()
	set src in oview()

	if(!usr || !src)	return
	if( (usr.sdisabilities & BLIND || usr.blinded || usr.stat) && !istype(usr,/mob/dead/observer) )
		usr << "<span class='notice'>Something is there but you can't see it.</span>"
		return

	var/msg = "<span class='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"
	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	msg += "<span class='info'>*---------*</span>"
	usr << msg
	return

/obj/item/device/mmi/posibrain/emp_act(severity)
	if(!src.brainmob)
		return
	else
		switch(severity)
			if(1)
				src.brainmob.emp_damage += rand(20,30)
			if(2)
				src.brainmob.emp_damage += rand(10,20)
			if(3)
				src.brainmob.emp_damage += rand(0,10)
	..()