// verb for admins to set custom event
/client/proc/cmd_admin_change_custom_event()
	set category = "Fun"
	set name = "Change Custom Event"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	var/input = input(usr, "Enter the description of the custom event. Be descriptive. To cancel the event, make this blank or hit cancel.", "Custom Event", GLOBL.custom_event_msg) as message | null
	if(!input || input == "")
		GLOBL.custom_event_msg = null
		log_admin("[usr.key] has cleared the custom event text.")
		message_admins("[key_name_admin(usr)] has cleared the custom event text.")
		return

	log_admin("[usr.key] has changed the custom event text.")
	message_admins("[key_name_admin(usr)] has changed the custom event text.")

	GLOBL.custom_event_msg = input

	to_world("<h1 class='alert'>Custom Event</h1>")
	to_world("<h2 class='alert'>A custom event is starting. OOC Info:</h2>")
	to_world(SPAN_ALERT("[html_encode(GLOBL.custom_event_msg)]"))
	to_world("<br>")

// normal verb for players to view info
/client/verb/cmd_view_custom_event()
	set category = "OOC"
	set name = "Custom Event Info"

	if(!GLOBL.custom_event_msg || GLOBL.custom_event_msg == "")
		to_chat(src, "There currently is no known custom event taking place.")
		to_chat(src, "Keep in mind: it is possible that an admin has not properly set this.")
		return

	to_chat(src, "<h1 class='alert'>Custom Event</h1>")
	to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
	to_chat(src, SPAN_ALERT("[html_encode(GLOBL.custom_event_msg)]"))
	to_chat(src, "<br>")