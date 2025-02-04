/obj/machinery/door/window
	name = "interior door"
	desc = "A strong door."
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "left"
	var/base_state = "left"
	var/health = 150.0 //If you change this, consiter changing ../door/window/brigdoor/ health at the bottom of this .dm file
	visible = 0.0
	use_power = 0
	flags = ON_BORDER
	opacity = FALSE
	var/obj/item/airlock_electronics/electronics = null
	explosion_resistance = 5
	air_properties_vary_with_direction = 1

/obj/machinery/door/window/update_nearby_tiles(need_rebuild)
	if(!global.CTair_system)
		return 0

	global.CTair_system.mark_for_update(get_turf(src))

	return 1

/obj/machinery/door/window/initialize()
	. = ..()
	if(length(req_access))
		src.icon_state = "[src.icon_state]"
		src.base_state = src.icon_state
	return

/obj/machinery/door/window/Destroy()
	density = FALSE
	return ..()

/obj/machinery/door/window/Bumped(atom/movable/AM as mob|obj)
	if(!ismob(AM))
		var/obj/machinery/bot/bot = AM
		if(istype(bot))
			if(density && src.check_access(bot.botcard))
				open()
				sleep(50)
				close()
		else if(ismecha(AM))
			var/obj/mecha/mecha = AM
			if(density)
				if(mecha.occupant && src.allowed(mecha.occupant))
					open()
					sleep(50)
					close()
		return
	if(!global.CTgame_ticker)
		return
	if(src.operating)
		return
	if(src.density && src.allowed(AM))
		open()
		if(src.check_access(null))
			sleep(50)
		else //secure doors close faster
			sleep(20)
		close()
	return

/obj/machinery/door/window/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group)
			return 0
		return !density
	else
		return 1

/obj/machinery/door/window/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/machinery/door/window/open()
	if(src.operating == 1) //doors can still open when emag-disabled
		return 0
	if(!global.CTgame_ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1
	flick("[src.base_state]opening", src)
	playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	src.icon_state = "[src.base_state]open"
	sleep(10)

	explosion_resistance = 0
	src.density = FALSE
//	src.sd_SetOpacity(0)	//TODO: why is this here? Opaque windoors? ~Carn
	update_nearby_tiles()

	if(operating == 1) //emag again
		src.operating = 0
	return 1

/obj/machinery/door/window/close()
	if(src.operating)
		return 0
	src.operating = 1
	flick("[src.base_state]closing", src)
	playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	src.icon_state = src.base_state

	src.density = TRUE
	explosion_resistance = initial(explosion_resistance)
//	if(src.visible)
//		SetOpacity(1)	//TODO: why is this here? Opaque windoors? ~Carn
	update_nearby_tiles()

	sleep(10)

	src.operating = 0
	return 1

/obj/machinery/door/window/proc/take_damage(damage)
	src.health = max(0, src.health - damage)
	if(src.health <= 0)
		new /obj/item/shard(src.loc)
		var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src.loc)
		CC.amount = 2
		var/obj/item/airlock_electronics/ae
		if(!electronics)
			ae = new/obj/item/airlock_electronics(src.loc)
			if(!src.req_access)
				src.check_access()
			if(length(req_access))
				ae.conf_access = src.req_access
			else if(length(req_one_access))
				ae.conf_access = src.req_one_access
				ae.one_access = 1
		else
			ae = electronics
			electronics = null
			ae.loc = src.loc
		if(operating == -1)
			ae.icon_state = "door_electronics_smoked"
			operating = 0
		src.density = FALSE
		playsound(src, "shatter", 70, 1)
		qdel(src)
		return

/obj/machinery/door/window/bullet_act(obj/item/projectile/Proj)
	if(Proj.damage)
		take_damage(round(Proj.damage / 2))
	..()

//When an object is thrown at the window
/obj/machinery/door/window/hitby(AM as mob|obj)
	..()
	visible_message(SPAN_DANGER("The glass door was hit by [AM]."), 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce
	playsound(src, 'sound/effects/Glasshit.ogg', 100, 1)
	take_damage(tforce)
	//..() //Does this really need to be here twice? The parent proc doesn't even do anything yet. - Nodrak
	return

/obj/machinery/door/window/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/window/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
			visible_message(SPAN_DANGER("[user] smashes against the [src.name]."), 1)
			take_damage(25)
			return

	return src.attackby(user, user)

/obj/machinery/door/window/attackby(obj/item/I as obj, mob/user as mob)
	//If it's in the process of opening/closing, ignore the click
	if(src.operating == 1)
		return

	//Emags and ninja swords? You may pass.
	if(src.density && (istype(I, /obj/item/card/emag) || istype(I, /obj/item/melee/energy/blade)))
		src.operating = -1
		if(istype(I, /obj/item/melee/energy/blade))
			var/datum/effect/system/spark_spread/spark_system = new /datum/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			visible_message(SPAN_INFO("The glass door was sliced open by [user]!"))
		flick("[src.base_state]spark", src)
		sleep(6)
		open()
		return 1

	//If it's emagged, crowbar can pry electronics out.
	if(src.operating == -1 && istype(I, /obj/item/crowbar))
		playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
		user.visible_message("[user] removes the electronics from the windoor.", "You start to remove electronics from the windoor.")
		if(do_after(user, 40))
			to_chat(user, SPAN_INFO("You removed the windoor electronics!"))

			var/obj/structure/windoor_assembly/wa = new/obj/structure/windoor_assembly(src.loc)
			if(istype(src, /obj/machinery/door/window/brigdoor))
				wa.secure = "secure_"
				wa.name = "Secure Wired Windoor Assembly"
			else
				wa.name = "Wired Windoor Assembly"
			if(src.base_state == "right" || src.base_state == "rightsecure")
				wa.facing = "r"
			wa.set_dir(src.dir)
			wa.state = "02"
			wa.update_icon()

			var/obj/item/airlock_electronics/ae
			if(!electronics)
				ae = new/obj/item/airlock_electronics(src.loc)
				if(!src.req_access)
					src.check_access()
				if(length(req_access))
					ae.conf_access = src.req_access
				else if(length(req_one_access))
					ae.conf_access = src.req_one_access
					ae.one_access = 1
			else
				ae = electronics
				electronics = null
				ae.loc = src.loc
			ae.icon_state = "door_electronics_smoked"

			operating = 0
			qdel(src)
			return

	//If it's a weapon, smash windoor. Unless it's an id card, agent card, ect.. then ignore it (Cards really shouldnt damage a door anyway)
	if(src.density && istype(I, /obj/item) && !istype(I, /obj/item/card))
		var/aforce = I.force
		playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		visible_message(SPAN_DANGER("[src] was hit by [I]."))
		if(I.damtype == BRUTE || I.damtype == BURN)
			take_damage(aforce)
		return

	src.add_fingerprint(user)
	if(!src.requiresID())
		//don't care who they are or what they have, act as if they're NOTHING
		user = null

	if(src.allowed(user))
		if(src.density)
			open()
		else
			close()

	else if(src.density)
		flick("[src.base_state]deny", src)
	return


/obj/machinery/door/window/brigdoor
	name = "Secure Door"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"
	req_access = list(ACCESS_SECURITY)
	var/id = null
	health = 300.0 //Stronger doors for prison (regular window door health is 150)


/obj/machinery/door/window/northleft
	dir = NORTH

/obj/machinery/door/window/eastleft
	dir = EAST

/obj/machinery/door/window/westleft
	dir = WEST

/obj/machinery/door/window/southleft
	dir = SOUTH

/obj/machinery/door/window/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/brigdoor/northleft
	dir = NORTH

/obj/machinery/door/window/brigdoor/eastleft
	dir = EAST

/obj/machinery/door/window/brigdoor/westleft
	dir = WEST

/obj/machinery/door/window/brigdoor/southleft
	dir = SOUTH

/obj/machinery/door/window/brigdoor/northright
	dir = NORTH
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/eastright
	dir = EAST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/westright
	dir = WEST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/southright
	dir = SOUTH
	icon_state = "rightsecure"
	base_state = "rightsecure"