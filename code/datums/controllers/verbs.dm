/*
 * Controller Verbs
 */
/client/proc/restart_controller(controller in list("Supply"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	usr = null
	qdel(src)
	switch(controller)
		if("Supply")
			global.supply_controller.process()
			feedback_add_details("admin_verb", "RSupply")
	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
	return

/client/proc/debug_controller(controller in list("Configuration", "Cameras"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	switch(controller)
		if("Configuration")
			debug_variables(CONFIG)
			feedback_add_details("admin_verb", "DConf")
		if("Cameras")
			debug_variables(global.cameranet)
			feedback_add_details("admin_verb", "DCameras")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return