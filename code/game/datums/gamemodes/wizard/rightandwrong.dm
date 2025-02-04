

/mob/proc/rightandwrong()
	to_chat(usr, "<B>You summoned guns!</B>")
	message_admins("[key_name_admin(usr, 1)] summoned guns!")
	for(var/mob/living/carbon/human/H in GLOBL.player_list)
		if(H.stat == DEAD || !H.client)
			continue
		if(is_special_character(H))
			continue
		if(prob(25))
			global.CTgame_ticker.mode.traitors += H.mind
			H.mind.special_role = "traitor"
			var/datum/objective/survive/survive = new
			survive.owner = H.mind
			H.mind.objectives += survive
			to_chat(H, "<B>You are the survivor! Your own safety matters above all else, trust no one and kill anyone who gets in your way. However, armed as you are, now would be the perfect time to settle that score or grab that pair of yellow gloves you've been eyeing...</B>")
			var/obj_count = 1
			for(var/datum/objective/OBJ in H.mind.objectives)
				H << "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]"
				obj_count++
		var/randomize = pick("taser", "egun", "laser", "revolver", "detective", "smg", "nuclear", "deagle", "gyrojet", "pulse", "silenced", "cannon", "doublebarrel", "shotgun", "combatshotgun", "mateba", "smg", "uzi", "crossbow", "saw")
		switch(randomize)
			if("taser")
				new /obj/item/gun/energy/taser(get_turf(H))
			if("egun")
				new /obj/item/gun/energy/gun(get_turf(H))
			if("laser")
				new /obj/item/gun/energy/laser(get_turf(H))
			if("revolver")
				new /obj/item/gun/projectile(get_turf(H))
			if("detective")
				new /obj/item/gun/projectile/detective(get_turf(H))
			if("smg")
				new /obj/item/gun/projectile/automatic/c20r(get_turf(H))
			if("nuclear")
				new /obj/item/gun/energy/gun/nuclear(get_turf(H))
			if("deagle")
				new /obj/item/gun/projectile/deagle/camo(get_turf(H))
			if("gyrojet")
				new /obj/item/gun/projectile/gyropistol(get_turf(H))
			if("pulse")
				new /obj/item/gun/energy/pulse_rifle(get_turf(H))
			if("silenced")
				new /obj/item/gun/projectile/pistol(get_turf(H))
				new /obj/item/silencer(get_turf(H))
			if("cannon")
				new /obj/item/gun/energy/lasercannon(get_turf(H))
			if("doublebarrel")
				new /obj/item/gun/projectile/shotgun/pump/(get_turf(H))
			if("shotgun")
				new /obj/item/gun/projectile/shotgun/pump/(get_turf(H))
			if("combatshotgun")
				new /obj/item/gun/projectile/shotgun/pump/combat(get_turf(H))
			if("mateba")
				new /obj/item/gun/projectile/mateba(get_turf(H))
			if("smg")
				new /obj/item/gun/projectile/automatic(get_turf(H))
			if("uzi")
				new /obj/item/gun/projectile/automatic/mini_uzi(get_turf(H))
			if("crossbow")
				new /obj/item/gun/energy/crossbow(get_turf(H))
			if("saw")
				new /obj/item/gun/projectile/automatic/l6_saw(get_turf(H))