//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a $ to denote that they aren't reagents.
The currently supporting non-reagent materials:
- $metal (/obj/item/stack/metal). One sheet = 3750 units.
- $glass (/obj/item/stack/glass). One sheet = 3750 units.
- $plasma (/obj/item/stack/plasma). One sheet = 3750 units.
- $silver (/obj/item/stack/silver). One sheet = 3750 units.
- $gold (/obj/item/stack/gold). One sheet = 3750 units.
- $uranium (/obj/item/stack/uranium). One sheet = 3750 units.
- $diamond (/obj/item/stack/diamond). One sheet = 3750 units.
- $clown (/obj/item/stack/clown). One sheet = 3750 units. ("Bananium")
(Insert new ones here)

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- The reliability formula for all R&D built items is reliability_base (a fixed number) + total tech levels required to make it +
reliability_mod (starts at 0, gets improved through experimentation). Example: PACMAN generator. 79 base reliablity + 6 tech
(3 plasmatech, 3 powerstorage) + 0 (since it's completely new) = 85% reliability. Reliability is the chance it works CORRECTLY.
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 3750 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).
- Add the AUTOLATHE tag to


*/
#define	IMPRINTER	1	//For circuits. Uses glass/chemicals.
#define PROTOLATHE	2	//New stuff. Uses glass/metal/chemicals
#define	AUTOLATHE	4	//Uses glass/metal only.
#define CRAFTLATHE	8	//Uses fuck if I know. For use eventually.
#define MECHFAB		16 //Remember, objects utilising this flag should have construction_time and construction_cost vars.
//Note: More then one of these can be added to a design but imprinter and lathe designs are incompatable.

/datum/design						//Datum for object designs, used in construction
	var/name = "Name"					//Name of the created object.
	var/desc = "Desc"					//Description of the created object.
	var/id = "id"						//ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols
	var/list/req_tech = list()			//IDs of that techs the object originated from and the minimum level requirements.
	var/reliability_mod = 0				//Reliability modifier of the device at it's starting point.
	var/reliability_base = 100			//Base reliability of a device before modifiers.
	var/reliability = 100				//Reliability of the device.
	var/build_type = null				//Flag as to what kind machine the design is built in. See defines.
	var/list/materials = list()			//List of materials. Format: "id" = amount.
	var/build_path = null					//The path of the object that gets created
	var/locked = 0						//If true it will spawn inside a lockbox with currently sec access
	var/category = null //Primarily used for Mech Fabricators, but can be used for anything

//A proc to calculate the reliability of a design based on tech levels and innate modifiers.
//Input: A list of /datum/tech; Output: The new reliabilty.
/datum/design/proc/CalcReliability(list/temp_techs)
	var/new_reliability = reliability_mod + reliability_base
	for(var/datum/tech/T in temp_techs)
		if(T.id in req_tech)
			new_reliability += T.level
	new_reliability = between(reliability_base, new_reliability, 100)
	reliability = new_reliability
	return

///////////////////Computer Boards///////////////////////////////////
/datum/design/seccamera
	name = "Circuit Design (Security)"
	desc = "Allows for the construction of circuit boards used to build security camera computers."
	id = "seccamera"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/security

/datum/design/aicore
	name = "Circuit Design (AI Core)"
	desc = "Allows for the construction of circuit boards used to build new AI cores."
	id = "aicore"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_BIOTECH = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/aicore

/datum/design/aiupload
	name = "Circuit Design (AI Upload)"
	desc = "Allows for the construction of circuit boards used to build an AI Upload Console."
	id = "aiupload"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/aiupload

/datum/design/borgupload
	name = "Circuit Design (Cyborg Upload)"
	desc = "Allows for the construction of circuit boards used to build a Cyborg Upload Console."
	id = "borgupload"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/borgupload

/datum/design/med_data
	name = "Circuit Design (Medical Records)"
	desc = "Allows for the construction of circuit boards used to build a medical records console."
	id = "med_data"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/med_data

/datum/design/operating
	name = "Circuit Design (Operating Computer)"
	desc = "Allows for the construction of circuit boards used to build an operating computer console."
	id = "operating"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/operating

/datum/design/pandemic
	name = "Circuit Design (PanD.E.M.I.C. 2200)"
	desc = "Allows for the construction of circuit boards used to build a PanD.E.M.I.C. 2200 console."
	id = "pandemic"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pandemic

/datum/design/scan_console
	name = "Circuit Design (DNA Machine)"
	desc = "Allows for the construction of circuit boards used to build a new DNA scanning console."
	id = "scan_console"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/scan_consolenew

/datum/design/comconsole
	name = "Circuit Design (Communications)"
	desc = "Allows for the construction of circuit boards used to build a communications console."
	id = "comconsole"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MAGNETS = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/communications

/datum/design/idcardconsole
	name = "Circuit Design (ID Computer)"
	desc = "Allows for the construction of circuit boards used to build an ID computer."
	id = "idcardconsole"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/card

/datum/design/crewconsole
	name = "Circuit Design (Crew monitoring computer)"
	desc = "Allows for the construction of circuit boards used to build a Crew monitoring computer."
	id = "crewconsole"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_BIOTECH = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/crew

/datum/design/teleconsole
	name = "Circuit Design (Teleporter Console)"
	desc = "Allows for the construction of circuit boards used to build a teleporter control console."
	id = "teleconsole"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BLUESPACE = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/teleporter

/datum/design/secdata
	name = "Circuit Design (Security Records Console)"
	desc = "Allows for the construction of circuit boards used to build a security records console."
	id = "secdata"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/secure_data

/datum/design/atmosalerts
	name = "Circuit Design (Atmosphere Alert)"
	desc = "Allows for the construction of circuit boards used to build an atmosphere alert console.."
	id = "atmosalerts"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/atmos_alert

/datum/design/air_management
	name = "Circuit Design (Atmospheric Monitor)"
	desc = "Allows for the construction of circuit boards used to build an Atmospheric Monitor."
	id = "air_management"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/air_management

/* Uncomment if someone makes these buildable
/datum/design/general_alert
	name = "Circuit Design (General Alert Console)"
	desc = "Allows for the construction of circuit boards used to build a General Alert console."
	id = "general_alert"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/general_alert
*/

/datum/design/robocontrol
	name = "Circuit Design (Robotics Control Console)"
	desc = "Allows for the construction of circuit boards used to build a Robotics Control console."
	id = "robocontrol"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/robotics

/datum/design/clonecontrol
	name = "Circuit Design (Cloning Machine Console)"
	desc = "Allows for the construction of circuit boards used to build a new Cloning Machine console."
	id = "clonecontrol"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/cloning

/datum/design/clonepod
	name = "Circuit Design (Clone Pod)"
	desc = "Allows for the construction of circuit boards used to build a Cloning Pod."
	id = "clonepod"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/clonepod

/datum/design/clonescanner
	name = "Circuit Design (Cloning Scanner)"
	desc = "Allows for the construction of circuit boards used to build a Cloning Scanner."
	id = "clonescanner"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/clonescanner

/datum/design/arcademachine
	name = "Circuit Design (Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "arcademachine"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 1)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/arcade

/datum/design/powermonitor
	name = "Circuit Design (Power Monitor)"
	desc = "Allows for the construction of circuit boards used to build a new power monitor"
	id = "powermonitor"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/powermonitor

/datum/design/solarcontrol
	name = "Circuit Design (Solar Control)"
	desc = "Allows for the construction of circuit boards used to build a solar control console"
	id = "solarcontrol"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_POWERSTORAGE = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/solar_control

/datum/design/prisonmanage
	name = "Circuit Design (Prisoner Management Console)"
	desc = "Allows for the construction of circuit boards used to build a prisoner management console."
	id = "prisonmanage"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/prisoner

/datum/design/mechacontrol
	name = "Circuit Design (Exosuit Control Console)"
	desc = "Allows for the construction of circuit boards used to build an exosuit control console."
	id = "mechacontrol"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha_control

/datum/design/mechapower
	name = "Circuit Design (Mech Bay Power Control Console)"
	desc = "Allows for the construction of circuit boards used to build a mech bay power control console."
	id = "mechapower"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mech_bay_power_console

/datum/design/rdconsole
	name = "Circuit Design (R&D Console)"
	desc = "Allows for the construction of circuit boards used to build a new R&D console."
	id = "rdconsole"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rdconsole

/datum/design/ordercomp
	name = "Circuit Design (Supply ordering console)"
	desc = "Allows for the construction of circuit boards used to build a Supply ordering console."
	id = "ordercomp"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/ordercomp

/datum/design/supplycomp
	name = "Circuit Design (Supply shuttle console)"
	desc = "Allows for the construction of circuit boards used to build a Supply shuttle console."
	id = "supplycomp"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/supplycomp

/datum/design/comm_monitor
	name = "Circuit Design (Telecommunications Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunications monitor."
	id = "comm_monitor"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/comm_monitor

/datum/design/comm_server
	name = "Circuit Design (Telecommunications Server Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunication server browser and monitor."
	id = "comm_server"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/comm_server

/datum/design/message_monitor
	name = "Circuit Design (Messaging Monitor Console)"
	desc = "Allows for the construction of circuit boards used to build a messaging monitor console."
	id = "message_monitor"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 5)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/message_monitor

/datum/design/aifixer
	name = "Circuit Design (AI Integrity Restorer)"
	desc = "Allows for the construction of circuit boards used to build an AI Integrity Restorer."
	id = "aifixer"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/aifixer

///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////
/datum/design/safeguard_module
	name = "Module Design (Safeguard)"
	desc = "Allows for the construction of a Safeguard AI Module."
	id = "safeguard_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_GOLD = 100)
	build_path = /obj/item/aiModule/safeguard

/datum/design/onehuman_module
	name = "Module Design (OneHuman)"
	desc = "Allows for the construction of a OneHuman AI Module."
	id = "onehuman_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_MATERIALS = 6)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_DIAMOND = 100)
	build_path = /obj/item/aiModule/oneHuman

/datum/design/protectstation_module
	name = "Module Design (ProtectStation)"
	desc = "Allows for the construction of a ProtectStation AI Module."
	id = "protectstation_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 6)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_GOLD = 100)
	build_path = /obj/item/aiModule/protectStation

/datum/design/notele_module
	name = "Module Design (TeleporterOffline Module)"
	desc = "Allows for the construction of a TeleporterOffline AI Module."
	id = "notele_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_GOLD = 100)
	build_path = /obj/item/aiModule/teleporterOffline

/datum/design/quarantine_module
	name = "Module Design (Quarantine)"
	desc = "Allows for the construction of a Quarantine AI Module."
	id = "quarantine_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MATERIALS = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_GOLD = 100)
	build_path = /obj/item/aiModule/quarantine

/datum/design/oxygen_module
	name = "Module Design (OxygenIsToxicToHumans)"
	desc = "Allows for the construction of a Safeguard AI Module."
	id = "oxygen_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MATERIALS = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_GOLD = 100)
	build_path = /obj/item/aiModule/oxygen

/datum/design/freeform_module
	name = "Module Design (Freeform)"
	desc = "Allows for the construction of a Freeform AI Module."
	id = "freeform_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_MATERIALS = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_GOLD = 100)
	build_path = /obj/item/aiModule/freeform

/datum/design/reset_module
	name = "Module Design (Reset)"
	desc = "Allows for the construction of a Reset AI Module."
	id = "reset_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 6)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_GOLD = 100)
	build_path = /obj/item/aiModule/reset

/datum/design/purge_module
	name = "Module Design (Purge)"
	desc = "Allows for the construction of a Purge AI Module."
	id = "purge_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_MATERIALS = 6)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_DIAMOND = 100)
	build_path = /obj/item/aiModule/purge

/datum/design/freeformcore_module
	name = "Core Module Design (Freeform)"
	desc = "Allows for the construction of a Freeform AI Core Module."
	id = "freeformcore_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_MATERIALS = 6)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_DIAMOND = 100)
	build_path = /obj/item/aiModule/freeformcore

/datum/design/asimov
	name = "Core Module Design (Asimov)"
	desc = "Allows for the construction of a Asimov AI Core Module."
	id = "asimov_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 6)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_DIAMOND = 100)
	build_path = /obj/item/aiModule/asimov

/datum/design/paladin_module
	name = "Core Module Design (P.A.L.A.D.I.N.)"
	desc = "Allows for the construction of a P.A.L.A.D.I.N. AI Core Module."
	id = "paladin_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_MATERIALS = 6)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_DIAMOND = 100)
	build_path = /obj/item/aiModule/paladin

/datum/design/tyrant_module
	name = "Core Module Design (T.Y.R.A.N.T.)"
	desc = "Allows for the construction of a T.Y.R.A.N.T. AI Module."
	id = "tyrant_module"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_SYNDICATE = 2, RESEARCH_TECH_MATERIALS = 6)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20, MATERIAL_DIAMOND = 100)
	build_path = /obj/item/aiModule/tyrant

///////////////////////////////////
/////Subspace Telecoms////////////
///////////////////////////////////
/datum/design/subspace_receiver
	name = "Circuit Design (Subspace Receiver)"
	desc = "Allows for the construction of Subspace Receiver equipment."
	id = "s-receiver"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 3, RESEARCH_TECH_BLUESPACE = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/receiver

/datum/design/telecoms_bus
	name = "Circuit Design (Bus Mainframe)"
	desc = "Allows for the construction of Telecommunications Bus Mainframes."
	id = "s-bus"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/bus

/datum/design/telecoms_hub
	name = "Circuit Design (Hub Mainframe)"
	desc = "Allows for the construction of Telecommunications Hub Mainframes."
	id = "s-hub"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/hub

/datum/design/telecoms_relay
	name = "Circuit Design (Relay Mainframe)"
	desc = "Allows for the construction of Telecommunications Relay Mainframes."
	id = "s-relay"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_BLUESPACE = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/relay

/datum/design/telecoms_processor
	name = "Circuit Design (Processor Unit)"
	desc = "Allows for the construction of Telecommunications Processor equipment."
	id = "s-processor"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/processor

/datum/design/telecoms_server
	name = "Circuit Design (Server Mainframe)"
	desc = "Allows for the construction of Telecommunications Servers."
	id = "s-server"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/server

/datum/design/subspace_broadcaster
	name = "Circuit Design (Subspace Broadcaster)"
	desc = "Allows for the construction of Subspace Broadcasting equipment."
	id = "s-broadcaster"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_BLUESPACE = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/broadcaster

///////////////////////////////////
/////Non-Board Computer Stuff//////
///////////////////////////////////
/datum/design/intellicard
	name = "Intellicard AI Transportation System"
	desc = "Allows for the construction of an intellicard."
	id = "intellicard"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_MATERIALS = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_GLASS = 1000, MATERIAL_GOLD = 200)
	build_path = /obj/item/device/aicard

/datum/design/paicard
	name = "Personal Artificial Intelligence Card"
	desc = "Allows for the construction of a pAI Card"
	id = "paicard"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_GLASS = 500, MATERIAL_METAL = 500)
	build_path = /obj/item/device/paicard

/datum/design/posibrain
	name = "Positronic Brain"
	desc = "Allows for the construction of a positronic brain"
	id = "posibrain"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 4, RESEARCH_TECH_MATERIALS = 6, RESEARCH_TECH_BLUESPACE = 2, RESEARCH_TECH_PROGRAMMING = 4)

	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 2000, MATERIAL_GLASS = 1000, MATERIAL_SILVER = 1000, MATERIAL_GOLD = 500, MATERIAL_PLASMA = 500, MATERIAL_DIAMOND = 100)
	build_path = /obj/item/device/mmi/posibrain

///////////////////////////////////
//////////Mecha Module Disks///////
///////////////////////////////////
/datum/design/ripley_main
	name = "Circuit Design (APLU \"Ripley\" Central Control module)"
	desc = "Allows for the construction of a \"Ripley\" Central Control module."
	id = "ripley_main"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/design/ripley_peri
	name = "Circuit Design (APLU \"Ripley\" Peripherals Control module)"
	desc = "Allows for the construction of a  \"Ripley\" Peripheral Control module."
	id = "ripley_peri"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/design/odysseus_main
	name = "Circuit Design (\"Odysseus\" Central Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Central Control module."
	id = "odysseus_main"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3,RESEARCH_TECH_BIOTECH = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/design/odysseus_peri
	name = "Circuit Design (\"Odysseus\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Peripheral Control module."
	id = "odysseus_peri"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3,RESEARCH_TECH_BIOTECH = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

/datum/design/gygax_main
	name = "Circuit Design (\"Gygax\" Central Control module)"
	desc = "Allows for the construction of a \"Gygax\" Central Control module."
	id = "gygax_main"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/design/gygax_peri
	name = "Circuit Design (\"Gygax\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Gygax\" Peripheral Control module."
	id = "gygax_peri"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/design/gygax_targ
	name = "Circuit Design (\"Gygax\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Gygax\" Weapons & Targeting Control module."
	id = "gygax_targ"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_COMBAT = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

/datum/design/durand_main
	name = "Circuit Design (\"Durand\" Central Control module)"
	desc = "Allows for the construction of a \"Durand\" Central Control module."
	id = "durand_main"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/design/durand_peri
	name = "Circuit Design (\"Durand\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Durand\" Peripheral Control module."
	id = "durand_peri"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/design/durand_targ
	name = "Circuit Design (\"Durand\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Durand\" Weapons & Targeting Control module."
	id = "durand_targ"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_COMBAT = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

/datum/design/honker_main
	name = "Circuit Design (\"H.O.N.K\" Central Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Central Control module."
	id = "honker_main"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/honker/main

/datum/design/honker_peri
	name = "Circuit Design (\"H.O.N.K\" Peripherals Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Peripheral Control module."
	id = "honker_peri"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/honker/peripherals

/datum/design/honker_targ
	name = "Circuit Design (\"H.O.N.K\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Weapons & Targeting Control module."
	id = "honker_targ"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/honker/targeting

////////////////////////////////////////
/////////// Mecha Equpment /////////////
////////////////////////////////////////
/datum/design/mech_scattershot
	name = "Exosuit Weapon Design (LBX AC 10 \"Scattershot\")"
	desc = "Allows for the construction of LBX AC 10."
	id = "mech_scattershot"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	category = "Exosuit Equipment"

/datum/design/mech_laser
	name = "Exosuit Weapon Design (CH-PS \"Immolator\" Laser)"
	desc = "Allows for the construction of CH-PS Laser."
	id = "mech_laser"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MAGNETS = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	category = "Exosuit Equipment"

/datum/design/mech_laser_heavy
	name = "Exosuit Weapon Design (CH-LC \"Solaris\" Laser Cannon)"
	desc = "Allows for the construction of CH-LC Laser Cannon."
	id = "mech_laser_heavy"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_MAGNETS = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	category = "Exosuit Equipment"

/datum/design/mech_grenade_launcher
	name = "Exosuit Weapon Design (SGL-6 Grenade Launcher)"
	desc = "Allows for the construction of SGL-6 Grenade Launcher."
	id = "mech_grenade_launcher"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang
	category = "Exosuit Equipment"

/datum/design/clusterbang_launcher
	name = "Exosuit Module Design (SOP-6 Clusterbang Launcher)"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute"
	id = "clusterbang_launcher"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_COMBAT = 5, RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_SYNDICATE = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited
	category = "Exosuit Equipment"

/datum/design/mech_wormhole_gen
	name = "Exosuit Module Design (Localized Wormhole Generator)"
	desc = "An exosuit module that allows generating of small quasi-stable wormholes."
	id = "mech_wormhole_gen"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_BLUESPACE = 3, RESEARCH_TECH_MAGNETS = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator
	category = "Exosuit Equipment"

/datum/design/mech_teleporter
	name = "Exosuit Module Design (Teleporter Module)"
	desc = "An exosuit module that allows exosuits to teleport to any position in view."
	id = "mech_teleporter"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_BLUESPACE = 10, RESEARCH_TECH_MAGNETS = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter
	category = "Exosuit Equipment"

/datum/design/mech_rcd
	name = "Exosuit Module Design (RCD Module)"
	desc = "An exosuit-mounted Rapid Construction Device."
	id = "mech_rcd"
	build_type = MECHFAB
	req_tech = list(
		RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_BLUESPACE = 3, RESEARCH_TECH_MAGNETS = 4,
		RESEARCH_TECH_POWERSTORAGE = 4, RESEARCH_TECH_ENGINEERING = 4
	)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd
	category = "Exosuit Equipment"

/datum/design/mech_gravcatapult
	name = "Exosuit Module Design (Gravitational Catapult Module)"
	desc = "An exosuit mounted Gravitational Catapult."
	id = "mech_gravcatapult"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_BLUESPACE = 2, RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult
	category = "Exosuit Equipment"

/datum/design/mech_repair_droid
	name = "Exosuit Module Design (Repair Droid Module)"
	desc = "Automated Repair Droid. BEEP BOOP"
	id = "mech_repair_droid"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid
	category = "Exosuit Equipment"

/datum/design/mech_plasma_generator
	name = "Exosuit Module Design (Plasma Converter Module)"
	desc = "Exosuit-mounted plasma converter."
	id = "mech_plasma_generator"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_PLASMATECH = 2, RESEARCH_TECH_POWERSTORAGE = 2, RESEARCH_TECH_ENGINEERING = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator
	category = "Exosuit Equipment"

/datum/design/mech_energy_relay
	name = "Exosuit Module Design (Tesla Energy Relay)"
	desc = "Tesla Energy Relay"
	id = "mech_energy_relay"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_POWERSTORAGE = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	category = "Exosuit Equipment"

/datum/design/mech_ccw_armor
	name = "Exosuit Module Design(Reactive Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	id = "mech_ccw_armor"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster
	category = "Exosuit Equipment"

/datum/design/mech_proj_armor
	name = "Exosuit Module Design(Reflective Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	id = "mech_proj_armor"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_COMBAT = 5, RESEARCH_TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster
	category = "Exosuit Equipment"

/datum/design/mech_syringe_gun
	name = "Exosuit Module Design(Syringe Gun)"
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	id = "mech_syringe_gun"
	build_type = MECHFAB
	req_tech = list(
		RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_BIOTECH = 4, RESEARCH_TECH_MAGNETS = 4,
		RESEARCH_TECH_PROGRAMMING = 3
	)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	category = "Exosuit Equipment"

/datum/design/mech_diamond_drill
	name = "Exosuit Module Design (Diamond Mining Drill)"
	desc = "An upgraded version of the standard drill"
	id = "mech_diamond_drill"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill
	category = "Exosuit Equipment"

/datum/design/mech_generator_nuclear
	name = "Exosuit Module Design (ExoNuclear Reactor)"
	desc = "Compact nuclear reactor module"
	id = "mech_generator_nuclear"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_ENGINEERING = 3, RESEARCH_TECH_MATERIALS = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear
	category = "Exosuit Equipment"

////////////////////////////////////////
//////////Disk Construction Disks///////
////////////////////////////////////////
/datum/design/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/disk/design_disk

/datum/design/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/disk/tech_disk

////////////////////////////////////////
/////////////Stock Parts////////////////
////////////////////////////////////////
/datum/design/basic_capacitor
	name = "Basic Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "basic_capacitor"
	req_tech = list(RESEARCH_TECH_POWERSTORAGE = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/stock_part/capacitor

/datum/design/basic_sensor
	name = "Basic Sensor Module"
	desc = "A stock part used in the construction of various devices."
	id = "basic_sensor"
	req_tech = list(RESEARCH_TECH_MAGNETS = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 20)
	build_path = /obj/item/stock_part/scanning_module

/datum/design/micro_mani
	name = "Micro Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "micro_mani"
	req_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_PROGRAMMING = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 30)
	build_path = /obj/item/stock_part/manipulator

/datum/design/basic_micro_laser
	name = "Basic Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "basic_micro_laser"
	req_tech = list(RESEARCH_TECH_MAGNETS = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 10, MATERIAL_GLASS = 20)
	build_path = /obj/item/stock_part/micro_laser

/datum/design/basic_matter_bin
	name = "Basic Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "basic_matter_bin"
	req_tech = list(RESEARCH_TECH_MATERIALS = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 80)
	build_path = /obj/item/stock_part/matter_bin

/datum/design/adv_capacitor
	name = "Advanced Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "adv_capacitor"
	req_tech = list(RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/stock_part/capacitor/adv

/datum/design/adv_sensor
	name = "Advanced Sensor Module"
	desc = "A stock part used in the construction of various devices."
	id = "adv_sensor"
	req_tech = list(RESEARCH_TECH_MAGNETS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 20)
	build_path = /obj/item/stock_part/scanning_module/adv

/datum/design/nano_mani
	name = "Nano Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "nano_mani"
	req_tech = list(RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_PROGRAMMING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30)
	build_path = /obj/item/stock_part/manipulator/nano

/datum/design/high_micro_laser
	name = "High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "high_micro_laser"
	req_tech = list(RESEARCH_TECH_MAGNETS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, MATERIAL_GLASS = 20)
	build_path = /obj/item/stock_part/micro_laser/high

/datum/design/adv_matter_bin
	name = "Advanced Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "adv_matter_bin"
	req_tech = list(RESEARCH_TECH_MATERIALS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 80)
	build_path = /obj/item/stock_part/matter_bin/adv

/datum/design/super_capacitor
	name = "Super Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "super_capacitor"
	req_tech = list(RESEARCH_TECH_POWERSTORAGE = 5, RESEARCH_TECH_MATERIALS = 4)
	build_type = PROTOLATHE
	reliability_base = 71
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50, MATERIAL_GOLD = 20)
	build_path = /obj/item/stock_part/capacitor/super

/datum/design/phasic_sensor
	name = "Phasic Sensor Module"
	desc = "A stock part used in the construction of various devices."
	id = "phasic_sensor"
	req_tech = list(RESEARCH_TECH_MAGNETS = 5, RESEARCH_TECH_MATERIALS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 20, MATERIAL_SILVER = 10)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/phasic

/datum/design/pico_mani
	name = "Pico Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "pico_mani"
	req_tech = list(RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_PROGRAMMING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/pico

/datum/design/ultra_micro_laser
	name = "Ultra-High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "ultra_micro_laser"
	req_tech = list(RESEARCH_TECH_MAGNETS = 5, RESEARCH_TECH_MATERIALS = 5)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, MATERIAL_GLASS = 20, MATERIAL_URANIUM = 10)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/ultra

/datum/design/super_matter_bin
	name = "Super Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "super_matter_bin"
	req_tech = list(RESEARCH_TECH_MATERIALS = 5)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 80)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/super

// Rating 4 -Frenjo.
/datum/design/hyper_capacitor
	name = "Hyper Capacitor"
	desc = "A stock part used in the construction of various devices."
	id = "hyper_capacitor"
	req_tech = list(RESEARCH_TECH_POWERSTORAGE = 7, RESEARCH_TECH_MATERIALS = 4)
	build_type = PROTOLATHE
	reliability_base = 71
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50, MATERIAL_GOLD = 20, MATERIAL_SILVER = 20)
	build_path = /obj/item/stock_part/capacitor/hyper

/datum/design/hyperphasic_sensor
	name = "Hyper-Phasic Sensor Module"
	desc = "A stock part used in the construction of various devices."
	id = "hyper_phasic_sensor"
	req_tech = list(RESEARCH_TECH_MAGNETS = 7, RESEARCH_TECH_MATERIALS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 20, MATERIAL_GOLD = 10, MATERIAL_SILVER = 10)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/hyperphasic

/datum/design/femto_mani
	name = "Femto Manipulator"
	desc = "A stock part used in the construction of various devices."
	id = "femto_mani"
	req_tech = list(RESEARCH_TECH_MATERIALS = 7, RESEARCH_TECH_PROGRAMMING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/femto

/datum/design/hyper_ultra_micro_laser
	name = "Hyper-Ultra-High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	id = "hyper_ultra_micro_laser"
	req_tech = list(RESEARCH_TECH_MAGNETS = 7, RESEARCH_TECH_MATERIALS = 5)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, MATERIAL_GLASS = 20, MATERIAL_URANIUM = 10, MATERIAL_PLASMA = 10)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/hyperultra

/datum/design/hyper_matter_bin
	name = "Hyper Matter Bin"
	desc = "A stock part used in the construction of various devices."
	id = "hyper_matter_bin"
	req_tech = list(RESEARCH_TECH_MATERIALS = 7)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 80)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/hyper

////////////////////////////////////////
///////////////Subspace/////////////////
////////////////////////////////////////
/datum/design/subspace_ansible
	name = "Subspace Ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	id = "s-ansible"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_BLUESPACE = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 80, MATERIAL_SILVER = 20)
	build_path = /obj/item/stock_part/subspace/ansible

/datum/design/hyperwave_filter
	name = "Hyperwave Filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	id = "s-filter"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 40, MATERIAL_SILVER = 10)
	build_path = /obj/item/stock_part/subspace/filter

/datum/design/subspace_amplifier
	name = "Subspace Amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	id = "s-amplifier"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_BLUESPACE = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, MATERIAL_GOLD = 30, MATERIAL_URANIUM = 15)
	build_path = /obj/item/stock_part/subspace/amplifier

/datum/design/subspace_treatment
	name = "Subspace Treatment Disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	id = "s-treatment"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_BLUESPACE = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, MATERIAL_SILVER = 20)
	build_path = /obj/item/stock_part/subspace/treatment

/datum/design/subspace_analyser
	name = "Subspace Analyser"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	id = "s-analyser"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_BLUESPACE = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, MATERIAL_GOLD = 15)
	build_path = /obj/item/stock_part/subspace/analyser

/datum/design/subspace_crystal
	name = "Ansible Crystal"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."
	id = "s-crystal"
	req_tech = list(RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_BLUESPACE = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_GLASS = 1000, MATERIAL_SILVER = 20, MATERIAL_GOLD = 20)
	build_path = /obj/item/stock_part/subspace/crystal

/datum/design/subspace_transmitter
	name = "Subspace Transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	id = "s-transmitter"
	req_tech = list(RESEARCH_TECH_MAGNETS = 5, RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_BLUESPACE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_GLASS = 100, MATERIAL_SILVER = 10, MATERIAL_URANIUM = 15)
	build_path = /obj/item/stock_part/subspace/transmitter

////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////
/datum/design/basic_cell
	name = "Basic Power Cell"
	desc = "A basic power cell that holds 1000 units of energy"
	id = "basic_cell"
	req_tech = list(RESEARCH_TECH_POWERSTORAGE = 1)
	build_type = PROTOLATHE | AUTOLATHE |MECHFAB
	materials = list(MATERIAL_METAL = 700, MATERIAL_GLASS = 50)
	build_path = /obj/item/cell
	category = "Misc"

/datum/design/high_cell
	name = "High-Capacity Power Cell"
	desc = "A power cell that holds 10000 units of energy"
	id = "high_cell"
	req_tech = list(RESEARCH_TECH_POWERSTORAGE = 2)
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 700, MATERIAL_GLASS = 60)
	build_path = /obj/item/cell/high
	category = "Misc"

/datum/design/super_cell
	name = "Super-Capacity Power Cell"
	desc = "A power cell that holds 20000 units of energy"
	id = "super_cell"
	req_tech = list(RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_MATERIALS = 2)
	reliability_base = 75
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 700, MATERIAL_GLASS = 70)
	build_path = /obj/item/cell/super
	category = "Misc"

/datum/design/hyper_cell
	name = "Hyper-Capacity Power Cell"
	desc = "A power cell that holds 30000 units of energy"
	id = "hyper_cell"
	req_tech = list(RESEARCH_TECH_POWERSTORAGE = 5, RESEARCH_TECH_MATERIALS = 4)
	reliability_base = 70
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 400, MATERIAL_GOLD = 150, MATERIAL_SILVER = 150, MATERIAL_GLASS = 70)
	build_path = /obj/item/cell/hyper
	category = "Misc"

/datum/design/light_replacer
	name = "Light Replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_MATERIALS = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 1500, MATERIAL_SILVER = 150, MATERIAL_GLASS = 3000)
	build_path = /obj/item/device/lightreplacer

////////////////////////////////////////
//////////////MISC Boards///////////////
////////////////////////////////////////
/datum/design/destructive_analyzer
	name = "Destructive Analyzer Board"
	desc = "The circuit board for a destructive analyzer."
	id = "destructive_analyzer"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/destructive_analyzer

/datum/design/protolathe
	name = "Protolathe Board"
	desc = "The circuit board for a protolathe."
	id = "protolathe"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/protolathe

/datum/design/circuit_imprinter
	name = "Circuit Imprinter Board"
	desc = "The circuit board for a circuit imprinter."
	id = "circuit_imprinter"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/circuit_imprinter

/datum/design/autolathe
	name = "Autolathe Board"
	desc = "The circuit board for a autolathe."
	id = "autolathe"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/autolathe

/datum/design/rdservercontrol
	name = "R&D Server Control Console Board"
	desc = "The circuit board for a R&D Server Control Console"
	id = "rdservercontrol"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rdservercontrol

/datum/design/rdserver
	name = "R&D Server Board"
	desc = "The circuit board for an R&D Server"
	id = "rdserver"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rdserver

/datum/design/mechfab
	name = "Exosuit Fabricator Board"
	desc = "The circuit board for an Exosuit Fabricator"
	id = "mechfab"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mechfab

/////////////////////////////////////////
////////////Power Stuff//////////////////
/////////////////////////////////////////
/datum/design/pacman
	name = "PACMAN-type Generator Board"
	desc = "The circuit board that for a PACMAN-type portable generator."
	id = "pacman"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_PLASMATECH = 3, RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	reliability_base = 79
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pacman

/datum/design/superpacman
	name = "SUPERPACMAN-type Generator Board"
	desc = "The circuit board that for a SUPERPACMAN-type portable generator."
	id = "superpacman"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_POWERSTORAGE = 4, RESEARCH_TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	reliability_base = 76
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pacman/super

/datum/design/mrspacman
	name = "MRSPACMAN-type Generator Board"
	desc = "The circuit board that for a MRSPACMAN-type portable generator."
	id = "mrspacman"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_POWERSTORAGE = 5, RESEARCH_TECH_ENGINEERING = 5)
	build_type = IMPRINTER
	reliability_base = 74
	materials = list(MATERIAL_GLASS = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pacman/mrs

/////////////////////////////////////////
////////////Medical Tools////////////////
/////////////////////////////////////////
/datum/design/mass_spectrometer
	name = "Mass-Spectrometer"
	desc = "A device for analyzing chemicals in the blood."
	id = "mass_spectrometer"
	req_tech = list(RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MAGNETS = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 20)
	reliability_base = 76
	build_path = /obj/item/device/mass_spectrometer

/datum/design/adv_mass_spectrometer
	name = "Advanced Mass-Spectrometer"
	desc = "A device for analyzing chemicals in the blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list(RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MAGNETS = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 20)
	reliability_base = 74
	build_path = /obj/item/device/mass_spectrometer/adv

/datum/design/reagent_scanner
	name = "Reagent Scanner"
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list(RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MAGNETS = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 20)
	reliability_base = 76
	build_path = /obj/item/device/reagent_scanner

/datum/design/adv_reagent_scanner
	name = "Advanced Reagent Scanner"
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list(RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MAGNETS = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 20)
	reliability_base = 74
	build_path = /obj/item/device/reagent_scanner/adv

/datum/design/mmi
	name = "Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	id = "mmi"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 3)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 1000, MATERIAL_GLASS = 500)
	reliability_base = 76
	build_path = /obj/item/device/mmi
	category = "Misc"

/datum/design/mmi_radio
	name = "Radio-enabled Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	id = "mmi_radio"
	req_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 1200, MATERIAL_GLASS = 500)
	reliability_base = 74
	build_path = /obj/item/device/mmi/radio_enabled
	category = "Misc"

/datum/design/synthetic_flash
	name = "Synthetic Flash"
	desc = "When a problem arises, SCIENCE is the solution."
	id = "sflash"
	req_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_COMBAT = 2)
	build_type = MECHFAB
	materials = list(MATERIAL_METAL = 750, MATERIAL_GLASS = 750)
	reliability_base = 76
	build_path = /obj/item/device/flash/synthetic
	category = "Misc"

/datum/design/nanopaste
	name = "nanopaste"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list(RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 7000, MATERIAL_GLASS = 7000)
	build_path = /obj/item/stack/nanopaste

/datum/design/implant_loyal
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	id = "implant_loyal"
	req_tech = list(RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_BIOTECH = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 7000, MATERIAL_GLASS = 7000)
	build_path = /obj/item/implant/loyalty

/datum/design/implant_chem
	name = "chemical implant"
	desc = "Injects things."
	id = "implant_chem"
	req_tech = list(RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_BIOTECH = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/implant/chem

/datum/design/implant_free
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	id = "implant_free"
	req_tech = list(RESEARCH_TECH_SYNDICATE = 2, RESEARCH_TECH_BIOTECH = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/implant/freedom

/datum/design/chameleon
	name = "Chameleon Jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	id = "chameleon"
	req_tech = list(RESEARCH_TECH_SYNDICATE = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 500)
	build_path = /obj/item/clothing/under/chameleon

/datum/design/bluespacebeaker
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list(RESEARCH_TECH_BLUESPACE = 2, RESEARCH_TECH_MATERIALS = 6)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 3000, MATERIAL_PLASMA = 3000, MATERIAL_DIAMOND = 500)
	reliability_base = 76
	build_path = /obj/item/reagent_containers/glass/beaker/bluespace

/datum/design/noreactbeaker
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(RESEARCH_TECH_MATERIALS = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 3000)
	reliability_base = 76
	build_path = /obj/item/reagent_containers/glass/beaker/noreact
	category = "Misc"

/datum/design/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	id = "scalpel_laser1"
	req_tech = list(RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_MAGNETS = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 12500, MATERIAL_GLASS = 7500)
	build_path = /obj/item/scalpel/laser1

/datum/design/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	id = "scalpel_laser2"
	req_tech = list(RESEARCH_TECH_BIOTECH = 3, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_MAGNETS = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 2500)
	build_path = /obj/item/scalpel/laser2

/datum/design/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	req_tech = list(RESEARCH_TECH_BIOTECH = 4, RESEARCH_TECH_MATERIALS = 6, RESEARCH_TECH_MAGNETS = 5)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 2000, MATERIAL_GOLD = 1500)
	build_path = /obj/item/scalpel/laser3

/datum/design/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list(RESEARCH_TECH_BIOTECH = 4, RESEARCH_TECH_MATERIALS = 7, RESEARCH_TECH_MAGNETS = 5, RESEARCH_TECH_PROGRAMMING = 4)
	build_type = PROTOLATHE
	materials = list (MATERIAL_METAL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 1500, MATERIAL_GOLD = 1500, MATERIAL_DIAMOND = 750)
	build_path = /obj/item/scalpel/manager

// Added hypospray to protolathe with some sensible-looking variables. -Frenjo
/datum/design/hypospray
	name = "Hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	id = "hypospray"
	req_tech = list(RESEARCH_TECH_BIOTECH = 4, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 7500, MATERIAL_GLASS = 4500, MATERIAL_SILVER = 1500, MATERIAL_GOLD = 1500)
	build_path = /obj/item/reagent_containers/hypospray

/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////
/datum/design/nuclear_gun
	name = "Advanced Energy Gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	id = "nuclear_gun"
	req_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 500)
	reliability_base = 76
	build_path = /obj/item/gun/energy/gun/nuclear
	locked = 1

/datum/design/stunrevolver
	name = "Stun Revolver"
	desc = "The prize of the Head of Security."
	id = "stunrevolver"
	req_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_POWERSTORAGE = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver
	locked = 1

/datum/design/lasercannon
	name = "Laser Cannon"
	desc = "A heavy duty laser cannon."
	id = "lasercannon"
	req_tech = list(RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10000, MATERIAL_GLASS = 1000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/lasercannon
	locked = 1

/datum/design/decloner
	name = "Decloner"
	desc = "Your opponent will bubble into a messy pile of goop."
	id = "decloner"
	req_tech = list(RESEARCH_TECH_COMBAT = 8, RESEARCH_TECH_MATERIALS = 7, RESEARCH_TECH_BIOTECH = 5, RESEARCH_TECH_POWERSTORAGE = 6)
	build_type = PROTOLATHE
	materials = list(MATERIAL_GOLD = 5000,MATERIAL_URANIUM = 10000, "mutagen" = 40)
	build_path = /obj/item/gun/energy/decloner
	locked = 1

/datum/design/chemsprayer
	name = "Chem Sprayer"
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_ENGINEERING = 3, RESEARCH_TECH_BIOTECH = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, MATERIAL_GLASS = 1000)
	reliability_base = 100
	build_path = /obj/item/reagent_containers/spray/chemsprayer

/datum/design/rapidsyringe
	name = "Rapid Syringe Gun"
	desc = "A gun that fires many syringes."
	id = "rapidsyringe"
	req_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_ENGINEERING = 3, RESEARCH_TECH_BIOTECH = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/gun/syringe/rapidsyringe

/*
/datum/design/largecrossbow
	name = "Energy Crossbow"
	desc = "A weapon favoured by syndicate infiltration teams."
	id = "largecrossbow"
	req_tech = list(RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_ENGINEERING = 3, RESEARCH_TECH_BIOTECH = 4, RESEARCH_TECH_SYNDICATE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 1000, MATERIAL_SILVER = 1000)
	build_path = /obj/item/gun/energy/crossbow/largecrossbow
*/

/datum/design/temp_gun
	name = "Temperature Gun"
	desc = "A gun that shoots temperature bullet energythings to change temperature."//Change it if you want
	id = "temp_gun"
	req_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_MAGNETS = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 3000)
	build_path = /obj/item/gun/energy/temperature
	locked = 1

/datum/design/flora_gun
	name = "Floral Somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells. Harmless to other organic life."
	id = "flora_gun"
	req_tech = list(RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_BIOTECH = 3, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 2000, MATERIAL_GLASS = 500, MATERIAL_URANIUM = 500)
	build_path = /obj/item/gun/energy/floragun

/datum/design/large_grenade
	name = "Large Grenade"
	desc = "A grenade that affects a larger area and use larger containers."
	id = "large_Grenade"
	req_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 3000)
	reliability_base = 79
	build_path = /obj/item/grenade/chem_grenade/large

/datum/design/smg
	name = "Submachine Gun"
	desc = "A lightweight, fast firing gun."
	id = "smg"
	req_tech = list(RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_MATERIALS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 8000, MATERIAL_SILVER = 2000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/gun/projectile/automatic
	locked = 1

/datum/design/ammo_9mm
	name = "Ammunition Box (9mm)"
	desc = "A box of prototype 9mm ammunition."
	id = "ammo_9mm"
	req_tech = list(RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_MATERIALS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 3750, MATERIAL_SILVER = 100)
	build_path = /obj/item/ammo_magazine/c9mm

/datum/design/stunshell
	name = "Stun Shell"
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell

/datum/design/plasmapistol
	name = "plasma pistol"
	desc = "A specialized firearm designed to fire lethal bolts of toxins."
	id = "ppistol"
	req_tech = list(RESEARCH_TECH_COMBAT = 5, RESEARCH_TECH_PLASMATECH = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PLASMA = 3000)
	build_path = /obj/item/gun/energy/toxgun

/////////////////////////////////////////
/////////////////Mining//////////////////
/////////////////////////////////////////
/datum/design/jackhammer
	name = "Sonic Jackhammer"
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	id = "jackhammer"
	req_tech = list(RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_POWERSTORAGE = 2, RESEARCH_TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 2000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 500)
	build_path = /obj/item/pickaxe/jackhammer

/datum/design/drill
	name = "Mining Drill"
	desc = "Yours is the drill that will pierce through the rock walls."
	id = "drill"
	req_tech = list(RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 6000, MATERIAL_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill

/datum/design/plasmacutter
	name = "Plasma Cutter"
	desc = "You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	id = "plasmacutter"
	req_tech = list(RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_PLASMATECH = 3, RESEARCH_TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 1500, MATERIAL_GLASS = 500, MATERIAL_GOLD = 500, MATERIAL_PLASMA = 500)
	reliability_base = 79
	build_path = /obj/item/pickaxe/plasmacutter

/datum/design/pick_diamond
	name = "Diamond Pickaxe"
	desc = "A pickaxe with a diamond pick head, this is just like minecraft."
	id = "pick_diamond"
	req_tech = list(RESEARCH_TECH_MATERIALS = 6)
	build_type = PROTOLATHE
	materials = list(MATERIAL_DIAMOND = 3000)
	build_path = /obj/item/pickaxe/diamond

/datum/design/drill_diamond
	name = "Diamond Mining Drill"
	desc = "Yours is the drill that will pierce the heavens!"
	id = "drill_diamond"
	req_tech = list(RESEARCH_TECH_MATERIALS = 6, RESEARCH_TECH_POWERSTORAGE = 4, RESEARCH_TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 3000, MATERIAL_GLASS = 1000, MATERIAL_DIAMOND = 3750) //Yes, a whole diamond is needed.
	reliability_base = 79
	build_path = /obj/item/pickaxe/diamonddrill

/datum/design/mesons
	name = "Optical Meson Scanners"
	desc = "Used for seeing walls, floors, and stuff through anything."
	id = "mesons"
	req_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/clothing/glasses/meson

/////////////////////////////////////////
//////////////Blue Space/////////////////
/////////////////////////////////////////
/datum/design/beacon
	name = "Tracking Beacon"
	desc = "A blue space tracking beacon."
	id = "beacon"
	req_tech = list(RESEARCH_TECH_BLUESPACE = 1)
	build_type = PROTOLATHE
	materials = list (MATERIAL_METAL = 20, MATERIAL_GLASS = 10)
	build_path = /obj/item/device/radio/beacon

/datum/design/bag_holding
	name = "Bag of Holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	id = "bag_holding"
	req_tech = list(RESEARCH_TECH_BLUESPACE = 4, RESEARCH_TECH_MATERIALS = 6)
	build_type = PROTOLATHE
	materials = list(MATERIAL_GOLD = 3000, MATERIAL_DIAMOND = 1500, MATERIAL_URANIUM = 250)
	reliability_base = 80
	build_path = /obj/item/storage/backpack/holding

/datum/design/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	desc = "A small blue crystal with mystical properties."
	id = "bluespace_crystal"
	req_tech = list(RESEARCH_TECH_BLUESPACE = 5, RESEARCH_TECH_MATERIALS = 7)
	build_type = PROTOLATHE
	materials = list(MATERIAL_GOLD = 1500, MATERIAL_DIAMOND = 3000, MATERIAL_PLASMA = 1500)
	reliability_base = 100
	build_path = /obj/item/bluespace_crystal/artificial

/datum/design/miningsatchel_holding
	name = "Mining Satchel of Holding"
	desc = "A mining satchel that can hold an infinite amount of ores."
	id = "minerbag_holding"
	req_tech = list(RESEARCH_TECH_BLUESPACE = 3, RESEARCH_TECH_MATERIALS = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_GOLD = 500, MATERIAL_DIAMOND = 500, MATERIAL_URANIUM = 500) //quite cheap, for more convenience
	reliability_base = 100
	build_path = /obj/item/storage/bag/ore/holding

/////////////////////////////////////////
/////////////////HUDs////////////////////
/////////////////////////////////////////
/datum/design/health_hud
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	id = "health_hud"
	req_tech = list(RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MAGNETS = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/clothing/glasses/hud/health

/datum/design/security_hud
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status."
	id = "security_hud"
	req_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_COMBAT = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/clothing/glasses/hud/security
	locked = 1

/////////////////////////////////////////
//////////////////Test///////////////////
/////////////////////////////////////////
	/*	test
			name = "Test Design"
			desc = "A design to test the new protolathe."
			id = "protolathe_test"
			build_type = PROTOLATHE
			req_tech = list(RESEARCH_TECH_MATERIALS = 1)
			materials = list(MATERIAL_GOLD = 3000, "iron" = 15, "copper" = 10, MATERIAL_SILVER = 2500)
			build_path = "/obj/item/banhammer" */

////////////////////////////////////////
//Disks for transporting design datums//
////////////////////////////////////////
/obj/item/disk/design_disk
	name = "Component Design Disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = 1.0
	matter_amounts = list(MATERIAL_METAL = 30, MATERIAL_METAL = 10)

	var/datum/design/blueprint

/obj/item/disk/design_disk/New()
	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)

/////////////////////////////////////////
//////////////Borg Upgrades//////////////
/////////////////////////////////////////
/datum/design/borg_syndicate_module
	name = "Borg Illegal Weapons Upgrade"
	desc = "Allows for the construction of illegal upgrades for cyborgs"
	id = "borg_syndicate_module"
	build_type = MECHFAB
	req_tech = list(RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_SYNDICATE = 3)
	build_path = /obj/item/borg/upgrade/syndicate
	category = "Cyborg Upgrade Modules"

/////////////////////////////////////////
/////////////PDA and Radio stuff/////////
/////////////////////////////////////////
/datum/design/binaryencrypt
	name = "Binary Encrpytion Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	id = "binaryencrypt"
	req_tech = list(RESEARCH_TECH_SYNDICATE = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 300, MATERIAL_GLASS = 300)
	build_path = /obj/item/device/encryptionkey/binary

/datum/design/pda
	name = "PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	id = "pda"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/device/pda

/datum/design/cart_basic
	name = "Generic Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_basic"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge

/datum/design/cart_engineering
	name = "Power-ON Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_engineering"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/engineering

/datum/design/cart_atmos
	name = "BreatheDeep Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_atmos"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/atmos

/datum/design/cart_medical
	name = "Med-U Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_medical"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/medical

/datum/design/cart_chemistry
	name = "ChemWhiz Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_chemistry"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/chemistry

/datum/design/cart_security
	name = "R.O.B.U.S.T. Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_security"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/security
	locked = 1

/datum/design/cart_janitor
	name = "CustodiPRO Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_janitor"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/janitor

/datum/design/cart_clown
	name = "Honkworks 5.0 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_clown"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/clown

/datum/design/cart_mime
	name = "Gestur-O 1000 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_mime"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/mime

/datum/design/cart_toxins
	name = "Signal Ace 2 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_toxins"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/signal/toxins

/datum/design/cart_quartermaster
	name = "Space Parts & Space Vendors Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_quartermaster"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/quartermaster
	locked = 1

/datum/design/cart_hop
	name = "Human Resources 9001 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_hop"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/hop
	locked = 1

/datum/design/cart_hos
	name = "R.O.B.U.S.T. DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_hos"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/hos
	locked = 1

/datum/design/cart_ce
	name = "Power-On DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_ce"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/ce
	locked = 1

/datum/design/cart_cmo
	name = "Med-U DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_cmo"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/cmo
	locked = 1

/datum/design/cart_rd
	name = "Signal Ace DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_rd"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/rd
	locked = 1

/datum/design/cart_captain
	name = "Value-PAK Cartridge"
	desc = "A data cartridge for portable microcomputers."
	id = "cart_captain"
	req_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_POWERSTORAGE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/cartridge/captain
	locked = 1