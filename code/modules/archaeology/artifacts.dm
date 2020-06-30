/obj/item/archaeology/artifact
	name = "ancient artifact"
	desc = "A mysterious artifact lost to time. It looks to be restorable, but is covered in dirt and grime."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "artifact"
	var/scan_state = "artifact"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/artifact/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/brush))
		to_chat(user, "<span class='notice'>You carefully begin to brush clean [src] with [W]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You brush the dust and grime from [src].</span>")
			new /obj/item/archaeology/artifact/brushed(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/brushed
	desc = "A mysterious artifact lost to time. It's been brushed clean, but some stubborn grime still remains."
	icon_state = "artifact2"

/obj/item/archaeology/artifact/brushed/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/probepick))
		to_chat(user, "<span class='notice'>You begin to carefully probe and pick the remaing filth from [src]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You pick the dirt from [src] with the [W].</span>")
			new /obj/item/archaeology/artifact/probed(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/probed
	desc = "A mysterious artifact lost to time. The outside is clean, the inside however..."
	icon_state = "artifact2"

/obj/item/archaeology/artifact/probed/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/archeodrill))
		to_chat(user, "<span class='notice'>You begin taking apart [src] with the [W]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You gently take apart [src], into its various parts.</span>")
			new /obj/item/archaeology/artifact/onedrilled(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/onedrilled
	desc = "A mysterious artifact lost to time. It's been carefully disassembled for deep cleaning."
	icon_state = "artifact3"

/obj/item/archaeology/artifact/onedrilled/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/probepick))
		to_chat(user, "<span class='notice'>You pick and scrape the disassembled parts of [src] clean with the [W]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>With careful hands, you clean out the parts and insides of [src].</span>")
			new /obj/item/archaeology/artifact/twoprobed(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/twoprobed
	desc = "A mysterious artifact lost to time. It's clean but needs to be reassembled."
	icon_state = "artifact3"

/obj/item/archaeology/artifact/twoprobed/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/archeodrill))
		to_chat(user, "<span class='notice'>You begin reassembling [src]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You reassemble [src].</span>")
			new /obj/item/archaeology/artifact/prepared/tech(drop_location())
			qdel(src)
		return

	else

/obj/item/archaeology/artifact/fossil
	name = "fossil"
	desc = "The preserved remains of an ancient life-form. It looks to be restorable, but is still encased in dirt and rock."
	icon_state = "fossil"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/artifact/fossil/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/archeodrill))
		to_chat(user, "<span class='notice'>You begin cutting [src] free with [W]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You free [src] from the surrounding rock.</span>")
			new /obj/item/archaeology/artifact/fossil/cut(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/fossil/cut
	desc = "The preserved remains of an ancient life-form. It has been cut free from the surrounding rock, but is still covered in dirt and dust."
	icon_state = "fossil2"

/obj/item/archaeology/artifact/fossil/cut/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/brush))
		to_chat(user, "<span class='notice'>You start brushing dust and dirt from [src]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You clean the dust from [src].</span>")
			new /obj/item/archaeology/artifact/fossil/brushed(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/fossil/brushed
	desc = "The preserved remains of an ancient life-form. It needs precise cleaning before restoration."
	icon_state = "fossil2"

/obj/item/archaeology/artifact/fossil/brushed/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/probepick))
		to_chat(user, "<span class='notice'>You begin scraping dirt from the inner recesses of [src] with [W]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You pick the last bits of dirt from [src].</span>")
			new /obj/item/archaeology/artifact/prepared/fossil(drop_location())
			qdel(src)
		return

	else
		. = ..()

//////Guaranteed rare item//////
/obj/item/archaeology/artifact/rare
	name = "ancient artifact"
	desc = "A mysterious artifact lost to time. It looks to be restorable, but is covered in dirt and grime."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "artifact"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/artifact/rare/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/brush))
		to_chat(user, "<span class='notice'>You carefully begin to brush clean [src] with [W]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You brush the dust and grime from [src].</span>")
			new /obj/item/archaeology/artifact/rare/brushed(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/rare/brushed
	desc = "A mysterious artifact lost to time. It's been brushed clean, but some stubborn grime still remains."
	icon_state = "artifact2"

/obj/item/archaeology/artifact/rare/brushed/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/probepick))
		to_chat(user, "<span class='notice'>You begin to carefully probe and pick the remaing filth from [src]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You pick the dirt from [src] with the [W].</span>")
			new /obj/item/archaeology/artifact/rare/probed(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/rare/probed
	desc = "A mysterious artifact lost to time. The outside is clean, the inside however..."
	icon_state = "artifact2"

/obj/item/archaeology/artifact/rare/probed/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/archeodrill))
		to_chat(user, "<span class='notice'>You begin taking apart [src] with the [W]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You gently take apart [src], into its various parts.</span>")
			new /obj/item/archaeology/artifact/rare/onedrilled(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/rare/onedrilled
	desc = "A mysterious artifact lost to time. It's been carefully disassembled for deep cleaning."
	icon_state = "artifact3"

/obj/item/archaeology/artifact/rare/onedrilled/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/probepick))
		to_chat(user, "<span class='notice'>You pick and scrape the disassembled parts of [src] clean with the [W]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>With careful hands, you clean out the parts and insides of [src].</span>")
			new /obj/item/archaeology/artifact/rare/twoprobed(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/item/archaeology/artifact/rare/twoprobed
	desc = "A mysterious artifact lost to time. It's clean but needs to be reassembled."
	icon_state = "artifact3"

/obj/item/archaeology/artifact/rare/twoprobed/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/archeodrill))
		to_chat(user, "<span class='notice'>You begin reassembling [src]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You reassemble [src].</span>")
			new /obj/item/archaeology/artifact/prepared/rare(drop_location())
			qdel(src)
		return

	else

/////////FINAL STEP////////////

/obj/item/archaeology/artifact/prepared/rare
	name = "clean ancient artifact"
	desc = "A mysterious artifact lost to time. An artifact restorer would be able to return this to its former glory."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "artifact4"

/obj/item/archaeology/artifact/prepared/tech
	name = "clean ancient artifact"
	desc = "A mysterious artifact lost to time. An artifact restorer would be able to return this to its former glory."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "artifact4"

/obj/item/archaeology/artifact/prepared/fossil
	name = "clean fossil"
	desc = "The preserved remains of an ancient life-form. An artifact restorer should be able to identify it."
	icon_state = "fossil3"

////////ARTIFACT SPAWNERS/////////////

/obj/effect/spawner/lootdrop/artifactH // for ruins
	name = "high chance artifact spawner"
	lootdoubles = 1

	loot = list(
				/obj/item/archaeology/artifact = 80
				)

/obj/effect/spawner/lootdrop/artifactM
	name = "med chance artifact spawner"
	lootdoubles = 1

	loot = list(
				/obj/item/archaeology/artifact = 50
				)

/obj/effect/spawner/lootdrop/artifactL
	name = "low chance artifact spawner"
	lootdoubles = 1

	loot = list(
				/obj/item/archaeology/artifact = 20
				)

/obj/effect/spawner/lootdrop/artifactMR
	name = "med chance artifact spawner with rare"
	lootdoubles = 1

	loot = list(
				/obj/item/archaeology/artifact = 50,
				/obj/item/archaeology/artifact/rare = 50
				)