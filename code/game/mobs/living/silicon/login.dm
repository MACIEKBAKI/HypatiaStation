/mob/living/silicon/Login()
	if(mind && global.CTgame_ticker && global.CTgame_ticker.mode)
		global.CTgame_ticker.mode.remove_cultist(mind, 1)
		global.CTgame_ticker.mode.remove_revolutionary(mind, 1)
	..()