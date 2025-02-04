/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 *		Plasma Glass Sheets
 *		Reinforced Plasma Glass Sheets (AKA Holy fuck strong windows)
 *		Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
/obj/item/stack/sheet/glass
	name = "glass"
	desc = "HOLY SHEET! That is a lot of glass."
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	matter_amounts = list(MATERIAL_GLASS = 3750)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1)
	var/created_window = /obj/structure/window/basic

/obj/item/stack/sheet/glass/cyborg
	name = "glass"
	desc = "HOLY SHEET! That is a lot of glass."
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	matter_amounts = list()
	created_window = /obj/structure/window/basic

/obj/item/stack/sheet/glass/attack_self(mob/user as mob)
	construct_window(user)

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(CC.amount < 5)
			to_chat(user, "\b There is not enough wire in this coil. You need 5 lengths.")
			return
		CC.use(5)
		to_chat(user, SPAN_INFO("You attach wire to the [name]."))
		new /obj/item/stack/light_w(user.loc)
		src.use(1)
	else if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V  = W
		var/obj/item/stack/sheet/rglass/RG = new(user.loc)
		RG.add_fingerprint(user)
		RG.add_to_stacks(user)
		V.use(1)
		var/obj/item/stack/sheet/glass/G = src
		qdel(src)
		var/replace = (user.get_inactive_hand() == G)
		G.use(1)
		if(!G && !RG && replace)
			user.put_in_hands(RG)
	else
		return ..()

/obj/item/stack/sheet/glass/proc/construct_window(mob/user as mob)
	if(!user || !src)
		return 0
	if(!isturf(user.loc))
		return 0
	if(!user.IsAdvancedToolUser())
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return 0

	var/title = "Sheet-Glass"
	title += " ([src.amount] sheet\s left)"
	switch(alert(title, "Would you like full tile glass or one direction?", "One Direction", "Full Window", "Cancel", null))
		if("One Direction")
			if(!src)
				return 1
			if(src.loc != user)
				return 1

			var/list/directions = list(GLOBL.cardinal)
			var/i = 0
			for(var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					to_chat(user, SPAN_WARNING("There are too many windows in this location."))
					return 1
				directions -= win.dir
				if(!(win.ini_dir in GLOBL.cardinal))
					to_chat(user, SPAN_WARNING("Can't let you do that."))
					return 1

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list(user.dir, turn(user.dir, 90), turn(user.dir, 180), turn(user.dir, 270)))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break
			var/obj/structure/window/W
			W = new created_window(user.loc, 0)
			W.set_dir(dir_to_set)
			W.ini_dir = W.dir
			W.anchored = FALSE
			src.use(1)

		if("Full Window")
			if(!src)
				return 1
			if(src.loc != user)
				return 1
			if(src.amount < 2)
				to_chat(user, SPAN_WARNING("You need more glass to do that."))
				return 1
			if(locate(/obj/structure/window) in user.loc)
				to_chat(user, SPAN_WARNING("There is a window in the way."))
				return 1

			var/obj/structure/window/W
			W = new created_window(user.loc, 0)
			W.set_dir(SOUTHWEST)
			W.ini_dir = SOUTHWEST
			W.anchored = FALSE
			src.use(2)
	return 0

/*
 * Reinforced glass sheets
 */
/obj/item/stack/sheet/rglass
	name = "reinforced glass"
	desc = "Glass which seems to have rods or something stuck in them."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	matter_amounts = list(MATERIAL_METAL = 1875, MATERIAL_GLASS = 3750)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 2)

/obj/item/stack/sheet/rglass/cyborg
	name = "reinforced glass"
	desc = "Glass which seems to have rods or something stuck in them."
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	matter_amounts = list()

/obj/item/stack/sheet/rglass/attack_self(mob/user as mob)
	construct_window(user)

/obj/item/stack/sheet/rglass/proc/construct_window(mob/user as mob)
	if(!user || !src)
		return 0
	if(!isturf(user.loc))
		return 0
	if(!user.IsAdvancedToolUser())
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return 0

	var/title = "Sheet Reinf. Glass"
	title += " ([src.amount] sheet\s left)"
	switch(input(title, "Would you like full tile glass, a one direction glass pane or a windoor?") in list("One Direction", "Full Window", "Windoor", "Cancel"))
		if("One Direction")
			if(!src)
				return 1
			if(src.loc != user)
				return 1

			var/list/directions = list(GLOBL.cardinal)
			var/i = 0
			for(var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					to_chat(user, SPAN_WARNING("There are too many windows in this location."))
					return 1
				directions -= win.dir
				if(!(win.ini_dir in GLOBL.cardinal))
					to_chat(user, SPAN_WARNING("Can't let you do that."))
					return 1

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list(user.dir, turn(user.dir, 90), turn(user.dir, 180), turn(user.dir, 270)))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break

			var/obj/structure/window/W
			W = new /obj/structure/window/reinforced(user.loc, 1)
			W.state = 0
			W.set_dir(dir_to_set)
			W.ini_dir = W.dir
			W.anchored = FALSE
			src.use(1)

		if("Full Window")
			if(!src)
				return 1
			if(src.loc != user)
				return 1
			if(src.amount < 2)
				to_chat(user, SPAN_WARNING("You need more glass to do that."))
				return 1
			if(locate(/obj/structure/window) in user.loc)
				to_chat(user, SPAN_WARNING("There is a window in the way."))
				return 1
			var/obj/structure/window/W
			W = new /obj/structure/window/reinforced(user.loc, 1)
			W.state = 0
			W.set_dir(SOUTHWEST)
			W.ini_dir = SOUTHWEST
			W.anchored = FALSE
			src.use(2)

		if("Windoor")
			if(!src || src.loc != user)
				return 1

			if(isturf(user.loc) && locate(/obj/structure/windoor_assembly, user.loc))
				to_chat(user, SPAN_WARNING("There is already a windoor assembly in that location."))
				return 1

			if(isturf(user.loc) && locate(/obj/machinery/door/window, user.loc))
				to_chat(user, SPAN_WARNING("There is already a windoor in that location."))
				return 1

			if(src.amount < 5)
				to_chat(user, SPAN_WARNING("You need more glass to do that."))
				return 1

			var/obj/structure/windoor_assembly/WD
			WD = new /obj/structure/windoor_assembly(user.loc)
			WD.state = "01"
			WD.anchored = FALSE
			src.use(5)
			switch(user.dir)
				if(SOUTH)
					WD.set_dir(SOUTH)
					WD.ini_dir = SOUTH
				if(EAST)
					WD.set_dir(EAST)
					WD.ini_dir = EAST
				if(WEST)
					WD.set_dir(WEST)
					WD.ini_dir = WEST
				else	//If the user is facing northeast. northwest, southeast, southwest or north, default to north
					WD.set_dir(NORTH)
					WD.ini_dir = NORTH
		else
			return 1
	return 0

/*
 * Glass shards - TODO: Move this into code/game/object/item/weapons
 */
/obj/item/shard/Bump()
	spawn(0)
		if(prob(20))
			src.force = 15
		else
			src.force = 4
		..()
		return
	return

/obj/item/shard/New()
	src.icon_state = pick("large", "medium", "small")
	switch(src.icon_state)
		if("small")
			src.pixel_x = rand(-12, 12)
			src.pixel_y = rand(-12, 12)
		if("medium")
			src.pixel_x = rand(-8, 8)
			src.pixel_y = rand(-8, 8)
		if("large")
			src.pixel_x = rand(-5, 5)
			src.pixel_y = rand(-5, 5)
		else
	return

/obj/item/shard/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			var/obj/item/stack/sheet/glass/NG = new(user.loc)
			for(var/obj/item/stack/sheet/glass/G in user.loc)
				if(G == NG)
					continue
				if(G.amount >= G.max_amount)
					continue
				G.attackby(NG, user)
				to_chat(usr, "You add the newly-formed glass to the stack. It now contains [NG.amount] sheets.")

			qdel(src)
			return
	return ..()

/obj/item/shard/Crossed(AM as mob|obj)
	if(ismob(AM))
		var/mob/M = AM
		to_chat(M, SPAN_DANGER("You step in the broken glass!"))
		playsound(src, 'sound/effects/glass_step.ogg', 50, 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.flags & IS_SYNTHETIC)
				return

			if(!H.shoes && (!H.wear_suit || !(H.wear_suit.body_parts_covered & FEET)))
				var/datum/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot"))
				if(affecting.status & ORGAN_ROBOT)
					return

				H.Weaken(3)
				if(affecting.take_damage(5, 0))
					H.UpdateDamageIcon()
				H.updatehealth()
	..()


/*
 * Plasma Glass sheets
 */
/obj/item/stack/sheet/glass/plasmaglass
	name = "plasma glass"
	desc = "A very strong and very resistant sheet of a plasma-glass alloy."
	singular_name = "plasma glass sheet"
	icon_state = "sheet-plasmaglass"
	matter_amounts = list(MATERIAL_GLASS = 7500)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_PLASMATECH = 2)
	created_window = /obj/structure/window/plasmabasic

/obj/item/stack/sheet/glass/plasmaglass/attack_self(mob/user as mob)
	construct_window(user)

/obj/item/stack/sheet/glass/plasmaglass/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/V = W
		var/obj/item/stack/sheet/glass/plasmarglass/RG = new (user.loc)
		RG.add_fingerprint(user)
		RG.add_to_stacks(user)
		V.use(1)
		var/obj/item/stack/sheet/glass/G = src
		qdel(src)
		var/replace = (user.get_inactive_hand() == G)
		G.use(1)
		if (!G && !RG && replace)
			user.put_in_hands(RG)
	else
		return ..()

/*
 * Reinforced plasma glass sheets
 */
/obj/item/stack/sheet/glass/plasmarglass
	name = "reinforced plasma glass"
	desc = "Plasma glass which seems to have rods or something stuck in them."
	singular_name = "reinforced plasma glass sheet"
	icon_state = "sheet-plasmarglass"
	matter_amounts = list(MATERIAL_METAL = 1875, MATERIAL_GLASS = 7500)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_PLASMATECH = 2)
	created_window = /obj/structure/window/plasmareinforced

/obj/item/stack/sheet/glass/plasmarglass/attack_self(mob/user as mob)
	construct_window(user)