/obj/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5
	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0

	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/New()
	..()
	for(dir in list(NORTH, EAST, SOUTH, WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if(computer)
			computer.table = src
			break
//	spawn(100) //Wont the MC just call this process() before and at the 10 second mark anyway?
//		process()

/obj/machinery/optable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				src.density = FALSE
		else
	return

/obj/machinery/optable/blob_act()
	if(prob(75))
		qdel(src)

/obj/machinery/optable/attack_paw(mob/user as mob)
	if((HULK in usr.mutations))
		to_chat(usr, SPAN_INFO("You destroy the operating table."))
		visible_message(SPAN_WARNING("[usr] destroys the operating table!"))
		src.density = FALSE
		qdel(src)
	if(!(locate(/obj/machinery/optable, user.loc)))
		step(user, get_dir(user, src))
		if(user.loc == src.loc)
			user.layer = TURF_LAYER
			visible_message("The monkey hides under the table!")
	return

/obj/machinery/optable/attack_hand(mob/user as mob)
	if(HULK in usr.mutations)
		to_chat(usr, SPAN_INFO("You destroy the table."))
		visible_message(SPAN_WARNING("[usr] destroys the operating table!"))
		src.density = FALSE
		qdel(src)
	return

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || (height == 0))
		return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/optable/MouseDrop_T(obj/O as obj, mob/user as mob)
	if((!(istype(O, /obj/item)) || user.get_active_hand() != O))
		return
	user.drop_item()
	if(O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/machinery/optable/proc/check_victim()
	if(locate(/mob/living/carbon/human, src.loc))
		var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, src.loc)
		if(M.resting)
			src.victim = M
			icon_state = M.pulse ? "table2-active" : "table2-idle"
			return 1
	src.victim = null
	icon_state = "table2-idle"
	return 0

/obj/machinery/optable/process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user as mob)
	if(C == user)
		user.visible_message("[user] climbs on the operating table.","You climb on the operating table.")
	else
		visible_message(SPAN_WARNING("[C] has been laid on the operating table by [user]."), 3)
	if(C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.resting = 1
	C.loc = src.loc
	for(var/obj/O in src)
		O.loc = src.loc
	src.add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		src.victim = H
		icon_state = H.pulse ? "table2-active" : "table2-idle"
	else
		icon_state = "table2-idle"

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr) || usr.buckled || usr.restrained())
		return

	if(src.victim)
		to_chat(usr, SPAN_INFO_B("The table is already occupied!"))
		return

	take_victim(usr, usr)

/obj/machinery/optable/attackby(obj/item/W as obj, mob/living/carbon/user as mob)
	if(istype(W, /obj/item/grab))
		if(iscarbon(W:affecting))
			take_victim(W:affecting, usr)
			qdel(W)
			return
	user.drop_item()
	if(W && W.loc)
		W.loc = src.loc
	return