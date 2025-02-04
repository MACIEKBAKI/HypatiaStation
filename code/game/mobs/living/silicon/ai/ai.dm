//Not sure why this is necessary...
/proc/AutoUpdateAI(obj/subject)
	var/is_in_use = FALSE
	if(isnotnull(subject))
		for(var/A in GLOBL.ai_list)
			var/mob/living/silicon/ai/M = A
			if(isnotnull(M.client) && M.machine == subject)
				is_in_use = TRUE
				subject.attack_ai(M)
	return is_in_use

/mob/living/silicon/ai
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = TRUE // -- TLE
	density = TRUE
	status_flags = CANSTUN|CANPARALYSE

	var/list/network = list("SS13")
	var/obj/machinery/camera/current = null
	var/list/connected_robots = list()
	var/aiRestorePowerRoutine = 0
	//var/list/laws = list()
	var/viewalerts = 0
	var/lawcheck[1]
	var/ioncheck[1]
	var/icon/holo_icon//Default is assigned when AI is created.
	var/obj/item/device/pda/ai/aiPDA = null
	var/obj/item/device/multitool/aiMulti = null
	var/custom_sprite = 0 //For our custom sprites
//Hud stuff

	//MALFUNCTION
	var/datum/AI_Module/module_picker/malf_picker
	var/processing_time = 100
	var/list/datum/AI_Module/current_modules = list()
	var/fire_res_on_core = 0

	var/control_disabled = 0 // Set to 1 to stop AI from interacting via Click() -- TLE
	var/malfhacking = 0 // More or less a copy of the above var, so that malf AIs can hack and still get new cyborgs -- NeoFite

	var/obj/machinery/power/apc/malfhack = null
	var/explosive = 0 //does the AI explode when it dies?

	var/mob/living/silicon/ai/parent = null

	var/camera_light_on = 0	//Defines if the AI toggled the light on the camera it's looking through.
	var/datum/trackable/track = null
	var/last_announcement = ""

/mob/living/silicon/ai/New(loc, datum/ai_laws/L, obj/item/device/mmi/B, safety = 0)
	. = ..()
	var/list/possibleNames = GLOBL.ai_names

	var/pickedName = null
	while(isnull(pickedName))
		pickedName = pick(GLOBL.ai_names)
		for(var/mob/living/silicon/ai/A in GLOBL.mob_list)
			if(A.real_name == pickedName && length(possibleNames) > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName = null

	real_name = pickedName
	name = real_name
	anchored = TRUE
	canmove = FALSE
	density = TRUE
	src.loc = loc

	holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))

	proc_holder_list = list()

	if(isnotnull(L))
		if(istype(L, /datum/ai_laws))
			laws = L
	else
		laws = new BASE_LAW_TYPE()

	aiPDA = new /obj/item/device/pda/ai(src)
	aiPDA.set_name_and_job(name, "AI")

	aiMulti = new /obj/item/device/multitool(src)

	if(isturf(loc))
		add_ai_verbs()

	//Languages
	add_language("Robot Talk")
	add_language("Drone Talk", FALSE)

	add_language("Sol Common", FALSE)
	add_language("Sinta'unathi", FALSE)
	add_language("Siik'maas", FALSE)
	add_language("Siik'tajr", FALSE)
	add_language("Skrellian", FALSE)
	add_language("Rootspeak", FALSE)
	add_language("Obsedaian", FALSE)
	add_language("Plasmalin", FALSE)
	add_language("Binary Audio Language")
	add_language("Tradeband")
	add_language("Gutter", FALSE)

	if(!safety) // Only used by AIize() to successfully spawn an AI.
		if(isnull(B)) // If there is no player/brain inside.
			new/obj/structure/ai_core/deactivated(loc) // New empty terminal.
			qdel(src) // Delete AI.
			return
		else
			if(isnotnull(B.brainmob.mind))
				B.brainmob.mind.transfer_to(src)

			to_chat(src, "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
			to_chat(src, "<B>To look at other parts of the station, click on yourself to get a camera menu.</B>")
			to_chat(src, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
			to_chat(src, "To use something, simply click on it.")
			to_chat(src, "Use say :b to speak to your cyborgs through binary.")
			if(isnull(global.CTgame_ticker?.mode) || !(mind in global.CTgame_ticker.mode.malf_ai))
				show_laws()
				to_chat(src, "<b>These laws may be changed by other players, or by you being the traitor.</b>")

			job = "AI"

	spawn(5)
		new /obj/machinery/ai_power_supply(src)

	hud_list[HEALTH_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[ID_HUD]			= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[WANTED_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]		= image('icons/mob/screen/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD]	= image('icons/mob/screen/hud.dmi', src, "hudblank")

	GLOBL.ai_list.Add(src)

/mob/living/silicon/ai/Destroy()
	GLOBL.ai_list.Remove(src)
	return ..()

// displays the malf_ai information if the AI is the malf
/mob/living/silicon/ai/show_malf_ai()
	if(!IS_GAME_MODE(/datum/game_mode/malfunction))
		var/datum/game_mode/malfunction/malf = global.CTgame_ticker.mode
		for(var/datum/mind/malfai in malf.malf_ai)
			if(mind == malfai) // are we the evil one?
				if(malf.apcs >= 3)
					stat(null, "Time until station control secured: [max(malf.AI_win_timeleft / (malf.apcs / 3), 0)] seconds")

/mob/living/silicon/ai/check_eye(mob/user as mob)
	if(isnull(current))
		return null
	user.reset_view(current)
	return 1

/mob/living/silicon/ai/restrained()
	return 0

/mob/living/silicon/ai/emp_act(severity)
	if(prob(30))
		switch(pick(1, 2))
			if(1)
				view_core()
			if(2)
				ai_call_shuttle()
	..()

/mob/living/silicon/ai/Topic(href, href_list)
	if(usr != src)
		return
	..()
	if(href_list["mach_close"])
		if(href_list["mach_close"] == "aialerts")
			viewalerts = 0
		var/t1 = "window=[href_list["mach_close"]]"
		unset_machine()
		src << browse(null, t1)
	if(href_list["switchcamera"])
		switchCamera(locate(href_list["switchcamera"])) in global.CTcameranet.cameras
	if(href_list["showalerts"])
		ai_alerts()
	//Carn: holopad requests
	if(href_list["jumptoholopad"])
		var/obj/machinery/hologram/holopad/H = locate(href_list["jumptoholopad"])
		if(stat == CONSCIOUS)
			if(isnotnull(H))
				H.attack_ai(src) //may as well recycle
			else
				to_chat(src, SPAN_NOTICE("Unable to locate the holopad."))

	if(href_list["lawc"]) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = text2num(href_list["lawc"])
		switch(lawcheck[L + 1])
			if("Yes")
				lawcheck[L + 1] = "No"
			if("No")
				lawcheck[L + 1] = "Yes"
//		src << text ("Switching Law [L]'s report status to []", lawcheck[L+1])
		checklaws()

	if(href_list["say_word"])
		play_vox_word(href_list["say_word"], null, src)
		return

	if(href_list["lawi"]) // Toggling whether or not a law gets stated by the State Laws verb --NeoFite
		var/L = text2num(href_list["lawi"])
		switch(ioncheck[L])
			if("Yes")
				ioncheck[L] = "No"
			if("No")
				ioncheck[L] = "Yes"
//		src << text ("Switching Law [L]'s report status to []", lawcheck[L+1])
		checklaws()

	if(href_list["laws"]) // With how my law selection code works, I changed statelaws from a verb to a proc, and call it through my law selection panel. --NeoFite
		statelaws()

	if(href_list["track"])
		var/mob/target = locate(href_list["track"]) in GLOBL.mob_list
		/*
		var/mob/living/silicon/ai/A = locate(href_list["track2"]) in mob_list
		if(A && target)
			A.ai_actual_track(target)
		*/
		if(isnotnull(target))
			ai_actual_track(target)
		return

	else if(href_list["faketrack"])
		var/mob/target = locate(href_list["track"]) in GLOBL.mob_list
		var/mob/living/silicon/ai/A = locate(href_list["track2"]) in GLOBL.mob_list
		if(isnotnull(A) && isnotnull(target))
			A.cameraFollow = target
			to_chat(A, "Now tracking [target.name] on camera.")
			if(isnull(usr.machine))
				usr.machine = usr

			while(cameraFollow == target)
				to_chat(usr, "Target is not on or near any active cameras on the station. We'll check again in 5 seconds (unless you use the cancel-camera verb).")
				sleep(40)
				continue

/mob/living/silicon/ai/meteorhit(obj/O as obj)
	visible_message(SPAN_WARNING("[src] has been hit by [O]!"))
	if(health > 0)
		adjustBruteLoss(30)
		if(O.icon_state == "flaming")
			adjustFireLoss(40)
		updatehealth()

/mob/living/silicon/ai/attack_animal(mob/living/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(isnotnull(M.attack_sound))
			playsound(loc, M.attack_sound, 50, 1, 1)
		visible_message(SPAN_WARNING("<B>[M]</B> [M.attacktext] [src]!"))
		M.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [name] ([ckey])</font>"
		attack_log += "\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>"
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()

/mob/living/silicon/ai/reset_view(atom/A)
	if(isnotnull(current))
		//current.SetLuminosity(0)
		current.set_light(0)
	if(istype(A, /obj/machinery/camera))
		current = A
	..()
	if(istype(A, /obj/machinery/camera))
		//if(camera_light_on)	A.SetLuminosity(AI_CAMERA_LUMINOSITY)
		//else				A.SetLuminosity(0)
		if(camera_light_on)
			A.set_light(AI_CAMERA_LUMINOSITY)
		else
			A.set_light(0)

/mob/living/silicon/ai/triggerAlarm(class, area/A, list/cameralist, source)
	if(stat == DEAD)
		return 1

	..()

	var/cameratext = ""
	for(var/obj/machinery/camera/C in cameralist)
		cameratext += "[(cameratext == "")? "" : "|"]<A HREF=?src=\ref[src];switchcamera=\ref[C]>[C.c_tag]</A>"
	queueAlarm("--- [class] alarm detected in [A.name]! ([(cameratext)? cameratext : "No Camera"])", class)

	if(viewalerts)
		ai_alerts()

/mob/living/silicon/ai/cancelAlarm(class, area/A as area, source)
	var/has_alarm = ..()

	if(!has_alarm)
		queueAlarm("--- [class] alarm in [A.name] has been cleared.", class, 0)
		if(viewalerts)
			ai_alerts()

	return has_alarm

/mob/living/silicon/ai/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		if(anchored)
			user.visible_message(SPAN_INFO("\The [user] starts to unbolt \the [src] from the plating..."))
			if(!do_after(user, 40))
				user.visible_message(SPAN_INFO("\The [user] decides not to unbolt \the [src]."))
				return
			user.visible_message(SPAN_INFO("\The [user] finishes unfastening \the [src]!"))
			anchored = FALSE
			return
		else
			user.visible_message(SPAN_INFO("\The [user] starts to bolt \the [src] to the plating..."))
			if(!do_after(user, 40))
				user.visible_message(SPAN_INFO("\The [user] decides not to bolt \the [src]."))
				return
			user.visible_message(SPAN_INFO("\The [user] finishes fastening down \the [src]!"))
			anchored = TRUE
			return
	else
		return ..()

/mob/living/silicon/ai/proc/add_ai_verbs()
	verbs |= GLOBL.ai_verbs_default

/mob/living/silicon/ai/proc/remove_ai_verbs()
	verbs.Remove(GLOBL.ai_verbs_default)

/mob/living/silicon/ai/proc/switchCamera(obj/machinery/camera/C)
	cameraFollow = null

	if(isnull(C) || stat == DEAD) //C.can_use())
		return 0

	if(isnull(eyeobj))
		view_core()
		return
	// ok, we're alive, camera is good and in our network...
	eyeobj.setLoc(get_turf(C))
	//machine = src

	return 1