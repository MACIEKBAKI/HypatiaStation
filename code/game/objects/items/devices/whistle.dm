/obj/item/device/hailer
	name = "hailer"
	desc = "Used by obese officers to save their breath for running."
	icon_state = "voice0"
	item_state = "flashbang"	//looks exactly like a flash (and nothing like a flashbang)
	w_class = 1.0
	flags = CONDUCT

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0//just in case

/obj/item/device/hailer/attack_self(mob/living/carbon/user as mob)
	if(spamcheck)
		return

	if(emagged)
		if(insults >= 1)
			// I am deeply conflicted about the content of these insults. -Frenjo
			playsound(get_turf(src), 'sound/voice/binsult.ogg', 100, 1, vary = 0)//hueheuheuheuheuheuhe
			user.show_message(SPAN_WARNING("[user]'s [name] gurgles, \"FUCK YOUR CUNT YOU SHIT EATING CUNT TILL YOU ARE A MASS EATING SHIT CUNT. EAT PENISES IN YOUR FUCK FACE AND SHIT OUT ABORTIONS TO FUCK UP SHIT IN YOUR ASS YOU COCK FUCK SHIT MONKEY FROM THE DEPTHS OF SHIT\""), 2) //It's a hearable message silly!
			insults--
		else
			to_chat(user, SPAN_WARNING("*BZZZZcuntZZZZT*"))
	else
		playsound(get_turf(src), 'sound/voice/halt.ogg', 100, 1, vary = 0)
		user.show_message(SPAN_WARNING("[user]'s [name] rasps, \"Halt! Security!\""), 1)

	spamcheck = 1
	spawn(20)
		spamcheck = 0

/obj/item/device/hailer/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/emag) && !emagged)
		to_chat(user, SPAN_WARNING("You overload \the [src]'s voice synthesizer."))
		emagged = 1
		insults = rand(1, 3)//to prevent dickflooding
		return
	return