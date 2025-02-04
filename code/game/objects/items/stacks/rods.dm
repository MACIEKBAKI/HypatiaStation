/obj/item/stack/rods
	name = "metal rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "metal rod"
	icon_state = "rods"
	flags = CONDUCT
	w_class = 3.0
	force = 9.0
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	matter_amounts = list(MATERIAL_METAL = 1875)
	max_amount = 60
	attack_verb = list("hit", "bludgeoned", "whacked")

/obj/item/stack/rods/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W

		if(amount < 2)
			to_chat(user, SPAN_WARNING("You need at least two rods to do this."))
			return

		if(WT.remove_fuel(0, user))
			var/obj/item/stack/sheet/metal/new_item = new(usr.loc)
			new_item.add_to_stacks(usr)
			for(var/mob/M in viewers(src))
				M.show_message(SPAN_WARNING("[src] is shaped into metal by [user.name] with the weldingtool."), 3, SPAN_WARNING("You hear welding."), 2)
			var/obj/item/stack/rods/R = src
			qdel(src)
			var/replace = (user.get_inactive_hand() == R)
			R.use(2)
			if(!R && replace)
				user.put_in_hands(new_item)
		return
	..()

/obj/item/stack/rods/attack_self(mob/user as mob)
	src.add_fingerprint(user)

	if(!isturf(user.loc))
		return 0

	if(locate(/obj/structure/grille, user.loc))
		for(var/obj/structure/grille/G in user.loc)
			if(G.destroyed)
				G.health = 10
				G.density = TRUE
				G.destroyed = 0
				G.icon_state = "grille"
				use(1)
			else
				return 1
	else
		if(amount < 2)
			to_chat(user, SPAN_INFO("You need at least two rods to do this."))
			return
		to_chat(user, SPAN_INFO("Assembling grille..."))
		if(!do_after(user, 10))
			return
		var/obj/structure/grille/F = new /obj/structure/grille(user.loc)
		to_chat(user, SPAN_INFO("You assemble a grille."))
		F.add_fingerprint(user)
		use(2)
	return