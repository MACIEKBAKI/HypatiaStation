/obj/item/device/radio/beacon
	name = "Tracking Beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "signaler"
	var/code = "electronic"
	origin_tech = list(RESEARCH_TECH_BLUESPACE = 1)

/obj/item/device/radio/beacon/hear_talk()
	return

/obj/item/device/radio/beacon/send_hear()
	return null

/obj/item/device/radio/beacon/verb/alter_signal(t as text)
	set name = "Alter Beacon's Signal"
	set category = "Object"
	set src in usr

	if(usr.canmove && !usr.restrained())
		src.code = t
	if(!src.code)
		src.code = "beacon"
	src.add_fingerprint(usr)
	return

//Probably a better way of doing this, I'm lazy.
/obj/item/device/radio/beacon/bacon/proc/digest_delay()
	spawn(600)
		qdel(src)

// SINGULO BEACON SPAWNER

/obj/item/device/radio/beacon/syndicate
	name = "suspicious beacon"
	desc = "A label on it reads: <i>Activate to have a singularity beacon teleported to your location</i>."
	origin_tech = list(RESEARCH_TECH_BLUESPACE = 1, RESEARCH_TECH_SYNDICATE = 7)

/obj/item/device/radio/beacon/syndicate/attack_self(mob/user as mob)
	if(user)
		to_chat(user, SPAN_INFO("Locked In"))
		new /obj/machinery/singularity_beacon/syndicate(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return