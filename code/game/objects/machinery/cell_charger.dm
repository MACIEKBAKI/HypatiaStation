/obj/machinery/cell_charger
	//name = "cell charger"
	//desc = "It charges power cells."
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 60
	power_channel = EQUIP
	var/obj/item/cell/charging = null
	var/chargelevel = -1
	var/power_rating = 40000	//40 kW. A measure of how powerful this charger is for charging cells (this the power drawn when charging)

/obj/machinery/cell_charger/proc/updateicon()
	icon_state = "ccharger[charging ? 1 : 0]"

	if(charging && !(stat & (BROKEN|NOPOWER)) )

		var/newlevel = 	round(charging.percent() * 4.0 / 99)
		//to_world("nl: [newlevel]")

		if(chargelevel != newlevel)

			overlays.Cut()
			overlays += "ccharger-o[newlevel]"

			chargelevel = newlevel
	else
		overlays.Cut()

/obj/machinery/cell_charger/examine()
	set src in oview(5)
	..()
	usr << "There's [charging ? "a" : "no"] cell in the charger."
	if(charging)
		usr << "Current charge: [charging.charge]"

/obj/machinery/cell_charger/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/cell) && anchored)
		if(charging)
			user << "\red There is already a cell in the charger."
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(!a.power_equip) // There's no APC in this area, don't try to cheat power!
				user << "\red The [name] blinks red as you try to insert the cell!"
				return

			user.drop_item()
			W.loc = src
			charging = W
			user.visible_message("[user] inserts a cell into the charger.", "You insert a cell into the charger.")
			chargelevel = -1
		updateicon()
	else if(istype(W, /obj/item/wrench))
		if(charging)
			user << "\red Remove the cell first!"
			return

		anchored = !anchored
		user << "You [anchored ? "attach" : "detach"] the cell charger [anchored ? "to" : "from"] the ground"
		playsound(src, 'sound/items/Ratchet.ogg', 75, 1)

/obj/machinery/cell_charger/attack_hand(mob/user)
	if(charging)
		usr.put_in_hands(charging)
		charging.add_fingerprint(user)
		charging.updateicon()

		src.charging = null
		user.visible_message("[user] removes the cell from the charger.", "You remove the cell from the charger.")
		chargelevel = -1
		updateicon()

/obj/machinery/cell_charger/attack_ai(mob/user)
	return

/obj/machinery/cell_charger/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)


/obj/machinery/cell_charger/process()
	//to_world("ccpt [charging] [stat]")
	if(!charging || (stat & (BROKEN|NOPOWER)) || !anchored)
		return

	//use_power(200)		//this used to use CELLRATE, but CELLRATE is fucking awful. feel free to fix this properly!
	//charging.give(175)	//inefficiency.

	if (!charging.fully_charged())
		var/charge_used = charging.give(power_rating*CELLRATE)
		use_power(charge_used/CELLRATE)		//It's only while charging something, so I'm going to say use_power() is fine here...

	updateicon()