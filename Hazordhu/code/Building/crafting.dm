/****************************************
*										*
*	All /obj/builder types are used as	*
*	the new path for building objects	*
*	They will replace all /obj/Smithing	*
* 	/obj/Woodworking and other like		*
* 	type paths for a cleaner and more	*
*	efficient crafting system			*
*										*
****************************************/

builder
	parent_type = /obj

	//	Tooltip defaults
	desc = "A craftable item"

	var
		req[0]		//	A list of all requirements for the object being built
					//	Format is /path = num
					//	/path is the path of the required material
					//	num is the ammount of the required material
		built		//	The object created
		extras[0]	//	Anything unused in the actual object (buckets, bowls, etc)
		build_amount = 1
		obj/Item/Tools/main_tool

		group_only = FALSE
		allowed_races = HUMAN | ORC	//	1 = human, 2 = orc, 3 = both

		//	Can it be made in the tutorial area?
		allowed_in_tutorial = FALSE

	proc
		build_amount() return build_amount

		base_build_time()
			return 100

		build_time(mob/player/player)
			. = base_build_time()
			var skill_level/s = player.get_skill(skill)
			. -= s.time_bonus()

		valid_loc(turf/Environment/t, mob/player/player)
			if(t)
				if(isturf(t)) for(var/PropertyDeed/deed in t.deeds) if(!deed.can_build(player)) return FALSE
				if(ismob(t) && !ispath(built, /obj/Item)) return FALSE
				if(iswater(t) && !t.is_bridged()) return FALSE
				if(density)
					if(t.density) return FALSE
					for(var/atom/movable/o in t)
						if(istype(o, /obj/cliff_border)) continue
						if(o.density && !istype(o, /obj/Built)) return FALSE
				for(var/obj/Resource/r in t) if(r.density) return FALSE
				return TRUE

		condition(mob/m) return TRUE

		/*	Returns TRUE if m has required materials.
			req: Paths of required materials, associated to amount
			has: Paths of necessary materials m has, associated to amount
		*/
		mat_check(mob/m, has[])
			if(!has) has = m.item_paths()
			var _has[0]
			for(var/item in req)
				for(var/path in has)
					if(ispath(path, item))
						_has[item] += has[path]
			for(var/item in req)
				if(_has[item] < req[item])
					mat_fail(m)
					return FALSE
			return TRUE

		mat_fail(mob/m)
			m.aux_output("You do not have enough materials to make \a [name].")

		tool_check(mob/player/player)
			if(player.ToolbeltCheck(main_tool)) 
				return TRUE

			if(main_tool && !player.is_equipped(main_tool) && !player.equip(locate(main_tool) in player))
				player.aux_output("You need a [tool2text(main_tool)] to make \a [src].")
				return FALSE

			return TRUE

	//	Called when the player successfully crafted this.
	proc/success(mob/player/player, products[])

	//	Called for each product.
	proc/crafted(product, crafter)

	var skill = ""
	var experience = 1
	proc/give_experience(mob/player/player)
		if(!skill) CRASH("No skill level specified! ([type])")
		player.gain_experience(skill, experience)

	DblClick() if(valid_loc(usr, usr)) craft(usr)

	/mob/player
		var tmp/dragging_builder

	MouseDrag(BuildGrid/build_cell/cell)
		var mob/player/p = usr
		p.dragging_builder = TRUE
		if(istype(cell))
			p.BuildGrid.select(cell)
		else p.BuildGrid.deselect()

	MouseDown()
		var mob/player/p = usr
		if(can_craft(p))
			p.dragging_builder = TRUE
			p.BuildGrid.show(src)
			p.client.mouse_pointer_icon = icon(icon, icon_state)

	MouseUp()
		var mob/player/p = usr
		p.dragging_builder = FALSE
		p.BuildGrid.hide()
		p.client.mouse_pointer_icon = 'code/icons/pointer.dmi'

	MouseDrop(BuildGrid/build_cell/cell)
		var mob/player/p = usr
		p.dragging_builder = FALSE
		p.client.mouse_pointer_icon = 'code/icons/pointer.dmi'

		if(istype(cell))
			var build_loc = cell.loc
			p.BuildGrid.hide()
			craft(usr, build_loc)

			if(p.dragging_builder)
				p.BuildGrid.show(src)
			else p.BuildGrid.hide()

		else p.BuildGrid.hide()

	proc/can_craft(mob/player/player)
		if(player.Locked) return
		switch(player.Race)
			if("Human") if(!(allowed_races & HUMAN))
				player.aux_output("Humans can't make \a [src].")
				return

			if("Orc") if(!(allowed_races & ORC))
				player.aux_output("Orcs can't make \a [src].")
				return
		if(group_only && (!player.Group || player.Group.members.len < 3))
			player.aux_output("You need to be in a group with at least 3 people to make \a [src].")
			return

		if(!tool_check(player)) return
		if(!allowed_in_tutorial && player.in_tutorial())
			player.aux_output("You can't build here.")
			return
		if(!mat_check(player)) return
		return TRUE

	proc/craft(mob/player/player, turf/buildloc)
		if(!can_craft(player)) return

		var condition = condition(player)
		if(!condition) return

		if(!buildloc && ispath(built, /obj/Item))
			buildloc = player

		if(!valid_loc(buildloc, player))
			player.aux_output("You can't build that there.")
			return

		if(main_tool) player.used_tool()

		for(var/i in 1 to req.len)
			var cur = req[i]
			var amnt = req[cur]
			var obj/Item/found = locate(cur) in player
			player.lose_item(found, amnt)

		player._do_work(build_time(player))

		spawn_product(player, buildloc, condition)

	proc/spawn_product(mob/player/player, turf/buildloc, condition)
	//	var turf/buildloc = isturf(condition) ? condition : player.cloc()
		if(!buildloc) return

		if(istype(src, /builder/farming)) player.medalMsg("Farmer")
		if(istype(src, /builder/smithing)) player.medalMsg("Blacksmith")

		//	Special spawning instructions
		if(findtext(name, "cuff") || findtext(name,"lock") || findtext(name, "key"))
			. = list(new built (buildloc, condition))

		//	Bridge making
		else if(findtext(name,"bridge"))
			var below = get_step(buildloc, SOUTH)
			if(locate(/obj/Built/Floors) in below) below = null
			if(!is_water(below) && !is_lava(below)) below = null
			var global/floor_types	= list(
				"Wooden Bridge"		= /obj/Built/Floor,
				"Brick Bridge"		= /obj/Built/Stone_Floor,
				"Sandstone Bridge"	= /obj/Built/Sandstone_Floor
			)
			var global/bridge_types	= list(
				"Wooden Bridge"		= /obj/Built/Bridge,
				"Brick Bridge"		= /obj/Built/Stone_Bridge,
				"Sandstone Bridge"	= /obj/Built/Sandstone_Bridge
			)
			. = list()
			var floor_type = floor_types[name]
			var bridge_type = bridge_types[name]
			. += new floor_type (buildloc)
			if(below) . += new bridge_type (below)

		else
			. = list()
			//	Normal crafting
			for(var/i in 1 to build_amount())
				. += new built (buildloc)

			if(extras)
				for(var/i in 1 to extras.len)
					var extra = extras[i]
					. += new extra (buildloc)

		//	Post-creation code
		if(. && length(.))
			success(player, .)
			for(var/obj/o in .)
				crafted(o, player)
				o.crafted_by(player)

			give_experience(player)

			var skill_level/s = player.get_skill(skill)
			if(s) for(var/a in .) if(a) s.apply(a)

		else return null

proc/tool2text(obj/Item/Tools/tool)
	return initial(tool:name)
	var obj/newtool = new tool
	. = newtool.name
	del newtool

//	called when a player crafted this
obj/proc/crafted_by(mob/player/player)