//This has been ported from /TG/Station, who took it from /vg/station13, which was in turn forked from baystation12;
//Please do not bother them with bugs from this port, however, as it has been modified quite a bit and then modified again.
//Modifications include removing the world-ending full supermatter variation, and leaving only the shard.
//Glad to see we're all constantly "sharing" shit with eachother guys

//Just call tesla zapping you did all this unnecessary work smh


#define PLASMA_HEAT_PENALTY 15     // Higher == Bigger heat and waste penalty from having the crystal surrounded by this gas. Negative numbers reduce penalty.
#define OXYGEN_HEAT_PENALTY 1
#define CO2_HEAT_PENALTY 0.1
#define NITROGEN_HEAT_PENALTY -1.5


//All of these get divided by 10-bzcomp * 5 before having 1 added and being multiplied with power to determine rads
//Keep the negative values here above -10 and we won't get negative rads
#define OXYGEN_TRANSMIT_MODIFIER 1.5   //Higher == Bigger bonus to power generation.
#define PLASMA_TRANSMIT_MODIFIER 4




#define POWERLOSS_INHIBITION_GAS_THRESHOLD 0.20         //Higher == Higher percentage of inhibitor gas needed before the charge inertia chain reaction effect starts.
#define POWERLOSS_INHIBITION_MOLE_THRESHOLD 20        //Higher == More moles of the gas are needed before the charge inertia chain reaction effect starts.        //Scales powerloss inhibition down until this amount of moles is reached
#define POWERLOSS_INHIBITION_MOLE_BOOST_THRESHOLD 500  //bonus powerloss inhibition boost if this amount of moles is reached

#define MOLE_PENALTY_THRESHOLD 1800           //Above this value we can get lord singulo and independent mol damage, below it we can heal damage
#define MOLE_HEAT_PENALTY 350                 //Heat damage scales around this. Too hot setups with this amount of moles do regular damage, anything above and below is scaled
//Along with damage_penalty_point, makes flux anomalies.
#define POWER_PENALTY_THRESHOLD 5000          //The cutoff on power properly doing damage, pulling shit around, and delamming into a tesla. Low chance of pyro anomalies, +2 bolts of electricity
#define SEVERE_POWER_PENALTY_THRESHOLD 7000   //+1 bolt of electricity, allows for gravitational anomalies, and higher chances of pyro anomalies
#define CRITICAL_POWER_PENALTY_THRESHOLD 9000 //+1 bolt of electricity.
#define HEAT_PENALTY_THRESHOLD 40             //Higher == Crystal safe operational temperature is higher.
#define DAMAGE_HARDCAP 0.002
#define DAMAGE_INCREASE_MULTIPLIER 0.25


#define THERMAL_RELEASE_MODIFIER 5         //Higher == less heat released during reaction, not to be confused with the above values
#define PLASMA_RELEASE_MODIFIER 750        //Higher == less plasma released by reaction
#define OXYGEN_RELEASE_MODIFIER 325        //Higher == less oxygen released at high temperature/power

#define REACTION_POWER_MODIFIER 0.55       //Higher == more overall power

#define MATTER_POWER_CONVERSION 10         //Crystal converts 1/this value of stored matter into energy.

//These would be what you would get at point blank, decreases with distance
#define DETONATION_RADS 200
#define DETONATION_HALLUCINATION 600


#define WARNING_DELAY 20

#define HALLUCINATION_RANGE(P) (min(7, round(P ** 0.25)))


#define GRAVITATIONAL_ANOMALY "gravitational_anomaly"
#define FLUX_ANOMALY "flux_anomaly"
#define PYRO_ANOMALY "pyro_anomaly"

//If integrity percent remaining is less than these values, the monitor sets off the relevant alarm.
#define SUPERMATTER_DELAM_PERCENT 5
#define SUPERMATTER_EMERGENCY_PERCENT 50
#define SUPERMATTER_DANGER_PERCENT 75
#define SUPERMATTER_WARNING_PERCENT 100
#define CRITICAL_TEMPERATURE 10000

#define SUPERMATTER_COUNTDOWN_TIME 30 SECONDS

///to prevent accent sounds from layering
#define SUPERMATTER_ACCENT_SOUND_MIN_COOLDOWN 2 SECONDS

#define DEFAULT_ZAP_ICON_STATE "sm_arc"
#define SLIGHTLY_CHARGED_ZAP_ICON_STATE "sm_arc_supercharged"
#define OVER_9000_ZAP_ICON_STATE "sm_arc_dbz_referance" //Witty I know

GLOBAL_DATUM(main_supermatter_engine, /obj/machinery/power/supermatter_crystal)

/obj/machinery/power/supermatter_crystal
	name = "the Warpstone Crystal"
	desc = "A strangely translucent and iridescent crystal. <span class='danger'>You get headaches just from looking at it, but it's hard to stop staring.</span>"
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "darkmatter"
	density = 1
	anchored = TRUE

	var/zap_icon = DEFAULT_ZAP_ICON_STATE


	light_range = 4
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF



	//If we ever start to care about all gasses, make this based on type and apply it as a for loop
	var/list/gas_trans = list("PL" = PLASMA_TRANSMIT_MODIFIER, "O2" = OXYGEN_TRANSMIT_MODIFIER)
	var/gasefficency = 0.15

	var/base_icon_state = "darkmatter"

	var/final_countdown = FALSE

	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Warpstone hyperstructure returning to safe operating parameters."
	var/warning_point = 50
	var/warning_alert = "Danger! Warpstone hyperstructure instability detected!"
	var/damage_penalty_point = 550
	var/emergency_point = 650
	var/tell_station = 450
	var/tell_alert = "Warning! Warpstone integrity is failing!"
	var/emergency_alert = "WARPSTONE DELAMINATION IMMINENT."
	var/explosion_point = 900

	var/emergency_issued = FALSE

	var/explosion_power = 35
	var/temp_factor = 30

	var/lastwarning = 0                // Time in 1/10th of seconds since the last sent warning
	var/power = 0
	///Determines the rate of positve change in gas comp values
	var/gas_change_rate = 0.05
	///Ranging from 0 to 1, this is used to judge gas composition. It doesn't perfectly match the air around the sm, instead moving up at a rate determined by gas_change_rate per call
	var/n2comp = 0                    // raw composition of each gas in the chamber, ranges from 0 to 1
	var/plasmacomp = 0
	var/o2comp = 0
	var/co2comp = 0
	var/n2ocomp = 0

	///The last air sample's total molar count, will always be above or equal to 0
	var/combined_gas = 0
	var/gasmix_power_ratio = 0
	var/dynamic_heat_modifier = 1
	var/dynamic_heat_resistance = 1
	var/powerloss_inhibitor = 1
	var/powerloss_dynamic_scaling= 0
	var/power_transmission_bonus = 0
	var/mole_heat_penalty = 0
	var/matter_power = 0
	//The cutoff for a bolt jumping, grows with heat, lowers with higher mol count,
	var/zap_cutoff = 1500
	//Temporary values so that we can optimize this
	//How much the bullets damage should be multiplied by when it is added to the internal variables
	var/config_bullet_energy = 2
	//How much of the power is left after processing is finished?
	//    var/config_power_reduction_per_tick = 0.5
	//How much hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.1

	var/obj/item/radio/radio
	var/radio_key = /obj/item/encryptionkey/headset_eng
	var/engineering_channel = "Engineering"
	var/common_channel = null

	//for logging
	var/has_been_powered = FALSE
	var/has_reached_emergency = FALSE

	// For making hugbox supermatter
	var/takes_damage = TRUE
	var/produces_gas = TRUE
	var/obj/effect/countdown/supermatter/countdown

	var/is_main_engine = FALSE

	var/datum/looping_sound/supermatter/soundloop

	var/moveable = FALSE

	/// cooldown tracker for accent sounds,
	var/last_accent_sound = 0

	//admin shit
	var/disable_adminwarn = TRUE

	var/aw_normal = FALSE
	var/aw_notify = FALSE
	var/aw_warning = FALSE
	var/aw_danger = FALSE
	var/aw_emerg = FALSE
	var/aw_delam = FALSE



/obj/machinery/power/supermatter_crystal/Initialize()
	. = ..()
	uid = gl_uid++
	SSair.atmos_machinery += src
	countdown = new(src)
	countdown.start()
	GLOB.poi_list |= src
	radio = new(src)
	radio.config(list("Engineering" = 0))
	radio.listening = 0
	investigate_log("has been created.", "warpstone")
	if(is_main_engine)
		GLOB.main_supermatter_engine = src




	soundloop = new(list(src), TRUE)

/obj/machinery/power/supermatter_crystal/proc/handle_admin_warnings()
	if(disable_adminwarn)
		return

	// Generic checks, similar to checks done by supermatter monitor program.
	aw_normal = status_adminwarn_check(SUPERMATTER_NORMAL, aw_normal, "INFO: Warpstone crystal has been energised.<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.", FALSE)
	aw_notify = status_adminwarn_check(SUPERMATTER_NOTIFY, aw_notify, "INFO: Warpstone crystal is approaching unsafe operating temperature.<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.", FALSE)
	aw_warning = status_adminwarn_check(SUPERMATTER_WARNING, aw_warning, "WARN: Warpstone crystal is taking integrity damage!<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.", FALSE)
	aw_danger = status_adminwarn_check(SUPERMATTER_DANGER, aw_danger, "WARN: Warpstone integrity is below 75%!<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.", TRUE)
	aw_emerg = status_adminwarn_check(SUPERMATTER_EMERGENCY, aw_emerg, "CRIT: Warpstone integrity is below 50%!<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.", FALSE)
	aw_delam = status_adminwarn_check(SUPERMATTER_DELAMINATING, aw_delam, "CRIT: Warpstone is delaminating!<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.", TRUE)

/obj/machinery/power/supermatter_crystal/proc/status_adminwarn_check(var/min_status, var/current_state, var/message, var/send_to_irc = FALSE)
	var/status = get_status()
	if(status >= min_status)
		if(!current_state)
			log_and_message_admins(message)
			if(send_to_irc)
				send2adminirc(message)
		return TRUE
	else
		return FALSE

/obj/machinery/power/supermatter_crystal/Destroy()
	investigate_log("has been destroyed.", "warpstone")
	SSair.atmos_machinery -= src
	QDEL_NULL(radio)
	GLOB.poi_list -= src
	QDEL_NULL(countdown)
	if(is_main_engine && GLOB.main_supermatter_engine == src)
		GLOB.main_supermatter_engine = null
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/power/supermatter_crystal/examine(mob/user as mob)
	. = ..()
	for(var/mob/living/carbon/human/C in view(src, min(7, round(sqrt(power/6)))))
		if(C.glasses && istype(C.glasses, /obj/item/clothing/glasses/meson))
			continue
		var/obj/item/organ/internal/eyes/eyes = C.get_int_organ(/obj/item/organ/internal/eyes)
		if(!istype(eyes))
			continue
		. += "<span class='danger'>You get headaches just from looking at it, but it's hard to stop staring.</span>"

/obj/machinery/power/supermatter_crystal/proc/get_status()
	var/turf/T = get_turf(src)
	if(!T)
		return SUPERMATTER_ERROR
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return SUPERMATTER_ERROR

	var/integrity = get_integrity()
	if(integrity < SUPERMATTER_DELAM_PERCENT)
		return SUPERMATTER_DELAMINATING

	if(integrity < SUPERMATTER_EMERGENCY_PERCENT)
		return SUPERMATTER_EMERGENCY

	if(integrity < SUPERMATTER_DANGER_PERCENT)
		return SUPERMATTER_DANGER

	if((integrity < SUPERMATTER_WARNING_PERCENT) || (air.temperature > CRITICAL_TEMPERATURE))
		return SUPERMATTER_WARNING

	if(air.temperature > (CRITICAL_TEMPERATURE * 0.8))
		return SUPERMATTER_NOTIFY

	if(power > 5)
		return SUPERMATTER_NORMAL
	return SUPERMATTER_INACTIVE

/obj/machinery/power/supermatter_crystal/proc/alarm()
	switch(get_status())
		if(SUPERMATTER_DELAMINATING)
			playsound(src, 'sound/misc/bloblarm.ogg', 100)
		if(SUPERMATTER_EMERGENCY)
			playsound(src, 'sound/machines/engine_alert1.ogg', 100)
		if(SUPERMATTER_DANGER)
			playsound(src, 'sound/machines/engine_alert2.ogg', 100)
		if(SUPERMATTER_WARNING)
			playsound(src, 'sound/machines/terminal_alert.ogg', 75)

/obj/machinery/power/supermatter_crystal/proc/get_integrity()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100, 0.01)
	integrity = integrity < 0 ? 0 : integrity
	return integrity

/obj/machinery/power/supermatter_crystal/proc/countdown()
	set waitfor = FALSE

	if(final_countdown) // We're already doing it go away
		return
	final_countdown = TRUE

	var/image/causality_field = image(icon, null, "causality_field")
	add_overlay(causality_field, TRUE)

	var/speaking = "[emergency_alert] The warpstone has reached critical integrity failure. Emergency Gellar Field engaged."
	radio.autosay(speaking, "Warpstone Monitor")
	for(var/i in SUPERMATTER_COUNTDOWN_TIME to 0 step -10)
		if(damage < explosion_point) // Cutting it a bit close there engineers
			radio.autosay("[safe_alert] Failsafe has been disengaged.", "Warpstone Monitor")
			cut_overlay(causality_field, TRUE)
			final_countdown = FALSE
			return
		else if((i % 50) != 0 && i > 50) // A message once every 5 seconds until the final 5 seconds which count down individualy
			sleep(10)
			continue
		else if(i > 50)
			speaking = "[DisplayTimeText(i, TRUE)] remain before Gellar Field failure."
		else
			speaking = "[i*0.1]..."
		radio.autosay(speaking, "Warpstone Monitor")
		sleep(10)

	explode()

/obj/machinery/power/supermatter_crystal/proc/explode()
	for(var/mob in GLOB.living_mob_list)
		var/mob/living/L = mob
		if(istype(L) && L.z == z)
			if(ishuman(mob))
				//Hilariously enough, running into a closet should make you get hit the hardest.
				var/mob/living/carbon/human/H = mob
				H.hallucination += max(50, min(300, DETONATION_HALLUCINATION * sqrt(1 / (get_dist(mob, src) + 1)) ) )
			var/rads = DETONATION_RADS * sqrt( 1 / (get_dist(L, src) + 1) )
			L.apply_effect(rads, IRRADIATE)

	var/turf/T = get_turf(src)
	for(var/mob/M in GLOB.player_list)
		if(M.z == z)
			to_chat(M, "<span class='boldannounce'>You feel reality distort for a moment...</span>")

	if(combined_gas > MOLE_PENALTY_THRESHOLD)
		investigate_log("has collapsed into a singularity.", "warpstone")
		if(T) //If something fucks up we blow anyhow. This fix is 4 years old and none ever said why it's here. help.
			var/obj/singularity/S = new(T)
			S.energy = 800
			S.consume(src)
			return //No boom for me sir
	else if(power > POWER_PENALTY_THRESHOLD)
		investigate_log("has spawned additional energy balls.", "warpstone")
		if(T)
			var/obj/singularity/energy_ball/E = new(T)
			E.energy = power
	investigate_log("has exploded.", "warpstone")
	explosion(get_turf(T), explosion_power * max(gasmix_power_ratio, 0.205) * 0.5 , explosion_power * max(gasmix_power_ratio, 0.205) + 2, explosion_power * max(gasmix_power_ratio, 0.205) + 4 , explosion_power * max(gasmix_power_ratio, 0.205) + 6, 1, 1)

	//Time to get crazy
	for(var/mob/M in GLOB.mob_list)
		M << 'sound/effects/warpexplosion.ogg'
	set_security_level(4)
	SSshuttle.emergencyNoEscape = 1
	new/datum/event/warpstorm
	qdel(src)


//this is here to eat arguments
/obj/machinery/power/supermatter_crystal/proc/call_explode()
	explode()

/obj/machinery/power/supermatter_crystal/process_atmos()
	var/turf/T = loc

	if(isnull(T))// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(T))//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return  //Yeah just stop.

	//We vary volume by power, and handle OH FUCK FUSION IN COOLING LOOP noises.
	if(power)
		soundloop.volume = clamp((50 + (power / 50)), 50, 100)
	if(damage >= 300)
		soundloop.mid_sounds = list('sound/machines/sm/loops/delamming.ogg' = 1)
	else
		soundloop.mid_sounds = list('sound/machines/sm/loops/calm.ogg' = 1)

	//We play delam/neutral sounds at a rate determined by power and damage
	if(last_accent_sound < world.time && prob(20))
		var/aggression = min(((damage / 800) * (power / 2500)), 1.0) * 100
		if(damage >= 300)
			playsound(src, "smdelam", max(50, aggression), FALSE, 10)
		else
			playsound(src, "smcalm", max(50, aggression), FALSE, 10)
		var/next_sound = round((100 - aggression) * 5)
		last_accent_sound = world.time + max(SUPERMATTER_ACCENT_SOUND_MIN_COOLDOWN, next_sound)

	//Ok, get the air from the turf
	var/datum/gas_mixture/env = T.return_air()

	var/datum/gas_mixture/removed
	if(produces_gas)
		//Remove gas from surrounding area
		removed = env.remove(gasefficency * env.total_moles())
	else
		// Pass all the gas related code an empty gas container
		removed = new()

	damage_archived = damage
	if(!removed || !removed.total_moles() || isspaceturf(T)) //we're in space or there is no gas to process
		if(takes_damage)
			damage += max((power / 1000) * DAMAGE_INCREASE_MULTIPLIER, 0.1) // always does at least some damage
	else
		if(takes_damage)
			//causing damage
			//Due to DAMAGE_INCREASE_MULTIPLIER, we only deal one 4th of the damage the statements otherwise would cause

			//((((some value between 0.5 and 1 * temp - ((273.15 + 40) * some values between 1 and 6)) * some number between 0.25 and knock your socks off / 150) * 0.25
			//Heat and mols account for each other, a lot of hot mols are more damaging then a few
			//Mols start to have a positive effect on damage after 350
			damage = max(damage + (max(clamp(removed.total_moles() / 200, 0.5, 1) * removed.temperature - ((T0C + HEAT_PENALTY_THRESHOLD)*dynamic_heat_resistance), 0) * mole_heat_penalty / 150 ) * DAMAGE_INCREASE_MULTIPLIER, 0)
			//Power only starts affecting damage when it is above 5000
			damage = max(damage + (max(power - POWER_PENALTY_THRESHOLD, 0)/500) * DAMAGE_INCREASE_MULTIPLIER, 0)
			//Molar count only starts affecting damage when it is above 1800
			damage = max(damage + (max(combined_gas - MOLE_PENALTY_THRESHOLD, 0)/80) * DAMAGE_INCREASE_MULTIPLIER, 0)

			//There might be a way to integrate healing and hurting via heat
			//healing damage
			if(combined_gas < MOLE_PENALTY_THRESHOLD)
				//Only heals damage when the temp is below 313.15, heals up to 2 damage
				damage = max(damage + (min(removed.temperature - (T0C + HEAT_PENALTY_THRESHOLD), 0) / 150 ), 0)

			//caps damage rate

			//Takes the lower number between archived damage + (1.8) and damage
			//This means we can only deal 1.8 damage per function call
			damage = min(damage_archived + (DAMAGE_HARDCAP * explosion_point),damage)

		var/device_energy = power * REACTION_POWER_MODIFIER

		//calculating gas related values
		//Wanna know a secret? See that max() to zero? it's used for error checking. If we get a mol count in the negative, we'll get a divide by zero error
		combined_gas = max(removed.total_moles(), 0)

		//This is more error prevention, according to all known laws of atmos, gas_mix.remove() should never make negative mol values.
		//But this is SS13

		//Lets get the proportions of the gasses in the mix and then slowly move our comp to that value
		//Can cause an overestimation of mol count, should stabalize things though.
		//Prevents huge bursts of gas/heat when a large amount of something is introduced
		//They range between 0 and 1
		plasmacomp += clamp(max(removed.toxins / combined_gas, 0) - plasmacomp, -1, gas_change_rate)
		o2comp += clamp(max(removed.oxygen / combined_gas, 0) - o2comp, -1, gas_change_rate)
		co2comp += clamp(max(removed.carbon_dioxide / combined_gas, 0) - co2comp, -1, gas_change_rate)
		n2comp += clamp(max(removed.nitrogen / combined_gas, 0) - n2comp, -1, gas_change_rate)

		//No less then zero, and no greater then one, we use this to do explosions and heat to power transfer
		gasmix_power_ratio = min(max((plasmacomp + o2comp + co2comp - n2comp), 0), 1)

		//Minimum value of 1.5, maximum value of 23
		dynamic_heat_modifier = plasmacomp * PLASMA_HEAT_PENALTY
		dynamic_heat_modifier += o2comp * OXYGEN_HEAT_PENALTY
		dynamic_heat_modifier += co2comp * CO2_HEAT_PENALTY
		dynamic_heat_modifier += n2comp * NITROGEN_HEAT_PENALTY
		dynamic_heat_modifier = max(dynamic_heat_modifier, 0.5)

		//Value between 30 and -5, used to determine radiation output as it concerns things like collectors
		power_transmission_bonus = plasmacomp * gas_trans["PL"]
		power_transmission_bonus += o2comp * gas_trans["O2"]

		//more moles of gases are harder to heat than fewer, so let's scale heat damage around them
		mole_heat_penalty = max(combined_gas / MOLE_HEAT_PENALTY, 0.25)

		//Ramps up or down in increments of 0.02 up to the proportion of co2
		//Given infinite time, powerloss_dynamic_scaling = co2comp
		//Some value between 0 and 1
		if (combined_gas > POWERLOSS_INHIBITION_MOLE_THRESHOLD && co2comp > POWERLOSS_INHIBITION_GAS_THRESHOLD) //If there are more then 20 mols, or more then 20% co2
			powerloss_dynamic_scaling = clamp(powerloss_dynamic_scaling + clamp(co2comp - powerloss_dynamic_scaling, -0.02, 0.02), 0, 1)
		else
			powerloss_dynamic_scaling = clamp(powerloss_dynamic_scaling - 0.05,0, 1)
		//Ranges from 0 to 1(1-(value between 0 and 1 * ranges from 1 to 1.5(mol / 500)))
		//We take the mol count, and scale it to be our inhibitor
		powerloss_inhibitor = clamp(1-(powerloss_dynamic_scaling * clamp(combined_gas/POWERLOSS_INHIBITION_MOLE_BOOST_THRESHOLD,1 ,1.5)),0 ,1)

		//Releases stored power into the general pool
		//We get this by consuming shit or being scalpeled
		if(matter_power)
			//We base our removed power off one 10th of the matter_power.
			var/removed_matter = max(matter_power/MATTER_POWER_CONVERSION, 40)
			//Adds at least 40 power
			power = max(power + removed_matter, 0)
			//Removes at least 40 matter power
			matter_power = max(matter_power - removed_matter, 0)

		var/temp_factor = 50
		if(gasmix_power_ratio > 0.8)
			//with a perfect gas mix, make the power more based on heat
			icon_state = "[base_icon_state]_glow"
		else
			//in normal mode, power is less effected by heat
			temp_factor = 30
			icon_state = base_icon_state


		power = max((removed.temperature * temp_factor / T0C) * gasmix_power_ratio + power, 0)





		//To figure out how much temperature to add each tick, consider that at one atmosphere's worth
		//of pure oxygen, with all four lasers firing at standard energy and no N2 present, at room temperature
		//that the device energy is around 2140. At that stage, we don't want too much heat to be put out
		//Since the core is effectively "cold"

		//Also keep in mind we are only adding this temperature to (efficiency)% of the one tile the rock
		//is on. An increase of 4*C @ 25% efficiency here results in an increase of 1*C / (#tilesincore) overall.
		//Power * 0.55 * (some value between 1.5 and 23) / 5
		removed.temperature += ((device_energy * dynamic_heat_modifier) / THERMAL_RELEASE_MODIFIER)
		//We can only emit so much heat, that being 57500
		removed.temperature = max(0, min(removed.temperature, 2500 * dynamic_heat_modifier))

		//Calculate how much gas to release
		//Varies based on power and gas content
		removed.toxins += max((device_energy * dynamic_heat_modifier) / PLASMA_RELEASE_MODIFIER, 0)
		//Varies based on power, gas content, and heat
		removed.oxygen += max(((device_energy + removed.temperature * dynamic_heat_modifier) - T0C) / OXYGEN_RELEASE_MODIFIER, 0)

		if(produces_gas)
			env.merge(removed)
			air_update_turf()

	//Makes em go mad and accumulate rads.
	for(var/mob/living/carbon/human/l in view(src, min(7, round(sqrt(power/6)))))
		// If they can see it without mesons on.  Bad on them.
		if(l.glasses && istype(l.glasses, /obj/item/clothing/glasses/meson))
			continue
		// Where we're going, we don't need eyes.
		// Prosthetic eyes will also protect against this business.
		var/obj/item/organ/internal/eyes/eyes = l.get_int_organ(/obj/item/organ/internal/eyes)
		if(!istype(eyes))
			continue
		l.Hallucinate(min(200, l.hallucination + power * config_hallucination_power * sqrt( 1 / max(1,get_dist(l, src)))))

	for(var/mob/living/l in range(src, round((power / 100) ** 0.25)))
		var/rads = 500 * sqrt( 1 / (get_dist(l, src) + 1) )
		l.apply_effect(rads, IRRADIATE)

	handle_admin_warnings()

	//Transitions between one function and another, one we use for the fast inital startup, the other is used to prevent errors with fusion temperatures.
	//Use of the second function improves the power gain imparted by using co2
	power = max(power - min(((power/500)**3) * powerloss_inhibitor, power * 0.83 * powerloss_inhibitor),0)
	//After this point power is lowered
	//This wraps around to the begining of the function
	//Handle high power zaps/anomaly generation
	if(power > POWER_PENALTY_THRESHOLD || damage > damage_penalty_point) //If the power is above 5000 or if the damage is above 550
		var/range = 4
		zap_cutoff = 1500
		if(removed && removed.return_pressure() > 0 && removed.return_temperature() > 0)
			//You may be able to freeze the zapstate of the engine with good planning, we'll see
			zap_cutoff = clamp(3000 - (power * (removed.total_moles()) / 10) / removed.return_temperature(), 350, 3000)//If the core is cold, it's easier to jump, ditto if there are a lot of mols
			//We should always be able to zap our way out of the default enclosure
			//See supermatter_zap() for more details
			range = clamp(power / removed.return_pressure() * 10, 2, 7)
		var/flags = ZAP_SUPERMATTER_FLAGS
		var/zap_count = 0
		//Deal with power zaps
		switch(power)
			if(0 to SEVERE_POWER_PENALTY_THRESHOLD)
				zap_icon = DEFAULT_ZAP_ICON_STATE
				zap_count = 2
			if(SEVERE_POWER_PENALTY_THRESHOLD to CRITICAL_POWER_PENALTY_THRESHOLD)
				zap_icon = SLIGHTLY_CHARGED_ZAP_ICON_STATE
				//Uncaps the zap damage, it's maxed by the input power
				//Objects take damage now
				flags |= (ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE)
				zap_count = 3
			if(CRITICAL_POWER_PENALTY_THRESHOLD to INFINITY)
				zap_icon = OVER_9000_ZAP_ICON_STATE
				//It'll stun more now, and damage will hit harder, gloves are no garentee.
				//Machines go boom
				flags |= (ZAP_MOB_STUN | ZAP_MACHINE_EXPLOSIVE | ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE)
				zap_count = 4
		//Now we deal with damage shit
		if (damage > damage_penalty_point && prob(20))
			zap_count += 1

		if(zap_count >= 1)
			playsound(src.loc, 'sound/weapons/emitter2.ogg', 100, TRUE, extrarange = 10)
			for(var/i in 1 to zap_count)
				supermatter_zap(src, range, clamp(power*2, 4000, 20000), list(), flags)

		if(prob(15) && power > POWER_PENALTY_THRESHOLD)
			supermatter_pull(src, power/750)
		if(prob(5))
			supermatter_anomaly_gen(src, FLUX_ANOMALY, rand(5, 10))
		if(power > SEVERE_POWER_PENALTY_THRESHOLD && prob(5) || prob(1))
			supermatter_anomaly_gen(src, GRAVITATIONAL_ANOMALY, rand(5, 10))
		if((power > SEVERE_POWER_PENALTY_THRESHOLD && prob(2)) || (prob(0.3) && power > POWER_PENALTY_THRESHOLD))
			supermatter_anomaly_gen(src, PYRO_ANOMALY, rand(5, 10))

	//Tells the engi team to get their butt in gear
	if(damage > warning_point) // while the core is still damaged and it's still worth noting its status
		if((world.timeofday - lastwarning) / 10 >= WARNING_DELAY)
			alarm()

			//Oh shit it's bad, time to freak out
			if(damage > emergency_point)
				radio.autosay("[emergency_alert] Integrity: [get_integrity()]%", "Warpstone Monitor")
				lastwarning = world.timeofday
				if(!has_reached_emergency)
					investigate_log("has reached the emergency point for the first time.", "warpstone")
					message_admins("[src] has reached the emergency point [ADMIN_JMP(src)].")
					has_reached_emergency = 1

			else if(damage > tell_station)
				radio.autosay("[tell_alert] Integrity: [get_integrity()]%", "Warpstone Monitor")
				radio.autosay("[warning_alert] Integrity: [get_integrity()]%", "Warpstone Monitor", "Engineering")
				lastwarning = world.timeofday

			else if(damage >= damage_archived) // The damage is still going up
				radio.autosay("[warning_alert] Integrity: [get_integrity()]%", "Warpstone Monitor", "Engineering")
				lastwarning = world.timeofday - (WARNING_DELAY * 5)

			else                                                 // Phew, we're safe
				radio.autosay("[safe_alert] Integrity: [get_integrity()]%", "Warpstone Monitor", "Engineering")
				lastwarning = world.timeofday

			if(power > POWER_PENALTY_THRESHOLD)
				radio.autosay("Warning: Warpstone has reached dangerous power level.", "Warpstone Monitor", "Engineering")
				if(powerloss_inhibitor < 0.5)
					radio.autosay("DANGER: CHARGE INERTIA CHAIN REACTION IN PROGRESS.", "Warpstone Monitor", "Engineering")

			if(combined_gas > MOLE_PENALTY_THRESHOLD)
				radio.autosay("Warning: Critical coolant mass reached.", "Warpstone Monitor", "Engineering")
		//Boom (Mind blown)
		if(damage > explosion_point)
			countdown()

	transfer_energy()

	return 1

/obj/machinery/power/supermatter_crystal/proc/transfer_energy()
	for(var/obj/machinery/power/rad_collector/R in GLOB.rad_collectors)
		if(get_dist(R, src) <= 15) // Better than using orange() every process
			R.receive_pulse(power/10)
	return

/obj/machinery/power/supermatter_crystal/bullet_act(var/obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0	// This stops people from being able to really power up the supermatter
				// Then bring it inside to explode instantly upon landing on a valid turf.


	if(Proj.flag != "bullet")
		power += Proj.damage * config_bullet_energy
		if(!has_been_powered)
			investigate_log("has been powered for the first time.", "warpstone")
			message_admins("[src] has been powered for the first time <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.")
			has_been_powered = 1
	else
		damage += Proj.damage * config_bullet_energy
	supermatter_zap()
	return 0


/obj/machinery/power/supermatter_crystal/singularity_act()
	var/gain = 100
	investigate_log("Warpstone shard consumed by singularity.", "singulo")
	message_admins("Singularity has consumed a warpstone shard and can now become stage six.<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>(JMP)</a>.")
	visible_message("<span class='userdanger'>[src] is consumed by the singularity!</span>")
	for(var/mob/M in GLOB.player_list)
		if(M.z == z)
			SEND_SOUND(M, 'sound/effects/supermatter.ogg') //everyone gunna know bout this
			to_chat(M, "<span class='boldannounce'>A horrible screeching fills your ears, and a wave of dread washes over you...</span>")
	qdel(src)
	return gain

/obj/machinery/power/supermatter_crystal/blob_act(obj/structure/blob/B)
	if(B && !isspaceturf(loc)) //does nothing in space
		playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, TRUE)
		damage += B.obj_integrity * 0.5 //take damage equal to 50% of remaining blob health before it tried to eat us
		if(B.obj_integrity > 100)
			B.visible_message("<span class='danger'>\The [B] strikes at \the [src] and flinches away!</span>",\
			"<span class='hear'>You hear a loud crack as you are washed with a wave of heat.</span>")
			B.take_damage(100, BURN)
		else
			B.visible_message("<span class='danger'>\The [B] strikes at \the [src] and rapidly flashes to ash.</span>",\
			"<span class='hear'>You hear a loud crack as you are washed with a wave of heat.</span>")
			Consume(B)

/obj/machinery/power/supermatter_crystal/attack_tk(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		to_chat(C, "<span class='userdanger'>That was a really dense idea.</span>")
		Consume(user)

/obj/machinery/power/supermatter_crystal/attack_alien(mob/user)
	dust_mob(user, cause = "alien attack")

/obj/machinery/power/supermatter_crystal/attack_animal(mob/living/simple_animal/S)
	var/murder
	if(!S.melee_damage_upper && !S.melee_damage_lower)
		murder = S.friendly
	else
		murder = S.attacktext
	dust_mob(S, \
	"<span class='danger'>[S] unwisely [murder] [src], and [S.p_their()] body burns brilliantly before flashing into ash!</span>", \
	"<span class='userdanger'>You unwisely touch [src], and your vision glows brightly as your body crumbles to dust. Oops.</span>", \
	"simple animal attack")

/obj/machinery/power/supermatter_crystal/attack_robot(mob/user)
	if(Adjacent(user))
		dust_mob(user, cause = "cyborg attack")
	else
		ui_interact(user)
	return

/obj/machinery/power/supermatter_crystal/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/power/supermatter_shard/attack_ghost(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/supermatter_crystal/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	dust_mob(user, cause = "hand")

/obj/machinery/power/supermatter_crystal/proc/dust_mob(mob/living/nom, vis_msg, mob_msg, cause)
	if(nom.incorporeal_move || nom.status_flags & GODMODE)
		return
	if(!vis_msg)
		vis_msg = "<span class='danger'>[nom] reaches out and touches [src], inducing a resonance... [nom.p_their()] body starts to glow and burst into flames before flashing into dust!</span>"
	if(!mob_msg)
		mob_msg = "<span class='userdanger'>You reach out and touch [src]. Everything starts burning and all you can hear is ringing. Your last thought is \"That was not a wise decision.\"</span>"
	if(!cause)
		cause = "contact"
	nom.visible_message(vis_msg, mob_msg, "<span class='hear'>You hear an unearthly noise as a wave of heat washes over you.</span>")
	investigate_log("has been attacked ([cause]) by [key_name(nom)]", "warpstone")
	playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, TRUE)
	Consume(nom)

/obj/machinery/power/supermatter_crystal/attackby(obj/item/W, mob/living/user, params)
	if(!istype(W) || (W.flags & ABSTRACT) || !istype(user))
		return
	if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/cig = W
		if(CLUMSY in user.mutations)
			user.visible_message("<span class='danger'>The [W] flashes out of existence on contact with \the [src], resonating with a horrible sound...</span>",\
				"<span class='danger'>Oops! The [W] flashes out of existence on contact with \the [src], setting you on fire! That was clumsy of you!</span>")
			playsound(src, 'sound/effects/supermatter.ogg', 150, TRUE)
			user.adjust_fire_stacks(1)
			user.IgniteMob()
			qdel(W)
			return
		if(cig.lit || user.a_intent != INTENT_HELP)
			user.visible_message("<span class='danger'>A hideous sound echoes as [W] is ashed out on contact with \the [src]. That didn't seem like a good idea...</span>")
			playsound(src, 'sound/effects/supermatter.ogg', 150, TRUE)
			Consume(W)
			for(var/mob/living/L in range(10))
				var/rads = 500 * sqrt( 1 / (get_dist(L, src) + 1) )
				L.apply_effect(rads, IRRADIATE)
			return ..()
		else
			user.visible_message("<span class='danger'>As [user] lights \their [W] on \the [src], silence fills the room...</span>",\
				"<span class='danger'>Time seems to slow to a crawl as you touch \the [src] with \the [W].</span>\n<span class='notice'>\The [W] flashes alight with an eerie energy as you nonchalantly lift your hand away from \the [src]. Damn.</span>")
			cig.light()
			playsound(src, 'sound/effects/supermatter.ogg', 50, TRUE)
			for(var/mob/living/L in range(10))
				var/rads = 500 * sqrt( 1 / (get_dist(L, src) + 1) )
				L.apply_effect(rads, IRRADIATE)
			return

			//Shard extraction will be a future update, I'm sick of fucking around with this right now
	if(istype(W, /obj/item/scalpel/supermatter))
		to_chat(user, "<span class='notice'>You carefully begin to scrape \the [src] with the \the [W]...</span>")
		if(W.use_tool(src, user, 60, volume=100))
			to_chat(user, "<span class='danger'>You extract a sliver from \the [src]. \The [src] begins to react violently!</span>")
			new /obj/item/supermatter_crystal/splinter(drop_location())
			matter_power += 800
		return

	if(user.drop_item(W))
		Consume(W)
		user.visible_message("<span class='danger'>As [user] touches \the [src] with \a [W], silence fills the room...</span>",\
			"<span class='userdanger'>You touch \the [src] with \the [W], and everything suddenly goes silent.\"</span>\n<span class='notice'>\The [W] flashes into dust as you flinch away from \the [src].</span>",\
			"<span class='italics'>Everything suddenly goes silent.</span>")

		playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, 1)

		user.apply_effect(150, IRRADIATE)

	else if(Adjacent(user)) //if the item is stuck to the person, kill the person too instead of eating just the item.
		var/vis_msg = "<span class='danger'>[user] reaches out and touches [src] with [W], inducing a resonance... [W] starts to glow briefly before the light continues up to [user]'s body. [user.p_they(TRUE)] bursts into flames before flashing into dust!</span>"
		var/mob_msg = "<span class='userdanger'>You reach out and touch [src] with [W]. Everything starts burning and all you can hear is ringing. Your last thought is \"That was not a wise decision.\"</span>"
		dust_mob(user, vis_msg, mob_msg)

/obj/machinery/power/supermatter_crystal/Bumped(atom/movable/AM)
	if(isliving(AM))
		AM.visible_message("<span class='danger'>\The [AM] slams into \the [src] inducing a resonance... [AM.p_their()] body starts to glow and burst into flames before flashing into dust!</span>",\
		"<span class='userdanger'>You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class='hear'>You hear an unearthly noise as a wave of heat washes over you.</span>")
	else if(isobj(AM) && !iseffect(AM))
		AM.visible_message("<span class='danger'>\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>", null,\
		"<span class='hear'>You hear a loud crack as you are washed with a wave of heat.</span>")
	else
		return

	playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, TRUE)

	Consume(AM)

/obj/machinery/power/supermatter_crystal/proc/Consume(atom/movable/AM)
	if(istype(AM, /mob/living))
		var/mob/living/user = AM
		if(user.status_flags & GODMODE)
			return
		message_admins("[src] has consumed [key_name_admin(user)] [ADMIN_JMP(src)].")
		investigate_log("has consumed [key_name(user)].", "warpstone")
		user.dust()
		matter_power += 200
	else if(isobj(AM) && !istype(AM, /obj/effect))
		investigate_log("has consumed [AM].", "warpstone")
		qdel(AM)
	supermatter_zap()

	//Some poor sod got eaten, go ahead and irradiate people nearby.

	for(var/mob/living/L in range(10))
		var/rads = 500 * sqrt( 1 / (get_dist(L, src) + 1) )
		L.apply_effect(rads, IRRADIATE)
		investigate_log("has irradiated [L] after consuming [AM].", "warpstone")
		if(L in view())
			L.show_message("<span class='danger'>As \the [src] slowly stops resonating, you find your skin covered in new radiation burns.</span>", 1,\
				"<span class='danger'>The unearthly ringing subsides and you notice you have new radiation burns.</span>", 2)
		else
			L.show_message("<span class='hear'>You hear an unearthly ringing and notice your skin is covered in fresh radiation burns.</span>", 2)

/obj/machinery/power/supermatter_crystal/engine
	is_main_engine = TRUE


// This is purely informational UI that may be accessed by AIs or robots
/obj/machinery/power/supermatter_crystal/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "supermatter_crystal.tmpl", "Warpstone Crystal", 500, 300)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/power/supermatter_crystal/ui_data(mob/user, ui_key = "main", datum/topic_state/state = GLOB.default_state)
	var/data[0]

	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture/env = null
	if(!istype(src.loc, /turf/space))
		env = src.loc.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.return_pressure())
	if(damage > explosion_point)
		data["detonating"] = 1
	else
		data["detonating"] = 0

	return data

/obj/item/supermatter_crystal/splinter
	name = "Warpstone Splinter"
	desc = "A splinter of warpstone cut off from a larger crystal. Even this tiny shard is too dangerous to touch without special equipment."
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "darkmatter_splinter"
	item_state = "darkmatter_splinter"
	layer = ABOVE_MOB_LAYER
	w_class = WEIGHT_CLASS_TINY


/obj/machinery/power/supermatter_crystal/shard
	name = "Warpstone Shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. <span class='danger'>You get headaches just from looking at it, but it's hard to stop staring.</span>"
	icon_state = "darkmatter_shard"
	anchored = FALSE
	gasefficency = 0.125
	explosion_power = 12
	layer = ABOVE_MOB_LAYER
	moveable = TRUE

/obj/machinery/power/supermatter_crystal/shard/science
	name = "Stabilized Warpstone Shard"
	desc = "A warpstone shard contained within a specialized Gellar Field for use in experiments. Even stable, it is still very incredibly dangerous. <span class='danger'>You get headaches just from looking at it, but it's hard to stop staring.</span>"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"
	anchored = TRUE
	takes_damage = FALSE
	moveable = FALSE

// When you wanna make a supermatter shard for the dramatic effect, but
// don't want it exploding suddenly
/obj/machinery/power/supermatter_crystal/shard/safe
	name = "Secure Warpstone Shard"
	takes_damage = FALSE
	produces_gas = FALSE
	moveable = FALSE
	anchored = TRUE

/obj/machinery/power/supermatter_crystal/shard/safe/fakecrystal //Safe shard with crystal visuals, used in the Supermatter/Hyperfractal shuttle
	name = "Warpstone crystal"
	base_icon_state = "darkmatter"
	icon_state = "darkmatter"

/obj/machinery/power/supermatter_crystal/proc/supermatter_pull(turf/center, pull_range = 10)
	playsound(src.loc, 'sound/weapons/marauder.ogg', 100, TRUE, extrarange = 7)
	for(var/atom/movable/P in orange(pull_range,center))
		if(P.anchored || P.move_resist >= MOVE_FORCE_EXTREMELY_STRONG) //move resist memes.
			return
		if(ishuman(P))
			var/mob/living/carbon/human/H = P
			if(H.incapacitated() || H.mob_negates_gravity())
				return //You can't knock down someone who is already knocked down or has immunity to gravity
			H.visible_message("<span class='danger'>[H] is suddenly knocked down, as if [H.p_their()] [(H.get_num_legs() == 1) ? "leg had" : "legs have"] been pulled out from underneath [H.p_them()]!</span>",\
				"<span class='userdanger'>A sudden gravitational pulse knocks you down!</span>",\
				"<span class='hear'>You hear a thud.</span>")
			H.Stun(4)
		else //you're not human so you get sucked in
			step_towards(P,center)
			step_towards(P,center)
			step_towards(P,center)
			step_towards(P,center)

/obj/machinery/power/supermatter_crystal/proc/supermatter_anomaly_gen(turf/anomalycenter, type = FLUX_ANOMALY, anomalyrange = 5)
	var/turf/L = pick(orange(anomalyrange, anomalycenter))
	if(L)
		switch(type)
			if(FLUX_ANOMALY)
				new /obj/effect/anomaly/flux(L, 300)
			if(GRAVITATIONAL_ANOMALY)
				new /obj/effect/anomaly/grav(L, 250)
			if(PYRO_ANOMALY)
				new /obj/effect/anomaly/pyro(L, 200)


/obj/machinery/power/supermatter_crystal/proc/supermatter_zap(atom/zapstart = src, range = 5, zap_str = 4000, list/targets_hit = list(), zap_flags = ZAP_SUPERMATTER_FLAGS)
	playsound(get_turf(src), 'sound/magic/lightningbolt.ogg', 50, 1, ignore_walls = TRUE)
	tesla_zap(src, 10, max(1000,power * damage / explosion_point))

#undef HALLUCINATION_RANGE
#undef GRAVITATIONAL_ANOMALY
#undef FLUX_ANOMALY
#undef PYRO_ANOMALY

