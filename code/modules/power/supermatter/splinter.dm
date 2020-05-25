

/obj/item/supermatter_crystal/splinter
	name = "warpstone splinter"
	desc = "A splinter of warpstone cut off from a larger crystal. Even this tiny shard is too dangerous to touch without special equipment."
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "darkmatter_splinter"
	force = 10.0
	throwforce = 20.0
	sharp = 1
	w_class = WEIGHT_CLASS_SMALL
	flags = CONDUCT
	origin_tech = "materials=4;powerstorage=3"

/obj/item/supermatter_crystal/splinter/New()
	. = ..()

/obj/item/supermatter_crystal/splinter/pickup(mob/living/carbon/human/M as mob)
	if(!(M.gloves && istype(M.gloves, /obj/item/clothing/gloves/color/supermatter)))
		M.visible_message("<span class='danger'>[M] reaches out and tries to pick up the [src]. In a flash of light, [M.p_they()] catches fire!</span>",\
			"<span class='userdanger'>You reach for [src] without proper gloves. That was dumb.</span>")
		M.adjust_fire_stacks(1)
		M.IgniteMob()
		return FALSE
	else
		. = ..()