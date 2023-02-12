/*
 * Turf Process
 */
GLOBAL_GLOBL_LIST_NEW(processing_turfs)

PROCESS_DEF(turf)
	name = "Turf"
	schedule_interval = 3 SECONDS

/datum/process/turf/doWork()
	for(var/turf/T in GLOBL.processing_turfs)
		if(T && !GC_DESTROYED(T))
			if(T.process() == PROCESS_KILL)
				GLOBL.processing_turfs.Remove(T)
				continue

		SCHECK

/datum/process/turf/statProcess()
	. = ..()
	stat(null, "[length(GLOBL.processing_turfs)] turf\s")