/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit"
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	icon_living = "shade"
	icon_dead = "shade_dead"
	maxHealth = 50
	health = 50
	universal_speak = 1
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")
	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches the"
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "drains the life from"
	minbodytemp = 0
	maxbodytemp = 4000
	min_oxy = 0
	max_co2 = 0
	max_tox = 0
	speed = -1
	stop_automated_movement = 1
	status_flags = 0
	faction = "cult"
	status_flags = CANPUSH

/mob/living/simple_animal/shade/Life()
	..()
	if(stat == DEAD)
		new /obj/item/weapon/ectoplasm(src.loc)
		for(var/mob/M in viewers(src, null))
			if((M.client && !M.blinded))
				M.show_message(SPAN_WARNING("[src] lets out a contented sigh as their form unwinds."))
				ghostize()
		del src
		return

/mob/living/simple_animal/shade/attackby(obj/item/O as obj, mob/user as mob)  //Marker -Agouri
	if(istype(O, /obj/item/device/soulstone))
		O.transfer_soul("SHADE", src, user)
		return
	return ..()