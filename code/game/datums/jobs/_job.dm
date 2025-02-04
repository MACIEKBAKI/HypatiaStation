/datum/job
	// The name of the job.
	var/title = "NOPE"
	// Bitflags for the job.
	var/flag = 0
	var/department_flag = 0
	// Players will be allowed to spawn in as jobs that are set to "Station".
	var/faction = "None"

	// How many players can be this job.
	var/total_positions = 0
	// How many players can spawn in as this job.
	var/spawn_positions = 0
	// How many players have this job.
	var/current_positions = 0

	// Supervisors, who this person answers to directly.
	var/supervisors = null
	// Selection screen color.
	var/selection_color = "#ffffff"

	// If this is set to TRUE, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify = FALSE
	// If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	// Job access. The use of minimal_access or access is determined by a config setting: CONFIG_GET(jobs_have_minimal_access).
	var/list/access = list()			// Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/list/minimal_access = list()	// Useful for servers which prefer to only have access given to the places a job absolutely needs (IE larger server population.)

	// A typepath to the outfit that mobs with this job will spawn with, if any.
	var/outfit
	// List of alternate titles with alternate outfits as associative values, if any.
	var/list/alt_titles

	// The specific survival kit provided to characters with this job, if there is one.
	// Currently only used for engineering jobs.
	var/special_survival_kit = null

/datum/job/proc/equip(mob/living/carbon/human/H, alt_title)
	SHOULD_CALL_PARENT(TRUE)

	var/outfit_type = outfit
	if(isnotnull(alt_title) && alt_title != title)
		outfit_type = alt_titles[alt_title]

	return H.equip_outfit(outfit_type)

/datum/job/proc/get_access()
	if(CONFIG_GET(jobs_have_minimal_access))
		return minimal_access.Copy()
	else
		return access.Copy()

// If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1.
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return 1	// Available in 0 days = available right now = player is old enough to play.
	return 0

/datum/job/proc/available_in_days(client/C)
	if(isnull(C))
		return 0
	if(!CONFIG_GET(use_age_restriction_for_jobs))
		return 0
	if(!isnum(C.player_age))
		return 0 // This is only a number if the db connection is established, otherwise it is text: "Requires database", meaning these restrictions cannot be enforced.
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)