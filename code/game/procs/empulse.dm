/proc/empulse(turf/epicenter, heavy_range, light_range, log = 0)
	if(!epicenter)
		return

	if(!isturf(epicenter))
		epicenter = get_turf(epicenter.loc)

	if(log)
		message_admins("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name]")
		log_game("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name]")

	if(heavy_range > 1)
		var/obj/effect/overlay/pulse = PoolOrNew(/obj/effect/overlay, epicenter)
		pulse.icon = 'icons/effects/effects.dmi'
		pulse.icon_state = "emppulse"
		pulse.name = "emp pulse"
		pulse.anchored = TRUE
		spawn(20)
			qdel(pulse)

	if(heavy_range > light_range)
		light_range = heavy_range

	for(var/mob/M in range(heavy_range, epicenter))
		M << 'sound/effects/EMPulse.ogg'

	for(var/atom/T in range(light_range, epicenter))
		var/distance = get_dist(epicenter, T)
		if(distance < 0)
			distance = 0
		if(distance < heavy_range)
			T.emp_act(1)
		else if(distance == heavy_range)
			if(prob(50))
				T.emp_act(1)
			else
				T.emp_act(2)
		else if(distance <= light_range)
			T.emp_act(2)
	return 1