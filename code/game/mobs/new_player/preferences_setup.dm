//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/randomize_appearance_for(mob/living/carbon/human/H)
	if(H)
		if(H.gender == MALE)
			gender = MALE
		else
			gender = FEMALE
	s_tone = random_skin_tone()
	h_style = random_hair_style(gender, species)
	f_style = random_facial_hair_style(gender, species)
	randomize_hair_color("hair")
	randomize_hair_color("facial")
	randomize_eyes_color()
	randomize_skin_color()
	underwear = rand(1, length(GLOBL.underwear_m))
	backbag = 2
	age = rand(AGE_MIN,AGE_MAX)
	if(H)
		copy_to(H, 1)

/datum/preferences/proc/randomize_hair_color(target = "hair")
	if(prob(75) && target == "facial") // Chance to inherit hair color
		r_facial = r_hair
		g_facial = g_hair
		b_facial = b_hair
		return

	var/red
	var/green
	var/blue

	var/col = pick("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
	switch(col)
		if("blonde")
			red = 255
			green = 255
			blue = 0
		if("black")
			red = 0
			green = 0
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 51
		if("copper")
			red = 255
			green = 153
			blue = 0
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("wheat")
			red = 255
			green = 255
			blue = 153
		if("old")
			red = rand (100, 255)
			green = red
			blue = red
		if("punk")
			red = rand (0, 255)
			green = rand (0, 255)
			blue = rand (0, 255)

	red = max(min(red + rand(-25, 25), 255), 0)
	green = max(min(green + rand(-25, 25), 255), 0)
	blue = max(min(blue + rand(-25, 25), 255), 0)

	switch(target)
		if("hair")
			r_hair = red
			g_hair = green
			b_hair = blue
		if("facial")
			r_facial = red
			g_facial = green
			b_facial = blue

/datum/preferences/proc/randomize_eyes_color()
	var/red
	var/green
	var/blue

	var/col = pick("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand(-25, 25), 255), 0)
	green = max(min(green + rand(-25, 25), 255), 0)
	blue = max(min(blue + rand(-25, 25), 255), 0)

	r_eyes = red
	g_eyes = green
	b_eyes = blue

/datum/preferences/proc/randomize_skin_color()
	var/red
	var/green
	var/blue

	var/col = pick("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand(-25, 25), 255), 0)
	green = max(min(green + rand(-25, 25), 255), 0)
	blue = max(min(blue + rand(-25, 25), 255), 0)

	r_skin = red
	g_skin = green
	b_skin = blue

/datum/preferences/proc/update_preview_icon()		//seriously. This is horrendous.
	qdel(preview_icon_front)
	qdel(preview_icon_side)
	qdel(preview_icon)

	var/g = "m"
	if(gender == FEMALE)
		g = "f"

	var/icon/icobase
	var/datum/species/current_species = GLOBL.all_species[species]

	if(current_species)
		icobase = current_species.icobase
	else
		icobase = 'icons/mob/human_races/r_human.dmi'

	preview_icon = new /icon(icobase, "torso_[g]")
	preview_icon.Blend(new /icon(icobase, "groin_[g]"), ICON_OVERLAY)
	preview_icon.Blend(new /icon(icobase, "head_[g]"), ICON_OVERLAY)

	for(var/name in list("l_arm","r_arm","l_leg","r_leg","l_foot","r_foot","l_hand","r_hand"))
		// make sure the organ is added to the list so it's drawn
		if(organ_data[name] == null)
			organ_data[name] = null

	for(var/name in organ_data)
		if(organ_data[name] == "amputated")
			continue

		var/icon/temp = new /icon(icobase, "[name]")
		if(organ_data[name] == "cyborg")
			temp.MapColors(rgb(77, 77, 77), rgb(150, 150, 150), rgb(28, 28, 28), rgb(0, 0, 0))

		preview_icon.Blend(temp, ICON_OVERLAY)

	//Tail
	if(current_species && (current_species.flags & HAS_TAIL))
		var/icon/temp = new/icon("icon" = 'icons/effects/species.dmi', "icon_state" = "[current_species.tail]_s")
		preview_icon.Blend(temp, ICON_OVERLAY)

	// Skin color
	if(current_species && (current_species.flags & HAS_SKIN_COLOR))
		preview_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)

	// Skin tone
	if(current_species && (current_species.flags & HAS_SKIN_TONE))
		if(s_tone >= 0)
			preview_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
		else
			preview_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)

	var/icon/eyes_s = new/icon("icon" = 'icons/mob/on_mob/human_face.dmi', "icon_state" = current_species ? current_species.eyes : "eyes_s")
	if((current_species && (current_species.flags & HAS_EYE_COLOR)))
		eyes_s.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)

	var/datum/sprite_accessory/hair_style = GLOBL.hair_styles_list[h_style]
	if(hair_style)
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
		eyes_s.Blend(hair_s, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_hair_style = GLOBL.facial_hair_styles_list[f_style]
	if(facial_hair_style)
		var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
		facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)
		eyes_s.Blend(facial_s, ICON_OVERLAY)

	var/icon/underwear_s = null
	if(underwear > 0 && underwear < 7 && current_species.flags & HAS_UNDERWEAR)
		underwear_s = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "underwear[underwear]_[g]_s")

	var/icon/clothes_s = null
	// Plasmalins just always wear one uniform, because I am way too lazy to port the others until the /decl/outfit system gets ported.
	// I also happen to be too lazy to port the /decl/outfit system so deal with this until then. -Frenjo
	if(current_species && current_species.name == SPECIES_PLASMALIN)
		clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "plasmalin_s")
		clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "rig0-standard-plasmalin"), ICON_OVERLAY)
		clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if(backbag == 2)
			clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
		else if(backbag == 3 || backbag == 4)
			clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)

	else if(job_civilian_low & JOB_ASSISTANT)//This gives the preview icon clothes depending on which job(if any) is set to 'high'
		clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "grey_s")
		clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if(backbag == 2)
			clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
		else if(backbag == 3 || backbag == 4)
			clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)

	else if(job_civilian_high)//I hate how this looks, but there's no reason to go through this switch if it's empty
		switch(job_civilian_high)
			if(JOB_HOP)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "hop_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "ianshirt"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_BARTENDER)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "ba_suit_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "tophat"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_BOTANIST)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "hydroponics_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "ggloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "apron"), ICON_OVERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "nymph"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-hyd"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_CHEF)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "chef_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "chef"), ICON_OVERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "apronchef"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_JANITOR)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "janitor_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "bio_janitor"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_LIBRARIAN)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "red_suit_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "hairflower"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_QUARTERMASTER)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "qm_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "poncho"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_CARGOTECH)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "cargotech_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "flat_cap"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_MININGFOREMAN)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "overalls_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_MINER)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "miner_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "bearpelt"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_LAWYER)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "internalaffairs_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/items_righthand.dmi', "briefcase"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "suitjacket_blue"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_CHAPLAIN)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "chapblack_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "imperium_monk"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_CLOWN)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "clown_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "clown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/mask.dmi', "clown"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "clownpack"), ICON_OVERLAY)
			if(JOB_MIME)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "mime_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "lgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/mask.dmi', "mime"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "beret"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "suspenders"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)

	else if(job_medsci_high)
		switch(job_medsci_high)
			if(JOB_RD)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "director_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "petehat"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-tox"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_SCIENTIST)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "toxinswhite_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_tox_open"), ICON_OVERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "metroid"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-tox"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_CHEMIST)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "chemistrywhite_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labgreen"), ICON_OVERLAY)
				else
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_chem_open"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-chem"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_CMO)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "cmo_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "bio_cmo"), ICON_OVERLAY)
				else
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_cmo_open"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "medicalpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-med"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_DOCTOR)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "medical_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "surgeon"), ICON_OVERLAY)
				else
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "medicalpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-med"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_GENETICIST)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "geneticswhite_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "monkeysuit"), ICON_OVERLAY)
				else
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_gen_open"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-gen"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_VIROLOGIST)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "virologywhite_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/mask.dmi', "sterile"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_vir_open"), ICON_OVERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "plaguedoctor"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "medicalpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-vir"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_ROBOTICIST)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "robotics_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/items_righthand.dmi', "toolbox_blue"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)

	else if(job_engsec_high)
		switch(job_engsec_high)
			if(JOB_CAPTAIN)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "captain_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "captain"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/mask.dmi', "cigaron"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/eyes.dmi', "sun"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "caparmor"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-cap"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_HOS)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "hosred_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "hosberet"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "securitypack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_WARDEN)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "warden_s")
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "slippers_worn"), ICON_OVERLAY)
				else
					clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "securitypack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_DETECTIVE)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "detective_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/mask.dmi', "cigaron"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "detective"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "detective"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_OFFICER)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "secred_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "officerberet"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "securitypack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_SECPARA)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "redshirt2_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "medicalpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-med"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_CHIEF)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "chief_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/belt.dmi', "utility"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "hardhat0_white"), ICON_OVERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/items_righthand.dmi', "blueprints"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "engiepack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_ENGINEER)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "engine_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "orange"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/belt.dmi', "utility"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "hardhat0_yellow"), ICON_OVERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "hazard"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "engiepack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_ATMOSTECH)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "atmos_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/belt.dmi', "utility"), ICON_OVERLAY)
				if(prob(1))
					clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "firesuit"), ICON_OVERLAY)
				switch(backbag)
					if(2)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
					if(3)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
					if(4)
						clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)

			if(JOB_AI)//Gives AI and borgs assistant-wear, so they can still customize their character
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "grey_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "straight_jacket"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "cardborg_h"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
				else if(backbag == 3 || backbag == 4)
					clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(JOB_CYBORG)
				clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "grey_s")
				clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "cardborg"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/on_mob/head.dmi', "cardborg_h"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "backpack"), ICON_OVERLAY)
				else if(backbag == 3 || backbag == 4)
					clothes_s.Blend(new /icon('icons/mob/on_mob/back.dmi', "satchel"), ICON_OVERLAY)

	if(disabilities & NEARSIGHTED)
		preview_icon.Blend(new /icon('icons/mob/on_mob/eyes.dmi', "glasses"), ICON_OVERLAY)

	preview_icon.Blend(eyes_s, ICON_OVERLAY)
	if(underwear_s)
		preview_icon.Blend(underwear_s, ICON_OVERLAY)
	if(clothes_s)
		preview_icon.Blend(clothes_s, ICON_OVERLAY)
	preview_icon_front = new(preview_icon, dir = SOUTH)
	preview_icon_side = new(preview_icon, dir = WEST)

	qdel(eyes_s)
	qdel(underwear_s)
	qdel(clothes_s)