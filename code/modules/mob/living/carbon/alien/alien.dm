/mob/living/carbon/alien
	name = "alien"
	desc = "What IS that?"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alien"
	pass_flags = PASSTABLE
	melee_damage_lower = 1
	melee_damage_upper = 3
	attacktext = "bites"
	attack_sound = null
	friendly = "nuzzles"
	wall_smash = 0

	var/adult_form
	var/dead_icon
	var/amount_grown = 0
	var/max_grown = 10
	var/time_of_birth
	var/co2overloadtime = null
	var/temperature_resistance = T0C+75
	var/language

/mob/living/carbon/alien/New()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src

	name = "[initial(name)] ([rand(1, 1000)])"
	real_name = name
	regenerate_icons()

	if(language)
		add_language(language)

	gender = NEUTER

/mob/living/carbon/alien/adjustToxLoss(amount)
	..()

/mob/living/carbon/alien/u_equip(obj/item/W as obj)
	return

//This is fine, works the same as a human
/mob/living/carbon/alien/Bump(atom/movable/AM as mob|obj, yes)
	spawn(0)
		if((!(yes) || now_pushing))
			return
		now_pushing = 1
		if(ismob(AM))
			var/mob/tmob = AM
			if(istype(tmob, /mob/living/carbon/human) && (FAT in tmob.mutations))
				if(prob(70))
					src << "\red <B>You fail to push [tmob]'s fat ass out of the way.</B>"
					now_pushing = 0
					return
				if(!(tmob.status_flags & CANPUSH))
					now_pushing = 0
					return
			tmob.LAssailant = src

		now_pushing = 0
		..()
		if(!(istype(AM, /atom/movable)))
			return
		if(!(now_pushing))
			now_pushing = 1
			if(!(AM.anchored))
				var/t = get_dir(src, AM)
				step(AM, t)
			now_pushing = null
		return

/mob/living/carbon/alien/Stat()
	..()
	stat(null, "Progress: [amount_grown]/[max_grown]")

/mob/living/carbon/alien/restrained()
	return 0

/mob/living/carbon/alien/show_inv(mob/user as mob)
	return //Consider adding cuffs and hats to this, for the sake of fun.

/mob/living/carbon/alien/can_use_vents()
	return