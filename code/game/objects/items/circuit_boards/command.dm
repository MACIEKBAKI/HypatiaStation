/*
 * Command Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/communications
	name = "circuit board (Communications)"
	build_path = /obj/machinery/computer/communications
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MAGNETS = 2)

/obj/item/circuitboard/communications/Destroy()
	. = ..()
	for(var/obj/machinery/computer/communications/commconsole in world)
		if(isturf(commconsole.loc))
			return .

	for(var/obj/item/circuitboard/communications/commboard in world)
		if((isturf(commboard.loc) || istype(commboard.loc, /obj/item/storage)) && commboard != src)
			return .

	for(var/mob/living/silicon/ai/shuttlecaller in GLOBL.player_list)
		if(!shuttlecaller.stat && shuttlecaller.client && isturf(shuttlecaller.loc))
			return .

	if(IS_GAME_MODE(/datum/game_mode/revolution) || IS_GAME_MODE(/datum/game_mode/malfunction) || GLOBL.sent_strike_team)
		return .

	global.CTemergency.call_evac()
	log_game("All the AIs, comm consoles and boards are destroyed. Shuttle called.")
	message_admins("All the AIs, comm consoles and boards are destroyed. Shuttle called.", 1)

/obj/item/circuitboard/card
	name = "circuit board (ID Computer)"
	build_path = /obj/machinery/computer/card

/obj/item/circuitboard/card/centcom
	name = "circuit board (CentCom ID Computer)"
	build_path = /obj/machinery/computer/card/centcom

/obj/item/circuitboard/teleporter
	name = "circuit board (Teleporter)"
	build_path = /obj/machinery/computer/teleporter
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BLUESPACE = 2)

/obj/item/circuitboard/skills
	name = "circuit board (Employment Records)"
	build_path = /obj/machinery/computer/skills