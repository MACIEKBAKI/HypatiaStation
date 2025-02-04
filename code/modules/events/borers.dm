//Cortical borer spawn event - care of RobRichards1997 with minor editing by Zuhayr.
/datum/event/borer_infestation
	announceWhen = 400
	oneShot = TRUE

	var/spawncount = 1
	var/successSpawn = FALSE	// So we don't make a command report if nothing gets spawned.

/datum/event/borer_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
	spawncount = rand(1, 3)

/datum/event/borer_infestation/announce()
	if(successSpawn)
		command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert")
		world << sound('sound/AI/aliens.ogg')

/datum/event/borer_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
		if(!temp_vent.welded && temp_vent.network && isStationLevel(temp_vent.loc.z))
			//Stops cortical borers getting stuck in small networks. See: Security, Virology
			if(length(temp_vent.network.normal_members) > 50)
				vents += temp_vent

	var/list/candidates = get_alien_candidates()
	while(spawncount > 0 && length(vents) && length(candidates))
		var/obj/vent = pick_n_take(vents)
		var/client/C = pick_n_take(candidates)

		var/mob/living/simple_animal/borer/new_borer = new(vent.loc)
		new_borer.key = C.key

		spawncount--
		successSpawn = TRUE