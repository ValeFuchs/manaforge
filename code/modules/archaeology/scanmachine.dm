/obj/machinery/archaeology_scanner
	icon = 'icons/obj/archaeology.dmi'
	icon_state = "analyzer-idle"
	name = "artifact restorer"
	desc = "A device that scans and restores archaeological artifacts."
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	active_power_usage = 5000
	var/obj/item/loaded_item = null
	var/shocked = 0
	var/disabled = 0
	var/time_coeff = 1
	var/component_coeff = 1
	var/working = FALSE
	var/decon_mod = 0
	var/id
	var/part_set
	var/screen = "main"
	var/temp

/obj/machinery/archaeology_scanner/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/archan(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stock_parts/micro_laser(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	RefreshParts()

/obj/machinery/archaeology_scanner/upgraded/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/archan(null)
	component_parts += new /obj/item/stock_parts/manipulator/pico(null)
	component_parts += new /obj/item/stock_parts/micro_laser/ultra(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	RefreshParts()

/obj/machinery/archaeology_scanner/Destroy()
	GET_COMPONENT(materials, /datum/component/material_container)
	materials.retrieve_all()
	return ..()

/obj/machinery/archaeology_scanner/RefreshParts()
	var/T = 0
	//resources adjustment coefficient (1 -> 0.85 -> 0.7 -> 0.55)
	T = 1.15
	for(var/obj/item/stock_parts/micro_laser/Ma in component_parts)
		T -= Ma.rating*0.15
	component_coeff = T

	//building time adjustment coefficient (1 -> 0.8 -> 0.6)
	T = -1
	for(var/obj/item/stock_parts/manipulator/Ml in component_parts)
		T += Ml.rating
	time_coeff = round(initial(time_coeff) - (initial(time_coeff)*(T))/5,0.01)

/obj/machinery/archaeology_scanner/attack_hand(mob/user)
	user.set_machine(src)
	var/dat = "<center>"
	if(working)
		dat += "<b>Restoration in progress...</b> [loaded_item]<br>"
	else if(loaded_item)
		dat += "<b>Loaded Item:</b> [loaded_item]<br>"
		dat += "<br><b><a href='byond://?src=[UID()];item=\ref[loaded_item];function=makerelic'>Begin Restoration</A></b><br>"
		dat += "<br><b><a href='byond://?src=[UID()];function=eject'>Eject</A>"
	else
		dat += "<b>Nothing loaded.</b>"
	dat += "<br><a href='byond://?src=[UID()];function=refresh'>Refresh</A><br>"
	dat += "<br><a href='byond://?src=[UID()];close=1'>Close</A><br></center>"
	var/datum/browser/popup = new(user, "scanmachine","Artifact Restorer", 700, 400, src)
	popup.set_content(dat)
	popup.open()
	onclose(user, "scanmachine")

/obj/machinery/archaeology_scanner/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)

	var/scantype = href_list["function"]
	var/obj/item/process = locate(href_list["item"]) in src

	if(href_list["close"])
		usr << browse(null, "window=scanmachine")
		return

	else if(scantype == "makerelic")
		working = TRUE
		src.updateUsrDialog()
		use_power(750)
		make_relic()
		src.updateUsrDialog()
		return

	else if(scantype == "eject")
		var/turf/dropturf = drop_location()
		if(!dropturf) //Failsafe to prevent the object being lost in the void forever.
			dropturf = get_turf(src)
		loaded_item.loc = dropturf
		loaded_item = null
		src.updateUsrDialog()

	else if(scantype == "refresh")
		src.updateUsrDialog()

	else
		if(!loaded_item)
			updateUsrDialog() //Set the interface to unloaded mode
			to_chat(usr, "<span class='warning'>[src] is not currently loaded!</span>")
			return
		else if(!process || process != loaded_item) //Interface exploit protection (such as hrefs or swapping items with interface set to old item)
			updateUsrDialog() //Refresh interface to update interface hrefs
			to_chat(usr, "<span class='danger'>Interface failure detected in [src]. Please try again.</span>")
			return
		else
			to_chat(usr, "<span class='danger'>This is an error. If you're seeing this, tell Valence to unfuck scanmachine.dm</span>")
			return

/obj/machinery/archaeology_scanner/proc/make_relic()
	flick("analyzer-active", src)
	sleep((17 * time_coeff)+(17 * component_coeff))
	if(istype(loaded_item, /obj/item/archaeology/artifact/prepared/fossil))

		var/loot = rand(1, 196)
		switch(loot)
			if(1 to 10)
				new /obj/item/archaeology/finished/alien_claw(drop_location())
			if(11 to 20)
				new /obj/item/archaeology/finished/alien_skull(drop_location())
			if(21 to 30)
				new /obj/item/archaeology/finished/tentacle(drop_location())
			if(31 to 40)
				new /obj/item/archaeology/finished/necklace(drop_location())
			if(41 to 50)
				new /obj/item/archaeology/finished/mirror(drop_location())
			if(51 to 60)
				new /obj/item/archaeology/finished/necklace2(drop_location())
			if(61 to 70)
				new /obj/item/archaeology/finished/necklace3(drop_location())
			if(71 to 80)
				new /obj/item/archaeology/finished/necklace4(drop_location())
			if(81 to 82)
				new /obj/item/archaeology/finished/cube(drop_location())
			if(83 to 84)
				new /obj/item/archaeology/finished/redcube(drop_location())
			if(85 to 86)
				new /obj/item/archaeology/finished/bluecube(drop_location())
			if(87 to 90)
				new /obj/item/archaeology/finished/ship(drop_location())
			if(91)
				new /obj/item/archaeology/finished/vase(drop_location())
			if(92 to 95)
				new /obj/item/archaeology/finished/katana(drop_location())
			if(96 to 100)
				new /obj/item/archaeology/finished/gladius(drop_location())
			if(101 to 105)
				new /obj/item/archaeology/finished/hand(drop_location())
			if(106 to 115)
				new /obj/item/archaeology/finished/rock(drop_location())
			if(116 to 129)
				new /obj/item/archaeology/finished/femur(drop_location())
			if(130 to 140)
				new /obj/item/archaeology/finished/egg(drop_location())
			if(141 to 150)
				new /obj/item/archaeology/finished/bigclaw(drop_location())
			if(151 to 156)
				new /obj/item/archaeology/finished/brassspear(drop_location())
			if(157 to 158)
				new /obj/item/archaeology/finished/prism(drop_location())
			if(159 to 161)
				new /obj/item/archaeology/finished/gem(drop_location())
			if(162 to 171)
				new /obj/item/archaeology/finished/cog(drop_location())
			if(172 to 185)
				new /obj/item/archaeology/finished/massiveskull(drop_location())
			if(186 to 187)
				new /obj/item/melee/rapier/archaeology(drop_location())
			if(188 to 195)
				new /obj/item/twohanded/spear/archaeology(drop_location())
			if(196)
				new /obj/item/twohanded/dualsaber/archaeology(drop_location())

		qdel(loaded_item)
		loaded_item = null
		working = FALSE


	else if(istype(loaded_item, /obj/item/archaeology/artifact/prepared/tech))
		var/loot = rand(1, 76)
		switch(loot)
			if(1 to 4)
				new /obj/item/archaeology/finished/necklace(drop_location())
			if(5 to 10)
				new /obj/item/archaeology/finished/mirror(drop_location())
			if(11 to 12)
				new /obj/item/archaeology/finished/necklace2(drop_location())
			if(13 to 15)
				new /obj/item/archaeology/finished/necklace3(drop_location())
			if(16 to 20)
				new /obj/item/archaeology/finished/necklace4(drop_location())
			if(21 to 22)
				new /obj/item/archaeology/finished/cube(drop_location())
			if(23 to 24)
				new /obj/item/archaeology/finished/redcube(drop_location())
			if(25 to 26)
				new /obj/item/archaeology/finished/bluecube(drop_location())
			if(27 to 30)
				new /obj/item/archaeology/finished/ship(drop_location())
			if(31)
				new /obj/item/archaeology/finished/vase(drop_location())
			if(32 to 40)
				new /obj/item/archaeology/finished/unknown(drop_location())
			if(41 to 46)
				new /obj/item/archaeology/finished/brassspear(drop_location())
			if(47 to 48)
				new /obj/item/archaeology/finished/clockeye(drop_location())
			if(49 to 55)
				new /obj/item/archaeology/finished/armour(drop_location())
			if(56 to 61)
				new /obj/item/archaeology/finished/cog(drop_location())
			if(62 to 69)
				new /obj/item/archaeology/finished/advmech(drop_location())
			if(70 to 71)
				new /obj/item/gun/energy/laser/archaeology(drop_location())
			if(72 to 75)
				new /obj/item/clothing/suit/space/hardsuit/archaeology(drop_location())
			if(76)
				new /obj/item/twohanded/dualsaber/archaeology(drop_location())

		qdel(loaded_item)
		loaded_item = null
		working = FALSE

	else if(istype(loaded_item, /obj/item/archaeology/artifact/prepared/rare)) //guaranteed good shit so random numbers never fucks you
		var/loot = rand(1, 3)
		switch(loot)
			if(1)
				new /obj/item/gun/energy/laser/archaeology(drop_location())
			if(2)
				new /obj/item/twohanded/dualsaber/archaeology(drop_location())
			if(3)
				new /obj/item/clothing/suit/space/hardsuit/archaeology(drop_location())

		qdel(loaded_item)
		loaded_item = null
		working = FALSE

	else
		working = FALSE
		..()	//to_chat(usr, "<span class='danger'>Make_relic() was called without a valid relic in the machine. If you're seeing this, tell Valence to unfuck scanmachine.dm</span>")

/obj/machinery/archaeology_scanner/attackby(obj/item/O, mob/user, params)
	if(shocked)
		shock(user,50)

	if(default_deconstruction_screwdriver(user, "analyzer-o", "analyzer-idle", O))
		return

	if(exchange_parts(user, O))
		return

	if(panel_open && istype(O, /obj/item/crowbar))
		default_deconstruction_crowbar(user, O)
		return
	if(disabled)
		return
	if(loaded_item)
		to_chat(user, "<span class='warning'>The [src] is already loaded.</span>")
		return
	if(istype(O, /obj/item))
		if(!istype(O, /obj/item/archaeology/artifact))
			to_chat(user, "<span class='warning'>This item does not go into the restorer!</span>")
			return

		if(!istype(O, /obj/item/archaeology/artifact/prepared))
			to_chat(user, "<span class='warning'>The [O] must be cleaned and prepared for restoration first!</span>")
			return

		if(!user.drop_item())
			return
		overlays += "analyzer-in"
		loaded_item = O
		O.loc = src
		to_chat(user, "<span class='notice'>You place the [O.name] into the machine.</span>")
		sleep(6)
		overlays -= "analyzer-in"

	return