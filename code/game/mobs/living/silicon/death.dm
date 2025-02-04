/mob/living/silicon/gib()
	..("gibbed-r")
	robogibs(loc, viruses)

	GLOBL.dead_mob_list -= src

/mob/living/silicon/dust()
	..("dust-r", /obj/effect/decal/remains/robot)

/mob/living/silicon/death(gibbed, deathmessage)
	if(in_contents_of(/obj/machinery/recharge_station))//exit the recharge station
		var/obj/machinery/recharge_station/RC = loc
		RC.go_out()
	return ..(gibbed, deathmessage)