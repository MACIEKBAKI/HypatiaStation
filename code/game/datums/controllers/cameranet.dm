/*
 * CAMERA NET
 *
 * The controller datum containing all the chunks.
 */
/hook/startup/proc/create_camera_networks()
	global.CTcameranet = new /datum/controller/cameranet()
	return 1

CONTROLLER_DEF(cameranet)
	name = "Cameras"

	// The cameras on the map, no matter if they work or not. Updated in obj/machinery/camera.dm by New() and Del().
	var/list/cameras = list()
	// The chunks of the map, mapping the areas that the cameras can see.
	var/list/chunks = list()
	var/ready = 0

// Checks if a chunk has been Generated in x, y, z.
/datum/controller/cameranet/proc/chunkGenerated(x, y, z)
	x &= ~0xf
	y &= ~0xf
	var/key = "[x],[y],[z]"
	return chunks[key]

// Returns the chunk in the x, y, z.
// If there is no chunk, it creates a new chunk and returns that.
/datum/controller/cameranet/proc/getCameraChunk(x, y, z)
	x &= ~0xf
	y &= ~0xf
	var/key = "[x],[y],[z]"
	if(isnull(chunks[key]))
		chunks[key] = new /datum/camerachunk(null, x, y, z)

	return chunks[key]

// Updates what the aiEye can see. It is recommended you use this when the aiEye moves or it's location is set.
/datum/controller/cameranet/proc/visibility(mob/aiEye/ai)
	// 0xf = 15
	var/x1 = max(0, ai.x - 16) & ~0xf
	var/y1 = max(0, ai.y - 16) & ~0xf
	var/x2 = min(world.maxx, ai.x + 16) & ~0xf
	var/y2 = min(world.maxy, ai.y + 16) & ~0xf

	var/list/visibleChunks = list()

	for(var/x = x1; x <= x2; x += 16)
		for(var/y = y1; y <= y2; y += 16)
			visibleChunks.Add(getCameraChunk(x, y, ai.z))

	var/list/remove = ai.visibleCameraChunks - visibleChunks
	var/list/add = visibleChunks - ai.visibleCameraChunks

	for(var/chunk in remove)
		var/datum/camerachunk/c = chunk
		c.remove(ai)

	for(var/chunk in add)
		var/datum/camerachunk/c = chunk
		c.add(ai)

// Updates the chunks that the turf is located in. Use this when obstacles are destroyed or	when doors open.
/datum/controller/cameranet/proc/updateVisibility(atom/A, opacity_check = 1)
	if(isnull(global.CTgame_ticker) || (opacity_check && !A.opacity))
		return
	majorChunkChange(A, 2)

/datum/controller/cameranet/proc/updateChunk(x, y, z)
	// 0xf = 15
	if(isnull(chunkGenerated(x, y, z)))
		return
	var/datum/camerachunk/chunk = getCameraChunk(x, y, z)
	chunk.hasChanged()

// Removes a camera from a chunk.
/datum/controller/cameranet/proc/removeCamera(obj/machinery/camera/c)
	if(c.can_use())
		majorChunkChange(c, 0)

// Add a camera to a chunk.
/datum/controller/cameranet/proc/addCamera(obj/machinery/camera/c)
	if(c.can_use())
		majorChunkChange(c, 1)

// Used for Cyborg cameras. Since portable cameras can be in ANY chunk.
/datum/controller/cameranet/proc/updatePortableCamera(obj/machinery/camera/c)
	if(c.can_use())
		majorChunkChange(c, 1)
	//else
	//	majorChunkChange(c, 0)

// Never access this proc directly!!!!
// This will update the chunk and all the surrounding chunks.
// It will also add the atom to the cameras list if you set the choice to 1.
// Setting the choice to 0 will remove the camera from the chunks.
// If you want to update the chunks around an object, without adding/removing a camera, use choice 2.
/datum/controller/cameranet/proc/majorChunkChange(atom/c, choice)
	// 0xf = 15
	if(isnull(c))
		return

	var/turf/T = get_turf(c)
	if(isnotnull(T))
		var/x1 = max(0, T.x - 8) & ~0xf
		var/y1 = max(0, T.y - 8) & ~0xf
		var/x2 = min(world.maxx, T.x + 8) & ~0xf
		var/y2 = min(world.maxy, T.y + 8) & ~0xf

		//to_world("X1: [x1] - Y1: [y1] - X2: [x2] - Y2: [y2]")

		for(var/x = x1; x <= x2; x += 16)
			for(var/y = y1; y <= y2; y += 16)
				if(isnull(chunkGenerated(x, y, T.z)))
					continue
				var/datum/camerachunk/chunk = getCameraChunk(x, y, T.z)
				if(choice == 0)
					// Remove the camera.
					chunk.cameras.Remove(c)
				else if(choice == 1)
					// You can't have the same camera in the list twice.
					chunk.cameras |= c
				chunk.hasChanged()

// Will check if a mob is on a viewable turf. Returns 1 if it is, otherwise returns 0.
/datum/controller/cameranet/proc/checkCameraVis(mob/living/target as mob)
	// 0xf = 15
	var/turf/position = get_turf(target)
	var/datum/camerachunk/chunk = getCameraChunk(position.x, position.y, position.z)
	if(isnull(chunk))
		return 0
	if(chunk.changed)
		chunk.hasChanged(1) // Update now, no matter if it's visible or not.
	if(chunk.visibleTurfs[position])
		return 1
	return 0

// Debug verb for VVing the chunk that the turf is in.
/*
/turf/verb/view_chunk()
	set src in world

	if(cameranet.chunkGenerated(x, y, z))
		var/datum/camerachunk/chunk = cameranet.getCameraChunk(x, y, z)
		usr.client.debug_variables(chunk)
*/