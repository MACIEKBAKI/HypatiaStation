/obj/machinery/replicator
	name = "alien machine"
	desc = "It's some kind of pod with strange wires and gadgets all over it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "borgcharger0(old)"
	density = TRUE

	idle_power_usage = 100
	active_power_usage = 1000
	use_power = 1

	var/spawn_progress = 0
	var/max_spawn_ticks = 5
	var/list/construction = list()
	var/list/spawning_types = list()

/obj/machinery/replicator/New()
	..()

	var/list/viables = list(
		/obj/item/roller,
		/obj/structure/closet/crate,
		/obj/structure/closet/acloset,
		/mob/living/simple_animal/hostile/mimic,
		/mob/living/simple_animal/hostile/viscerator,
		/mob/living/simple_animal/hostile/hivebot,
		/obj/item/device/analyzer,
		/obj/item/device/camera,
		/obj/item/device/flash,
		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/multitool,
		/obj/item/device/paicard,
		/obj/item/device/radio,
		/obj/item/device/radio/headset,
		/obj/item/device/radio/beacon,
		/obj/item/autopsy_scanner,
		/obj/item/bikehorn,
		/obj/item/bonesetter,
		/obj/item/butch,
		/obj/item/caution,
		/obj/item/caution/cone,
		/obj/item/crowbar,
		/obj/item/clipboard,
		/obj/item/cell,
		/obj/item/circular_saw,
		/obj/item/hatchet,
		/obj/item/handcuffs,
		/obj/item/hemostat,
		/obj/item/kitchenknife,
		/obj/item/lighter,
		/obj/item/lighter,
		/obj/item/light/bulb,
		/obj/item/light/tube,
		/obj/item/pickaxe,
		/obj/item/shovel,
		/obj/item/table_parts,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/screwdriver,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/metalfoam
	)

	var/quantity = rand(5, 15)
	for(var/i = 0, i < quantity, i++)
		var/button_desc = "[pick("a yellow", "a purple", "a green", "a blue", "a red", "an orange", "a white")], "
		button_desc += "[pick("round", "square", "diamond", "heart", "dog", "human")] shaped "
		button_desc += "[pick("toggle", "switch", "lever", "button", "pad", "hole")]"
		var/type = pick(viables)
		viables.Remove(type)
		construction[button_desc] = type

/obj/machinery/replicator/process()
	if(length(spawning_types) && powered())
		spawn_progress++
		if(spawn_progress > max_spawn_ticks)
			visible_message(SPAN_INFO("\icon[src] [src] pings!"))
			var/spawn_type = spawning_types[1]
			new spawn_type(src.loc)

			spawning_types.Remove(spawning_types[1])
			spawn_progress = 0
			max_spawn_ticks = rand(5, 30)

			if(!length(spawning_types))
				use_power = 1
				icon_state = "borgcharger0(old)"

		else if(prob(5))
			visible_message(SPAN_INFO("\icon[src] [src] [pick("clicks", "whizzes", "whirrs", "whooshes", "clanks", "clongs", "clonks", "bangs")]."))

/obj/machinery/replicator/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/replicator/interact(mob/user)
	var/dat = "The control panel displays an incomprehensible selection of controls, many with unusual markings or text around them.<br>"
	dat += "<br>"
	for(var/index = 1, index <= length(construction), index++)
		dat += "<A href='?src=\ref[src];activate=[index]'>\[[construction[index]]\]</a><br>"

	user << browse(dat, "window=alien_replicator")

/obj/machinery/replicator/Topic(href, href_list)
	if(href_list["activate"])
		var/index = text2num(href_list["activate"])
		if(index > 0 && index <= length(construction))
			if(length(spawning_types))
				visible_message(SPAN_INFO("\icon[src] a [pick("light", "dial", "display", "meter", "pad")] on [src]'s front [pick("blinks","flashes")] [pick("red", "yellow", "blue", "orange", "purple", "green", "white")]."))
			else
				visible_message(SPAN_INFO("\icon[src] [src]'s front compartment slides shut."))

			spawning_types.Add(construction[construction[index]])
			spawn_progress = 0
			use_power = 2
			icon_state = "borgcharger1(old)"