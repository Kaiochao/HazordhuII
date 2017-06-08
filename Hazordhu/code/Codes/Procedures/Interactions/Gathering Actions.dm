
/*
	Gathering ------------------------------------------------------------------------------------
*/
mob/proc
	has_hatchet()
		if(ToolbeltCheck(/obj/Item/Tools/Hatchet)) return 1
		return is_equipped(/obj/Item/Tools/Hatchet)
	has_pickaxe()
		if(ToolbeltCheck(/obj/Item/Tools/Pickaxe)) return 1
		return is_equipped(/obj/Item/Tools/Pickaxe)
	has_knife()
		if(ToolbeltCheck(/obj/Item/Tools/Knife)) return 1
		return is_equipped(/obj/Item/Tools/Knife)
	has_rod()
		if(ToolbeltCheck(/obj/Item/Tools/Fishing_Rod)) return 1
		return is_equipped(/obj/Item/Tools/Fishing_Rod)

	_gather(atom/movable/r)
		if(istype(r, /obj/Resource))
			var obj/Resource/R = r
			if(R.resources <= 0) return FALSE

		if(istype(r, /obj/Woodcutting) && has_hatchet()) return _chop(r)
		else if(istype(r, /obj/Woodcutting)) return _pickfruit(r)
		if(istype(r, /obj/Mining) && has_pickaxe()) return _mine(r)
		if(istype(r, /mob/Corpse) && (has_knife() || has_hatchet())) return _skin(r)
		if(is_fishable(r) && has_rod()) return _fish(r)

	_chop(obj/Woodcutting/o) if(istype(o)) return Chop(o)
	_mine(obj/Mining/o) if(istype(o)) return Mine(o)
	_skin(mob/Corpse/o) if(istype(o)) return o.Skin(src)
	_pickfruit(obj/Woodcutting/o) if(istype(o)) return o.pick_fruit(src)

	is_fishable(o)
		if(istype(o, /turf/Environment/Water))
			var turf/Environment/Water/water = o
			if(water.is_frozen())
				return FALSE
			return TRUE

		if(istype(o, /turf/Environment/Ocean))
			return FALSE

	_fish(turf/Environment/Water/o)
		used_tool()
		emote("starts fishing")

		var
			duration = 80
			chance = 40
		if(istype(src, /mob/player))
			var mob/player/player = src
			var skill_level/fishing/fishing = player.get_skill(/skill_level/fishing)
			duration = fishing.Duration()
			chance = fishing.FishChance()

		_do_work(duration)
		if(prob(chance))
			emote("fails to catch anything")
		else
			emote("catches a fish")
			new /obj/Item/Food/Meat/Fish (loc)

		if(istype(src, /mob/player))
			var mob/player/player = src
			player.gain_experience(FISHING, 1)

		return TRUE