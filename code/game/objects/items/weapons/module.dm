/obj/item/module
	icon = 'icons/obj/items/module.dmi'
	icon_state = "std_module"
	w_class = 2.0
	item_state = "electronic"
	flags = CONDUCT

	var/mtype = 1						// 1=electronic 2=hardware

/obj/item/module/card_reader
	name = "card reader module"
	desc = "An electronic module for reading data and ID cards."
	icon_state = "card_mod"

/obj/item/module/power_control
	name = "power control module"
	desc = "Heavy-duty switching circuits for power control."
	icon_state = "power_mod"
	matter_amounts = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)

/obj/item/module/id_auth
	name = "\improper ID authentication module"
	desc = "A module allowing secure authorisation of ID cards."
	icon_state = "id_mod"

/obj/item/module/cell_power
	name = "power cell regulator module"
	desc = "A converter and regulator allowing the use of power cells."
	icon_state = "power_mod"

/obj/item/module/cell_power
	name = "power cell charger module"
	desc = "Charging circuits for power cells."
	icon_state = "power_mod"