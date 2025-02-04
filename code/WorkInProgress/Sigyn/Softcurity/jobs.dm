/datum/job/hos
	title = "Safety Administrator"
	flag = HOS
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffdddd"
	idtype = /obj/item/card/id/silver
	req_admin_notify = 1


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/storage/satchel_sec(H), SLOT_ID_BACK)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hos(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/administrator(H), SLOT_ID_W_UNIFORM)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots(H), SLOT_ID_SHOES)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hos(H), SLOT_ID_BELT)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), SLOT_ID_GLASSES)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(H), SLOT_ID_WEAR_SUIT)
		H.equip_to_slot_or_del(new /obj/item/gun/energy/taser(H), SLOT_ID_S_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/handcuffs(H), SLOT_ID_IN_BACKPACK)
		var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		return 1



/datum/job/warden
	title = "Correctional Advisor"
	flag = WARDEN
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the safety administrator"
	selection_color = "#ffeeee"


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/storage/satchel_sec(H), SLOT_ID_BACK)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/advisor(H), SLOT_ID_W_UNIFORM)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots(H), SLOT_ID_SHOES)
		H.equip_to_slot_or_del(new /obj/item/device/pda/warden(H), SLOT_ID_BELT)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), SLOT_ID_GLASSES)
		H.equip_to_slot_or_del(new /obj/item/device/flash(H), SLOT_ID_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/handcuffs(H), SLOT_ID_IN_BACKPACK)
		var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		return 1



/datum/job/detective
	title = "Detective"
	flag = DETECTIVE
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the safety administrator"
	selection_color = "#ffeeee"


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/storage/satchel_norm(H), SLOT_ID_BACK)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/det(H), SLOT_ID_W_UNIFORM)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), SLOT_ID_SHOES)
		H.equip_to_slot_or_del(new /obj/item/device/pda/detective(H), SLOT_ID_BELT)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/det_hat(H), SLOT_ID_HEAD)
		var/obj/item/clothing/mask/cigarette/CIG = new /obj/item/clothing/mask/cigarette(H)
		CIG.light("")
		H.equip_to_slot_or_del(CIG, SLOT_ID_WEAR_MASK)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), SLOT_ID_GLOVES)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/det_suit(H), SLOT_ID_WEAR_SUIT)
		H.equip_to_slot_or_del(new /obj/item/lighter/zippo(H), SLOT_ID_L_STORE)

		H.equip_to_slot_or_del(new /obj/item/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/storage/box/evidence(H), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/device/detective_scanner(H), SLOT_ID_IN_BACKPACK)

		var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		return 1



/datum/job/officer
	title = "Crew Supervisor"
	flag = OFFICER
	department_flag = DEPARTMENT_ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the safety administrator"
	selection_color = "#ffeeee"


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/storage/satchel_sec(H), SLOT_ID_BACK)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/supervisor(H), SLOT_ID_W_UNIFORM)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots(H), SLOT_ID_SHOES)
		H.equip_to_slot_or_del(new /obj/item/device/pda/security(H), SLOT_ID_BELT)
		H.equip_to_slot_or_del(new /obj/item/handcuffs(H), SLOT_ID_R_STORE)
		H.equip_to_slot_or_del(new /obj/item/device/flash(H), SLOT_ID_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/handcuffs(H), SLOT_ID_IN_BACKPACK)
		var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		return 1

/datum/job/hop
	title = "Head of Personnel"
	flag = HOP
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ddddff"
	idtype = /obj/item/card/id/silver
	req_admin_notify = 1


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hop(H), slot_ears)
		if(H.backbag == 2) H.equip_to_slot_or_del(new /obj/item/storage/backpack(H), SLOT_ID_BACK)
		if(H.backbag == 3) H.equip_to_slot_or_del(new /obj/item/storage/satchel_norm(H), SLOT_ID_BACK)
		H.equip_to_slot_or_del(new /obj/item/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_personnel(H), SLOT_ID_W_UNIFORM)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), SLOT_ID_SHOES)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hop(H), SLOT_ID_BELT)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/storage/id_kit(H), SLOT_ID_R_HAND)
		else
			H.equip_to_slot_or_del(new /obj/item/storage/id_kit(H.back), SLOT_ID_IN_BACKPACK)
		return 1
