
/obj/machinery/computer/station_alert
	name = "Station Alert Computer"
	desc = "Used to access the station's automated alert system."
	icon_state = "alert:0"
	circuit = /obj/item/circuitboard/stationalert
	var/alarms = list("Fire"=list(), "Atmosphere"=list(), "Power"=list())

	light_color = "#e6ffff"

/obj/machinery/computer/station_alert/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)
	return

/obj/machinery/computer/station_alert/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)
	return

/obj/machinery/computer/station_alert/interact(mob/user)
	usr.set_machine(src)
	var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[user];mach_close=alerts'>Close</A><br><br>"
	for (var/cat in src.alarms)
		dat += text("<B>[]</B><BR>\n", cat)
		var/list/L = src.alarms[cat]
		if(length(L))
			for (var/alarm in L)
				var/list/alm = L[alarm]
				var/area/A = alm[1]
				var/list/sources = alm[3]
				dat += "<NOBR>"
				dat += "&bull; "
				dat += "[A.name]"
				if(length(sources) > 1)
					dat += " - [length(sources)] sources"
				dat += "</NOBR><BR>\n"
		else
			dat += "-- All Systems Nominal<BR>\n"
		dat += "<BR>\n"
	user << browse(dat, "window=alerts")
	onclose(user, "alerts")

/obj/machinery/computer/station_alert/Topic(href, href_list)
	if(..())
		return
	return


/obj/machinery/computer/station_alert/proc/triggerAlarm(var/class, area/A, var/O, var/alarmsource)
	if(stat & (BROKEN))
		return
	var/list/L = src.alarms[class]
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/sources = alarm[3]
			if (!(alarmsource in sources))
				sources += alarmsource
			return 1
	var/obj/machinery/camera/C = null
	var/list/CL = null
	if (O && istype(O, /list))
		CL = O
		if(length(CL) == 1)
			C = CL[1]
	else if (O && istype(O, /obj/machinery/camera))
		C = O
	L[A.name] = list(A, (C) ? C : O, list(alarmsource))
	return 1

/obj/machinery/computer/station_alert/proc/cancelAlarm(var/class, area/A as area, obj/origin)
	if(stat & (BROKEN))
		return
	var/list/L = src.alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if(!length(srcs))
				cleared = 1
				L -= I
	return !cleared

/obj/machinery/computer/station_alert/process()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "atmos0"
		return
	var/active_alarms = 0
	for (var/cat in src.alarms)
		var/list/L = src.alarms[cat]
		if(length(L))
			active_alarms = 1
	if(active_alarms)
		icon_state = "alert:2"
	else
		icon_state = "alert:0"
	..()
	return