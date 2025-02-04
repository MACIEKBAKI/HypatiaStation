/obj/item/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = 2.0
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "grenade"
	item_state = "flashbang"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/active = 0
	var/det_time = 50

/obj/item/grenade/proc/clown_check(var/mob/living/user)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("Huh? How does this thing work?"))

		activate(user)
		add_fingerprint(user)
		spawn(5)
			prime()
		return 0
	return 1


/*/obj/item/grenade/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (istype(target, /obj/item/storage)) return ..() // Trying to put it in a full container
	if (istype(target, /obj/item/gun/grenadelauncher)) return ..()
	if((user.get_active_hand() == src) && (!active) && (clown_check(user)) && target.loc != src.loc)
		to_chat(user, SPAN_WARNING("You prime the [name]! [det_time/10] seconds!"))
		active = 1
		icon_state = initial(icon_state) + "_active"
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		spawn(det_time)
			prime()
			return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
	return*/


/obj/item/grenade/examine()
	set src in usr
	to_chat(usr, desc)
	if(det_time > 1)
		to_chat(usr, "The timer is set to [det_time / 10] seconds.")
		return
	to_chat(usr, "\The [src] is set for instant detonation.")


/obj/item/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			to_chat(user, SPAN_WARNING("You prime \the [name]! [det_time/10] seconds!"))

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return


/obj/item/grenade/proc/activate(mob/user as mob)
	if(active)
		return

	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	spawn(det_time)
		prime()
		return


/obj/item/grenade/proc/prime()
//	playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)


/obj/item/grenade/attackby(obj/item/W as obj, mob/user as mob)
	if(isscrewdriver(W))
		switch(det_time)
			if ("1")
				det_time = 10
				to_chat(user, SPAN_NOTICE("You set the [name] for 1 second detonation time."))
			if ("10")
				det_time = 30
				to_chat(user, SPAN_NOTICE("You set the [name] for 3 second detonation time."))
			if ("30")
				det_time = 50
				to_chat(user, SPAN_NOTICE("You set the [name] for 5 second detonation time."))
			if ("50")
				det_time = 1
				to_chat(user, SPAN_NOTICE("You set the [name] for instant detonation."))
		add_fingerprint(user)
	..()
	return

/obj/item/grenade/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/grenade/attack_paw(mob/user as mob)
	return attack_hand(user)
