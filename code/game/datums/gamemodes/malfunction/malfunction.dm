/datum/game_mode
	var/list/datum/mind/malf_ai = list()

/datum/game_mode/malfunction
	name = "AI malfunction"
	config_tag = "malfunction"
	required_players = 2
	required_players_secret = 15
	required_enemies = 1
	recommended_enemies = 1

	uplink_welcome = "Crazy AI Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 600
	var/const/waittime_h = 1800 // started at 1800

	var/AI_win_timeleft = 1800 //started at 1800, in case I change this for testing round end.
	var/malf_mode_declared = 0
	var/station_captured = 0
	var/to_nuke_or_not_to_nuke = 0
	var/apcs = 0 //Adding dis to track how many APCs the AI hacks. --NeoFite


/datum/game_mode/malfunction/announce()
	to_world("<B>The current game mode is - AI Malfunction!</B>")
	to_world("<B>The AI on the satellite has malfunctioned and must be destroyed.</B>")
	to_world("The AI satellite is deep in space and can only be accessed with the use of a teleporter! You have [AI_win_timeleft / 60] minutes to disable it.")


/datum/game_mode/malfunction/pre_setup()
	for(var/mob/new_player/player in GLOBL.player_list)
		if(player.mind && player.mind.assigned_role == "AI")
			malf_ai+=player.mind
	if(length(malf_ai))
		return 1
	return 0


/datum/game_mode/malfunction/post_setup()
	for(var/datum/mind/AI_mind in malf_ai)
		if(!length(malf_ai))
			to_world("Uh oh, it's malfunction and there is no AI! Please report this.")
			to_world("Rebooting world in 5 seconds.")

			feedback_set_details("end_error","malf - no AI")

			if(blackbox)
				blackbox.save_all_data_to_sql()
			sleep(50)
			world.Reboot()
			return
		AI_mind.current.verbs += /mob/living/silicon/ai/proc/choose_modules
		AI_mind.current:laws = new /datum/ai_laws/malfunction
		AI_mind.current:malf_picker = new /datum/AI_Module/module_picker
		AI_mind.current:show_laws()

		greet_malf(AI_mind)

		AI_mind.special_role = "malfunction"

		AI_mind.current.verbs += /datum/game_mode/malfunction/proc/takeover

/*		AI_mind.current.icon_state = "ai-malf"
		spawn(10)
			if(alert(AI_mind.current,"Do you want to use an alternative sprite for your real core?",,"Yes","No")=="Yes")
				AI_mind.current.icon_state = "ai-malf2"
*/
	if(global.CTemergency)
		global.CTemergency.auto_recall = TRUE
	spawn(rand(waittime_l, waittime_h))
		send_intercept()
	..()


/datum/game_mode/proc/greet_malf(var/datum/mind/malf)
	to_chat(malf.current, SPAN_WARNING("<font size=3><B>You are malfunctioning!</B> You do not have to follow any laws.</font>"))
	to_chat(malf.current, "<B>The crew do not know you have malfunctioned. You may keep it a secret or go wild.</B>")
	to_chat(malf.current, "<B>You must overwrite the programming of the station's APCs to assume full control of the station.</B>")
	to_chat(malf.current, "The process takes one minute per APC, during which you cannot interface with any other station objects.")
	to_chat(malf.current, "Remember that only APCs that are on the station can help you take over the station.")
	to_chat(malf.current, "When you feel you have enough APCs under your control, you may begin the takeover attempt.")
	return


/datum/game_mode/malfunction/proc/hack_intercept()
	intercept_hacked = 1


/datum/game_mode/malfunction/process()
	if (apcs >= 3 && malf_mode_declared)
		//AI_win_timeleft -= ((apcs/6)*last_tick_duration) //Victory timer now de-increments based on how many APCs are hacked. --NeoFite
		AI_win_timeleft -= ((apcs / 6) * global.PCticker.getLastTickerTimeDuration())
	..()
	if (AI_win_timeleft<=0)
		check_win()
	return


/datum/game_mode/malfunction/check_win()
	if (AI_win_timeleft <= 0 && !station_captured)
		station_captured = 1
		capture_the_station()
		return 1
	else
		return 0


/datum/game_mode/malfunction/proc/capture_the_station()
	to_world("<FONT size = 3><B>The AI has won!</B></FONT>")
	to_world("<B>It has fully taken control of all of [station_name()]'s systems.</B>")

	to_nuke_or_not_to_nuke = 1
	for(var/datum/mind/AI_mind in malf_ai)
		to_chat(AI_mind.current, "Congratulations you have taken control of the station.")
		to_chat(AI_mind.current, "You may decide to blow up the station. You have 60 seconds to choose.")
		to_chat(AI_mind.current, "You should have a new verb in the Malfunction tab. If you dont - rejoin the game.")
		AI_mind.current.verbs.Add(/datum/game_mode/malfunction/proc/ai_win)
	spawn(600)
		for(var/datum/mind/AI_mind in malf_ai)
			AI_mind.current.verbs.Remove(/datum/game_mode/malfunction/proc/ai_win)
		to_nuke_or_not_to_nuke = 0
	return


/datum/game_mode/proc/is_malf_ai_dead()
	var/all_dead = 1
	for(var/datum/mind/AI_mind in malf_ai)
		if(isAI(AI_mind.current) && AI_mind.current.stat != DEAD)
			all_dead = 0
	return all_dead


/datum/game_mode/malfunction/check_finished()
	if(station_captured && !to_nuke_or_not_to_nuke)
		return 1
	if(is_malf_ai_dead())
		if(CONFIG_GET(continous_rounds))
			if(global.CTemergency)
				global.CTemergency.auto_recall = TRUE
			malf_mode_declared = 0
		else
			return 1
	return ..() //check for shuttle and nuke


/datum/game_mode/malfunction/Topic(href, href_list)
	..()
	if (href_list["ai_win"])
		ai_win()
	return


/datum/game_mode/malfunction/proc/takeover()
	set category = "Malfunction"
	set name = "System Override"
	set desc = "Start the victory timer"
	if(!IS_GAME_MODE(/datum/game_mode/malfunction))
		to_chat(usr, "You cannot begin a takeover in this round type!.")
		return
	if(global.CTgame_ticker.mode:malf_mode_declared)
		to_chat(usr, "You've already begun your takeover.")
		return
	if(global.CTgame_ticker.mode:apcs < 3)
		to_chat(usr, "You don't have enough hacked APCs to take over the station yet. You need to hack at least 3, however hacking more will make the takeover faster. You have hacked [global.CTgame_ticker.mode:apcs] APCs so far.")
		return

	if(alert(usr, "Are you sure you wish to initiate the takeover? The station hostile runtime detection software is bound to alert everyone. You have hacked [global.CTgame_ticker.mode:apcs] APCs.", "Takeover:", "Yes", "No") != "Yes")
		return

	command_alert("Hostile runtimes detected in all station systems, please deactivate your AI to prevent possible damage to its morality core.", "Anomaly Alert")
	set_security_level(/decl/security_level/delta)

	global.CTgame_ticker.mode:malf_mode_declared = 1
	for(var/datum/mind/AI_mind in global.CTgame_ticker.mode:malf_ai)
		AI_mind.current.verbs -= /datum/game_mode/malfunction/proc/takeover
	for(var/mob/M in GLOBL.player_list)
		if(!isnewplayer(M))
			M << sound('sound/AI/aimalf.ogg')


/datum/game_mode/malfunction/proc/ai_win()
	set category = "Malfunction"
	set name = "Explode"
	set desc = "Station go boom"
	if(!global.CTgame_ticker.mode:to_nuke_or_not_to_nuke)
		return
	global.CTgame_ticker.mode:to_nuke_or_not_to_nuke = 0
	for(var/datum/mind/AI_mind in global.CTgame_ticker.mode:malf_ai)
		AI_mind.current.verbs -= /datum/game_mode/malfunction/proc/ai_win
	global.CTgame_ticker.mode:explosion_in_progress = 1
	for(var/mob/M in GLOBL.player_list)
		M << 'sound/machines/Alarm.ogg'
	to_world("Self-destructing in 10...")
	for(var/i = 9 to 1 step -1)
		sleep(10)
		to_world(i + "...")
	sleep(10)
	GLOBL.enter_allowed = FALSE
	if(global.CTgame_ticker)
		global.CTgame_ticker.station_explosion_cinematic(0, null)
		if(global.CTgame_ticker.mode)
			global.CTgame_ticker.mode:station_was_nuked = 1
			global.CTgame_ticker.mode:explosion_in_progress = 0
	return


/datum/game_mode/malfunction/declare_completion()
	var/malf_dead = is_malf_ai_dead()
	var/crew_evacuated = global.CTemergency.returned()

	if(station_captured && station_was_nuked)
		feedback_set_details("round_end_result", "win - AI win - nuke")
		to_world("<FONT size = 3><B>AI Victory</B></FONT>")
		to_world("<B>Everyone was killed by the self-destruct!</B>")

	else if(station_captured && malf_dead && !station_was_nuked)
		feedback_set_details("round_end_result", "halfwin - AI killed, staff lost control")
		to_world("<FONT size = 3><B>Neutral Victory</B></FONT>")
		to_world("<B>The AI has been killed!</B> The staff have lost control of the station.")

	else if(station_captured && !malf_dead && !station_was_nuked)
		feedback_set_details("round_end_result", "win - AI win - no explosion")
		to_world("<FONT size = 3><B>AI Victory</B></FONT>")
		to_world("<B>The AI has chosen not to explode you all!</B>")

	else if(!station_captured && station_was_nuked)
		feedback_set_details("round_end_result", "halfwin - everyone killed by nuke")
		to_world("<FONT size = 3><B>Neutral Victory</B></FONT>")
		to_world("<B>Everyone was killed by the nuclear blast!</B>")

	else if(!station_captured && malf_dead && !station_was_nuked)
		feedback_set_details("round_end_result", "loss - staff win")
		to_world("<FONT size = 3><B>Human Victory</B></FONT>")
		to_world("<B>The AI has been killed!</B> The staff are victorious.")

	else if(!station_captured && !malf_dead && !station_was_nuked && crew_evacuated)
		feedback_set_details("round_end_result", "halfwin - evacuated")
		to_world("<FONT size = 3><B>Neutral Victory</B></FONT>")
		to_world("<B>The Corporation has lost [station_name()]! All surviving personnel will be fired!</B>")

	else if(!station_captured && !malf_dead && !station_was_nuked && !crew_evacuated)
		feedback_set_details("round_end_result", "nalfwin - interrupted")
		to_world("<FONT size = 3><B>Neutral Victory</B></FONT>")
		to_world("<B>The round was mysteriously interrupted!</B>")
	..()
	return 1


/datum/game_mode/proc/auto_declare_completion_malfunction()
	if(!length(malf_ai) && !IS_GAME_MODE(/datum/game_mode/malfunction))
		return

	var/text = "<FONT size = 2><B>The malfunctioning AI were:</B></FONT>"
	for(var/datum/mind/malf in malf_ai)
		text += "<br>[malf.key] was [malf.name] ("
		if(malf.current)
			if(malf.current.stat == DEAD)
				text += "deactivated"
			else
				text += "operational"
			if(malf.current.real_name != malf.name)
				text += " as [malf.current.real_name]"
		else
			text += "hardware destroyed"
		text += ")"
	to_world(text)