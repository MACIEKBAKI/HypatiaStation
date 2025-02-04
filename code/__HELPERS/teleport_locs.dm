/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual teleport routine at the start of the game.*/
GLOBAL_GLOBL_LIST_NEW(teleportlocs)
GLOBAL_GLOBL_LIST_NEW(ghostteleportlocs)

/hook/startup/proc/setup_teleport_locs()
	for(var/area/a in world)
		if(istype(a, /area/shuttle) || istype(a, /area/syndicate_station) || istype(a, /area/wizard_station))
			continue
		if(GLOBL.teleportlocs.Find(a.name))
			continue
		var/turf/picked = pick(get_area_turfs(a.type))
		if(isStationLevel(picked.z))
			GLOBL.teleportlocs += a.name
			GLOBL.teleportlocs[a.name] = a
	GLOBL.teleportlocs = sortAssoc(GLOBL.teleportlocs)
	return 1

/hook/startup/proc/setup_ghost_teleport_locs()
	for(var/area/a in world)
		if(GLOBL.ghostteleportlocs.Find(a.name))
			continue
		if(istype(a, /area/turret_protected/aisat) || istype(a, /area/derelict) || istype(a, /area/tdome))
			GLOBL.ghostteleportlocs += a.name
			GLOBL.ghostteleportlocs[a.name] = a
		var/turf/picked = pick(get_area_turfs(a.type))
		if(isPlayerLevel(picked.z))
			GLOBL.ghostteleportlocs += a.name
			GLOBL.ghostteleportlocs[a.name] = a
	GLOBL.ghostteleportlocs = sortAssoc(GLOBL.ghostteleportlocs)
	return 1