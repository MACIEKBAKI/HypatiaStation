/*
 * Scanning Modules
 */
// Rating 1
/obj/item/stock_part/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 1)
	matter_amounts = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 20)

// Rating 2
/obj/item/stock_part/scanning_module/adv
	name = "advanced scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "adv_scan_module"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 3)
	rating = 2

// Rating 3
/obj/item/stock_part/scanning_module/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	icon_state = "phasic_scan_module"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 5)
	rating = 3

// Rating 4
/obj/item/stock_part/scanning_module/hyperphasic
	name = "hyper-phasic scanning module"
	desc = "A compact, high resolution hyper-phasic scanning module used in the construction of certain devices."
	icon_state = "hyper_phasic_scan_module"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 7)
	rating = 4