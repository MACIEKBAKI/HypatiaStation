// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	return

// No comment
/atom/proc/attackby(obj/item/W, mob/user)
	return

/atom/movable/attackby(obj/item/W, mob/user)
	if(!(W.flags & NOBLUDGEON))
		visible_message(SPAN_DANGER("[src] has been hit by [user] with [W]."))

/mob/living/attackby(obj/item/I, mob/user)
	if(istype(I) && ismob(user))
		I.attack(src, user)

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

/obj/item/proc/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if(!istype(M)) // not sure if this is the right thing...
		return

	var/messagesource = M
	if(can_operate(M))		//Checks if mob is lying down on table for surgery
		if(do_surgery(M, user, src))
			return
	if(isbrain(M))
		messagesource = M:container
	if(hitsound)
		playsound(loc, hitsound, 50, 1, -1)
	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
	msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])" )

	//spawn(1800)            // this wont work right
	//	M.lastattacker = null
	/////////////////////////

	var/power = force
	if(HULK in user.mutations)
		power *= 2

	if(!ishuman(M))
		if(isslime(M))
			var/mob/living/carbon/slime/slime = M
			if(prob(25))
				to_chat(M, SPAN_WARNING("[src] passes right through [M]!"))
				return

			if(power > 0)
				slime.attacked += 10

			if(slime.Discipline && prob(50))	// wow, buddy, why am I getting attacked??
				slime.Discipline = 0

			if(power >= 3)
				if(isslimeadult(slime))
					if(prob(5 + round(power / 2)))

						if(slime.Victim)
							if(prob(80) && !slime.client)
								slime.Discipline++
						slime.Victim = null
						slime.anchored = FALSE

						spawn()
							if(slime)
								slime.SStun = 1
								sleep(rand(5, 20))
								if(slime)
									slime.SStun = 0

						spawn(0)
							if(slime)
								slime.canmove = FALSE
								step_away(slime, user)
								if(prob(25 + power))
									sleep(2)
									if(slime && user)
										step_away(slime, user)
								slime.canmove = TRUE

				else
					if(prob(10 + power * 2))
						if(slime)
							if(slime.Victim)
								if(prob(80) && !slime.client)
									slime.Discipline++

									if(slime.Discipline == 1)
										slime.attacked = 0

								spawn()
									if(slime)
										slime.SStun = 1
										sleep(rand(5, 20))
										if(slime)
											slime.SStun = 0

							slime.Victim = null
							slime.anchored = FALSE


						spawn(0)
							if(slime && user)
								step_away(slime, user)
								slime.canmove = FALSE
								if(prob(25 + power * 4))
									sleep(2)
									if(slime && user)
										step_away(slime, user)
								slime.canmove = TRUE

		var/showname = "."
		if(user)
			showname = " by [user]."
		if(!(user in viewers(M, null)))
			showname = "."

		for(var/mob/O in viewers(messagesource, null))
			if(length(attack_verb))
				O.show_message(SPAN_DANGER("[M] has been [pick(attack_verb)] with [src][showname]."), 1)
			else
				O.show_message(SPAN_DANGER("[M] has been attacked with [src][showname]."), 1)

		if(!showname)
			if(isnotnull(user?.client))
				to_chat(user, SPAN_DANGER("You attack [M] with [src]."))

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		return H.attacked_by(src, user, def_zone)
	else
		switch(damtype)
			if("brute")
				if(isslime(src))
					M.adjustBrainLoss(power)
				else
					M.take_organ_damage(power)
					if(prob(33)) // Added blood for whacking non-humans too
						if(istype(M.loc, /turf/simulated))
							var/turf/simulated/location = M.loc
							location.add_blood_floor(M)
			if("fire")
				if(!(COLD_RESISTANCE in M.mutations))
					M.take_organ_damage(0, power)
					to_chat(M, "Aargh it burns!")
		M.updatehealth()
	add_fingerprint(user)
	return 1