//these are probably broken

/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = TRUE
	var/on = 0
	var/obj/item/cell/high/cell = null
	var/use = 5
	var/unlocked = 0
	var/open = 0
	var/brightness_on = 999		//can't remember what the maxed out value is

/obj/machinery/floodlight/New()
	src.cell = new(src)
	..()

/obj/machinery/floodlight/proc/updateicon()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/process()
	if(on)
		if(cell.charge >= use)
			cell.use(use)
		else
			on = 0
			updateicon()
			//SetLuminosity(0)
			set_light(0)
			src.visible_message(SPAN_WARNING("[src] shuts down due to lack of power!"))
			return

/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.loc = user.loc
		else
			cell.loc = loc

		cell.add_fingerprint(user)
		cell.updateicon()

		src.cell = null
		to_chat(user, "You remove the power cell.")
		updateicon()
		return

	if(on)
		on = 0
		to_chat(user, SPAN_INFO("You turn off the light."))
		set_light(0)
	else
		if(!cell)
			return
		if(cell.charge <= 0)
			return
		on = 1
		to_chat(user, SPAN_INFO("You turn on the light."))
		set_light(brightness_on)

	updateicon()

/obj/machinery/floodlight/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/screwdriver))
		if(!open)
			if(unlocked)
				unlocked = 0
				to_chat(user, "You screw the battery panel in place.")
			else
				unlocked = 1
				to_chat(user, "You unscrew the battery panel.")

	if(istype(W, /obj/item/crowbar))
		if(unlocked)
			if(open)
				open = 0
				overlays = null
				to_chat(user, "You crowbar the battery panel in place.")
			else
				if(unlocked)
					open = 1
					to_chat(user, "You remove the battery panel.")

	if(istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, "There is a power cell already installed.")
			else
				user.drop_item()
				W.loc = src
				cell = W
				to_chat(user, "You insert the power cell.")
	updateicon()
