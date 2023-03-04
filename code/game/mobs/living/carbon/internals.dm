/mob/living/carbon/ui_toggle_internals()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
			if(C.internal)
				C.internal = null
				to_chat(C, SPAN_NOTICE("No longer running on internals."))
				if(C.internals)
					C.internals.icon_state = "internal0"
				return

			if(!istype(C.wear_mask, /obj/item/clothing/mask))
				to_chat(C, SPAN_NOTICE("You are not wearing a mask."))
				return

			var/list/nicename = null
			var/list/tankcheck = null
			var/breathes = GAS_OXYGEN	// Default, we'll check later.
			var/list/contents = list()

			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				breathes = H.species.breath_type
				nicename = list("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
				tankcheck = list(H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
			else
				nicename = list("Right Hand", "Left Hand", "Back")
				tankcheck = list(C.r_hand, C.l_hand, C.back)

			for(var/i = 1, i < length(tankcheck) + 1, ++i)
				if(istype(tankcheck[i], /obj/item/weapon/tank))
					var/obj/item/weapon/tank/t = tankcheck[i]
					if(!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc, breathes))
						// Someone messed with the tank and put unknown gases in it, so we're going to believe the tank is what it says it is.
						contents.Add(t.air_contents.total_moles)
						continue
					switch(breathes)
						// These tanks we're sure of their contents.
						// So we're a bit more picky about them.
						if(GAS_NITROGEN)
							if(t.air_contents.gas[GAS_NITROGEN] && !t.air_contents.gas[GAS_OXYGEN])
								contents.Add(t.air_contents.gas[GAS_NITROGEN])
							else
								contents.Add(0)

						if(GAS_OXYGEN)
							if(t.air_contents.gas[GAS_OXYGEN] && !t.air_contents.gas[GAS_PLASMA])
								contents.Add(t.air_contents.gas[GAS_OXYGEN])
							else
								contents.Add(0)

						// No races breath this, but never know about downstream servers.
						if(GAS_CARBON_DIOXIDE)
							if(t.air_contents.gas[GAS_CARBON_DIOXIDE] && !t.air_contents.gas[GAS_PLASMA])
								contents.Add(t.air_contents.gas[GAS_CARBON_DIOXIDE])
							else
								contents.Add(0)

						// Plasmalins breath this.
						if(GAS_PLASMA)
							if(t.air_contents.gas[GAS_PLASMA] && !t.air_contents.gas[GAS_OXYGEN])
								contents.Add(t.air_contents.gas[GAS_PLASMA])
							else
								contents.Add(0)
				else
					// No tank so we set contents to 0.
					contents.Add(0)

			// Alright now we know the contents of the tanks so we have to pick the best one.
			var/best = 0
			var/bestcontents = 0
			for(var/i = 1, i < length(contents) + 1, ++i)
				if(!contents[i])
					continue
				if(contents[i] > bestcontents)
					best = i
					bestcontents = contents[i]

			// We've determined the best container now we set it as our internals.
			if(best)
				to_chat(C, SPAN_NOTICE("You are now running on internals from [tankcheck[best]] on your [nicename[best]]."))
				C.internal = tankcheck[best]

			if(C.internal)
				if(C.internals)
					C.internals.icon_state = "internal1"
			else
				to_chat(C, SPAN_NOTICE("You don't have a[breathes == GAS_OXYGEN ? "n oxygen" : addtext(" ", breathes)] tank."))