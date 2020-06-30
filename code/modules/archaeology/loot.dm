///////////USEFUL STUFF EVERYONE WANTS/////////////

/obj/item/gun/energy/laser/archaeology
	name = "transphotonic arquebus"
	desc = "A mysterious gun that seems far more advanced than anything currently on the station, despite its age. It self charges over time."
	icon_state = "tesla"
	item_state = "tesla"
	origin_tech = "combat=5;magnets=5;powerstorage=5"
	can_charge = 0
	force = 15
	ammo_x_offset = 3
	ammo_type = list(/obj/item/ammo_casing/energy/laser/accelerator, /obj/item/ammo_casing/energy/xray)
	selfcharge = 1

/obj/item/melee/rapier/archaeology
	name = "Xuantong sword"
	desc = "An ancient sword from a galactic empire long dead. It is rather dull."
	icon_state = "rapier"
	item_state = "rapier"
	flags = CONDUCT
	force = 7
	throwforce = 7
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 25
	armour_penetration = 35
	sharp = 0
	origin_tech = "combat=3"
	attack_verb = list("lunged at", "stabbed")
	hitsound = 'sound/weapons/rapierhit.ogg'

/obj/item/twohanded/dualsaber/archaeology //don't fuck with the science team!
	icon_state = "dualsaber0"
	name = "Akarmenid dual-honourblade"
	desc = "A relic from an ancient, galaxy spanning empire. Despite its age, it's still an incredibly powerful dual energy sword."
	force = 10
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	force_unwielded = 3
	force_wielded = 120
	wieldsound = 'sound/weapons/saberon.ogg'
	unwieldsound = 'sound/weapons/saberoff.ogg'
	armour_penetration = 95
	origin_tech = "magnets=4;combat=5;powerstorage=5"
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = 85
	sharp_when_wielded = TRUE // only sharp when wielded
	max_integrity = 400
	armor = list("melee" = 95, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 20, "bio" = 20, "rad" = 20, "fire" = 100, "acid" = 70)
	resistance_flags = FIRE_PROOF
	light_power = 2

/obj/item/twohanded/spear/archaeology//Not valid for explosive modification.
	icon_state = "bone_spear0"
	name = "bone spear"
	desc = "Appears to be a weapon from the mysterious Ash Walker tribe native to Lavaland."
	force = 11
	force_unwielded = 11
	force_wielded = 20					//I have no idea how to balance
	throwforce = 22
	armour_penetration = 15				//Enhanced armor piercing
	icon_prefix = "bone_spear"

/obj/item/clothing/suit/space/hardsuit/archaeology
	name = "ancient combat RIG suit"
	desc = "An ancient combat RIG suit. Provides excellent protection while being comfortable to move around in, thanks to the powered locomotives. Remains very bulky however."
	icon_state = "hardsuit-ancient"
	item_state = "anc_hardsuit"
	armor = list("melee" = 80, "bullet" = 70, "laser" = 70, "energy" = 70, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	slowdown = 3
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	sprite_sheets = null
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ancient
	var/footstep = 1

/obj/item/clothing/head/helmet/space/hardsuit/archaeology
	name = "ancient combat RIG helmet"
	desc = "An ancient combat RIG helmet, designed to quickly shift over a user's head. Design constraints of the helmet mean it has no inbuilt cameras, thus it restricts the users visability."
	icon_state = "hardsuit0-ancient"
	item_state = "anc_helm"
	armor = list("melee" = 80, "bullet" = 70, "laser" = 70, "energy" = 70, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	item_color = "ancient"
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	sprite_sheets = null

/obj/item/clothing/suit/space/hardsuit/archaeology/on_mob_move()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.wear_suit != src)
		return
	if(footstep > 1)
		playsound(src, 'sound/effects/servostep.ogg', 100, 1)
		footstep = 0
	else
		footstep++
	..()

/////////BUM FLUFF ARTIFACTS AND BONES////////////

/obj/item/archaeology/finished/alien_claw
	name = "ancient claw"
	desc = "The fossilized claw of some ancient beast."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "claws"
	force = 7
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/alien_skull
	name = "ancient skull"
	desc = "The fossilized skull of a prehistoric alien humanoid."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "skull"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/tentacle
	name = "fossilized tentacle"
	desc = "An ancient tentacle, possibly from an ancestor of the common Lavaland Goliath."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "tentacle"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/necklace
	name = "ancient necklace"
	desc = "A prehistoric necklace, little more than a stringed rock with a crude engraving."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "necklace"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/necklace2
	name = "brass necklace"
	desc = "A brass necklace, it bears a small engraving of a cog. Metallurgy analysis indicates it's over 10,000 standard years old."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "necklace2"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/necklace3
	name = "ancient luck charm"
	desc = "An old lucky charm. Metallurgy analysis suggests it's of Terran origin, possibly from the first space explorers."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "necklace3"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/necklace4
	name = "religious artifact"
	desc = "An ancient rosary. The symbolism suggests it is a relic of a human religion, possibly from the first space explorers."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "necklace4"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/cube
	name = "ancient cube"
	desc = "An inscribed cube from a bygone age. The runes do not match with any known galactic language."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "cube"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/redcube
	name = "ancient cube"
	desc = "An inscribed cube from a bygone age. The runes do not match with any known galactic language."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "red_cube"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/bluecube
	name = "ancient cube"
	desc = "An inscribed cube from a bygone age. The runes do not match with any known galactic language."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "blue_cube"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/ship
	name = "ship in a bottle"
	desc = "It appears to be a miniature model of an ancient dragon ship. Such vessels were common in the prehistories of several different galactic races."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "ship_bottle"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/unknown
	name = "anomalous artifact"
	desc = "Mysterious technological artifact of unknown origin. It is causing minor blue space disruption around itself."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "anomaly core"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/vase
	name = "Xuantong vase"
	desc = "A vase from the Xuantong dynasty. It is extremely rare to find intact, pre-collapse pottery from the once galaxy spanning Heavenly Empire."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "vase"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/mirror
	name = "ancient mirror"
	desc = "An ancient mirror, surprisingly unbroken. Iconography on the mirror suggests Akarmenid origin."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "vase"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/katana
	name = "wooden sword"
	desc = "A well preserved wooden sword, likely once used for training. It is useless as a weapon."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "katana"
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/gladius
	name = "rusty gladius"
	desc = "An ancient sword, perhaps of Vox origin. The ravages of time have not been kind to it."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "rustysword"
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/hand
	name = "mummified hand"
	desc = "The severed hand of a long dead being, mummified from exposure to space. Bio analysis suggests it is from a carbon based life form that lived 3,000 standard years ago."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "mummyhand"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/rock
	name = "warpstone rock"
	desc = "Volcanic rock from Lavaland, with clear signs of warpstone trapped inside of it."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "glowing"
	force = 5
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/femur
	name = "fossilized bone"
	desc = "The fossilized bone of a remarkably large creature. Carbon dating suggests it is over 75 million standard years old."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "femur"
	force = 5
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/egg
	name = "fossilized egg"
	desc = "A fossilized egg that never hatched. Carbon dating suggests it is over 55 million standard years old."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "egg"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/bigclaw
	name = "fossilized claw"
	desc = "A large, fossilized claw. Carbon dating suggests it is around 15 million standard years old."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "bigclaw"
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/brassspear
	name = "brass spear"
	desc = "A well preserved brass spear. It is covered in the iconography of an unknown culture or religion."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "brassspear"
	force = 10
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/clockeye
	name = "clockwork eye"
	desc = "A surprisingly complex clockwork eye. The slow march of time has rendered it inoperable."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "clockworkeye"
	force = 1
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/prism
	name = "ancient prism"
	desc = "A shard of obsidian cut into a perfectly proportioned prism. Mineral analysis suggests Lavaland as the source of the obsidian used."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "prism"
	force = 1
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/gem
	name = "ancient jewel"
	desc = "An ancient jewel, cut into a perfect oval. Markings suggest it was once embedded into a larger item or structure."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "gem"
	force = 1
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/armour
	name = "ancient armour"
	desc = "An ancient suit of armour. Analysis suggests it is around 10,000 years old, likely of Kidan origin."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "ancientarmour"
	force = 1
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/cog
	name = "brass cog"
	desc = "An ancient brass cog. It was likely once part of a much larger contraption, lost to time."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "cog"
	force = 1
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/massiveskull
	name = "massive skull"
	desc = "An enormous skull. It is far too large for a normal display case and must be placed on one of the larger display platforms."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "massiveskull"
	force = 1
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/archaeology/finished/advmech
	name = "advanced mech"
	desc = "An enormous mechsuit of advanced origin. It is far too large for a normal display case and must be placed on one of the larger display platforms."
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "bigmech"
	force = 1
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_speed = 3
	throw_range = 6