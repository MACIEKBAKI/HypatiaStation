/*
 * Subspace Stock Parts
 */
/obj/item/stock_part/subspace
	matter_amounts = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 10)

// Subspace Ansible
/obj/item/stock_part/subspace/ansible
	name = "subspace ansible"
	icon_state = "subspace_ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 5, RESEARCH_TECH_MATERIALS = 4,
		RESEARCH_TECH_BLUESPACE = 2
	)

// Hyperwave Filter
/obj/item/stock_part/subspace/filter
	name = "hyperwave filter"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_MAGNETS = 2)

// Subspace Amplifier
/obj/item/stock_part/subspace/amplifier
	name = "subspace amplifier"
	icon_state = "subspace_amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_MATERIALS = 4,
		RESEARCH_TECH_BLUESPACE = 2
	)

// Subspace Treatment Disk
/obj/item/stock_part/subspace/treatment
	name = "subspace treatment disk"
	icon_state = "treatment_disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_MATERIALS = 5,
		RESEARCH_TECH_BLUESPACE = 2
	)

// Subspace Wavelength Analyser
/obj/item/stock_part/subspace/analyser
	name = "subspace wavelength analyser"
	icon_state = "wavelength_analyser"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_MATERIALS = 4,
		RESEARCH_TECH_BLUESPACE = 2
	)

// Ansible Crystal
/obj/item/stock_part/subspace/crystal
	name = "ansible crystal"
	icon_state = "ansible_crystal"
	desc = "A crystal made from pure glass used to transmit laser databursts to subspace."
	origin_tech = list(RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_BLUESPACE = 2)
	matter_amounts = list(MATERIAL_GLASS = 50)

// Subspace Transmitter
/obj/item/stock_part/subspace/transmitter
	name = "subspace transmitter"
	icon_state = "subspace_transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	origin_tech = list(RESEARCH_TECH_MAGNETS = 5, RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_BLUESPACE = 3)
	matter_amounts = list(MATERIAL_METAL = 50)