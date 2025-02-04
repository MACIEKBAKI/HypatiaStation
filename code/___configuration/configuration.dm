/*
 * Configuration
 *
 * The configuration object sets and globally stores configurable values after loading them from their associated files.
 *
 * Most of this is set up in /configuration/New().
 *
 * In a gentle way, you can shake the world. ~ Mahatma Gandhi
*/
/var/global/configuration/config // Set in /datum/global_init/New()

// These are deprecated but still used in certain places.
#define CONFIG_GET_OLD(VAR) global.config.VAR
#define CONFIG_SET_OLD(VAR, VALUE) global.config.VAR = VALUE

// These are for the new system and are the ones that should be used.
#define CONFIG_GET(VAR) global.config.get_value(#VAR)
#define CONFIG_SET(VAR, VALUE) global.config.set_value(#VAR, VALUE)

/configuration
	var/static/list/categories_by_file_name = list(
		"gamemode_probabilities.txt" = list(
			CATEGORY_GAMEMODE_PROBABILITIES
		),
		"config.txt" = list(
			CATEGORY_INFORMATION,
			CATEGORY_TICK,
			CATEGORY_URLS,
			CATEGORY_PYTHON,
			CATEGORY_IRC,
			CATEGORY_LOGGING,
			CATEGORY_CHAT,
			CATEGORY_ADMIN,
			CATEGORY_GAMEMODE,
			CATEGORY_VOTING,
			CATEGORY_WHITELISTS,
			CATEGORY_ALERTS,
			CATEGORY_MOBS,
			CATEGORY_MISCELLANEOUS_0
		),
		"game_options.txt" = list(
			CATEGORY_HEALTH,
			CATEGORY_BREAKAGE,
			CATEGORY_ORGANS,
			CATEGORY_REVIVAL,
			CATEGORY_MOVEMENT_UNIVERSAL,
			CATEGORY_MOVEMENT_SPECIFIC,
			CATEGORY_MISCELLANEOUS_1
		),
		"dbconfig.txt" = list(
			CATEGORY_DATABASE,
			CATEGORY_FEEDBACK_DATABASE
		),
		"forumdbconfig.txt" = list(
			CATEGORY_FORUM_DATABASE
		)
	)

	var/static/list/entries_by_name = list()
	var/static/list/entries_by_category = list()

	// Gamemode.
	var/static/list/mode_names = list()
	var/static/list/modes = list()			// Allowed modes.
	var/static/list/votable_modes = list()	// Votable modes.
	var/static/list/probabilities = list()	// Relative probability of each mode

	// Miscellaneous.
	//var/static/enable_authentication, FALSE)	// goon authentication

/configuration/New()
	init_entries()

	// Generates the default example configuration files.
	generate_default("gamemode_probabilities.txt")
	generate_default("config.txt")
	generate_default("game_options.txt")
	generate_default("dbconfig.txt")
	generate_default("forumdbconfig.txt")

	load_gamemodes()
	load("config.txt")
	load("game_options.txt")
	load("dbconfig.txt")
	load("forumdbconfig.txt")

/configuration/proc/init_entries()
	for(var/path in SUBTYPESOF(/datum/configuration_entry))
		var/datum/configuration_entry/entry = new path()
		entries_by_name[entry.name] = entry
		if(isnull(entries_by_category[entry.category]))
			entries_by_category[entry.category] = list()
		entries_by_category[entry.category] += entry

/configuration/proc/generate_default(file_name)
	if(isnull(categories_by_file_name[file_name]))
		return
	fdel("config/example/[file_name]")

	var/list/lines = list()
	for(var/category in categories_by_file_name[file_name])
		lines.Add("### [uppertext(category)] ###\n\n")
		for(var/datum/configuration_entry/entry in entries_by_category[category])
			if(isnotnull(entry.description))
				for(var/desc_line in entry.description)
					lines.Add("## [desc_line]\n")
			else
				lines.Add("##\n")
			if(isnotnull(entry.value) && entry.value != "")
				lines.Add("[uppertext(entry.name)] [entry.value]\n\n")
			else
				lines.Add("[uppertext(entry.name)]\n\n")

	text2file(jointext(lines, ""), "config/example/[file_name]")

// This does what the old /proc/load(filename, type) used to do, except it returns the result as a list...
// So it can be used in other functions for the different config files. -Frenjo
/configuration/proc/read(file_name)
	file_name = "config/[file_name]"

	var/list/result = list()
	var/list/lines = file2list(file_name)
	for(var/t in lines)
		if(isnull(t))
			continue
		t = trim(t)
		if(length(t) == 0 || copytext(t, 1, 2) == "#")
			continue
		var/pos = findtext(t, " ")
		var/name = (pos ? lowertext(copytext(t, 1, pos)) : lowertext(t))
		if(isnull(name))
			continue
		var/value = (pos ? copytext(t, pos + 1) : null)
		result[name] = value
	return result

// This loads configuration entries using the new system from a provided file.
/configuration/proc/load(file_name)
	var/list/config_file = read(file_name)
	for(var/option in config_file)
		var/value = config_file[option]
		if(isnull(value))
			continue
		for(var/category in categories_by_file_name[file_name])
			for(var/datum/configuration_entry/entry in entries_by_category[category])
				if(option != entry.name)
					continue
				switch(entry.value_type)
					if(TYPE_NONE)
						;
					if(TYPE_BOOLEAN, TYPE_NUMERIC)
						entry.value = text2num(value)
					if(TYPE_STRING)
						entry.value = value
					if(TYPE_LIST)
						entry.value = splittext(value, " ")

/configuration/proc/load_gamemodes()
	for(var/T in SUBTYPESOF(/datum/game_mode))
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()

		if(isnotnull(M.config_tag))
			if(!(M.config_tag in modes))	// ensure each mode is added only once
				log_misc("Adding game mode [M.name] ([M.config_tag]) to configuration.")
				modes.Add(M.config_tag)
				mode_names[M.config_tag] = M.name
				probabilities[M.config_tag] = M.probability
				if(M.votable)
					votable_modes.Add(M.config_tag)
		qdel(M)
	votable_modes.Add("secret")

	// Loads the gamemode probabilities from their configuration file.
	load("gamemode_probabilities.txt")
	// This is ugly but necessary to make the rest of the configuration stuff work currently.
	probabilities["extended"] = CONFIG_GET(probability_extended)
	probabilities["malfunction"] = CONFIG_GET(probability_malfunction)
	probabilities["nuclear"] = CONFIG_GET(probability_nuclear)
	probabilities["wizard"] = CONFIG_GET(probability_wizard)
	probabilities["changeling"] = CONFIG_GET(probability_changeling)
	probabilities["cult"] = CONFIG_GET(probability_cult)
	probabilities["extend-a-traitormongous"] = CONFIG_GET(probability_autotraitor)

/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for(var/T in SUBTYPESOF(/datum/game_mode))
		var/datum/game_mode/M = new T()
		if(M.config_tag && M.config_tag == mode_name)
			return M
		qdel(M)
	return new /datum/game_mode/extended()

/configuration/proc/get_runnable_modes()
	var/list/datum/game_mode/runnable_modes = list()
	for(var/T in SUBTYPESOF(/datum/game_mode))
		var/datum/game_mode/M = new T()
		//to_world("DEBUG: [T], tag=[M.config_tag], prob=[probabilities[M.config_tag]]")
		if(!(M.config_tag in modes))
			qdel(M)
			continue
		if(probabilities[M.config_tag] <= 0)
			qdel(M)
			continue
		if(M.can_start())
			runnable_modes[M] = probabilities[M.config_tag]
			//to_world("DEBUG: runnable_mode\[[length(runnable_modes)]\] = [M.config_tag]")
	return runnable_modes

/configuration/proc/post_load()
	//apply a default value to python_path, if needed
	if(isnull(CONFIG_GET(python_path)))
		if(world.system_type == UNIX)
			CONFIG_SET(python_path, "/usr/bin/env python2")
		else //probably windows, if not this should work anyway
			CONFIG_SET(python_path, "python")

// Retrieves and returns a configuration value from its corresponding entry datum.
/configuration/proc/get_value(name)
	if(isnull(entries_by_name[name]))
		return null

	var/datum/configuration_entry/entry = entries_by_name[name]
	return entry.value

// Retrieves and sets the configuration value of the corresponding entry datum.
/configuration/proc/set_value(name, value)
	if(isnull(entries_by_name[name]))
		return

	var/datum/configuration_entry/entry = entries_by_name[name]
	entry.value = value