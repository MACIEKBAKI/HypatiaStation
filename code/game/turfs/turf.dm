/turf
	icon = 'icons/turf/floors.dmi'
	level = 1.0

	// For floors, use is_plating(), is_plasteel_floor() and is_light_floor().
	var/intact = 1

	// Properties for open tiles (/floor)
	var/list/initial_gases = list() // A list of all gas amounts that this turf starts with, indexed by typepath.

	// Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	// Properties for both
	var/temperature = T20C

	var/blocks_air = 0
	var/icon_old = null
	var/pathweight = 1

/turf/New()
	. = ..()
	GLOBL.processing_turfs.Add(src)

	for(var/atom/movable/AM as mob|obj in src)
		spawn(0)
			Entered(AM)
			return

/turf/Destroy()
	GLOBL.processing_turfs.Remove(src)
	return ..()

/turf/proc/process()
	return PROCESS_KILL

/turf/ex_act(severity)
	return 0

/turf/bullet_act(obj/item/projectile/proj)
	if(istype(proj, /obj/item/projectile/energy/beam/pulse))
		ex_act(2)
	. = ..()

/turf/bullet_act(obj/item/projectile/proj)
	if(istype(proj, /obj/item/projectile/bullet/gyro))
		explosion(src, -1, 0, 2)
	. = ..()

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		FEEDBACK_MOVEMENT_ADMIN_DISABLED(usr) // This is to identify lag problems.
		return

	if(isnull(mover) || !isturf(mover.loc))
		return TRUE

	// First, check objects to block exit that are not on the border.
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.flags & ON_BORDER) && mover != obstacle && forget != obstacle)
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return FALSE

	// Now, check objects to block exit that are on the border.
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && mover != border_obstacle && forget != border_obstacle)
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return FALSE

	// Next, check objects to block entry that are on the border.
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && forget != border_obstacle)
				mover.Bump(border_obstacle, 1)
				return FALSE

	// Then, check the turf itself.
	if(!CanPass(mover, src))
		mover.Bump(src, 1)
		return FALSE

	// Finally, check objects/mobs to block entry that are not on the border.
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.flags & ON_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && forget != obstacle)
				mover.Bump(obstacle, 1)
				return FALSE

	return TRUE // Nothing found to block so return success!

/turf/Entered(atom/atom as mob|obj)
	if(movement_disabled)
		FEEDBACK_MOVEMENT_ADMIN_DISABLED(usr) // This is to identify lag problems.
		return
	..()
//vvvvv Infared beam stuff vvvvv

	if(atom && atom.density && !istype(atom, /obj/effect/beam))
		for(var/obj/effect/beam/i_beam/I in src)
			spawn(0)
				if(I)
					I.hit()
				break

//^^^^^ Infared beam stuff ^^^^^

	if(!ismovable(atom))
		return

	var/atom/movable/M = atom

	var/loopsanity = 100
	if(ismob(M))
		var/mob/mob = M
		if(isnull(mob.lastarea))
			mob.lastarea = get_area(M.loc)
		if(!mob.lastarea.has_gravity)
			inertial_drift(M)

	/*
		if(M.flags & NOGRAV)
			inertial_drift(M)
	*/

		else if(!isspace(src))
			M:inertia_dir = 0
	..()
	var/objects = 0
	for(var/atom/A as mob|obj|turf|area in range(1))
		if(objects > loopsanity)
			break
		objects++
		spawn(0)
			if(A && M)
				A.HasProximity(M, 1)
			return

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0
/turf/proc/is_asteroid_floor()
	return 0
/turf/proc/is_plasteel_floor()
	return 0
/turf/proc/is_light_floor()
	return 0
/turf/proc/is_grass_floor()
	return 0
/turf/proc/is_wood_floor()
	return 0
/turf/proc/is_carpet_floor()
	return 0
/turf/proc/return_siding_icon_state()		//used for grass floors, which have siding.
	return 0

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(isnull(A.last_move))
		return

	if(ismob(A) && x > 2 && x < (world.maxx - 1) && y > 2 && y < (world.maxy - 1))
		var/mob/M = A
		if(M.Process_Spacemove(1))
			M.inertia_dir = 0
			return
		spawn(5)
			if(isnotnull(M) && !M.anchored && !M.pulledby && M.loc == src)
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(src.intact)

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(isnotnull(L))
		qdel(L)

//Creates a new turf
/turf/proc/ChangeTurf(turf/N)
	if(isnull(N))
		return

///// Z-Level Stuff ///// This makes sure that turfs are not changed to space when one side is part of a zone
	if(N == /turf/space)
		var/turf/controller = locate(1, 1, src.z)
		for(var/obj/effect/landmark/zcontroller/c in controller)
			if(c.down)
				var/turf/below = locate(src.x, src.y, c.down_target)
				if((global.CTair_system.has_valid_zone(below) || global.CTair_system.has_valid_zone(src)) && !isspace(below)) // dont make open space into space, its pointless and makes people drop out of the station
					var/turf/W = ChangeTurf(/turf/simulated/floor/open)
					var/list/temp = list()
					temp.Add(W)
					c.add(temp, 3, 1) // report the new open space to the zcontroller
					return W
///// Z-Level Stuff

	var/obj/fire/old_fire = fire

	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/old_corners = corners

	if(connections)
		connections.erase_all()

	if(istype(src, /turf/simulated))
		//Yeah, we're just going to rebuild the whole thing.
		//Despite this being called a bunch during explosions,
		//the zone will only really do heavy lifting once.
		var/turf/simulated/S = src
		if(S.zone)
			S.zone.rebuild()

	if(ispath(N, /turf/simulated/floor))
		var/turf/simulated/W = new N(locate(src.x, src.y, src.z))

		if(old_fire)
			fire = old_fire

		if(istype(W, /turf/simulated/floor))
			W.RemoveLattice()

		global.CTair_system?.mark_for_update(src)

		for(var/turf/space/S in range(W, 1))
			S.update_starlight()

		W.levelupdate()
		. = W

	else
		var/turf/W = new N(locate(src.x, src.y, src.z))
		if(old_fire)
			old_fire.RemoveFire()

		global.CTair_system?.mark_for_update(src)

		for(var/turf/space/S in range(W, 1))
			S.update_starlight()

		W.levelupdate()
		. = W

	recalc_atom_opacity()

	if(GLOBL.lighting_overlays_initialised)
		lighting_overlay = old_lighting_overlay
		affecting_lights = old_affecting_lights
		corners = old_corners
		if(old_opacity != opacity || dynamic_lighting != old_dynamic_lighting)
			reconsider_lights()
		if(dynamic_lighting != old_dynamic_lighting)
			if(dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0

	set_dir(other.dir)
	icon_state = other.icon_state
	icon = other.icon
	overlays = other.overlays.Copy()
	underlays = other.underlays.Copy()
	return 1

//I would name this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0

	if(other.zone)
		if(isnull(air))
			make_air()
		air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1

//No idea why resetting the base appearence from New() isn't enough, but without this it doesn't work
/turf/simulated/shuttle/wall/corner/exterior/transport_properties_from(turf/simulated/other)
	. = ..()
	reset_base_appearance()

//Commented out by SkyMarshal 5/10/13 - If you are patching up space, it should be vacuum.
//  If you are replacing a wall, you have increased the volume of the room without increasing the amount of gas in it.
//  As such, this will no longer be used.

//////Assimilate Air//////
/*
/turf/simulated/proc/Assimilate_Air()
	var/aoxy = 0//Holders to assimilate air from nearby turfs
	var/anitro = 0
	var/aco = 0
	var/atox = 0
	var/atemp = 0
	var/turf_count = 0

	for(var/direction in cardinal)//Only use cardinals to cut down on lag
		var/turf/T = get_step(src,direction)
		if(isspace(T))//Counted as no air
			turf_count++//Considered a valid turf for air calcs
			continue
		else if(istype(T,/turf/simulated/floor))
			var/turf/simulated/S = T
			if(S.air)//Add the air's contents to the holders
				aoxy += S.air.oxygen
				anitro += S.air.nitrogen
				aco += S.air.carbon_dioxide
				atox += S.air.toxins
				atemp += S.air.temperature
			turf_count ++
	air.oxygen = (aoxy/max(turf_count,1))//Averages contents of the turfs, ignoring walls and the like
	air.nitrogen = (anitro/max(turf_count,1))
	air.carbon_dioxide = (aco/max(turf_count,1))
	air.toxins = (atox/max(turf_count,1))
	air.temperature = (atemp/max(turf_count,1))//Trace gases can get bant
	air.update_values()

	//cael - duplicate the averaged values across adjacent turfs to enforce a seamless atmos change
	for(var/direction in cardinal)//Only use cardinals to cut down on lag
		var/turf/T = get_step(src,direction)
		if(isspace(T))//Counted as no air
			continue
		else if(istype(T,/turf/simulated/floor))
			var/turf/simulated/S = T
			if(S.air)//Add the air's contents to the holders
				S.air.oxygen = air.oxygen
				S.air.nitrogen = air.nitrogen
				S.air.carbon_dioxide = air.carbon_dioxide
				S.air.toxins = air.toxins
				S.air.temperature = air.temperature
				S.air.update_values()
*/

/turf/proc/ReplaceWithLattice()
	ChangeTurf(get_base_turf_by_area(get_area(src.loc)))
	new /obj/structure/lattice(locate(x, y, z))

/turf/proc/kill_creatures(mob/U = null)	//Will kill people/creatures and damage mechs./N
//Useful to batch-add creatures to the list.
	for(var/mob/living/M in src)
		if(M == U)
			continue	//Will not harm U. Since null != M, can be excluded to kill everyone.
		spawn(0)
			M.gib()
	for(var/obj/mecha/M in src)//Mecha are not gibbed but are damaged.
		spawn(0)
			M.take_damage(100, "brute")

/turf/proc/Bless()
	if(flags & NOJAUNT)
		return
	flags |= NOJAUNT

/turf/proc/AdjacentTurfs()
	var/list/list = list()
	for(var/turf/simulated/t in oview(src, 1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				list.Add(t)
	return list

/turf/proc/Distance(turf/t)
	if(get_dist(src, t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight + t.pathweight) / 2
		return cost
	else
		return get_dist(src, t)

/turf/proc/AdjacentTurfsSpace()
	var/list/list = list()
	for(var/turf/t in oview(src, 1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				list.Add(t)
	return list