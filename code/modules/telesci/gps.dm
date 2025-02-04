GLOBAL_GLOBL_LIST_NEW(gps_list)

/obj/item/device/gps
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 2016."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	w_class = 2.0
	slot_flags = SLOT_BELT
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_ENGINEERING = 2)

	var/gpstag = "COM0"
	var/emped = FALSE

/obj/item/device/gps/New()
	. = ..()
	GLOBL.gps_list.Add(src)
	name = "global positioning system ([gpstag])"
	overlays += "working"

/obj/item/device/gps/Destroy()
	GLOBL.gps_list.Remove(src)
	return ..()

/obj/item/device/gps/emp_act(severity)
	emped = TRUE
	overlays.Remove("working")
	overlays.Add("emp")
	spawn(300)
		emped = FALSE
		overlays.Remove("emp")
		overlays.Add("working")

/obj/item/device/gps/attack_self(mob/user as mob)
	var/html
	if(emped)
		html += "ERROR"
	else
		html += "<BR><A href='?src=\ref[src];tag=1'>Set Tag</A> "
		html += "<BR>Tag: [gpstag]"

		for(var/obj/item/device/gps/G in GLOBL.gps_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(G.emped)
				html += "<BR>[tracked_gpstag]: ERROR"
			else
				html += "<BR>[tracked_gpstag]: [format_text(gps_area.name)] ([pos.x], [pos.y], [pos.z])"

	var/datum/browser/popup = new /datum/browser(user, "GPS", name, 600, 450)
	popup.set_content(html)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/item/device/gps/Topic(href, href_list)
	..()
	if(href_list["tag"] )
		var/a = input("Please enter desired tag.", name, gpstag) as text
		a = uppertext(copytext(sanitize(a), 1, 5))
		if(src.loc == usr)
			gpstag = a
			name = "global positioning system ([gpstag])"
			attack_self(usr)

/obj/item/device/gps/science
	icon_state = "gps-s"
	gpstag = "SCI0"

/obj/item/device/gps/engineering
	icon_state = "gps-e"
	gpstag = "ENG0"