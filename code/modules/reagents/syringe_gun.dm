/obj/item/weapon/gun/syringe
	name = "syringe gun"
	desc = "A spring loaded rifle designed to fit syringes, designed to incapacitate unruly patients from a distance."
	icon = 'icons/obj/gun.dmi'
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 4.0
	var/list/syringes = list()
	var/max_syringes = 1
	m_amt = 2000

/obj/item/weapon/gun/syringe/examine()
	set src in view()
	..()
	if(!(usr in view(2)) && usr != src.loc)
		return
	to_chat(usr, SPAN_INFO("[length(syringes)] / [max_syringes] syringes."))

/obj/item/weapon/gun/syringe/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = I
		if(S.mode != 2) //SYRINGE_BROKEN in syringes.dm
			if(length(syringes) < max_syringes)
				user.drop_item()
				I.loc = src
				syringes += I
				to_chat(user, SPAN_INFO("You put the syringe in [src]."))
				to_chat(user, SPAN_INFO("[length(syringes)] / [max_syringes] syringes."))
			else
				to_chat(usr, SPAN_WARNING("[src] cannot hold more syringes."))
		else
			to_chat(usr, SPAN_WARNING("This syringe is broken!"))

/obj/item/weapon/gun/syringe/afterattack(obj/target, mob/user , flag)
	if(!isturf(target.loc) || target == user)
		return
	..()

/obj/item/weapon/gun/syringe/can_fire()
	return length(syringes)

/obj/item/weapon/gun/syringe/can_hit(mob/living/target as mob, mob/living/user as mob)
	return 1		//SHOOT AND LET THE GOD GUIDE IT (probably will hit a wall anyway)

/obj/item/weapon/gun/syringe/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
	if(length(syringes))
		spawn(0)
			fire_syringe(target,user)
	else
		to_chat(usr, SPAN_WARNING("[src] is empty."))

/obj/item/weapon/gun/syringe/proc/fire_syringe(atom/target, mob/user)
	if(locate(/obj/structure/table, src.loc))
		return
	else
		var/turf/trg = get_turf(target)
		var/obj/effect/syringe_gun_dummy/D = new/obj/effect/syringe_gun_dummy(get_turf(src))
		var/obj/item/weapon/reagent_containers/syringe/S = syringes[1]
		if((!S) || (!S.reagents))	//ho boy! wot runtimes!
			return
		S.reagents.trans_to(D, S.reagents.total_volume)
		syringes -= S
		qdel(S)
		D.icon_state = "syringeproj"
		D.name = "syringe"
		playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)

		for(var/i = 0, i < 6, i++)
			if(!D)
				break
			if(D.loc == trg)
				break
			step_towards(D, trg)

			if(D)
				for(var/mob/living/carbon/M in D.loc)
					if(!iscarbon(M))
						continue
					if(M == user)
						continue
					//Syringe gun attack logging by Yvarov
					var/R
					if(D.reagents)
						for(var/datum/reagent/A in D.reagents.reagent_list)
							R += A.id + " ("
							R += num2text(A.volume) + "),"
					if(ismob(M))
						M.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>syringegun</b> ([R])"
						user.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>syringegun</b> ([R])"
						msg_admin_attack("[user] ([user.ckey]) shot [M] ([M.ckey]) with a syringegun ([R]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
					else
						M.attack_log += "\[[time_stamp()]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[M]/[M.ckey]</b> with a <b>syringegun</b> ([R])"
						msg_admin_attack("UNKNOWN shot [M] ([M.ckey]) with a <b>syringegun</b> ([R]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

					if(D.reagents)
						D.reagents.trans_to(M, 15)
					M.visible_message(SPAN_DANGER("[M] is hit by the syringe!"))

					qdel(D)
					break
			if(D)
				for(var/atom/A in D.loc)
					if(A == user)
						continue
					if(A.density)
						qdel(D)

			sleep(1)

		if(D)
			spawn(10)
				qdel(D)

		return


/obj/item/weapon/gun/syringe/rapidsyringe
	name = "rapid syringe gun"
	desc = "A modification of the syringe gun design, using a rotating cylinder to store up to four syringes."
	icon_state = "rapidsyringegun"
	max_syringes = 4


/obj/effect/syringe_gun_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	anchored = TRUE
	density = FALSE

/obj/effect/syringe_gun_dummy/New()
	var/datum/reagents/R = new/datum/reagents(15)
	reagents = R
	R.my_atom = src