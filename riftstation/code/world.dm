/turf/open/proc/IsExposed()
	return locate(/turf/open/space) in orange(1, src)

/turf/open/proc/GetSignature()
	. = "{\"exposed\":[IsExposed()]"
	/*if (air)
		. += ",\"temperature\":[air.temperature]"
		. += ",\"volume\":[air.volume]"
		. += ",\"gases\":[json_encode(air.gases)]"
		*/
	. += ",\"type\":\"[type]\""
	. += "}"

	return .

/world/New()
	. = ..()

	var/d = world.timeofday

	var/list/differences = new/list()
	var/json = "{data:\["
	var/id
	var/signature

	for (var/turf/open/T in world)
		if (!istype(T, /turf/open/space))
			signature = T.GetSignature()

			id = differences.Find(signature)

			if (!id)
				differences.Add(signature)
				id = differences.len

			json += "{\"x\":[T.x],\"y\":[T.y],\"z\":[T.z],\"id\":[id - 1]}"

	json += "\],mixtures:\["
	var/first = 1

	for (var/difference in differences)
		if (!first) json += ","
		json += "[difference]"
		first = 0
	json += "\]}"

	world.log << "Result: [json]"
	world.log << "Took [world.timeofday - d]"