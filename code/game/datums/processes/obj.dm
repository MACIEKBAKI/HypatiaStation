/*
 * Object Process
 */
GLOBAL_GLOBL_LIST_NEW(processing_objects)

PROCESS_DEF(obj)
	name = "Obj"
	schedule_interval = 2 SECONDS
	start_delay = 8

/datum/process/obj/do_work()
	for(var/last_object in GLOBL.processing_objects)
		var/obj/O = last_object
		if(!GC_DESTROYED(O))
			try
				if(O.process() == PROCESS_KILL)
					GLOBL.processing_objects.Remove(O)
					continue
			catch(var/exception/e)
				catch_exception(e, O)
			SCHECK
		else
			catch_bad_type(O)
			GLOBL.processing_objects.Remove(O)

/datum/process/obj/stat_entry()
	return list("[length(GLOBL.processing_objects)] object\s")