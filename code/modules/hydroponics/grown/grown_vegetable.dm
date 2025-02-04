/*
 * Cabbage
 */
/obj/item/reagent_containers/food/snacks/grown/cabbage
	seed = /obj/item/seeds/cabbageseed
	name = "cabbage"
	desc = "Ewwwwwwwwww. Cabbage."
	icon_state = "cabbage"
	potency = 25
	filling_color = "#A2B5A1"

/obj/item/reagent_containers/food/snacks/grown/cabbage/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	bitesize = reagents.total_volume

/*
 * Potato
 */
/obj/item/reagent_containers/food/snacks/grown/potato
	seed = /obj/item/seeds/potatoseed
	name = "potato"
	desc = "Boil 'em! Mash 'em! Stick 'em in a stew!"
	icon_state = "potato"
	potency = 25
	filling_color = "#E6E8DA"

/obj/item/reagent_containers/food/snacks/grown/potato/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	bitesize = reagents.total_volume

/obj/item/reagent_containers/food/snacks/grown/potato/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/stack/cable_coil))
		if(W:amount >= 5)
			W:amount -= 5
			if(!W:amount)
				qdel(W)
			to_chat(user, SPAN_NOTICE("You add some cable to the potato and slide it inside the battery casing."))
			var/obj/item/cell/potato/pocell = new /obj/item/cell/potato(user.loc)
			pocell.maxcharge = src.potency * 10
			pocell.charge = pocell.maxcharge
			qdel(src)
			return

/*
 * Soybean
 */
/obj/item/reagent_containers/food/snacks/grown/soybeans
	seed = /obj/item/seeds/soyaseed
	name = "soybeans"
	desc = "It's pretty bland, but oh the possibilities..."
	gender = PLURAL
	filling_color = "#E6E8B7"
	icon_state = "soybeans"
	
/obj/item/reagent_containers/food/snacks/grown/soybeans/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 20), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Carrot
 */
/obj/item/reagent_containers/food/snacks/grown/carrot
	seed = /obj/item/seeds/carrotseed
	name = "carrot"
	desc = "It's good for the eyes!"
	icon_state = "carrot"
	potency = 10
	filling_color = "#FFC400"
	
/obj/item/reagent_containers/food/snacks/grown/carrot/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 20), 1))
	reagents.add_reagent("imidazoline", 3 + round(potency / 5, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * White Beet
 */
/obj/item/reagent_containers/food/snacks/grown/whitebeet
	seed = /obj/item/seeds/whitebeetseed
	name = "white-beet"
	desc = "You can't beat white-beet."
	icon_state = "whitebeet"
	potency = 15
	filling_color = "#FFFCCC"
	
/obj/item/reagent_containers/food/snacks/grown/whitebeet/initialize()
	. = ..()
	reagents.add_reagent("nutriment", round((potency / 20), 1))
	reagents.add_reagent("sugar", 1 + round((potency / 5), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)