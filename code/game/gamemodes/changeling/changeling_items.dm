
/obj/item/weapon/melee/arm_blade
	name = "arm blade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon_state = "arm_blade"
	w_class = ITEM_SIZE_LARGE
	force = 35
	sharp = 1
	edge = 1
	anchored = 1
	slot_flags = null
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	obj_flags = OBJ_FLAG_NO_EMBED
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/mob/living/creator //This is just like ninja swords, needed to make sure dumb shit that removes the sword doesn't make it stay around.

/obj/item/weapon/melee/arm_blade/greater
	name = "arm greatblade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people and armor as a hot knife through butter."
	armor_penetration = 30

/obj/item/weapon/melee/arm_blade/Initialize(location)
	. = ..()
	START_PROCESSING(SSobj,src)
	if(ismob(loc))
		creator = loc
		creator.visible_message(
			"<span class='warning'>A grotesque blade forms around [loc.name]\'s arm!</span>",
			"<span class='warning'>Our arm twists and mutates, transforming it into a deadly blade.</span>",
			"<span class='italics'>You hear organic matter ripping and tearing!</span>"
			)
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)

/obj/item/weapon/melee/arm_blade/dropped(mob/user)
	user.visible_message(
		"<span class='warning'>With a sickening crunch, [creator] reforms their arm blade into an arm!</span>",
		"<span class='notice'>We assimilate the weapon back into our body.</span>",
		"<span class='italics'>You hear organic matter ripping and tearing!</span>"
		)
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	spawn(1)
		if(src)
			qdel(src)

/obj/item/weapon/melee/arm_blade/Destroy()
	STOP_PROCESSING(SSobj,src)
	creator = null
	. = ..()

//TODO ensure embedded objects call dropped, ensure items unembed themselves when deleted
/obj/item/weapon/melee/arm_blade/Process()  //Stolen from ninja swords.
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		spawn(1)
			if(src)
				qdel(src)

//roughly better than a security shield by having the same block chance, but able to block projectiles.
/obj/item/weapon/shield/riot/changeling
	name = "shield-like mass"
	desc = "A mass of tough, boney tissue. You can still see the fingers as a twisted pattern in the shield."
	icon_state = "ling_shield"
	item_state = "ling_shield"
	w_class = ITEM_SIZE_NO_CONTAINER
	slot_flags = null
	anchored = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0

	var/mob/living/creator

/obj/item/weapon/shield/riot/changeling/Initialize(location)
	. = ..()
	START_PROCESSING(SSobj,src)
	if(ismob(loc))
		creator = loc
		creator.visible_message(
			"<span class='warning'>A grotesque [src] forms around [loc.name]\'s arm!</span>",
			"<span class='notice'>Our arm twists and mutates, transforming it into a [src].</span>",
			"<span class='italics'>You hear organic matter ripping and tearing!</span>"
			)
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)

/obj/item/weapon/shield/riot/changeling/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/weapon/shield/riot/changeling/dropped(mob/user)
	user.visible_message(
		"<span class='warning'>With a sickening crunch, [creator] reforms their [src] into an arm!</span>",
		"<span class='notice'>We assimilate the shield back into our body.</span>",
		"<span class='italics'>You hear organic matter ripping and tearing!</span>"
		)
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	spawn(1)
		if(src)
			qdel(src)

/obj/item/weapon/shield/riot/changeling/Process() //What is this even for?
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		spawn(1)
			if(src)
				qdel(src)

/obj/item/weapon/shield/riot/changeling/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return (base_block_chance - round(damage / 3)) //block bullets and beams using the old block chance
	return base_block_chance