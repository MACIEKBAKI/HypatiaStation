/obj/item/gun/energy/taser
	name = "taser gun"
	desc = "A small, low capacity gun used for non-lethal takedowns."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 100
	has_firemodes = 0
	gun_setting = GUN_SETTING_STUN
	pulse_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode
	)
	cell_type = /obj/item/cell/crap

/obj/item/gun/energy/taser/cyborg
	charge_cost = 100
	cell_type = /obj/item/cell/secborg

	var/charge_tick = 0
	var/recharge_time = 10 //Time it takes for shots to recharge (in ticks)

/obj/item/gun/energy/taser/cyborg/New()
	. = ..()
	GLOBL.processing_objects.Add(src)

/obj/item/gun/energy/taser/cyborg/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/gun/energy/taser/cyborg/process() //Every [recharge_time] ticks, recharge a shot for the cyborg
	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(!power_supply)
		return 0 //sanity
	if(power_supply.charge >= power_supply.maxcharge)
		return 0 // check if we actually need to recharge

	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			R.cell.use(charge_cost) 		//Take power from the borg...
			power_supply.give(charge_cost)	//... to recharge the shot

	update_icon()
	return 1

/obj/item/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "A high-tech revolver that fires stun cartridges. The stun cartridges can be recharged using a conventional energy weapon recharger."
	icon_state = "stunrevolver"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	origin_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_POWERSTORAGE = 2)
	charge_cost = 125
	has_firemodes = 0
	gun_setting = GUN_SETTING_STUN
	pulse_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode
	)
	cell_type = /obj/item/cell

/obj/item/gun/energy/disabler
	name = "disabler"
	desc = "A non-lethal self-defense weapon that exhausts organic targets, weakening them until they collapse."
	icon_state = "disabler"
	fire_sound = 'sound/weapons/taser2.ogg'
	origin_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_POWERSTORAGE = 1)
	charge_cost = 100
	gun_setting = GUN_SETTING_DISABLE
	pulse_projectile_types = list(
		GUN_SETTING_DISABLE = /obj/item/projectile/energy/pulse/disabler
	)
	beam_projectile_types = list(
		GUN_SETTING_DISABLE = /obj/item/projectile/energy/beam/disabler
	)
	cell_type = /obj/item/cell

/obj/item/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many of the syndicates stealth specialists."
	icon_state = "crossbow"
	item_state = "crossbow"
	w_class = 2.0
	origin_tech = list(RESEARCH_TECH_COMBAT = 2, RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_SYNDICATE = 5)
	silenced = 1
	fire_sound = 'sound/weapons/Genhit.ogg'
	has_firemodes = 0
	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(
		GUN_SETTING_SPECIAL = /obj/item/projectile/energy/bolt
	)
	cell_type = /obj/item/cell/crap

	var/charge_tick = 0

/obj/item/gun/energy/crossbow/New()
	. = ..()
	GLOBL.processing_objects.Add(src)

/obj/item/gun/energy/crossbow/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/gun/energy/crossbow/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(!power_supply)
		return 0
	power_supply.give(100)
	return 1

/obj/item/gun/energy/crossbow/update_icon()
	return

/obj/item/gun/energy/crossbow/largecrossbow
	name = "Energy Crossbow"
	desc = "A weapon favored by syndicate infiltration teams."
	w_class = 4.0
	force = 10
	matter_amounts = list(MATERIAL_METAL = 200000)
	pulse_projectile_types = list(
		GUN_SETTING_SPECIAL = /obj/item/projectile/energy/bolt/large
	)