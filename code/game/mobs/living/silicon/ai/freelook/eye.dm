// AI EYE
//
// An invisible (no icon) mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.

/mob/aiEye
	name = "Inactive AI Eye"
	icon = 'icons/obj/machines/status_display.dmi' // For AI friend secret shh :o
	var/list/visibleCameraChunks = list()
	var/mob/living/silicon/ai/ai = null
	density = FALSE
	status_flags = GODMODE  // You can't damage it.
	mouse_opacity = FALSE
	see_in_dark = 7

// Movement code. Returns 0 to stop air movement from moving it.
/mob/aiEye/Move()
	return 0

/mob/aiEye/examinate(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/aiEye/pointed(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/aiEye/examine(mob/user)

// Use this when setting the aiEye's location.
// It will also stream the chunk that the new loc is in.

/mob/aiEye/proc/setLoc(T)
	if(ai)
		if(!isturf(ai.loc))
			return
		T = get_turf(T)
		loc = T
		global.CTcameranet.visibility(src)
		if(ai.client)
			ai.client.eye = src
		//Holopad
		if(istype(ai.current, /obj/machinery/hologram/holopad))
			var/obj/machinery/hologram/holopad/H = ai.current
			H.move_hologram()


// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	var/mob/aiEye/eyeobj = new()
	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1


// Intiliaze the eye by assigning it's "ai" variable to us. Then set it's loc to us.
/mob/living/silicon/ai/New()
	..()
	eyeobj.ai = src
	eyeobj.name = "[src.name] (AI Eye)" // Give it a name

/mob/living/silicon/ai/initialize()
	. = ..()
	eyeobj.loc = src.loc

/mob/living/silicon/ai/Destroy()
	if(eyeobj)
		eyeobj.ai = null
		qdel(eyeobj) // No AI, no Eye
		eyeobj = null
	return ..()

/atom/proc/move_camera_by_click()
	if(istype(usr, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = usr
		if(AI.eyeobj && AI.client.eye == AI.eyeobj)
			AI.cameraFollow = null
			AI.eyeobj.setLoc(src)

// This will move the AIEye. It will also cause lights near the eye to light up, if toggled.
// This is handled in the proc below this one.

/client/proc/AIMove(n, direct, mob/living/silicon/ai/user)
	var/initial = initial(user.sprint)
	var/max_sprint = 50

	if(user.cooldown && user.cooldown < world.timeofday) // 3 seconds
		user.sprint = initial

	for(var/i = 0; i < max(user.sprint, initial); i += 20)
		var/turf/step = get_turf(get_step(user.eyeobj, direct))
		if(step)
			user.eyeobj.setLoc(step)

	user.cooldown = world.timeofday + 5
	if(user.acceleration)
		user.sprint = min(user.sprint + 0.5, max_sprint)
	else
		user.sprint = initial

	user.cameraFollow = null

	//user.unset_machine() //Uncomment this if it causes problems.
	//user.lightNearbyCamera()


// Return to the Core.

/mob/living/silicon/ai/verb/core()
	set category = "AI Commands"
	set name = "AI Core"

	view_core()


/mob/living/silicon/ai/proc/view_core()
	current = null
	cameraFollow = null
	unset_machine()

	if(src.eyeobj && src.loc)
		src.eyeobj.loc = src.loc
	else
		src << "ERROR: Eyeobj not found. Creating new eye..."
		src.eyeobj = new(src.loc)
		src.eyeobj.ai = src
		src.eyeobj.name = "[src.name] (AI Eye)" // Give it a name

	if(client && client.eye)
		client.eye = src
	for(var/datum/camerachunk/c in eyeobj.visibleCameraChunks)
		c.remove(eyeobj)

/mob/living/silicon/ai/verb/toggle_acceleration()
	set category = "AI Commands"
	set name = "Toggle Camera Acceleration"

	acceleration = !acceleration
	usr << "Camera acceleration has been toggled [acceleration ? "on" : "off"]."