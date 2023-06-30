// Enabled as of 08/10/2019. -Frenjo
/obj/structure/filingcabinet
	name = "Filing Cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "filingcabinet"
	density = TRUE
	anchored = TRUE

/obj/structure/filingcabinet/attackby(obj/item/weapon/paper/P, mob/M)
	if(istype(P))
		to_chat(M, "You put \the [P] in the [src].")
		M.drop_item()
		P.loc = src
	else
		to_chat(M, "You can't put a [P] in the [src]!")

/obj/structure/filingcabinet/attack_hand(mob/user)
	if(src.contents.len <= 0)
		to_chat(user, "The [src] is empty.")
		return
	var/obj/item/weapon/paper/P = input(user, "Choose a sheet to take out.", "[src]", "Cancel") as null|obj in src.contents
	if(isnotnull(P) && in_range(src, user))
		P.loc = user.loc