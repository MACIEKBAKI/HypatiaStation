/*
Protolathe

Similar to an autolathe, you load glass and metal sheets (but not other objects) into it to be used as raw materials for the stuff
it creates. All the menus and other manipulation commands are in the R&D console.

Note: Must be placed west/left of and R&D console to function.

*/
/obj/machinery/r_n_d/protolathe
	name = "Protolathe"
	icon_state = "protolathe"
	flags = OPENCONTAINER

	accepted_materials = list(
		MATERIAL_METAL, MATERIAL_GLASS, MATERIAL_GOLD, MATERIAL_SILVER,
		MATERIAL_DIAMOND, MATERIAL_PLASMA, MATERIAL_URANIUM, MATERIAL_BANANIUM,
		MATERIAL_ADAMANTINE
	)
	max_storage_capacity = 100000

/obj/machinery/r_n_d/protolathe/New()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/protolathe(src)
	component_parts += new /obj/item/stock_part/matter_bin(src)
	component_parts += new /obj/item/stock_part/matter_bin(src)
	component_parts += new /obj/item/stock_part/manipulator(src)
	component_parts += new /obj/item/stock_part/manipulator(src)
	component_parts += new /obj/item/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/reagent_containers/glass/beaker(src)
	RefreshParts()

/obj/machinery/r_n_d/protolathe/RefreshParts()
	var/T = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	var/datum/reagents/R = new/datum/reagents(T)		//Holder for the reagents used as materials.
	reagents = R
	R.my_atom = src
	T = 0
	for(var/obj/item/stock_part/matter_bin/M in component_parts)
		T += M.rating
	max_storage_capacity = T * 75000

/obj/machinery/r_n_d/protolathe/attackby(obj/item/O as obj, mob/user as mob)
	if(..())
		return 1
	if(O.is_open_container())
		return 1

	if(istype(O, /obj/item/screwdriver))
		if(!opened)
			opened = TRUE
			if(linked_console)
				linked_console.linked_lathe = null
				linked_console = null
			icon_state = "protolathe_t"
			to_chat(user, "You open the maintenance hatch of the [src.name].")
		else
			opened = FALSE
			icon_state = "protolathe"
			to_chat(user, "You close the maintenance hatch of the [src.name].")
		return 1
	if(opened)
		if(istype(O, /obj/item/crowbar))
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			M.state = 2
			M.icon_state = "box_1"
			for(var/obj/I in component_parts)
				if(istype(I, /obj/item/reagent_containers/glass/beaker))
					reagents.trans_to(I, reagents.total_volume)
				if(I.reliability != 100 && crit_fail)
					I.crit_fail = 1
				I.loc = src.loc
			eject_stored_materials()
			qdel(src)
			return 1
		else
			to_chat(user, SPAN_WARNING("You can't load the [src.name] while it's opened."))
			return 1
	
	if(!linked_console)
		to_chat(user, SPAN_WARNING("\The [src.name] must be linked to an R&D console first!"))
		return 1

	if(!istype(O, /obj/item/stack/sheet))
		to_chat(user, SPAN_WARNING("You cannot insert this item into the [src.name]!"))
		return 1

	var/obj/item/stack/sheet/stack = O
	if(!O)
		return
	var/material = get_material_name_by_type(stack.type)
	if(!(material in accepted_materials))
		to_chat(user, SPAN_WARNING("The [src.name] cannot accept this material!"))
		return 1
	if(get_total_stored_materials() + stack.perunit > max_storage_capacity)
		to_chat(user, SPAN_WARNING("The [src.name]'s material bin is full. Please remove material before adding more."))
		return 1

	var/num_sheets = round(input("How many sheets do you want to add?") as num) // No decimals.
	if(num_sheets < 0) // No negative numbers.
		num_sheets = 0
	if(num_sheets == 0)
		return
	if(num_sheets > stack.amount)
		num_sheets = stack.amount
	if(max_storage_capacity - get_total_stored_materials() < (num_sheets * stack.perunit)) // Can't overfill.
		num_sheets = min(stack.amount, round((max_storage_capacity - get_total_stored_materials()) / stack.perunit))

	overlays.Add("protolathe_[stack.name]")

	busy = TRUE
	use_power(max(1000, (3750 * num_sheets / 10)))
	stack.use(num_sheets)
	if(do_after(user, 16))
		to_chat(user, SPAN_INFO("You add [num_sheets] sheets to the [src.name]."))
		stored_materials[material] += (num_sheets * stack.perunit)
	else
		new stack.type(src.loc, num_sheets)
	busy = FALSE

	overlays.Remove("protolathe_[stack.name]")

	updateUsrDialog()
	return 1