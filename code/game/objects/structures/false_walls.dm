/*
 * False Walls
 */
/obj/structure/falsewall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	anchored = TRUE
	icon = 'icons/turf/walls.dmi'
	var/mineral = MATERIAL_METAL
	var/opening = 0

/obj/structure/falsewall/New()
	relativewall_neighbours()
	..()

/obj/structure/falsewall/Destroy()

	var/temploc = src.loc

	spawn(10)
		for(var/turf/simulated/wall/W in range(temploc,1))
			W.relativewall()

		for(var/obj/structure/falsewall/W in range(temploc,1))
			W.relativewall()

		for(var/obj/structure/falserwall/W in range(temploc,1))
			W.relativewall()
	return ..()


/obj/structure/falsewall/relativewall()

	if(!density)
		icon_state = "[mineral]fwall_open"
		return

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	for(var/turf/simulated/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)//Only 'like' walls connect -Sieve
				junction |= get_dir(src,W)
	for(var/obj/structure/falsewall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	for(var/obj/structure/falserwall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	icon_state = "[mineral][junction]"
	return

/obj/structure/falsewall/attack_hand(mob/user as mob)
	if(opening)
		return

	if(density)
		opening = 1
		icon_state = "[mineral]fwall_open"
		flick("[mineral]fwall_opening", src)
		sleep(15)
		src.density = FALSE
		set_opacity(0)
		opening = 0
	else
		opening = 1
		flick("[mineral]fwall_closing", src)
		icon_state = "[mineral]0"
		density = TRUE
		sleep(15)
		set_opacity(1)
		src.relativewall()
		opening = 0

/obj/structure/falsewall/update_icon()//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	..()
	if(density)
		icon_state = "[mineral]0"
		src.relativewall()
	else
		icon_state = "[mineral]fwall_open"

/obj/structure/falsewall/attackby(obj/item/W as obj, mob/user as mob)
	if(opening)
		user << "\red You must wait until the door has stopped moving."
		return

	if(density)
		var/turf/T = get_turf(src)
		if(T.density)
			user << "\red The wall is blocked!"
			return
		if(istype(W, /obj/item/screwdriver))
			user.visible_message("[user] tightens some bolts on the wall.", "You tighten the bolts on the wall.")
			if(!mineral || mineral == MATERIAL_METAL)
				T.ChangeTurf(/turf/simulated/wall)
			else
				T.ChangeTurf(text2path("/turf/simulated/wall/mineral/[mineral]"))
			qdel(src)

		if( istype(W, /obj/item/weldingtool) )
			var/obj/item/weldingtool/WT = W
			if( WT:welding )
				if(!mineral)
					T.ChangeTurf(/turf/simulated/wall)
				else
					T.ChangeTurf(text2path("/turf/simulated/wall/mineral/[mineral]"))
				if(mineral != "plasma")//Stupid shit keeps me from pushing the attackby() to plasma walls -Sieve
					T = get_turf(src)
					T.attackby(W,user)
				qdel(src)
	else
		user << "\blue You can't reach, close it first!"

	if( istype(W, /obj/item/pickaxe/plasmacutter) )
		var/turf/T = get_turf(src)
		if(!mineral)
			T.ChangeTurf(/turf/simulated/wall)
		else
			T.ChangeTurf(text2path("/turf/simulated/wall/mineral/[mineral]"))
		if(mineral != "plasma")
			T = get_turf(src)
			T.attackby(W,user)
		qdel(src)

	//DRILLING
	else if (istype(W, /obj/item/pickaxe/diamonddrill))
		var/turf/T = get_turf(src)
		if(!mineral)
			T.ChangeTurf(/turf/simulated/wall)
		else
			T.ChangeTurf(text2path("/turf/simulated/wall/mineral/[mineral]"))
		T = get_turf(src)
		T.attackby(W,user)
		qdel(src)

	else if( istype(W, /obj/item/melee/energy/blade) )
		var/turf/T = get_turf(src)
		if(!mineral)
			T.ChangeTurf(/turf/simulated/wall)
		else
			T.ChangeTurf(text2path("/turf/simulated/wall/mineral/[mineral]"))
		if(mineral != "plasma")
			T = get_turf(src)
			T.attackby(W,user)
		qdel(src)

/obj/structure/falsewall/update_icon()//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	..()
	if(density)
		icon_state = "[mineral]0"
		src.relativewall()
	else
		icon_state = "[mineral]fwall_open"

/*
 * False R-Walls
 */

/obj/structure/falserwall
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to seperate rooms."
	icon = 'icons/turf/walls.dmi'
	icon_state = "r_wall"
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	var/mineral = MATERIAL_METAL
	var/opening = 0

/obj/structure/falserwall/New()
	relativewall_neighbours()
	..()


/obj/structure/falserwall/attack_hand(mob/user as mob)
	if(opening)
		return

	if(density)
		opening = 1
		// Open wall
		icon_state = "frwall_open"
		flick("frwall_opening", src)
		sleep(15)
		density = FALSE
		set_opacity(0)
		opening = 0
	else
		opening = 1
		icon_state = "r_wall"
		flick("frwall_closing", src)
		density = TRUE
		sleep(15)
		set_opacity(1)
		relativewall()
		opening = 0

/obj/structure/falserwall/relativewall()

	if(!density)
		icon_state = "frwall_open"
		return

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	for(var/turf/simulated/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)//Only 'like' walls connect -Sieve
				junction |= get_dir(src,W)
	for(var/obj/structure/falsewall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	for(var/obj/structure/falserwall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	icon_state = "rwall[junction]"
	return



/obj/structure/falserwall/attackby(obj/item/W as obj, mob/user as mob)
	if(opening)
		user << "\red You must wait until the door has stopped moving."
		return

	if(istype(W, /obj/item/screwdriver))
		var/turf/T = get_turf(src)
		user.visible_message("[user] tightens some bolts on the r wall.", "You tighten the bolts on the wall.")
		T.ChangeTurf(/turf/simulated/wall) //Intentionally makes a regular wall instead of an r-wall (no cheap r-walls for you).
		qdel(src)

	if( istype(W, /obj/item/weldingtool) )
		var/obj/item/weldingtool/WT = W
		if( WT.remove_fuel(0,user) )
			var/turf/T = get_turf(src)
			T.ChangeTurf(/turf/simulated/wall)
			T = get_turf(src)
			T.attackby(W,user)
			qdel(src)

	else if( istype(W, /obj/item/pickaxe/plasmacutter) )
		var/turf/T = get_turf(src)
		T.ChangeTurf(/turf/simulated/wall)
		T = get_turf(src)
		T.attackby(W,user)
		qdel(src)

	//DRILLING
	else if (istype(W, /obj/item/pickaxe/diamonddrill))
		var/turf/T = get_turf(src)
		T.ChangeTurf(/turf/simulated/wall)
		T = get_turf(src)
		T.attackby(W,user)
		qdel(src)

	else if( istype(W, /obj/item/melee/energy/blade) )
		var/turf/T = get_turf(src)
		T.ChangeTurf(/turf/simulated/wall)
		T = get_turf(src)
		T.attackby(W,user)
		qdel(src)


/*
 * Uranium Falsewalls
 */

/obj/structure/falsewall/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon_state = ""
	mineral = MATERIAL_URANIUM
	var/active = null
	var/last_event = 0

/obj/structure/falsewall/uranium/attackby(obj/item/W as obj, mob/user as mob)
	radiate()
	..()

/obj/structure/falsewall/uranium/attack_hand(mob/user as mob)
	radiate()
	..()

/obj/structure/falsewall/uranium/proc/radiate()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/L in range(3,src))
				L.apply_effect(12,IRRADIATE,0)
			for(var/turf/simulated/wall/mineral/uranium/T in range(3,src))
				T.radiate()
			last_event = world.time
			active = null
			return
	return
/*
 * Other misc falsewall types
 */

/obj/structure/falsewall/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon_state = ""
	mineral = MATERIAL_GOLD

/obj/structure/falsewall/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny."
	icon_state = ""
	mineral = MATERIAL_SILVER

/obj/structure/falsewall/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	icon_state = ""
	mineral = MATERIAL_DIAMOND

/obj/structure/falsewall/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definately a bad idea."
	icon_state = ""
	mineral = MATERIAL_PLASMA

//-----------wtf?-----------start
/obj/structure/falsewall/clown
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	icon_state = ""
	mineral = MATERIAL_BANANIUM

/obj/structure/falsewall/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating."
	icon_state = ""
	mineral = MATERIAL_SANDSTONE
//------------wtf?------------end