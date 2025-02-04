/turf/simulated/floor/open
	name = "open space"
	intact = 0
	density = FALSE
	icon_state = "black"
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

	var/icon/darkoverlays = null
	var/turf/floorbelow
	var/list/overlay_references

/turf/simulated/floor/open/New()
	..()
	getbelow()
	return

/turf/simulated/floor/open/Enter(atom/movable/enterer)
	if(..()) //TODO make this check if gravity is active (future use) - Sukasa
		spawn(1)
			// only fall down in defined areas (read: areas with artificial gravitiy)
			if(!floorbelow) //make sure that there is actually something below
				if(!getbelow())
					return
			if(enterer)
				var/area/areacheck = get_area(src)
				var/blocked = FALSE
				var/soft = FALSE
				for(var/atom/A in floorbelow.contents)
					if(A.density)
						blocked = TRUE
						break
					if(istype(A, /obj/machinery/atmospherics/pipe/zpipe/up) && istype(enterer, /obj/item/pipe))
						blocked = TRUE
						break
					if(istype(A, /obj/structure/disposalpipe/up) && istype(enterer, /obj/item/pipe))
						blocked = TRUE
						break
					if(istype(A, /obj/multiz/stairs))
						soft = TRUE
						//dont break here, since we still need to be sure that it isnt blocked

				if(soft || (!blocked && !(istype(areacheck, /area/space))))
					enterer.Move(floorbelow)
					if(!soft && ishuman(enterer))
						var/mob/living/carbon/human/H = enterer
						var/damage = 5
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "head")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "chest")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "l_leg")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "r_leg")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "l_arm")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "r_arm")
						H:weakened = max(H:weakened, 2)
						H:updatehealth()
	return ..()

// override to make sure nothing is hidden
/turf/simulated/floor/open/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

//overwrite the attackby of space to transform it to openspace if necessary
/turf/space/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/stack/cable_coil) && src.hasbelow())
		var/turf/simulated/floor/open/W = src.ChangeTurf(/turf/simulated/floor/open)
		W.attackby(C, user)
		return
	..()

/turf/simulated/floor/open/ex_act(severity)
	// cant destroy empty space with an ordinary bomb
	return

/turf/simulated/floor/open/attackby(obj/item/C as obj, mob/user as mob)
	..(C, user)
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/cable = C
		cable.turf_place(src, user)
		return

	if(istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		to_chat(user, SPAN_INFO("Constructing support lattice..."))
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))
	return

/turf/simulated/floor/open/proc/getbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		// check if there is something to draw below
		if(!controller.down)
			src.ChangeTurf(get_base_turf_by_area(src))
			return 0
		else
			floorbelow = locate(src.x, src.y, controller.down_target)
			return 1
	return 1

/turf/proc/hasbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.down)
			return 1
	return 0