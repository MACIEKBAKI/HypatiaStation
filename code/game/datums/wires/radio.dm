/datum/wires/radio
	holder_type = /obj/item/device/radio
	wire_count = 3

var/const/WIRE_SIGNAL = 1
var/const/WIRE_RECEIVE = 2
var/const/WIRE_TRANSMIT = 4

/datum/wires/radio/CanUse(mob/living/L)
	var/obj/item/device/radio/R = holder
	if(R.b_stat)
		return 1
	return 0

/datum/wires/radio/Interact(mob/living/user)
	if(CanUse(user))
		var/obj/item/device/radio/R = holder
		R.interact(user)

/datum/wires/radio/UpdatePulsed(index)
	var/obj/item/device/radio/R = holder
	switch(index)
		if(WIRE_SIGNAL)
			R.listening = !R.listening && !IsIndexCut(WIRE_RECEIVE)
			R.broadcasting = R.listening && !IsIndexCut(WIRE_TRANSMIT)
		if(WIRE_RECEIVE)
			R.listening = !R.listening && !IsIndexCut(WIRE_SIGNAL)
		if(WIRE_TRANSMIT)
			R.broadcasting = !R.broadcasting && !IsIndexCut(WIRE_SIGNAL)

/datum/wires/radio/UpdateCut(index, mended)
	var/obj/item/device/radio/R = holder
	switch(index)
		if(WIRE_SIGNAL)
			R.listening = mended && !IsIndexCut(WIRE_RECEIVE)
			R.broadcasting = mended && !IsIndexCut(WIRE_TRANSMIT)
		if(WIRE_RECEIVE)
			R.listening = mended && !IsIndexCut(WIRE_SIGNAL)
		if(WIRE_TRANSMIT)
			R.broadcasting = mended && !IsIndexCut(WIRE_SIGNAL)