/*
 * Transfer Process
 */
PROCESS_DEF(transfer)
	name = "Transfer"
	schedule_interval = 2 SECONDS

/datum/process/transfer/doWork()
	global.transfer_controller.process()