/*
 * Assistant
 */
/decl/hierarchy/outfit/job/assistant
	name = "Assistant"

/*
 * Internal Affairs Agent
 *
 * This needs to be moved to a Security or a Command job in future.
 */
/decl/hierarchy/outfit/job/internal_affairs
	name = "Internal Affairs Agent"

	uniform = /obj/item/clothing/under/rank/internalaffairs
	suit = /obj/item/clothing/suit/storage/internalaffairs

	glasses = /obj/item/clothing/glasses/sunglasses/big
	shoes = /obj/item/clothing/shoes/brown

	l_ear = /obj/item/device/radio/headset/sec

	l_hand = /obj/item/storage/briefcase

	pda_type = /obj/item/device/pda/lawyer

/*
 * Service
 */
/decl/hierarchy/outfit/job/service
	l_ear = /obj/item/device/radio/headset/service

	flags = OUTFIT_HIDE_IF_CATEGORY

/*
 * Bartender
 */
/decl/hierarchy/outfit/job/service/bartender
	name = "Bartender"

	uniform = /obj/item/clothing/under/rank/bartender

	pda_type = /obj/item/device/pda/bar

/*
 * Chef
 */
/decl/hierarchy/outfit/job/service/chef
	name = "Chef"

	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef

	head = /obj/item/clothing/head/chefhat

	pda_type = /obj/item/device/pda/chef

/*
 * Botanist
 */
/decl/hierarchy/outfit/job/service/botanist
	name = "Botanist"

	uniform = /obj/item/clothing/under/rank/hydroponics
	suit = /obj/item/clothing/suit/apron

	gloves = /obj/item/clothing/gloves/botanic_leather

	suit_store = /obj/item/device/analyzer/plant_analyzer

	pda_type = /obj/item/device/pda/botanist

	satchel_one = /obj/item/storage/satchel/hyd

/*
 * Clown
 */
/decl/hierarchy/outfit/job/service/clown
	name = "Clown"

	uniform = /obj/item/clothing/under/rank/clown
	back = /obj/item/storage/backpack/clown

	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes

	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/grown/banana = 1,
		/obj/item/bikehorn = 1,
		/obj/item/stamp/clown = 1,
		/obj/item/toy/crayon/rainbow = 1,
		/obj/item/storage/fancy/crayons = 1,
		/obj/item/toy/waterflower = 1
	)

	pda_type = /obj/item/device/pda/clown

/*
 * Mime
 */
/decl/hierarchy/outfit/job/service/mime
	name = "Mime"

	uniform = /obj/item/clothing/under/mime
	suit = /obj/item/clothing/suit/suspenders

	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white

	backpack_contents = list(
		/obj/item/toy/crayon/mime = 1,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing = 1
	)

	pda_type = /obj/item/device/pda/mime

/*
 * Janitor
 */
/decl/hierarchy/outfit/job/service/janitor
	name = "Janitor"

	uniform = /obj/item/clothing/under/rank/janitor

	pda_type = /obj/item/device/pda/janitor

/*
 * Librarian
 */
/decl/hierarchy/outfit/job/service/librarian
	name = "Librarian"

	uniform = /obj/item/clothing/under/suit_jacket/red

	l_hand = /obj/item/barcodescanner

	pda_type = /obj/item/device/pda/librarian

/*
 * Chaplain
 */
/decl/hierarchy/outfit/job/service/chaplain
	name = "Chaplain"

	uniform = /obj/item/clothing/under/rank/chaplain

	l_hand = /obj/item/storage/bible

	pda_type = /obj/item/device/pda/chaplain