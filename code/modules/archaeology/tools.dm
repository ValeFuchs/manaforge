/obj/item/archaeology/brush
	name = "small brush"
	desc = "For cleaning artifacts."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "brush"
	usesound = "sound/weapons/thudswoosh.ogg"
	materials = list(MAT_METAL=6000, MAT_GLASS=3000)
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "materials=1"
	attack_verb = list("attacked", "brushed")

/obj/item/archaeology/probepick
	name = "curette"
	desc = "A sharp probe for picking artifacts clean."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "curette"
	hitsound = 'sound/weapons/bladeslice.ogg'
	usesound = 'sound/items/screwdriver.ogg'
	materials = list(MAT_METAL=5000, MAT_GLASS=2500)
	flags = CONDUCT
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "materials=1"
	attack_verb = list("stabbed")

/obj/item/archaeology/archeodrill
	name = "archaeological drill"
	desc = "Small drill for restoring technological artifacts."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "drill"
	hitsound = 'sound/weapons/drill.ogg'
	usesound = 'sound/items/drill_hit.ogg'
	materials = list(MAT_METAL=10000, MAT_GLASS=6000)
	flags = CONDUCT
	force = 15.0
	sharp = 1
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = "materials=1"
	attack_verb = list("drilled")

/**********************Belt**********************/
/obj/item/storage/belt/archaeology
	name = "archaeologist belt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "A belt that holds various archaeology tools."
	icon_state = "utilitybelt"
	item_state = "utility"
	use_item_overlays = 1
	can_hold = list(
		/obj/item/archaeology/brush,
		/obj/item/archaeology/probepick,
		/obj/item/archaeology/archeodrill,
		/obj/item/pinpointer/archaeology,
		/obj/item/shovel,
		/obj/item/pickaxe/mini,
		/obj/item/flashlight,
		/obj/item/gun/energy/kinetic_accelerator,
		/obj/item/survivalcapsule)

/obj/item/storage/belt/archaeology/full/New()
	..()
	new /obj/item/archaeology/brush(src)
	new /obj/item/archaeology/probepick(src)
	new /obj/item/archaeology/archeodrill(src)
	new /obj/item/pinpointer/archaeology(src)
	new /obj/item/flashlight/seclite(src)
	update_icon()

//////////////////////Closet//////////////////////////
/obj/structure/closet/secure_closet/archaeologist
	name = "archaeologist's locker"
	req_access = list(ACCESS_ARCHAEOLOGY)
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"

/obj/structure/closet/secure_closet/archaeologist/New()
	..()
	new /obj/item/storage/backpack/science(src)
	new /obj/item/storage/backpack/satchel_tox(src)
	new /obj/item/clothing/under/rank/archaeologist(src)
	new /obj/item/clothing/suit/storage/labcoat/science(src)
	new /obj/item/clothing/shoes/workboots/mining(src)
	new /obj/item/radio/headset/headset_arch(src)
	new /obj/item/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/pickaxe/mini(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/pinpointer/archaeology(src)
	new /obj/item/gun/energy/kinetic_accelerator(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/survivalcapsule(src)
	new /obj/item/clothing/head/cowboyhat/tan

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

/////////Big Display Case////////////

/obj/structure/archaeology/display
	name = "large display base"
	icon = 'icons/obj/archaeologylarge.dmi'
	icon_state = "bigdisplay"
	desc = "A large display base for very large artifacts."
	density = TRUE
	anchored = TRUE
	resistance_flags = ACID_PROOF
	armor = list("melee" = 30, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 100)
	max_integrity = 200
	integrity_failure = 50

/obj/structure/archaeology/display/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/archaeology/finished/massiveskull))
		to_chat(user, "<span class='notice'>You begin assembling [W] on [src]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You place [W], on the display base.</span>")
			new /obj/structure/archaeology/display/skull(drop_location())
			qdel(src)
			qdel(W)
		return

	else if(istype(W, /obj/item/archaeology/finished/advmech))
		to_chat(user, "<span class='notice'>You begin assembling [W] on [src]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You place [W], on the display base.</span>")
			new /obj/structure/archaeology/display/mech(drop_location())
			qdel(src)
			qdel(W)
		return

	else
		. = ..()

/obj/structure/archaeology/display/skull
	name = "space dragon skull"
	icon_state = "bigdisplayskull"
	desc = "The enormous fossilized skull of a long extinct space dragon. Carbon dating suggests it is 25 million years old."
	layer = HIGH_LANDMARK_LAYER

/obj/structure/archaeology/display/skull/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/wrench))
		to_chat(user, "<span class='notice'>You begin disassembling [src] display...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You disassemble [src].</span>")
			new /obj/structure/archaeology/display(drop_location())
			new /obj/item/archaeology/finished/massiveskull(drop_location())
			qdel(src)
		return

	else
		. = ..()

/obj/structure/archaeology/display/mech
	name = "advanced combat mech suit"
	icon_state = "bigdisplaymecha"
	desc = "An enormous combat mech of highly advanced design. It dwarfs anything Nanotrasen currently produces. Its origin is unknown, and it appears fully nonfunctional."
	layer = HIGH_LANDMARK_LAYER

/obj/structure/archaeology/display/mech/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/wrench))
		to_chat(user, "<span class='notice'>You begin disassembling [src] display...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='notice'>You disassemble [src].</span>")
			new /obj/structure/archaeology/display(drop_location())
			new /obj/item/archaeology/finished/advmech(drop_location())
			qdel(src)
		return

	else
		. = ..()

/////The guide book/////////

/obj/item/book/manual/archaeology
	name = "Guide to Archaeology"
	icon = 'icons/obj/archaeology.dmi'
	icon_state ="guide"
	author = "Lawrence Jones of Indirabia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Guide to Archaeology"
//big pile of shit below.

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>
				<h3>Archaeology</h3>

				<h4>Introduction</h4>
				Congratulations esteemed researcher on your promotion into Nanotrasen's new archaeology department! We at Nanotrasen are committed to furthering the cause of both science and galactic history*, and have bright hopes our new archaeology department will contribute well to both!

				<h4>Your Equipment</h4>

				The archaeology lab comes fully furnished with everything the archaeology department will need to perform research. Remember that for exploration of space and Lavaland, you can find the appropriate equipment in EVA storage and the mining station respectively.
				<p>
				<b>Your equipment consists of:</b><br>
				Brushes, curettes, and drills for handling artifacts<br>
				A state of the art artifact restoration machine for restoring and cataloguing whatever relics you find.<br>
				A pinpointer capable of detecting rare and ancient objects.<br>
				Pens, paper, and a camera. Remember, Nanotrasen expects you to report your discoveries.<br>
				</p>

				<h4>Handling Artifacts</h4>

				While highly advanced, an artifact restorer cannot do all of the work that comes with handling artifacts and fossils. They must be prepared for the artifact restorer first.
				<p>
				<b>To prepare technological artifacts:</b><br><br>
				<b>Step One:</b> The artifact must be brushed clean. There are centuries of dirt and grime on it afterall.<br>
				<b>Step Two:</b> Some filth on the artifact will likely be too stubborn to brush off and must be picked loose with a curette.<br>
				<b>Step Three:</b> You will now need to take apart the artifact with your drill.<br>
				<b>Step Four:</b> With the artifact disassembled, you can now carefully clean and restore each piece with the curette.<br>
				<b>Step Five:</b> Now that everything is clean, reassemble the artifact with a drill.<br>
				<b>Step Six:</b> With your artifact fully cleaned inside and out, it can now be inserted into an artifact restorer.<br><br><br>
				<b>To prepare fossils:</b><br><br>
				<b>Step One:</b> The fossil must be cut free from the surrounding rock it is embedded in.<br>
				<b>Step Two:</b> The fossil must now be brushed clean.<br>
				<b>Step Three:</b> Finally, use your curette to remove any remaining stubborn filth from the fossil.<br>
				<b>Step Four:</b> With your fossil fully cleaned, it can now be scanned and identified by an artifact restorer.<br>
				</p>

				<h4>Museum and Artifact Shipment</h4>

				As you have no doubt noticed, your space station includes a museum fully equiped to showcase the artifacts you find.<br>
				Per department policy, Nanotrasen expects the station's resident archaeology team to supply and curate the museum's collection for display to the general crew / public.<br><br>
				<font color='red'>In addition, Nanotrasen expects to receive artifact shipments from the station each shift. Discuss transportation options with your station cargo bay team.</font><br><br>


				<h4><b><font color='red'>*Notice from Legal</font></b></h4>
				<font color='red'>Nanotrasen's commitment to historical research only pertains to areas covered in the judgement decision Galactic Heritage Society v. Nanotrasen, 410 T.E. 113</font>
				</body>
				</html>
				"}