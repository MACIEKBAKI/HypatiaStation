/*
 * Mineral Stacking Unit Console
 */
/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon_state = "console"

	var/obj/machinery/mineral/stacking_machine/machine = null
	var/machinedir = SOUTHEAST

/obj/machinery/mineral/stacking_unit_console/initialize()
	. = ..()
	machine = locate(/obj/machinery/mineral/stacking_machine, get_step(src, machinedir))
	if(machine)
		machine.console = src
	else
		qdel(src)

/obj/machinery/mineral/stacking_unit_console/process()
	updateDialog()

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/stacking_unit_console/interact(mob/user)
	user.set_machine(src)

	var/dat
	dat += text("<b>Stacking unit console</b><br><br>")

	if(machine.ore_iron)
		dat += text("Iron: [machine.ore_iron] <A href='?src=\ref[src];release=[MATERIAL_METAL]'>Release</A><br>")
	if(machine.ore_plasteel)
		dat += text("Plasteel: [machine.ore_plasteel] <A href='?src=\ref[src];release=[MATERIAL_PLASTEEL]'>Release</A><br>")
	if(machine.ore_glass)
		dat += text("Glass: [machine.ore_glass] <A href='?src=\ref[src];release=[MATERIAL_GLASS]'>Release</A><br>")
	if(machine.ore_rglass)
		dat += text("Reinforced Glass: [machine.ore_rglass] <A href='?src=\ref[src];release=[MATERIAL_RGLASS]'>Release</A><br>")
	if(machine.ore_plasma)
		dat += text("Plasma: [machine.ore_plasma] <A href='?src=\ref[src];release=[MATERIAL_PLASMA]'>Release</A><br>")
	if(machine.ore_plasmaglass)
		dat += text("Plasma Glass: [machine.ore_plasmaglass] <A href='?src=\ref[src];release=[MATERIAL_PLASMAGLASS]'>Release</A><br>")
	if(machine.ore_plasmarglass)
		dat += text("Reinforced Plasma Glass: [machine.ore_plasmarglass] <A href='?src=\ref[src];release=[MATERIAL_PLASMA_RGLASS]'>Release</A><br>")
	if(machine.ore_gold)
		dat += text("Gold: [machine.ore_gold] <A href='?src=\ref[src];release=[MATERIAL_GOLD]'>Release</A><br>")
	if(machine.ore_silver)
		dat += text("Silver: [machine.ore_silver] <A href='?src=\ref[src];release=[MATERIAL_SILVER]'>Release</A><br>")
	if(machine.ore_uranium)
		dat += text("Uranium: [machine.ore_uranium] <A href='?src=\ref[src];release=[MATERIAL_URANIUM]'>Release</A><br>")
	if(machine.ore_diamond)
		dat += text("Diamond: [machine.ore_diamond] <A href='?src=\ref[src];release=[MATERIAL_DIAMOND]'>Release</A><br>")
	if(machine.ore_wood)
		dat += text("Wood: [machine.ore_wood] <A href='?src=\ref[src];release=[MATERIAL_WOOD]'>Release</A><br>")
	if(machine.ore_cardboard)
		dat += text("Cardboard: [machine.ore_cardboard] <A href='?src=\ref[src];release=[MATERIAL_CARDBOARD]'>Release</A><br>")
	if(machine.ore_cloth)
		dat += text("Cloth: [machine.ore_cloth] <A href='?src=\ref[src];release=[MATERIAL_CLOTH]'>Release</A><br>")
	if(machine.ore_leather)
		dat += text("Leather: [machine.ore_leather] <A href='?src=\ref[src];release=[MATERIAL_LEATHER]'>Release</A><br>")
	if(machine.ore_bananium)
		dat += text("Bananium: [machine.ore_bananium] <A href='?src=\ref[src];release=[MATERIAL_BANANIUM]'>Release</A><br>")
	if(machine.ore_adamantine)
		dat += text ("Adamantine: [machine.ore_adamantine] <A href='?src=\ref[src];release=[MATERIAL_ADAMANTINE]'>Release</A><br>")
	if(machine.ore_mythril)
		dat += text ("Mythril: [machine.ore_mythril] <A href='?src=\ref[src];release=[MATERIAL_MYTHRIL]'>Release</A><br>")

	dat += text("<br>Stacking: [machine.stack_amt]<br><br>")

	user << browse("[dat]", "window=console_stacking_machine")
	onclose(user, "console_stacking_machine")

/obj/machinery/mineral/stacking_unit_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["release"])
		switch(href_list["release"])
			if(MATERIAL_PLASMA)
				if(machine.ore_plasma > 0)
					var/obj/item/stack/sheet/mineral/plasma/G = new /obj/item/stack/sheet/mineral/plasma
					G.amount = machine.ore_plasma
					G.loc = machine.output.loc
					machine.ore_plasma = 0
			if(MATERIAL_PLASMAGLASS)
				if(machine.ore_plasmaglass > 0)
					var/obj/item/stack/sheet/glass/plasmaglass/G = new /obj/item/stack/sheet/glass/plasmaglass
					G.amount = machine.ore_plasmaglass
					G.loc = machine.output.loc
					machine.ore_plasmaglass = 0
			if(MATERIAL_PLASMA_RGLASS)
				if(machine.ore_plasmarglass > 0)
					var/obj/item/stack/sheet/glass/plasmarglass/G = new /obj/item/stack/sheet/glass/plasmarglass
					G.amount = machine.ore_plasmarglass
					G.loc = machine.output.loc
					machine.ore_plasmarglass = 0
			if(MATERIAL_URANIUM)
				if(machine.ore_uranium > 0)
					var/obj/item/stack/sheet/mineral/uranium/G = new /obj/item/stack/sheet/mineral/uranium
					G.amount = machine.ore_uranium
					G.loc = machine.output.loc
					machine.ore_uranium = 0
			if(MATERIAL_GLASS)
				if(machine.ore_glass > 0)
					var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass
					G.amount = machine.ore_glass
					G.loc = machine.output.loc
					machine.ore_glass = 0
			if(MATERIAL_RGLASS)
				if(machine.ore_rglass > 0)
					var/obj/item/stack/sheet/rglass/G = new /obj/item/stack/sheet/rglass
					G.amount = machine.ore_rglass
					G.loc = machine.output.loc
					machine.ore_rglass = 0
			if(MATERIAL_GOLD)
				if(machine.ore_gold > 0)
					var/obj/item/stack/sheet/mineral/gold/G = new /obj/item/stack/sheet/mineral/gold
					G.amount = machine.ore_gold
					G.loc = machine.output.loc
					machine.ore_gold = 0
			if(MATERIAL_SILVER)
				if(machine.ore_silver > 0)
					var/obj/item/stack/sheet/mineral/silver/G = new /obj/item/stack/sheet/mineral/silver
					G.amount = machine.ore_silver
					G.loc = machine.output.loc
					machine.ore_silver = 0
			if(MATERIAL_DIAMOND)
				if(machine.ore_diamond > 0)
					var/obj/item/stack/sheet/mineral/diamond/G = new /obj/item/stack/sheet/mineral/diamond
					G.amount = machine.ore_diamond
					G.loc = machine.output.loc
					machine.ore_diamond = 0
			if(MATERIAL_METAL)
				if(machine.ore_iron > 0)
					var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal
					G.amount = machine.ore_iron
					G.loc = machine.output.loc
					machine.ore_iron = 0
			if(MATERIAL_PLASTEEL)
				if(machine.ore_plasteel > 0)
					var/obj/item/stack/sheet/plasteel/G = new /obj/item/stack/sheet/plasteel
					G.amount = machine.ore_plasteel
					G.loc = machine.output.loc
					machine.ore_plasteel = 0
			if(MATERIAL_WOOD)
				if(machine.ore_wood > 0)
					var/obj/item/stack/sheet/wood/G = new /obj/item/stack/sheet/wood
					G.amount = machine.ore_wood
					G.loc = machine.output.loc
					machine.ore_wood = 0
			if(MATERIAL_CARDBOARD)
				if(machine.ore_cardboard > 0)
					var/obj/item/stack/sheet/cardboard/G = new /obj/item/stack/sheet/cardboard
					G.amount = machine.ore_cardboard
					G.loc = machine.output.loc
					machine.ore_cardboard = 0
			if(MATERIAL_CLOTH)
				if(machine.ore_cloth > 0)
					var/obj/item/stack/sheet/cloth/G = new /obj/item/stack/sheet/cloth
					G.amount = machine.ore_cloth
					G.loc = machine.output.loc
					machine.ore_cloth = 0
			if(MATERIAL_LEATHER)
				if(machine.ore_leather > 0)
					var/obj/item/stack/sheet/leather/G = new /obj/item/stack/sheet/leather
					G.amount = machine.ore_diamond
					G.loc = machine.output.loc
					machine.ore_leather = 0
			if(MATERIAL_BANANIUM)
				if(machine.ore_bananium > 0)
					var/obj/item/stack/sheet/mineral/bananium/G = new /obj/item/stack/sheet/mineral/bananium
					G.amount = machine.ore_bananium
					G.loc = machine.output.loc
					machine.ore_bananium = 0
			if(MATERIAL_ADAMANTINE)
				if(machine.ore_adamantine > 0)
					var/obj/item/stack/sheet/mineral/adamantine/G = new /obj/item/stack/sheet/mineral/adamantine
					G.amount = machine.ore_adamantine
					G.loc = machine.output.loc
					machine.ore_adamantine = 0
			if(MATERIAL_MYTHRIL)
				if(machine.ore_mythril > 0)
					var/obj/item/stack/sheet/mineral/mythril/G = new /obj/item/stack/sheet/mineral/mythril
					G.amount = machine.ore_mythril
					G.loc = machine.output.loc
					machine.ore_mythril = 0
	src.updateUsrDialog()
	return

/*
 * Mineral Stacking Unit
 */
/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon_state = "stacker"

	var/obj/machinery/mineral/stacking_unit_console/console
	var/stk_types = list()
	var/stk_amt = list()
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/ore_gold = 0
	var/ore_silver = 0
	var/ore_diamond = 0
	var/ore_plasma = 0
	var/ore_plasmaglass = 0
	var/ore_plasmarglass = 0
	var/ore_iron = 0
	var/ore_uranium = 0
	var/ore_bananium = 0
	var/ore_glass = 0
	var/ore_rglass = 0
	var/ore_plasteel = 0
	var/ore_wood = 0
	var/ore_cardboard = 0
	var/ore_cloth = 0
	var/ore_leather = 0
	var/ore_adamantine = 0
	var/ore_mythril = 0
	var/stack_amt = 50	//ammount to stack before releassing

/obj/machinery/mineral/stacking_machine/initialize()
	. = ..()
	for(var/dir in GLOBL.cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input)
			break
	for(var/dir in GLOBL.cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			break
	GLOBL.processing_objects.Add(src)

/obj/machinery/mineral/stacking_machine/process()
	if(output && input)
		var/obj/item/stack/O
		while(locate(/obj/item, input.loc))
			O = locate(/obj/item/stack, input.loc)
			if(isnull(O))
				var/obj/item/I = locate(/obj/item, input.loc)
				if(istype(I, /obj/item/ore/slag))
					I.loc = null
				else
					I.loc = output.loc
				continue
			if(istype(O, /obj/item/stack/sheet/metal))
				ore_iron += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/diamond))
				ore_diamond += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/plasma))
				ore_plasma += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/gold))
				ore_gold += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/silver))
				ore_silver += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/bananium))
				ore_bananium += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/uranium))
				ore_uranium += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/glass/plasmaglass))
				ore_plasmaglass += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/glass/plasmarglass))
				ore_plasmarglass += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/glass))
				ore_glass += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/rglass))
				ore_rglass += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/plasteel))
				ore_plasteel += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/adamantine))
				ore_adamantine += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/mythril))
				ore_mythril += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/cardboard))
				ore_cardboard += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/wood))
				ore_wood += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/cloth))
				ore_cloth += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/leather))
				ore_leather += O.amount
				O.loc = null
				qdel(O)
				continue
			O.loc = src.output.loc

	if(ore_gold >= stack_amt)
		var/obj/item/stack/sheet/mineral/gold/G = new /obj/item/stack/sheet/mineral/gold()
		G.amount = stack_amt
		G.loc = output.loc
		ore_gold -= stack_amt
		return
	if(ore_silver >= stack_amt)
		var/obj/item/stack/sheet/mineral/silver/G = new /obj/item/stack/sheet/mineral/silver()
		G.amount = stack_amt
		G.loc = output.loc
		ore_silver -= stack_amt
		return
	if(ore_diamond >= stack_amt)
		var/obj/item/stack/sheet/mineral/diamond/G = new /obj/item/stack/sheet/mineral/diamond()
		G.amount = stack_amt
		G.loc = output.loc
		ore_diamond -= stack_amt
		return
	if(ore_plasma >= stack_amt)
		var/obj/item/stack/sheet/mineral/plasma/G = new /obj/item/stack/sheet/mineral/plasma()
		G.amount = stack_amt
		G.loc = output.loc
		ore_plasma -= stack_amt
		return
	if(ore_iron >= stack_amt)
		var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal()
		G.amount = stack_amt
		G.loc = output.loc
		ore_iron -= stack_amt
		return
	if(ore_bananium >= stack_amt)
		var/obj/item/stack/sheet/mineral/bananium/G = new /obj/item/stack/sheet/mineral/bananium()
		G.amount = stack_amt
		G.loc = output.loc
		ore_bananium -= stack_amt
		return
	if(ore_uranium >= stack_amt)
		var/obj/item/stack/sheet/mineral/uranium/G = new /obj/item/stack/sheet/mineral/uranium()
		G.amount = stack_amt
		G.loc = output.loc
		ore_uranium -= stack_amt
		return
	if(ore_glass >= stack_amt)
		var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass()
		G.amount = stack_amt
		G.loc = output.loc
		ore_glass -= stack_amt
		return
	if(ore_rglass >= stack_amt)
		var/obj/item/stack/sheet/rglass/G = new /obj/item/stack/sheet/rglass()
		G.amount = stack_amt
		G.loc = output.loc
		ore_rglass -= stack_amt
		return
	if(ore_plasmaglass >= stack_amt)
		var/obj/item/stack/sheet/glass/plasmaglass/G = new /obj/item/stack/sheet/glass/plasmaglass()
		G.amount = stack_amt
		G.loc = output.loc
		ore_plasmaglass -= stack_amt
		return
	if(ore_plasmarglass >= stack_amt)
		var/obj/item/stack/sheet/glass/plasmarglass/G = new /obj/item/stack/sheet/glass/plasmarglass()
		G.amount = stack_amt
		G.loc = output.loc
		ore_plasmarglass -= stack_amt
		return
	if(ore_plasteel >= stack_amt)
		var/obj/item/stack/sheet/plasteel/G = new /obj/item/stack/sheet/plasteel()
		G.amount = stack_amt
		G.loc = output.loc
		ore_plasteel -= stack_amt
		return
	if(ore_wood >= stack_amt)
		var/obj/item/stack/sheet/wood/G = new /obj/item/stack/sheet/wood()
		G.amount = stack_amt
		G.loc = output.loc
		ore_wood -= stack_amt
		return
	if(ore_cardboard >= stack_amt)
		var/obj/item/stack/sheet/cardboard/G = new /obj/item/stack/sheet/cardboard()
		G.amount = stack_amt
		G.loc = output.loc
		ore_cardboard -= stack_amt
		return
	if(ore_cloth >= stack_amt)
		var/obj/item/stack/sheet/cloth/G = new /obj/item/stack/sheet/cloth()
		G.amount = stack_amt
		G.loc = output.loc
		ore_cloth -= stack_amt
		return
	if(ore_leather >= stack_amt)
		var/obj/item/stack/sheet/leather/G = new /obj/item/stack/sheet/leather()
		G.amount = stack_amt
		G.loc = output.loc
		ore_leather -= stack_amt
		return
	if(ore_adamantine >= stack_amt)
		var/obj/item/stack/sheet/mineral/adamantine/G = new /obj/item/stack/sheet/mineral/adamantine()
		G.amount = stack_amt
		G.loc = output.loc
		ore_adamantine -= stack_amt
		return
	if(ore_mythril >= stack_amt)
		var/obj/item/stack/sheet/mineral/mythril/G = new /obj/item/stack/sheet/mineral/mythril()
		G.amount = stack_amt
		G.loc = output.loc
		ore_mythril -= stack_amt
		return
	return
