/datum/event/tear/honk
	var/obj/effect/tear/honk/HE //i could just inherit but its being finicky.

/datum/event/tear/honk/announce()
	GLOB.event_announcement.Announce("A Honknomoly has opened. Expected location: [impact_area.name].", "Honknomoly Alert", 'sound/items/airhorn.ogg')

/datum/event/tear/honk/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		HE = new /obj/effect/tear/honk(T.loc)

/datum/event/tear/honk/end()
	if(HE)
		qdel(HE)

/obj/effect/tear/honk
	name = "Honkmensional Tear"
	desc = "A tear in the dimensional fabric of sanity."

/obj/effect/tear/honk/spew_critters()
	for(var/l in 1 to 3)
		var/mob/living/simple_animal/hostile/retaliate/clown/banana/B = new(get_turf(src))
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(B, pick(NORTH, SOUTH, EAST, WEST))
	for(var/i in 1 to 6)
		var/mob/living/simple_animal/hostile/retaliate/clown/honkling/H = new(get_turf(src))
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(H, pick(NORTH, SOUTH, EAST, WEST))
	for(var/p in 1 to 2)
		var/mob/living/simple_animal/hostile/retaliate/clown/fleshclown/F = new(get_turf(src))
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(F, pick(NORTH, SOUTH, EAST, WEST))


