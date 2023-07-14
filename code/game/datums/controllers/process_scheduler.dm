/*
 * Process Scheduler
 */
GLOBAL_BYOND_TYPED(process_scheduler, /datum/controller/process_scheduler) // Set in world/New()

// This should NOT use CONTROLLER_DEF.
/datum/controller/process_scheduler
	name = "Process Scheduler"

	// Processes known by the scheduler
	var/tmp/list/processes = list()

	// Processes that are currently running
	var/tmp/list/running = list()

	// Processes that are idle
	var/tmp/list/idle = list()

	// Processes that are queued to run
	var/tmp/list/queued = list()

	// Process name -> process object map
	var/tmp/list/nameToProcessMap = list()

	// Process last queued times (world time)
	var/tmp/list/last_queued = list()

	// Process last start times (real time)
	var/tmp/list/last_start = list()

	// Process last run durations
	var/tmp/list/last_run_time = list()

	// Per process list of the last 20 durations
	var/tmp/list/last_twenty_run_times = list()

	// Process highest run time
	var/tmp/list/highest_run_time = list()

	// How long to sleep between runs (set to tick_lag in New)
	var/tmp/scheduler_sleep_interval

	// Controls whether the scheduler is running or not
	var/tmp/isRunning = FALSE

	// Setup for these processes will be deferred until all the other processes are set up.
	var/tmp/list/deferredSetupList = list()

	var/tmp/currentTick = 0

	var/tmp/timeAllowance = 0

	var/tmp/cpuAverage = 0

	var/tmp/timeAllowanceMax = 0

/datum/controller/process_scheduler/New()
	. = ..()
	// world.tick_lag is set by this point, so there's no need to reset these later.
	scheduler_sleep_interval = world.tick_lag
	timeAllowance = world.tick_lag * 0.5
	timeAllowanceMax = world.tick_lag

/**
 * deferSetupFor
 * @param path processPath
 * If a process needs to be initialized after everything else, add it to
 * the deferred setup list. On goonstation, only the ticker needs to have
 * this treatment.
 */
/datum/controller/process_scheduler/proc/deferSetupFor(processPath)
	if(!(processPath in deferredSetupList))
		deferredSetupList.Add(processPath)

/datum/controller/process_scheduler/setup()
	// There can be only one
	if(isnotnull(global.process_scheduler) && (global.process_scheduler != src))
		del(src)
		return 0

	var/process
	// Add all the processes we can find, except those deferred until later.
	for(process in SUBTYPESOF(/datum/process))
		if(!(process in deferredSetupList))
			addProcess(new process(src))

	for(process in deferredSetupList)
		addProcess(new process(src))

/datum/controller/process_scheduler/proc/start()
	isRunning = TRUE
	updateStartDelays()
	spawn(0)
		process()

/datum/controller/process_scheduler/process()
	updateCurrentTickData()

	for(var/i = world.tick_lag, i < world.tick_lag * 50, i += world.tick_lag)
		spawn(i)
			updateCurrentTickData()
	while(isRunning)
		// Hopefully spawning this for 50 ticks in the future will make it the first thing in the queue.
		spawn(world.tick_lag * 50)
			updateCurrentTickData()
		checkRunningProcesses()
		queueProcesses()
		runQueuedProcesses()
		sleep(scheduler_sleep_interval)

/datum/controller/process_scheduler/proc/stop()
	isRunning = FALSE

/datum/controller/process_scheduler/proc/checkRunningProcesses()
	for(var/datum/process/p in running)
		p.update()

		if(isnull(p)) // Process was killed
			continue

		var/status = p.getStatus()
		var/previousStatus = p.getPreviousStatus()

		// Check status changes
		if(status != previousStatus)
			//Status changed.
			switch(status)
				if(PROCESS_STATUS_PROBABLY_HUNG)
					message_admins("Process '[p.name]' may be hung.")
				if(PROCESS_STATUS_HUNG)
					message_admins("Process '[p.name]' is hung and will be restarted.")

/datum/controller/process_scheduler/proc/queueProcesses()
	for(var/datum/process/p in processes)
		// Don't double-queue, don't queue running processes
		if(p.disabled || p.running || p.queued || !p.idle)
			continue

		// If the process should be running by now, go ahead and queue it
		if(world.time >= last_queued[p] + p.schedule_interval)
			setQueuedProcessState(p)

/datum/controller/process_scheduler/proc/runQueuedProcesses()
	for(var/datum/process/p in queued)
		runProcess(p)

/datum/controller/process_scheduler/proc/addProcess(datum/process/process)
	// Report that we're initialising a process.
	to_world(SPAN_DANGER("Initialising [process.name] process."))

	processes.Add(process)
	process.idle()
	idle.Add(process)

	// init recordkeeping vars
	last_start.Add(process)
	last_start[process] = 0
	last_run_time.Add(process)
	last_run_time[process] = 0
	last_twenty_run_times.Add(process)
	last_twenty_run_times[process] = list()
	highest_run_time.Add(process)
	highest_run_time[process] = 0

	// init starts and stops record starts
	recordStart(process, 0)
	recordEnd(process, 0)

	// Set up process
	process.setup()

	// Save process in the name -> process map
	nameToProcessMap[process.name] = process

	// Wait until setup is done.
	sleep(-1)

/datum/controller/process_scheduler/proc/replaceProcess(datum/process/oldProcess, datum/process/newProcess)
	processes.Remove(oldProcess)
	processes.Add(newProcess)

	newProcess.idle()
	idle.Remove(oldProcess)
	running.Remove(oldProcess)
	queued.Remove(oldProcess)
	idle.Add(newProcess)

	last_start.Remove(oldProcess)
	last_start.Add(newProcess)
	last_start[newProcess] = 0

	last_run_time.Add(newProcess)
	last_run_time[newProcess] = last_run_time[oldProcess]
	last_run_time.Remove(oldProcess)

	last_twenty_run_times.Add(newProcess)
	last_twenty_run_times[newProcess] = last_twenty_run_times[oldProcess]
	last_twenty_run_times.Remove(oldProcess)

	highest_run_time.Add(newProcess)
	highest_run_time[newProcess] = highest_run_time[oldProcess]
	highest_run_time.Remove(oldProcess)

	recordStart(newProcess, 0)
	recordEnd(newProcess, 0)

	nameToProcessMap[newProcess.name] = newProcess

/datum/controller/process_scheduler/proc/updateStartDelays()
	for(var/datum/process/p in processes)
		if(p.start_delay)
			last_queued[p] = world.time - p.start_delay

/datum/controller/process_scheduler/proc/runProcess(datum/process/process)
	spawn(0)
		process.process()

/datum/controller/process_scheduler/proc/processStarted(datum/process/process)
	setRunningProcessState(process)
	recordStart(process)

/datum/controller/process_scheduler/proc/processFinished(datum/process/process)
	setIdleProcessState(process)
	recordEnd(process)

/datum/controller/process_scheduler/proc/setIdleProcessState(datum/process/process)
	if(process in running)
		running.Remove(process)
	if(process in queued)
		queued.Remove(process)
	if(!(process in idle))
		idle.Add(process)

/datum/controller/process_scheduler/proc/setQueuedProcessState(datum/process/process)
	if(process in running)
		running.Remove(process)
	if(process in idle)
		idle.Remove(process)
	if(!(process in queued))
		queued.Add(process)

	// The other state transitions are handled internally by the process.
	process.queued()

/datum/controller/process_scheduler/proc/setRunningProcessState(datum/process/process)
	if(process in queued)
		queued.Remove(process)
	if(process in idle)
		idle.Remove(process)
	if(!(process in running))
		running.Add(process)

/datum/controller/process_scheduler/proc/recordStart(datum/process/process, time = null)
	if(isnull(time))
		time = TimeOfGame
		last_queued[process] = world.time
		last_start[process] = time
	else
		last_queued[process] = (time == 0 ? 0 : world.time)
		last_start[process] = time

/datum/controller/process_scheduler/proc/recordEnd(datum/process/process, time = null)
	if(isnull(time))
		time = TimeOfGame

	var/lastRunTime = time - last_start[process]

	if(lastRunTime < 0)
		lastRunTime = 0

	recordRunTime(process, lastRunTime)

/**
 * recordRunTime
 * Records a run time for a process
 */
/datum/controller/process_scheduler/proc/recordRunTime(datum/process/process, time)
	last_run_time[process] = time
	if(time > highest_run_time[process])
		highest_run_time[process] = time

	var/list/lastTwenty = last_twenty_run_times[process]
	if(length(lastTwenty) == 20)
		lastTwenty.Cut(1, 2)
	lastTwenty.len++
	lastTwenty[length(lastTwenty)] = time

/**
 * averageRunTime
 * returns the average run time (over the last 20) of the process
 */
/datum/controller/process_scheduler/proc/averageRunTime(datum/process/process)
	var/lastTwenty = last_twenty_run_times[process]

	var/t = 0
	var/c = 0
	for(var/time in lastTwenty)
		t += time
		c++

	if(c > 0)
		return t / c
	return c

/datum/controller/process_scheduler/proc/getProcessLastRunTime(datum/process/process)
	return last_run_time[process]

/datum/controller/process_scheduler/proc/getProcessHighestRunTime(datum/process/process)
	return highest_run_time[process]

/datum/controller/process_scheduler/proc/getStatusData()
	var/list/data = list()

	for(var/datum/process/p in processes)
		data.len++
		data[length(data)] = p.getContextData()

	return data

/datum/controller/process_scheduler/proc/getProcessCount()
	return length(processes)

/datum/controller/process_scheduler/proc/hasProcess(processName as text)
	if(nameToProcessMap[processName])
		return 1

/datum/controller/process_scheduler/proc/killProcess(processName as text)
	restartProcess(processName)

/datum/controller/process_scheduler/proc/restartProcess(processName as text)
	if(hasProcess(processName))
		var/datum/process/oldInstance = nameToProcessMap[processName]
		var/datum/process/newInstance = new oldInstance.type(src)
		newInstance._copyStateFrom(oldInstance)
		replaceProcess(oldInstance, newInstance)
		oldInstance.kill()

/datum/controller/process_scheduler/proc/enableProcess(processName as text)
	if(hasProcess(processName))
		var/datum/process/process = nameToProcessMap[processName]
		process.enable()

/datum/controller/process_scheduler/proc/disableProcess(processName as text)
	if(hasProcess(processName))
		var/datum/process/process = nameToProcessMap[processName]
		process.disable()

/datum/controller/process_scheduler/proc/getCurrentTickElapsedTime()
	if(world.time > currentTick)
		updateCurrentTickData()
		return 0
	else
		return TimeOfTick

/datum/controller/process_scheduler/proc/updateCurrentTickData()
	if(world.time > currentTick)
		// New tick!
		currentTick = world.time
		updateTimeAllowance()
		cpuAverage = (world.cpu + cpuAverage + cpuAverage) / 3

/datum/controller/process_scheduler/proc/updateTimeAllowance()
	// Time allowance goes down linearly with world.cpu.
	var/error = cpuAverage - 100
	var/timeAllowanceDelta = SIMPLE_SIGN(error) * -0.5 * world.tick_lag * max(0, 0.001 * abs(error))

	//timeAllowance = world.tick_lag * min(1, 0.5 * ((200/max(1,cpuAverage)) - 1))
	timeAllowance = min(timeAllowanceMax, max(0, timeAllowance + timeAllowanceDelta))

/datum/controller/process_scheduler/proc/statProcesses()
	if(!isRunning)
		stat("Processes:", "Scheduler not running")
		return
	stat("Processes:", "[length(processes)] (R [length(running)] / Q [length(queued)] / I [length(idle)])")
	stat(null, "[round(cpuAverage, 0.1)] CPU, [round(timeAllowance, 0.1) / 10] TA")
	for(var/datum/process/p in processes)
		p.stat_process()

/datum/controller/process_scheduler/proc/getProcess(process_name)
	return nameToProcessMap[process_name]