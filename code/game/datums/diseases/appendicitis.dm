/datum/disease/appendicitis
	form = "Condition"
	name = "Appendicitis"
	max_stages = 4
	spread = "Acute"
	cure = "Surgery"
	agent = "Appendix"
	affected_species = list(SPECIES_HUMAN)
	permeability_mod = 1
	contagious_period = 9001 //slightly hacky, but hey! whatever works, right?
	desc = "If left untreated the subject will become very weak, and may vomit often."
	severity = "Medium"
	longevity = 1000
	hidden = list(0, 1)
	stage_minimum_age = 160 // at least 200 life ticks per stage

/datum/disease/appendicitis/stage_act()
	..()
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		if(H.species.flags & IS_PLANT || H.species.flags & IS_SYNTHETIC || H.species.name == SPECIES_VOX || H.species.name == SPECIES_VOX_ARMALIS || H.species.name == SPECIES_PLASMALIN)
			src.cure()

	if(stage == 1)
		if(affected_mob.op_stage.appendix == 2.0)
			// appendix is removed, can't get infected again
			src.cure()
		if(prob(5))
			to_chat(affected_mob, SPAN_WARNING("You feel a stinging pain in your abdomen!"))
			affected_mob.emote("me", 1, "winces slightly.")
	if(stage > 1)
		if(prob(3))
			to_chat(affected_mob, SPAN_WARNING("You feel a stabbing pain in your abdomen!"))
			affected_mob.emote("me", 1, "winces painfully.")
			affected_mob.adjustToxLoss(1)
	if(stage > 2)
		if(prob(1))
			if(affected_mob.nutrition > 100)
				var/mob/living/carbon/human/H = affected_mob
				H.vomit()
			else
				to_chat(affected_mob, SPAN_WARNING("You gag as you want to throw up, but there's nothing in your stomach!"))
				affected_mob.Weaken(10)
				affected_mob.adjustToxLoss(3)
	if(stage > 3)
		if(prob(1) && ishuman(affected_mob))
			var/mob/living/carbon/human/H = affected_mob
			to_chat(H, SPAN_WARNING("Your abdomen is a world of pain!"))
			H.Weaken(10)
			H.op_stage.appendix = 2.0

			var/datum/organ/external/groin = H.get_organ("groin")
			var/datum/wound/W = new /datum/wound/internal_bleeding(20)
			H.adjustToxLoss(25)
			groin.wounds += W
			src.cure()