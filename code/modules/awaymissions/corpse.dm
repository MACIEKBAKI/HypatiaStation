//These are meant for spawning on maps, namely Away Missions.

//If someone can do this in a neater way, be my guest-Kor

//To do: Allow corpses to appear mangled, bloody, etc. Allow customizing the bodies appearance (they're all bald and white right now).

/obj/effect/landmark/corpse
	name = "Unknown"
	var/mobname = "Unknown"  //Unused now but it'd fuck up maps to remove it now
	var/corpseuniform = null //Set this to an object path to have the slot filled with said object on the corpse.
	var/corpsesuit = null
	var/corpseshoes = null
	var/corpsegloves = null
	var/corpseradio = null
	var/corpseglasses = null
	var/corpsemask = null
	var/corpsehelmet = null
	var/corpsebelt = null
	var/corpsepocket1 = null
	var/corpsepocket2 = null
	var/corpseback = null
	var/corpseid = 0	//Just set to 1 if you want them to have an ID
	var/corpseidjob = null // Needs to be in quotes, such as "Clown" or "Chef." This just determines what the ID reads as, not their access
	var/corpseidaccess = null //This is for access. See access.dm for which jobs give what access. Again, put in quotes. Use "Captain" if you want it to be all access.
	var/corpseidicon = null //For setting it to be a gold, silver, centcom etc ID
	var/mutantrace = "human"

/obj/effect/landmark/corpse/initialize()
	. = ..()
	createCorpse()

/obj/effect/landmark/corpse/Destroy()
	corpseuniform = null
	corpsesuit = null
	corpseshoes = null
	corpsegloves = null
	corpseradio = null
	corpseglasses = null
	corpsemask = null
	corpsehelmet = null
	corpsebelt = null
	corpsepocket1 = null
	corpsepocket2 = null
	corpseback = null
	return ..()

/obj/effect/landmark/corpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/M = new /mob/living/carbon/human(src.loc)
	M.dna.mutantrace = mutantrace
	M.real_name = src.name
	M.death(1) //Kills the new mob
	if(src.corpseuniform)
		M.equip_to_slot_or_del(new src.corpseuniform(M), SLOT_ID_W_UNIFORM)
	if(src.corpsesuit)
		M.equip_to_slot_or_del(new src.corpsesuit(M), SLOT_ID_WEAR_SUIT)
	if(src.corpseshoes)
		M.equip_to_slot_or_del(new src.corpseshoes(M), SLOT_ID_SHOES)
	if(src.corpsegloves)
		M.equip_to_slot_or_del(new src.corpsegloves(M), SLOT_ID_GLOVES)
	if(src.corpseradio)
		M.equip_to_slot_or_del(new src.corpseradio(M), SLOT_ID_L_EAR)
	if(src.corpseglasses)
		M.equip_to_slot_or_del(new src.corpseglasses(M), SLOT_ID_GLASSES)
	if(src.corpsemask)
		M.equip_to_slot_or_del(new src.corpsemask(M), SLOT_ID_WEAR_MASK)
	if(src.corpsehelmet)
		M.equip_to_slot_or_del(new src.corpsehelmet(M), SLOT_ID_HEAD)
	if(src.corpsebelt)
		M.equip_to_slot_or_del(new src.corpsebelt(M), SLOT_ID_BELT)
	if(src.corpsepocket1)
		M.equip_to_slot_or_del(new src.corpsepocket1(M), SLOT_ID_R_STORE)
	if(src.corpsepocket2)
		M.equip_to_slot_or_del(new src.corpsepocket2(M), SLOT_ID_L_STORE)
	if(src.corpseback)
		M.equip_to_slot_or_del(new src.corpseback(M), SLOT_ID_BACK)
	if(src.corpseid == 1)
		var/obj/item/card/id/W = new(M)
		W.name = "[M.real_name]'s ID Card"
		var/datum/job/jobdatum
		for(var/jobtype in typesof(/datum/job))
			var/datum/job/J = new jobtype
			if(J.title == corpseidaccess)
				jobdatum = J
				break
		if(src.corpseidicon)
			W.icon_state = corpseidicon
		if(src.corpseidaccess)
			if(jobdatum)
				W.access = jobdatum.get_access()
			else
				W.access = list()
		if(corpseidjob)
			W.assignment = corpseidjob
		W.registered_name = M.real_name
		M.equip_to_slot_or_del(W, SLOT_ID_WEAR_ID)
	qdel(src)


// I'll work on making a list of corpses people request for maps, or that I think will be commonly used. Syndicate operatives for example.

/obj/effect/landmark/corpse/syndicatesoldier
	name = "Syndicate Operative"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/vest
	corpseshoes = /obj/item/clothing/shoes/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/storage/backpack
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"


/obj/effect/landmark/corpse/syndicatecommando
	name = "Syndicate Commando"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/space/rig/syndi
	corpseshoes = /obj/item/clothing/shoes/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/syndicate
	corpsehelmet = /obj/item/clothing/head/helmet/space/rig/syndi
	corpseback = /obj/item/tank/jetpack/oxygen
	corpsepocket1 = /obj/item/tank/emergency_oxygen
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"


///////////Civilians//////////////////////

/obj/effect/landmark/corpse/chef
	name = "Chef"
	corpseuniform = /obj/item/clothing/under/rank/chef
	corpsesuit = /obj/item/clothing/suit/chef/classic
	corpseshoes = /obj/item/clothing/shoes/black
	corpsehelmet = /obj/item/clothing/head/chefhat
	corpseback = /obj/item/storage/backpack
	corpseradio = /obj/item/device/radio/headset
	corpseid = 1
	corpseidjob = "Chef"
	corpseidaccess = "Chef"


/obj/effect/landmark/corpse/doctor
	name = "Doctor"
	corpseradio = /obj/item/device/radio/headset/med
	corpseuniform = /obj/item/clothing/under/rank/medical
	corpsesuit = /obj/item/clothing/suit/storage/labcoat
	corpseback = /obj/item/storage/backpack/medic
	corpsepocket1 = /obj/item/device/flashlight/pen
	corpseshoes = /obj/item/clothing/shoes/black
	corpseid = 1
	corpseidjob = "Medical Doctor"
	corpseidaccess = "Medical Doctor"


/obj/effect/landmark/corpse/engineer
	name = "Engineer"
	corpseradio = /obj/item/device/radio/headset/engi
	corpseuniform = /obj/item/clothing/under/rank/engineer
	corpseback = /obj/item/storage/backpack/industrial
	corpseshoes = /obj/item/clothing/shoes/orange
	corpsebelt = /obj/item/storage/belt/utility/full
	corpsegloves = /obj/item/clothing/gloves/yellow
	corpsehelmet = /obj/item/clothing/head/hardhat
	corpseid = 1
	corpseidjob = "Station Engineer"
	corpseidaccess = "Station Engineer"

/obj/effect/landmark/corpse/engineer/rig
	corpsesuit = /obj/item/clothing/suit/space/rig
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/rig


/obj/effect/landmark/corpse/clown
	name = "Clown"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/bikehorn
	corpseback = /obj/item/storage/backpack/clown
	corpseid = 1
	corpseidjob = "Clown"
	corpseidaccess = "Clown"


/obj/effect/landmark/corpse/scientist
	name = "Scientist"
	corpseradio = /obj/item/device/radio/headset/sci
	corpseuniform = /obj/item/clothing/under/rank/scientist
	corpsesuit = /obj/item/clothing/suit/storage/labcoat/science
	corpseback = /obj/item/storage/backpack
	corpseshoes = /obj/item/clothing/shoes/white
	corpseid = 1
	corpseidjob = "Scientist"
	corpseidaccess = "Scientist"


/obj/effect/landmark/corpse/miner
	corpseradio = /obj/item/device/radio/headset/cargo
	corpseuniform = /obj/item/clothing/under/rank/miner
	corpsegloves = /obj/item/clothing/gloves/black
	corpseback = /obj/item/storage/backpack/industrial
	corpseshoes = /obj/item/clothing/shoes/black
	corpseid = 1
	corpseidjob = "Shaft Miner"
	corpseidaccess = "Shaft Miner"

/obj/effect/landmark/corpse/miner/rig
	corpsesuit = /obj/item/clothing/suit/space/rig/mining
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/rig/mining


/////////////////Officers//////////////////////

/obj/effect/landmark/corpse/bridgeofficer
	name = "Bridge Officer"
	corpseradio = /obj/item/device/radio/headset/heads/hop
	corpseuniform = /obj/item/clothing/under/rank/centcom_officer
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseshoes = /obj/item/clothing/shoes/black
	corpseglasses = /obj/item/clothing/glasses/sunglasses
	corpseid = 1
	corpseidjob = "Bridge Officer"
	corpseidaccess = "Captain"


/obj/effect/landmark/corpse/commander
	name = "Commander"
	corpseuniform = /obj/item/clothing/under/rank/centcom_commander
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseradio = /obj/item/device/radio/headset/heads/captain
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsemask = /obj/item/clothing/mask/cigarette/cigar/cohiba
	corpsehelmet = /obj/item/clothing/head/centhat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseshoes = /obj/item/clothing/shoes/swat
	corpsepocket1 = /obj/item/lighter/zippo
	corpseid = 1
	corpseidjob = "Commander"
	corpseidaccess = "Captain"
