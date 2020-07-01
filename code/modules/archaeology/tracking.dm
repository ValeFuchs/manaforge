//Artifacts are currently tracked via GPS because pinpointers just don't work for them. If you ever wanna make pinpointing work, have fun

/**********************Fossil Scanner**********************/
/obj/item/pinpointer/archaeology
	name = "relic locator"
	desc = "A device capable of tracking down ancient artifacts using a tachyon enhanced quantum entanglement detection system."
	icon = 'icons/obj/device.dmi'
	icon_state = "pinoff_crew"
	flags = CONDUCT
	slot_flags = SLOT_PDA | SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	materials = list(MAT_METAL=500)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/obj/item/archaeology/artifact/coolthing = null
	shows_nuke_timer = FALSE
	icon_off = "pinoff_crew"
	icon_null = "pinonnull_crew"
	icon_direct = "pinondirect_crew"
	icon_close = "pinonclose_crew"
	icon_medium = "pinonmedium_crew"
	icon_far = "pinonfar_crew"

/obj/item/pinpointer/archaeology/New()
	..()
	GLOB.pinpointer_list += src

/obj/item/pinpointer/archaeology/Destroy()
	GLOB.pinpointer_list -= src
	active = 0
	coolthing = null
	return ..()

/obj/item/pinpointer/archaeology/attack_self()
	if(!active)
		active = 1
		workrelic()
		to_chat(usr, "<span class='notice'>You activate the locator.</span>")
	else
		active = 0
		icon_state = icon_off
		to_chat(usr, "<span class='notice'>You deactivate the locator.</span>")

/obj/item/pinpointer/archaeology/proc/scanrelic()
	if(!coolthing)
		coolthing = locate()

/obj/item/pinpointer/archaeology/proc/workrelic()
	scanrelic()
	point_at(coolthing, 0)
	spawn(5)
		.()

/obj/item/pinpointer/archaeology/examine(mob/user)
	. = ..()
	if(shows_nuke_timer)
		for(var/obj/machinery/nuclearbomb/bomb in GLOB.machines)
			if(bomb.timing)
				. += "Extreme danger.  Arming signal detected.   Time remaining: [bomb.timeleft]"
