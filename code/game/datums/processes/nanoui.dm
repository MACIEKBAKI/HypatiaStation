/*
 * NanoUI Process
 */
// nanomanager, the manager for Nano UIs
GLOBAL_BYOND_TYPED(nanomanager, /datum/nanomanager)

/hook/startup/proc/create_nanomanager()
	global.nanomanager = new /datum/nanomanager()
	return 1

PROCESS_DEF(nanoui)
	name = "NanoUI"
	schedule_interval = 2 SECONDS

/datum/process/nanoui/do_work()
	for(var/last_object in global.nanomanager.processing_uis)
		var/datum/nanoui/NUI = last_object
		if(!GC_DESTROYED(NUI))
			try
				NUI.process()
			catch(var/exception/e)
				catch_exception(e, NUI)
		else
			catch_bad_type(NUI)
			global.nanomanager.processing_uis.Remove(NUI)

/datum/process/nanoui/stat_entry()
	return list("[length(global.nanomanager.processing_uis)] UIs")