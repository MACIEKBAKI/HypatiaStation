/proc/random_hair_style(gender, species = SPECIES_HUMAN)
	var/h_style = "Bald"

	var/list/valid_hairstyles = list()
	for(var/hairstyle in GLOBL.hair_styles_list)
		var/datum/sprite_accessory/S = GLOBL.hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species in S.species_allowed))
			continue
		valid_hairstyles[hairstyle] = GLOBL.hair_styles_list[hairstyle]

	if(length(valid_hairstyles))
		h_style = pick(valid_hairstyles)

	return h_style

/proc/random_facial_hair_style(gender, species = SPECIES_HUMAN)
	var/f_style = "Shaved"

	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in GLOBL.facial_hair_styles_list)
		var/datum/sprite_accessory/S = GLOBL.facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species in S.species_allowed))
			continue

		valid_facialhairstyles[facialhairstyle] = GLOBL.facial_hair_styles_list[facialhairstyle]

	if(length(valid_facialhairstyles))
		f_style = pick(valid_facialhairstyles)

		return f_style

/proc/random_name(gender, species = SPECIES_HUMAN)
	if(gender == FEMALE)
		return capitalize(pick(GLOBL.first_names_female)) + " " + capitalize(pick(GLOBL.last_names))
	else
		return capitalize(pick(GLOBL.first_names_male)) + " " + capitalize(pick(GLOBL.last_names))

/proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")
			. = -10
		if("afroamerican")
			. = -115
		if("african")
			. = -165
		if("latino")
			. = -55
		if("albino")
			. = 34
		else
			. = rand(-185, 34)
	return min(max(. + rand(-25, 25), -185), 34)

/proc/skintone2racedescription(tone)
	switch(tone)
		if(30 to INFINITY)
			return "albino"
		if(20 to 30)
			return "pale"
		if(5 to 15)
			return "light skinned"
		if(-10 to 5)
			return "white"
		if(-25 to -10)
			return "tan"
		if(-45 to -25)
			return "darker skinned"
		if(-65 to -45)
			return "brown"
		if(-INFINITY to -65)
			return "black"
		else
			return "unknown"

/proc/age2agedescription(age)
	switch(age)
		if(0 to 1)
			return "infant"
		if(1 to 3)
			return "toddler"
		if(3 to 13)
			return "child"
		if(13 to 19)
			return "teenager"
		if(19 to 30)
			return "young adult"
		if(30 to 45)
			return "adult"
		if(45 to 60)
			return "middle-aged"
		if(60 to 70)
			return "aging"
		if(70 to INFINITY)
			return "elderly"
		else
			return "unknown"

/proc/RoundHealth(health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(70 to 100)
			return "health80"
		if(50 to 70)
			return "health60"
		if(30 to 50)
			return "health40"
		if(18 to 30)
			return "health25"
		if(5 to 18)
			return "health10"
		if(1 to 5)
			return "health1"
		if(-99 to 0)
			return "health0"
		else
			return "health-100"

/proc/do_mob(mob/user, mob/target, time = 30, uninterruptible = 0, progress = 1)
	if(isnull(user) || isnull(target))
		return 0
	var/user_loc = user.loc
	var/target_loc = target.loc

	var/holding = user.get_active_hand()
	var/datum/progressbar/progbar
	if(progress)
		progbar = new /datum/progressbar(user, time, target)

	var/endtime = world.time + time
	var/starttime = world.time
	. = 1
	while(world.time < endtime)
		sleep(1)
		if(progress)
			progbar.update(world.time - starttime)
		if(isnull(user) || isnull(target))
			. = 0
			break
		if(uninterruptible)
			continue

		if(isnull(user) || user.incapacitated() || user.loc != user_loc)
			. = 0
			break

		if(target.loc != target_loc || user.get_active_hand() != holding)
			. = 0
			break
	if(progbar)
		qdel(progbar)

/proc/do_after(mob/user, delay, atom/target = null, needhand = 1, progress = 1)
	if(isnull(user))
		return 0
	var/atom/target_loc = null
	if(isnotnull(target))
		target_loc = target.loc

	var/atom/original_loc = user.loc

	var/holding = user.get_active_hand()

	var/holdingnull = TRUE // User's hand started out empty, check for an empty hand.
	if(isnotnull(holding))
		holdingnull = FALSE // User's hand started holding something, check to see if it's still holding that.

	var/datum/progressbar/progbar
	if(progress)
		progbar = new /datum/progressbar(user, delay, target)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = 1
	while(world.time < endtime)
		sleep(1)
		if(progress)
			progbar.update(world.time - starttime)

		if(isnull(user) || user.incapacitated() || user.loc != original_loc)
			. = 0
			break

		if(isnotnull(target_loc) && (isnull(target) || target_loc != target.loc))
			. = 0
			break

		if(needhand)
			//This might seem like an odd check, but you can still need a hand even when it's empty
			//i.e the hand is used to pull some item/tool out of the construction
			if(!holdingnull)
				if(!holding)
					. = 0
					break
			if(user.get_active_hand() != holding)
				. = 0
				break

	if(progbar)
		qdel(progbar)

/proc/FindNameFromID(mob/living/carbon/human/H)
	ASSERT(istype(H))
	var/obj/item/card/id/C = H.get_active_hand()
	if(istype(C) || istype(C, /obj/item/device/pda))
		var/obj/item/card/id/ID = C

		if(istype(C, /obj/item/device/pda))
			var/obj/item/device/pda/pda = C
			ID = pda.id
		if(!istype(ID))
			ID = null

		if(isnotnull(ID))
			return ID.registered_name

	C = H.wear_id

	if(istype(C) || istype(C, /obj/item/device/pda))
		var/obj/item/card/id/ID = C

		if(istype(C, /obj/item/device/pda))
			var/obj/item/device/pda/pda = C
			ID = pda.id
		if(!istype(ID))
			ID = null

		if(isnotnull(ID))
			return ID.registered_name