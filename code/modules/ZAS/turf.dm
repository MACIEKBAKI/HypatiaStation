/turf/simulated
	var/zone/zone
	var/open_directions
	var/gas_graphic

/turf
	var/needs_air_update = FALSE
	var/datum/gas_mixture/air = null

/turf/simulated/proc/set_graphic(new_graphic)
	gas_graphic = new_graphic
	overlays.Cut()
	for(var/i in gas_graphic)
		overlays.Add(i)

/turf/proc/update_air_properties()
	var/block = c_airblock(src)
	if(block & AIR_BLOCKED)
		//dbg(blocked)
		return 1

	#ifdef ZLEVELS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/unsim = get_step(src, d)

		if(!unsim)
			continue

		block = unsim.c_airblock(src)

		if(block & AIR_BLOCKED)
			//unsim.dbg(air_blocked, turn(180,d))
			continue

		var/r_block = c_airblock(unsim)

		if(r_block & AIR_BLOCKED)
			continue

		if(istype(unsim, /turf/simulated))
			var/turf/simulated/sim = unsim
			if(global.CTair_system.has_valid_zone(sim))
				global.CTair_system.connect(sim, src)

/turf/simulated/update_air_properties()
	if(zone && zone.invalid)
		c_copy_air()
		zone = null //Easier than iterating through the list at the zone.

	var/s_block = c_airblock(src)
	if(s_block & AIR_BLOCKED)
		#ifdef ZASDBG
		if(verbose)
			to_world("Self-blocked.")
		//dbg(blocked)
		#endif
		if(zone)
			var/zone/z = zone
			if(locate(/obj/machinery/door/airlock) in src) //Hacky, but prevents normal airlocks from rebuilding zones all the time
				z.remove(src)
			else
				z.rebuild()

		return 1

	var/previously_open = open_directions
	open_directions = 0

	var/list/postponed
	#ifdef ZLEVELS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/unsim = get_step(src, d)

		if(!unsim) //edge of map
			continue

		var/block = unsim.c_airblock(src)
		if(block & AIR_BLOCKED)
			#ifdef ZASDBG
			if(verbose)
				to_world("[d] is blocked.")
			//unsim.dbg(air_blocked, turn(180,d))
			#endif

			continue

		var/r_block = c_airblock(unsim)
		if(r_block & AIR_BLOCKED)
			#ifdef ZASDBG
			if(verbose)
				to_world("[d] is blocked.")
			//dbg(air_blocked, d)
			#endif

			//Check that our zone hasn't been cut off recently.
			//This happens when windows move or are constructed. We need to rebuild.
			if((previously_open & d) && istype(unsim, /turf/simulated))
				var/turf/simulated/sim = unsim
				if(sim.zone == zone)
					zone.rebuild()
					return

			continue

		open_directions |= d

		if(istype(unsim, /turf/simulated))
			var/turf/simulated/sim = unsim
			sim.open_directions |= GLOBL.reverse_dir[d]

			if(global.CTair_system.has_valid_zone(sim))
				//Might have assigned a zone, since this happens for each direction.
				if(!zone)
					//if((block & ZONE_BLOCKED) || (r_block & ZONE_BLOCKED && !(s_block & ZONE_BLOCKED)))
					if(((block & ZONE_BLOCKED) && !(r_block & ZONE_BLOCKED)) || (r_block & ZONE_BLOCKED && !(s_block & ZONE_BLOCKED)))
						#ifdef ZASDBG
						if(verbose)
							to_world("[d] is zone blocked.")
						//dbg(zone_blocked, d)
						#endif

						//Postpone this tile rather than exit, since a connection can still be made.
						if(!postponed)
							postponed = list()
						postponed.Add(sim)

					else
						sim.zone.add(src)

						#ifdef ZASDBG
						dbg(assigned)
						if(verbose)
							to_world("Added to [zone]")
						#endif

				else if(sim.zone != zone)
					#ifdef ZASDBG
					if(verbose)
						to_world("Connecting to [sim.zone]")
					#endif

					global.CTair_system.connect(src, sim)

			#ifdef ZASDBG
				else if(verbose)
					to_world("[d] has same zone.")

			else if(verbose)
				to_world("[d] has invalid zone.")
			#endif

		else
			//Postponing connections to tiles until a zone is assured.
			if(!postponed)
				postponed = list()
			postponed.Add(unsim)

	if(!global.CTair_system.has_valid_zone(src)) //Still no zone, make a new one.
		var/zone/newzone = new /zone()
		newzone.add(src)

	#ifdef ZASDBG
		dbg(created)

	ASSERT(zone)
	#endif

	//At this point, a zone should have happened. If it hasn't, don't add more checks, fix the bug.

	for(var/turf/T in postponed)
		global.CTair_system.connect(src, T)

/turf/proc/post_update_air_properties()
	if(connections)
		connections.update_all()

/turf/assume_air(datum/gas_mixture/giver) //use this for machines to adjust air
	return 0

/turf/proc/assume_gas(gasid, moles, temp = 0)
	return 0

/turf/return_air()
	// Create gas mixture to hold data for passing.
	var/datum/gas_mixture/GM = new /datum/gas_mixture()
	if(isnotnull(initial_gases))
		GM.gas = initial_gases.Copy()
	GM.temperature = temperature
	GM.update_values()
	return GM

/turf/remove_air(amount as num)
	var/datum/gas_mixture/GM = return_air()
	return GM.remove(amount)

/turf/simulated/assume_air(datum/gas_mixture/giver)
	var/datum/gas_mixture/my_air = return_air()
	my_air.merge(giver)

/turf/simulated/assume_gas(gasid, moles, temp = null)
	var/datum/gas_mixture/my_air = return_air()

	if(isnull(temp))
		my_air.adjust_gas(gasid, moles)
	else
		my_air.adjust_gas_temp(gasid, moles, temp)

	return 1

/turf/simulated/remove_air(amount as num)
	var/datum/gas_mixture/my_air = return_air()
	return my_air.remove(amount)

/turf/simulated/return_air()
	if(zone)
		if(!zone.invalid)
			global.CTair_system.mark_zone_update(zone)
			return zone.air
		else
			if(isnull(air))
				make_air()
			c_copy_air()
			return air
	else
		if(isnull(air))
			make_air()
		return air

/turf/proc/make_air()
	air = new /datum/gas_mixture()
	if(isnotnull(initial_gases))
		air.gas = initial_gases.Copy()
	air.temperature = temperature
	air.update_values()

/turf/simulated/proc/c_copy_air()
	if(isnull(air))
		air = new /datum/gas_mixture()
	air.copy_from(zone.air)
	air.group_multiplier = 1