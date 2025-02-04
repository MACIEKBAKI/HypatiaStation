/obj/effect/expl_particles
	name = "explosive particles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	opacity = TRUE
	anchored = TRUE
	mouse_opacity = FALSE

/obj/effect/expl_particles/initialize()
	. = ..()
	spawn(15)
		qdel(src)

/datum/effect/system/expl_particles/set_up(n = 10, loca)
	number = n
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)

/datum/effect/system/expl_particles/start()
	var/i = 0
	for(i = 0, i < src.number, i++)
		spawn(0)
			var/obj/effect/expl_particles/expl = new /obj/effect/expl_particles(src.location)
			var/direct = pick(GLOBL.alldirs)
			for(i = 0, i < pick(1;25, 2;50, 3, 4;200), i++)
				sleep(1)
				step(expl, direct)

/obj/effect/explosion
	name = "explosive particles"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	opacity = TRUE
	anchored = TRUE
	mouse_opacity = FALSE
	pixel_x = -32
	pixel_y = -32

/obj/effect/explosion/initialize()
	. = ..()
	spawn(10)
		qdel(src)

/datum/effect/system/explosion/set_up(loca)
	if(isturf(loca))
		location = loca
	else location = get_turf(loca)

/datum/effect/system/explosion/start()
	new/obj/effect/explosion(location)
	var/datum/effect/system/expl_particles/P = new/datum/effect/system/expl_particles()
	P.set_up(10, location)
	P.start()
	spawn(5)
		var/datum/effect/system/smoke_spread/S = new/datum/effect/system/smoke_spread()
		S.set_up(5, 0, location, null)
		S.start()