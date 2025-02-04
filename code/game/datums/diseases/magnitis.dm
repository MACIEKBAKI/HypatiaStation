/datum/disease/magnitis
	name = "Magnitis"
	max_stages = 4
	spread = "Airborne"
	cure = "Iron"
	cure_id = "iron"
	agent = "Fukkos Miracos"
	affected_species = list(SPECIES_HUMAN)
	curable = 0
	permeability_mod = 0.75
	desc = "This disease disrupts the magnetic field of your body, making it act as if a powerful magnet. Injections of iron help stabilize the field."
	severity = "Medium"

/datum/disease/magnitis/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(2))
				to_chat(affected_mob, SPAN_WARNING("You feel a slight shock course through your body."))
			if(prob(2))
				for(var/obj/M in orange(2, affected_mob))
					if(!M.anchored && (M.flags & CONDUCT))
						step_towards(M, affected_mob)
				for(var/mob/living/silicon/S in orange(2, affected_mob))
					if(isAI(S))
						continue
					step_towards(S, affected_mob)
						/*
						if(M.x > affected_mob.x)
							M.x--
						else if(M.x < affected_mob.x)
							M.x++
						if(M.y > affected_mob.y)
							M.y--
						else if(M.y < affected_mob.y)
							M.y++
						*/
		if(3)
			if(prob(2))
				to_chat(affected_mob, SPAN_WARNING("You feel a strong shock course through your body."))
			if(prob(2))
				to_chat(affected_mob, SPAN_WARNING("You feel like clowning around."))
			if(prob(4))
				for(var/obj/M in orange(4, affected_mob))
					if(!M.anchored && (M.flags & CONDUCT))
						for(var/i = 0, i < rand(1, 2), i++)
							step_towards(M, affected_mob)
				for(var/mob/living/silicon/S in orange(4, affected_mob))
					if(isAI(S))
						continue
					for(var/i = 0, i < rand(1, 2), i++)
						step_towards(S, affected_mob)
						/*
						if(M.x > affected_mob.x)
							M.x-=rand(1,min(3,M.x-affected_mob.x))
						else if(M.x < affected_mob.x)
							M.x+=rand(1,min(3,affected_mob.x-M.x))
						if(M.y > affected_mob.y)
							M.y-=rand(1,min(3,M.y-affected_mob.y))
						else if(M.y < affected_mob.y)
							M.y+=rand(1,min(3,affected_mob.y-M.y))
						*/
		if(4)
			if(prob(2))
				to_chat(affected_mob, SPAN_WARNING("You feel a powerful shock course through your body."))
			if(prob(2))
				to_chat(affected_mob, SPAN_WARNING("You query upon the nature of miracles."))
			if(prob(8))
				for(var/obj/M in orange(6, affected_mob))
					if(!M.anchored && (M.flags & CONDUCT))
						for(var/i = 0, i < rand(1, 3), i++)
							step_towards(M, affected_mob)
				for(var/mob/living/silicon/S in orange(6, affected_mob))
					if(isAI(S))
						continue
					for(var/i = 0, i < rand(1, 3), i++)
						step_towards(S, affected_mob)
						/*
						if(M.x > affected_mob.x)
							M.x-=rand(1,min(5,M.x-affected_mob.x))
						else if(M.x < affected_mob.x)
							M.x+=rand(1,min(5,affected_mob.x-M.x))
						if(M.y > affected_mob.y)
							M.y-=rand(1,min(5,M.y-affected_mob.y))
						else if(M.y < affected_mob.y)
							M.y+=rand(1,min(5,affected_mob.y-M.y))
						*/
	return