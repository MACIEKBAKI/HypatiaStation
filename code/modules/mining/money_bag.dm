/*
 * Money Bag
 */
/obj/item/moneybag
	icon = 'icons/obj/storage/storage.dmi'
	name = "Money bag"
	icon_state = "moneybag"
	flags = CONDUCT
	force = 10.0
	throwforce = 2.0
	w_class = 4.0

/obj/item/moneybag/attack_hand(user as mob)
	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_diamond = 0
	var/amt_iron = 0
	var/amt_plasma = 0
	var/amt_uranium = 0
	var/amt_bananium = 0
	var/amt_adamantine = 0
	var/amt_mythril = 0

	for(var/obj/item/coin/C in contents)
		if(istype(C, /obj/item/coin/diamond))
			amt_diamond++
		if(istype(C, /obj/item/coin/plasma))
			amt_plasma++
		if(istype(C, /obj/item/coin/iron))
			amt_iron++
		if(istype(C, /obj/item/coin/silver))
			amt_silver++
		if(istype(C, /obj/item/coin/gold))
			amt_gold++
		if(istype(C, /obj/item/coin/uranium))
			amt_uranium++
		if(istype(C, /obj/item/coin/bananium))
			amt_bananium++
		if(istype(C, /obj/item/coin/adamantine))
			amt_adamantine++
		if(istype(C, /obj/item/coin/mythril))
			amt_mythril++

	var/dat = text("<b>The contents of the moneybag reveal...</b><br>")
	if(amt_gold)
		dat += text("Gold coins: [amt_gold] <A href='?src=\ref[src];remove=[MATERIAL_GOLD]'>Remove one</A><br>")
	if(amt_silver)
		dat += text("Silver coins: [amt_silver] <A href='?src=\ref[src];remove=[MATERIAL_SILVER]'>Remove one</A><br>")
	if(amt_iron)
		dat += text("Metal coins: [amt_iron] <A href='?src=\ref[src];remove=[MATERIAL_METAL]'>Remove one</A><br>")
	if(amt_diamond)
		dat += text("Diamond coins: [amt_diamond] <A href='?src=\ref[src];remove=[MATERIAL_DIAMOND]'>Remove one</A><br>")
	if(amt_plasma)
		dat += text("Plasma coins: [amt_plasma] <A href='?src=\ref[src];remove=[MATERIAL_PLASMA]'>Remove one</A><br>")
	if(amt_uranium)
		dat += text("Uranium coins: [amt_uranium] <A href='?src=\ref[src];remove=[MATERIAL_URANIUM]'>Remove one</A><br>")
	if(amt_bananium)
		dat += text("Bananium coins: [amt_bananium] <A href='?src=\ref[src];remove=[MATERIAL_BANANIUM]'>Remove one</A><br>")
	if(amt_adamantine)
		dat += text("Adamantine coins: [amt_adamantine] <A href='?src=\ref[src];remove=[MATERIAL_ADAMANTINE]'>Remove one</A><br>")
	if(amt_mythril)
		dat += text("Mythril coins: [amt_mythril] <A href='?src=\ref[src];remove=[MATERIAL_MYTHRIL]'>Remove one</A><br>")
	user << browse("[dat]", "window=moneybag")

/obj/item/moneybag/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/coin))
		var/obj/item/coin/C = W
		to_chat(user, SPAN_INFO("You add the [C.name] into the bag."))
		usr.drop_item()
		contents += C
	if(istype(W, /obj/item/moneybag))
		var/obj/item/moneybag/C = W
		for(var/obj/O in C.contents)
			contents += O
		to_chat(user, SPAN_INFO("You empty the [C.name] into the bag."))
	return

/obj/item/moneybag/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(href_list["remove"])
		var/obj/item/coin/coin
		switch(href_list["remove"])
			if(MATERIAL_GOLD)
				coin = locate(/obj/item/coin/gold, src.contents)
			if(MATERIAL_SILVER)
				coin = locate(/obj/item/coin/silver, src.contents)
			if(MATERIAL_METAL)
				coin = locate(/obj/item/coin/iron, src.contents)
			if(MATERIAL_DIAMOND)
				coin = locate(/obj/item/coin/diamond, src.contents)
			if(MATERIAL_PLASMA)
				coin = locate(/obj/item/coin/plasma, src.contents)
			if(MATERIAL_URANIUM)
				coin = locate(/obj/item/coin/uranium, src.contents)
			if(MATERIAL_BANANIUM)
				coin = locate(/obj/item/coin/bananium, src.contents)
			if(MATERIAL_ADAMANTINE)
				coin = locate(/obj/item/coin/adamantine, src.contents)
			if(MATERIAL_MYTHRIL)
				coin = locate(/obj/item/coin/mythril, src.contents)
		if(!coin)
			return
		coin.loc = src.loc
	return

/*
 * Vault Money Bag
 */
/obj/item/moneybag/vault/New()
	..()
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/adamantine(src)
	new /obj/item/coin/mythril(src)