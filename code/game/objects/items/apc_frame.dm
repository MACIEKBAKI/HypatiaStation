// APC HULL
/obj/item/apc_frame
	name = "APC frame"
	desc = "Used for repairing or building APCs"
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "apc_frame"
	flags = CONDUCT

/obj/item/apc_frame/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/wrench))
		new /obj/item/stack/sheet/metal(get_turf(src.loc), 2)
		qdel(src)

/obj/item/apc_frame/proc/try_build(turf/on_wall)
	if(get_dist(on_wall, usr) > 1)
		return
	var/ndir = get_dir(usr, on_wall)
	if(!(ndir in GLOBL.cardinal))
		return
	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if(!istype(loc, /turf/simulated/floor))
		to_chat(usr, SPAN_WARNING("An APC cannot be placed on this spot."))
		return
	if(!A.requires_power || istype(A, /area/space))
		to_chat(usr, SPAN_WARNING("An APC cannot be placed in this area."))
		return
	if(A.get_apc())
		to_chat(usr, SPAN_WARNING("This area already has an APC."))
		return //only one APC per area
	for(var/obj/machinery/power/terminal/T in loc)
		if(T.master)
			to_chat(usr, SPAN_WARNING("There is another network terminal here."))
			return
		else
			var/obj/item/stack/cable_coil/C = new /obj/item/stack/cable_coil(loc)
			C.amount = 10
			to_chat(usr, "You cut the cables and disassemble the unused power terminal.")
			qdel(T)
	new /obj/machinery/power/apc(loc, ndir, 1)
	qdel(src)