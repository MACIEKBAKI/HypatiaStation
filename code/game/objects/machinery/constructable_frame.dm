//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = TRUE
	anchored = TRUE
	use_power = 0
	var/obj/item/weapon/circuitboard/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = 1

/obj/machinery/constructable_frame/proc/update_desc()
	var/D
	if(req_components)
		D = "Requires "
		var/first = 1
		for(var/I in req_components)
			if(req_components[I] > 0)
				D += "[first?"":", "][num2text(req_components[I])] [req_component_names[I]]"
				first = 0
		if(first) // nothing needs to be added, then
			D += "nothing"
		D += "."
	desc = D

/obj/machinery/constructable_frame/machine_frame/attackby(obj/item/P as obj, mob/user as mob)
	if(P.crit_fail)
		user << "\red This part is faulty, you cannot add this to the machine!"
		return
	switch(state)
		if(1)
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = P
				if(C.amount >= 5)
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "\blue You start to add cables to the frame."
					if(do_after(user, 20))
						if(C)
							C.use(5)
							user << "\blue You add cables to the frame."
							state = 2
							icon_state = "box_1"
			else
				if(istype(P, /obj/item/weapon/wrench))
					playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
					user << "\blue You dismantle the frame"
					new /obj/item/stack/sheet/metal(src.loc, 5)
					qdel(src)
		if(2)
			if(istype(P, /obj/item/weapon/circuitboard))
				var/obj/item/weapon/circuitboard/B = P
				if(B.board_type == "machine")
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "\blue You add the circuit board to the frame."
					circuit = P
					user.drop_item()
					P.loc = src
					icon_state = "box_2"
					state = 3
					components = list()
					req_components = circuit.req_components.Copy()
					for(var/A in circuit.req_components)
						req_components[A] = circuit.req_components[A]
					req_component_names = circuit.req_components.Copy()
					for(var/A in req_components)
						var/cp = A
						var/obj/ct = new cp() // have to quickly instantiate it get name
						req_component_names[A] = ct.name
					if(circuit.frame_desc)
						desc = circuit.frame_desc
					else
						update_desc()
					user << desc
				else
					user << "\red This frame does not accept circuit boards of this type!"
			else
				if(istype(P, /obj/item/weapon/wirecutters))
					playsound(src, 'sound/items/Wirecutter.ogg', 50, 1)
					user << "\blue You remove the cables."
					state = 1
					icon_state = "box_0"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(src.loc)
					A.amount = 5

		if(3)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				state = 2
				circuit.loc = src.loc
				circuit = null
				if(!length(components))
					user << "\blue You remove the circuit board."
				else
					user << "\blue You remove the circuit board and other components."
					for(var/obj/item/weapon/W in components)
						W.loc = src.loc
				desc = initial(desc)
				req_components = null
				components = null
				icon_state = "box_1"
			else
				if(istype(P, /obj/item/weapon/screwdriver))
					var/component_check = 1
					for(var/R in req_components)
						if(req_components[R] > 0)
							component_check = 0
							break
					if(component_check)
						playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
						var/obj/machinery/new_machine = new src.circuit.build_path(src.loc)
						for(var/obj/O in new_machine.component_parts)
							qdel(O)
						new_machine.component_parts = list()
						for(var/obj/O in src)
							if(circuit.contain_parts) // things like disposal don't want their parts in them
								O.loc = new_machine
							else
								O.loc = null
							new_machine.component_parts += O
						if(circuit.contain_parts)
							circuit.loc = new_machine
						else
							circuit.loc = null
						new_machine.RefreshParts()
						qdel(src)
				else
					if(istype(P, /obj/item/weapon))
						for(var/I in req_components)
							if(istype(P, I) && (req_components[I] > 0))
								playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
								if(istype(P, /obj/item/stack/cable_coil))
									var/obj/item/stack/cable_coil/CP = P
									if(CP.amount > 1)
										var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
										var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src)
										CC.amount = camt
										CC.update_icon()
										CP.use(camt)
										components += CC
										req_components[I] -= camt
										update_desc()
										break
								user.drop_item()
								P.loc = src
								components += P
								req_components[I]--
								update_desc()
								break
						user << desc
						if(P && P.loc != src && !istype(P, /obj/item/stack/cable_coil))
							user << "\red You cannot add that component to the machine!"


//Machine Frame Circuit Boards
/*Common Parts: Parts List: Ignitor, Timer, Infra-red laser, Infra-red sensor, t_scanner, Capacitor, Valve, sensor unit,
micro-manipulator, console screen, beaker, Microlaser, matter bin, power cells.
Note: Once everything is added to the public areas, will add m_amt and g_amt to circuit boards since autolathe won't be able
to destroy them and players will be able to make replacements.
*/
/obj/item/weapon/circuitboard/destructive_analyzer
	name = "Circuit board (Destructive Analyzer)"
	build_path = /obj/machinery/r_n_d/destructive_analyzer
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_PROGRAMMING = 2)
	frame_desc = "Requires 1 Scanning Module, 1 Micro Manipulator, and 1 Micro-Laser."
	req_components = list(
							/obj/item/weapon/stock_part/scanning_module = 1,
							/obj/item/weapon/stock_part/manipulator = 1,
							/obj/item/weapon/stock_part/micro_laser = 1)

/obj/item/weapon/circuitboard/autolathe
	name = "Circuit board (Autolathe)"
	build_path = /obj/machinery/autolathe
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_PROGRAMMING = 2)
	frame_desc = "Requires 3 Matter Bins, 1 Micro Manipulator, and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_part/matter_bin = 3,
							/obj/item/weapon/stock_part/manipulator = 1,
							/obj/item/weapon/stock_part/console_screen = 1)

/obj/item/weapon/circuitboard/protolathe
	name = "Circuit board (Protolathe)"
	build_path = /obj/machinery/r_n_d/protolathe
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_PROGRAMMING = 2)
	frame_desc = "Requires 2 Matter Bins, 2 Micro Manipulators, and 2 Beakers."
	req_components = list(
							/obj/item/weapon/stock_part/matter_bin = 2,
							/obj/item/weapon/stock_part/manipulator = 2,
							/obj/item/weapon/reagent_containers/glass/beaker = 2)


/obj/item/weapon/circuitboard/circuit_imprinter
	name = "Circuit board (Circuit Imprinter)"
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_PROGRAMMING = 2)
	frame_desc = "Requires 1 Matter Bin, 1 Micro Manipulator, and 2 Beakers."
	req_components = list(
							/obj/item/weapon/stock_part/matter_bin = 1,
							/obj/item/weapon/stock_part/manipulator = 1,
							/obj/item/weapon/reagent_containers/glass/beaker = 2)

/obj/item/weapon/circuitboard/pacman
	name = "Circuit Board (PACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman
	board_type = "machine"
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_PLASMATECH = 3,
		RESEARCH_TECH_ENGINEERING = 3
	)
	frame_desc = "Requires 1 Matter Bin, 1 Micro-Laser, 2 Pieces of Cable, and 1 Capacitor."
	req_components = list(
							/obj/item/weapon/stock_part/matter_bin = 1,
							/obj/item/weapon/stock_part/micro_laser = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_part/capacitor = 1)

/obj/item/weapon/circuitboard/pacman/super
	name = "Circuit Board (SUPERPACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman/super
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_POWERSTORAGE = 4, RESEARCH_TECH_ENGINEERING = 4)

/obj/item/weapon/circuitboard/pacman/mrs
	name = "Circuit Board (MRSPACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman/mrs
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_POWERSTORAGE = 5, RESEARCH_TECH_ENGINEERING = 5)

/obj/item/weapon/circuitboard/rdserver
	name = "Circuit Board (R&D Server)"
	build_path = /obj/machinery/r_n_d/server
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	frame_desc = "Requires 2 pieces of cable, and 1 Scanning Module."
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_part/scanning_module = 1)

/obj/item/weapon/circuitboard/mechfab
	name = "Circuit board (Exosuit Fabricator)"
	build_path = /obj/machinery/mecha_part_fabricator
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_ENGINEERING = 3)
	frame_desc = "Requires 2 Matter Bins, 1 Micro Manipulator, 1 Micro-Laser and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_part/matter_bin = 2,
							/obj/item/weapon/stock_part/manipulator = 1,
							/obj/item/weapon/stock_part/micro_laser = 1,
							/obj/item/weapon/stock_part/console_screen = 1)

/obj/item/weapon/circuitboard/clonepod
	name = "Circuit board (Clone Pod)"
	build_path = /obj/machinery/clonepod
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 3)
	frame_desc = "Requires 2 Manipulator, 2 Scanning Module, 2 pieces of cable and 1 Console Screen."
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_part/scanning_module = 2,
							/obj/item/weapon/stock_part/manipulator = 2,
							/obj/item/weapon/stock_part/console_screen = 1)

/obj/item/weapon/circuitboard/clonescanner
	name = "Circuit board (Cloning Scanner)"
	build_path = /obj/machinery/dna_scannernew
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)
	frame_desc = "Requires 1 Scanning module, 1 Micro Manipulator, 1 Micro-Laser, 2 pieces of cable and 1 Console Screen."
	req_components = list(
							/obj/item/weapon/stock_part/scanning_module = 1,
							/obj/item/weapon/stock_part/manipulator = 1,
							/obj/item/weapon/stock_part/micro_laser = 1,
							/obj/item/weapon/stock_part/console_screen = 1,
							/obj/item/stack/cable_coil = 2,)


// Telecoms circuit boards:

/obj/item/weapon/circuitboard/telecoms/receiver
	name = "Circuit Board (Subspace Receiver)"
	build_path = /obj/machinery/telecoms/receiver
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 3, RESEARCH_TECH_BLUESPACE = 2)
	frame_desc = "Requires 1 Subspace Ansible, 1 Hyperwave Filter, 2 Micro Manipulators, and 1 Micro-Laser."
	req_components = list(
							/obj/item/weapon/stock_part/subspace/ansible = 1,
							/obj/item/weapon/stock_part/subspace/filter = 1,
							/obj/item/weapon/stock_part/manipulator = 2,
							/obj/item/weapon/stock_part/micro_laser = 1)

/obj/item/weapon/circuitboard/telecoms/hub
	name = "Circuit Board (Hub Mainframe)"
	build_path = /obj/machinery/telecoms/hub
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	frame_desc = "Requires 2 Micro Manipulators, 2 Cable Coil and 2 Hyperwave Filter."
	req_components = list(
							/obj/item/weapon/stock_part/manipulator = 2,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_part/subspace/filter = 2)

/obj/item/weapon/circuitboard/telecoms/relay
	name = "Circuit Board (Relay Mainframe)"
	build_path = /obj/machinery/telecoms/relay
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_BLUESPACE = 3)
	frame_desc = "Requires 2 Micro Manipulators, 2 Cable Coil and 2 Hyperwave Filters."
	req_components = list(
							/obj/item/weapon/stock_part/manipulator = 2,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_part/subspace/filter = 2)

/obj/item/weapon/circuitboard/telecoms/bus
	name = "Circuit Board (Bus Mainframe)"
	build_path = /obj/machinery/telecoms/bus
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	frame_desc = "Requires 2 Micro Manipulators, 1 Cable Coil and 1 Hyperwave Filter."
	req_components = list(
							/obj/item/weapon/stock_part/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_part/subspace/filter = 1)

/obj/item/weapon/circuitboard/telecoms/processor
	name = "Circuit Board (Processor Unit)"
	build_path = /obj/machinery/telecoms/processor
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	frame_desc = "Requires 3 Micro Manipulators, 1 Hyperwave Filter, 2 Treatment Disks, 1 Wavelength Analyzer, 2 Cable Coils and 1 Subspace Amplifier."
	req_components = list(
							/obj/item/weapon/stock_part/manipulator = 3,
							/obj/item/weapon/stock_part/subspace/filter = 1,
							/obj/item/weapon/stock_part/subspace/treatment = 2,
							/obj/item/weapon/stock_part/subspace/analyzer = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_part/subspace/amplifier = 1)

/obj/item/weapon/circuitboard/telecoms/server
	name = "Circuit Board (Telecommunication Server)"
	build_path = /obj/machinery/telecoms/server
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	frame_desc = "Requires 2 Micro Manipulators, 1 Cable Coil and 1 Hyperwave Filter."
	req_components = list(
							/obj/item/weapon/stock_part/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_part/subspace/filter = 1)

/obj/item/weapon/circuitboard/telecoms/broadcaster
	name = "Circuit Board (Subspace Broadcaster)"
	build_path = /obj/machinery/telecoms/broadcaster
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_BLUESPACE = 2)
	frame_desc = "Requires 2 Micro Manipulators, 1 Cable Coil, 1 Hyperwave Filter, 1 Ansible Crystal and 2 High-Powered Micro-Lasers. "
	req_components = list(
							/obj/item/weapon/stock_part/manipulator = 2,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_part/subspace/filter = 1,
							/obj/item/weapon/stock_part/subspace/crystal = 1,
							/obj/item/weapon/stock_part/micro_laser/high = 2)




