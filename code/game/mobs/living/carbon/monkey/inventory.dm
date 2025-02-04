/obj/effect/equip_e/monkey/process()
	if (item)
		item.add_fingerprint(source)
	if (!( item ))
		switch(place)
			if("head")
				if (!( target.wear_mask ))
					qdel(src)
					return
			if("l_hand")
				if (!( target.l_hand ))
					qdel(src)
					return
			if("r_hand")
				if (!( target.r_hand ))
					qdel(src)
					return
			if("back")
				if (!( target.back ))
					qdel(src)
					return
			if("handcuff")
				if (!( target.handcuffed ))
					qdel(src)
					return
			if("internal")
				if ((!( (istype(target.wear_mask, /obj/item/clothing/mask) && istype(target.back, /obj/item/tank) && !( target.internal )) ) && !( target.internal )))
					qdel(src)
					return

	if (item)
		if(isrobot(source) && place != "handcuff")
			var/list/L = list( "syringe", "pill", "drink", "dnainjector", "fuel")
			if(!(L.Find(place)))
				qdel(src)
				return
		for(var/mob/O in viewers(target, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("\red <B>[] is trying to put a [] on []</B>", source, item, target), 1)
	else
		var/message = null
		switch(place)
			if("mask")
				if(istype(target.wear_mask, /obj/item/clothing)&&!target.wear_mask:canremove)
					message = text("\red <B>[] fails to take off \a [] from []'s body!</B>", source, target.wear_mask, target)
				else
					message = text("\red <B>[] is trying to take off \a [] from []'s head!</B>", source, target.wear_mask, target)
			if("l_hand")
				message = text("\red <B>[] is trying to take off a [] from []'s left hand!</B>", source, target.l_hand, target)
			if("r_hand")
				message = text("\red <B>[] is trying to take off a [] from []'s right hand!</B>", source, target.r_hand, target)
			if("back")
				message = text("\red <B>[] is trying to take off a [] from []'s back!</B>", source, target.back, target)
			if("handcuff")
				message = text("\red <B>[] is trying to unhandcuff []!</B>", source, target)
			if("internal")
				if (target.internal)
					message = text("\red <B>[] is trying to remove []'s internals</B>", source, target)
				else
					message = text("\red <B>[] is trying to set on []'s internals.</B>", source, target)
			if("pockets")
				message = text("\red <B>[] is trying to empty []'s pockets</B>",source, target)
			else
		for(var/mob/M in viewers(target, null))
			M.show_message(message, 1)
	spawn( 30 )
		done()
		return
	return

/obj/effect/equip_e/monkey/done()
	if(!source || !target)						return
	if(source.loc != s_loc)						return
	if(target.loc != t_loc)						return
	if(LinkBlocked(s_loc,t_loc))				return
	if(item && source.get_active_hand() != item)	return
	if ((source.restrained() || source.stat))	return
	switch(place)
		if("mask")
			if (target.wear_mask)
				if(istype(target.wear_mask, /obj/item/clothing)&& !target.wear_mask:canremove)
					return
				var/obj/item/W = target.wear_mask
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.reset_plane_and_layer()
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/clothing/mask))
					source.drop_item()
					loc = target
					item.layer = 20
					target.wear_mask = item
					item.loc = target
		if("l_hand")
			if (target.l_hand)
				var/obj/item/W = target.l_hand
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.reset_plane_and_layer()
					W.dropped(target)
				W.add_fingerprint(source)
			else
				if(isitem(item))
					source.drop_item()
					loc = target
					item.layer = 20
					target.l_hand = item
					item.loc = target
					item.dropped(source)
					item.equipped(target,target.l_hand)
		if("r_hand")
			if (target.r_hand)
				var/obj/item/W = target.r_hand
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.reset_plane_and_layer()
					W.dropped(target)
				W.add_fingerprint(source)
			else
				if(isitem(item))
					source.drop_item()
					loc = target
					item.layer = 20
					target.r_hand = item
					item.loc = target
					item.dropped(source)
					item.equipped(target,target.r_hand)
		if("back")
			if (target.back)
				var/obj/item/W = target.back
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.reset_plane_and_layer()
				W.add_fingerprint(source)
			else
				if(isitem(item) && (item.slot_flags & SLOT_BACK))
					source.drop_item()
					loc = target
					item.layer = 20
					target.back = item
					item.loc = target
		if("handcuff")
			if (target.handcuffed)
				var/obj/item/W = target.handcuffed
				target.u_equip(W)
				if (target.client)
					target.client.screen -= W
				if (W)
					W.loc = target.loc
					W.dropped(target)
					W.reset_plane_and_layer()
				W.add_fingerprint(source)
			else
				if (istype(item, /obj/item/handcuffs))
					source.drop_item()
					target.handcuffed = item
					item.loc = target
		if("internal")
			if (target.internal)
				target.internal.add_fingerprint(source)
				target.internal = null
			else
				if (target.internal)
					target.internal = null
				if (!( istype(target.wear_mask, /obj/item/clothing/mask) ))
					return
				else
					if (istype(target.back, /obj/item/tank))
						target.internal = target.back
						target.internal.add_fingerprint(source)
						for(var/mob/M in viewers(target, 1))
							if ((M.client && !( M.blinded )))
								M.show_message(text("[] is now running on internals.", target), 1)
		else
	source.regenerate_icons()
	target.regenerate_icons()
	qdel(src)
	return



//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
//set redraw_mob to 0 if you don't wish the hud to be updated - if you're doing it manually in your own proc.
/mob/living/carbon/monkey/equip_to_slot(obj/item/W as obj, slot, redraw_mob = 1)
	if(!slot) return
	if(!istype(W)) return

	if(W == get_active_hand())
		u_equip(W)

	switch(slot)
		if(SLOT_ID_BACK)
			src.back = W
			W.equipped(src, slot)
			update_inv_back(redraw_mob)
		if(SLOT_ID_WEAR_MASK)
			src.wear_mask = W
			W.equipped(src, slot)
			update_inv_wear_mask(redraw_mob)
		if(SLOT_ID_HANDCUFFED)
			src.handcuffed = W
			update_inv_handcuffed(redraw_mob)
		if(SLOT_ID_LEGCUFFED)
			src.legcuffed = W
			W.equipped(src, slot)
			update_inv_legcuffed(redraw_mob)
		if(SLOT_ID_L_HAND)
			src.l_hand = W
			W.equipped(src, slot)
			update_inv_l_hand(redraw_mob)
		if(SLOT_ID_R_HAND)
			src.r_hand = W
			W.equipped(src, slot)
			update_inv_r_hand(redraw_mob)
		if(SLOT_ID_IN_BACKPACK)
			W.loc = src.back
		else
			usr << "\red You are trying to eqip this item to an unsupported inventory slot. How the heck did you manage that? Stop it..."
			return

	W.layer = 20

	return
