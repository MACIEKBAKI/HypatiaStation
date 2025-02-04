/proc/gibs(atom/location, list/viruses, datum/dna/MobDNA)		//CARN MARKER
	new /obj/effect/gibspawner/generic(get_turf(location), viruses, MobDNA)

/proc/hgibs(atom/location, list/viruses, datum/dna/MobDNA, fleshcolor, bloodcolor)
	new /obj/effect/gibspawner/human(get_turf(location), viruses, MobDNA, fleshcolor, bloodcolor)

/proc/xgibs(atom/location, list/viruses)
	new /obj/effect/gibspawner/xeno(get_turf(location), viruses)

/proc/robogibs(atom/location, list/viruses)
	new /obj/effect/gibspawner/robot(get_turf(location), viruses)


/obj/effect/gibspawner
	var/sparks = 0 //whether sparks spread on Gib()
	var/virusProb = 20 //the chance for viruses to spread on the gibs
	var/list/gibtypes = list()
	var/list/gibamounts = list()
	var/list/gibdirections = list() //of lists
	var/fleshcolor //Used for gibbed humans.
	var/bloodcolor //Used for gibbed humans.

/obj/effect/gibspawner/New(location, list/viruses, datum/dna/MobDNA, fleshcolor, bloodcolor)
	..()

	if(fleshcolor)
		src.fleshcolor = fleshcolor
	if(bloodcolor)
		src.bloodcolor = bloodcolor

	if(isturf(loc)) //basically if a badmin spawns it
		Gib(loc, viruses, MobDNA)

/obj/effect/gibspawner/proc/Gib(atom/location, list/viruses = list(), datum/dna/MobDNA = null)
	if(length(gibtypes) != length(gibamounts) || length(gibamounts) != length(gibdirections))
		to_world(SPAN_WARNING("Gib list length mismatch!"))
		return

	var/obj/effect/decal/cleanable/blood/gibs/gib = null
	for(var/datum/disease/D in viruses)
		if(D.spread_type == SPECIAL)
			qdel(D)

	if(sparks)
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(2, 1, location)
		s.start()

	for(var/i = 1, i <= length(gibtypes), i++)
		if(gibamounts[i])
			for(var/j = 1, j <= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(location)

				// Apply human species colouration to masks.
				if(fleshcolor)
					gib.fleshcolor = fleshcolor
				if(bloodcolor)
					gib.basecolor = bloodcolor

				gib.update_icon()

				if(length(viruses))
					for(var/datum/disease/D in viruses)
						if(prob(virusProb))
							var/datum/disease/viruus = D.Copy(1)
							gib.viruses += viruus
							viruus.holder = gib

				gib.blood_DNA = list()
				if(MobDNA)
					gib.blood_DNA[MobDNA.unique_enzymes] = MobDNA.b_type
				else if(istype(src, /obj/effect/gibspawner/xeno))
					gib.blood_DNA["UNKNOWN DNA"] = "X*"
				else if(istype(src, /obj/effect/gibspawner/human)) // Probably a monkey
					gib.blood_DNA["Non-human DNA"] = "A+"
				var/list/directions = gibdirections[i]
				if(length(directions))
					gib.streak(directions)

	qdel(src)