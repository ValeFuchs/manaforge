/datum/event/warpstorm
	startWhen = 3
	announceWhen = 10
	endWhen = 240
	var/list/pick_turfs = list()
	var/list/warpstorms = list()
	var/number_of_warpstorms = 12
	var/list/warpholes = list()
	var/shift_frequency = 3
	var/number_of_warpholes = 250

/datum/event/warpstorm/announce()
	GLOB.event_announcement.Announce("The station has been consumed by a warpstorm. Unable to conta-K1L4$(YH#B7N1??N*KL&ZZZZZ", "Anomaly Alert")

/datum/event/warpstorm/start()
	SSshuttle.emergencyNoEscape = 1
	for(var/turf/simulated/floor/T in world)
		if(is_station_level(T.z))
			pick_turfs += T

	for(var/i in 1 to number_of_warpstorms)
		var/turf/T = pick(pick_turfs)
		warpstorms += new /obj/effect/warpstorm(T.loc)

	for(var/i in 1 to number_of_warpholes)
		var/turf/T = pick(pick_turfs)
		warpholes += new /obj/effect/portal/warphole(T, null, null, -1)

/datum/event/warpstorm/tick()
	if(activeFor % shift_frequency == 0)
		for(var/obj/effect/portal/warphole/O in warpholes)
			var/turf/T = pick(pick_turfs)
			if(T)	O.loc = T

/datum/event/warpstorm/end()
	for(var/obj/effect/warpstorm/O in warpstorms)
		qdel(O)
	warpstorms.Cut()

	for(var/obj/effect/portal/warphole/O in warpholes)
		qdel(O)
	warpholes.Cut()

	GLOB.event_announcement.Announce("The warpstorm has passed. Communication with Central Command has been reestablished. Caution: Residual daemonic presence detected on the station.", "Anomaly Alert")
	SSshuttle.emergencyNoEscape = 0

/obj/effect/warpstorm
	name="Warp Tear"
	desc="A bridge between the material and immaterial realms."
	icon='icons/effects/tear.dmi'
	icon_state="tear"
	density = 0
	anchored = 1
	light_range = 3

/obj/effect/warpstorm/Initialize(mapload)
	. = ..()
	var/atom/movable/overlay/animation = new(loc)
	animation.icon_state = "newtear"
	animation.icon = 'icons/effects/tear.dmi'
	animation.master = src
	spawn(15)
		if(animation)
			qdel(animation)

	addtimer(CALLBACK(src, .proc/spew_critters), rand(30, 120))

/obj/effect/warpstorm/proc/spew_critters()
	for(var/i in 1 to 5)
		var/mob/living/simple_animal/S
		S = create_random_mob(get_turf(src), HOSTILE_SPAWN)
		S.faction |= "chemicalsummon"
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(S, pick(NORTH, SOUTH, EAST, WEST))

/obj/effect/portal/warphole
	name = "Warp Anomaly"
	desc = "It looks highly unstable; It could close at any moment."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	failchance = 0

/obj/effect/portal/warphole/can_teleport(atom/movable/M)
	. = ..()

	if(istype(M, /obj/singularity))
		. = FALSE

/obj/effect/portal/warphole/teleport(atom/movable/M)
	if(!can_teleport(M))
		return FALSE

	var/turf/target
	if(GLOB.portals.len)
		var/obj/effect/portal/P = pick(GLOB.portals)
		if(P && isturf(P.loc))
			target = P.loc

	if(!target)
		return FALSE

	if(!do_teleport(M, target, 1, TRUE)) ///You will appear adjacent to the beacon
		return FALSE

	return TRUE

