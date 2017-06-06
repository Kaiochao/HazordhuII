var const
	DMF_ITEMS = "inventory.item_grid" // "items.item_grid"
	DMF_STORAGE = "storage.storage_grid"
	DMF_EQUIPMENT = "items.equipment_grid"

mob
	proc/InventoryGrid()
	proc/StorageGrid()

	proc/get_item(obj/Item/item, stack)
		if(istext(item)) item = text2path(item)
		if(ispath(item))
			item = new item
			item.set_loc(loc, step_x, step_y)
		. = stack ? item.GetAll(src) : item.Get(src)
		InventoryGrid()

	proc/lose_item(obj/Item/item, amount = 1)
		amount = min(amount, item.Stacked)
		for(var/n in 1 to amount)
			item.Drop(src, location = 0)
		InventoryGrid()

	proc/can_get(obj/Item/item) return item.can_get
	proc/can_drop(obj/Item/item) return TRUE

mob/player
#if !THIN_SKIN
	InventoryGrid(obj/Item/exclude)
		var index = 0
		Items = 0
		for(var/obj/Item/o in contents - exclude)
			if(is_equipped(o)) continue
			src << output(o, "item_grid:1,[++index]")
			if(o.weight) Items += o.Stacked * o.weight
		winset(src, "item_grid", "cells=1,[index]")
		winset(src, "item_weight_bar",
			"value=[Items / Item_Limit * 100]")
		EquipmentGrid()

	StorageGrid(obj/Item/exclude)
		if(!storage) return
		var index = 0
		storage.Items = 0
		for(var/obj/Item/o in storage.contents - exclude)
			src << output(o, "storage_grid:1,[++index]")
			if(o.weight) storage.Items += o.Stacked * o.weight
		winset(src, "storage_grid", "cells=1,[index]")
		winset(src, "storage_weight_bar",
			"value=[storage.Items / storage.Item_Limit * 100]")
#endif

obj/Built
	var is_table = FALSE
	Table/is_table = TRUE
	Counter/is_table = TRUE

obj/Item
	SET_BOUNDS(8, 8, 16, 16)

	var Stacked = 1
	var weight = 1
	var complete_delete
	var Stackable = 1
	var fingerprints[]
	var can_get = TRUE
	layer = OBJ_LAYER + 1

	interact(mob/m)
		if(loc == m)
			if(m.is_equipped(src))
				m.unequip(src)
			else
				if(m.has_key("ctrl"))
					DropAll(m)
				else if(m.has_key("shift"))
					DropInFront(m)
				else Drop(m)
		else
			if(m.has_key("ctrl"))
				GetAll(m)
			else Get(m)
		return TRUE

	Del()
		if(Stacked == 1 || complete_delete)
			var mob/m = loc
			if(m && ismob(m))
				m.InventoryGrid(src)
			return ..()

		else if(Stacked > 1)
			Stack_Check(1)

	New(loc)
		..()

		Stack_Check()

		if(ismob(loc))
			var mob/m = loc
			m.InventoryGrid()
			if(m.Items > m.Item_Limit)
				Drop(m)

		else if(istype(loc, /obj/Built/Storage))
			for(var/mob/m in ohearers(1, loc))
				if(loc == m.storage)
					m.StorageGrid()

	map_loaded()
		if(isturf(loc))
			surface_check()
		..()

	Move(NewLoc)
		var mob/m
		if(NewLoc)
			Stack_Check()
			if(loc && ismob(loc))
				m = loc
				m.InventoryGrid()
		. = ..()
		if(loc)
			Stack_Check()
			if(m && m != loc)
				m.InventoryGrid()
			if(ismob(loc))
				m = loc
				m.InventoryGrid()

			else if(istype(loc, /obj/Built/Storage))
				for(var/mob/M in ohearers(1, loc))
					if(loc == M.storage)
						M.StorageGrid()

	MouseDrop(
	over_object,
	src_location, over_location,
	src_control, over_control, params)
		var mob/player/player = usr
		if(!player.Locked && loc)
			if(loc == player)
			//	equipping or unequipping an item
				if(get_equip_type(src))
					if(src_control == DMF_ITEMS && \
					over_control == DMF_EQUIPMENT)
						player.equip(src)
						return
					else if(src_control == DMF_EQUIPMENT && \
					over_control == DMF_ITEMS)
						player.unequip(src)
						return
			//	putting an item into a storage object
				if(player.storage)
					if(over_object == player.storage || \
					over_control == DMF_STORAGE)
						if(src_control == DMF_ITEMS)
							store_item(player,
								params2list(params)["ctrl"])
							return
						//	store from equipment
						if(src_control == DMF_EQUIPMENT)
							if(player.unequip(src))
								store_item(player,
									params2list(params)["ctrl"])
								return
			//	take an item out of a storage object
			else if(player.storage && loc == player.storage)
				if(over_control == DMF_ITEMS)
					unstore_item(player,
						params2list(params)["ctrl"])
					return
				//	equip from storage
				if(over_control == DMF_EQUIPMENT)
					unstore_item(player,
						params2list(params)["ctrl"])
					player.equip(src)
					return
		..()

	Click(l, c, p)
		//	taking an item out of storage
		if(loc == usr.storage)
			unstore_item(usr, params2list(p)["ctrl"])
		if(loc == usr)
			if(params2list(p)["middle"])
				usr.equip(src)
		else ..()

	proc
		//	a new stack was taken from this one
		split_as(obj/Item/item)
			return item

		store_item(mob/m, do_bulk)
			var obj/storage = m
			if(istype(storage) && storage.is_storage)
				m = null

			if(ismob(m))
				storage = m.storage
				if(!storage || !storage.is_storage || !storage.can_store(src))
					return
			
			if(istype(storage, /obj/Built/NewForge))
				if(istype(m) && !(m.is_equipped(/obj/Item/Tools/Tongs) || m.equip(locate(/obj/Item/Tools/Tongs) in m)))
					m.aux_output("You need Tongs equipped to transfer with a forge.")
					return

			if(storage.Item_Limit - storage.Items >= weight)
				. = TRUE
				if(Stackable && Stacked > 1)
					if(do_bulk)
						var bulk
						while(bulk < 10 && Stacked && \
						storage.Items < storage.Item_Limit)
							bulk ++
							storage.Items ++

							var obj/Item/item = new type
							split_as(item)
							item.Move(storage)
							m.storage.stored(item)

							Stack_Check(1)
					else
						var obj/Item/item = new type
						split_as(item)
						item.Move(storage)
						m.storage.stored(item)
						Stack_Check(1)
				else
					Move(storage)
					Stack_Check()

				//	update others looking in the storage object
				if(m)
					m.StorageGrid()
					for(var/mob/M in ohearers(1, storage))
						if(M != m && M.storage == storage)
							M.StorageGrid()

			else if(m)
				m.aux_output("The [storage] is full!")

		unstore_item(mob/m, do_bulk)
			if(!m.storage) return

			if(istype(m.storage, /obj/Built/NewForge))
				if(istype(m) && !(m.is_equipped(/obj/Item/Tools/Tongs) || m.equip(locate(/obj/Item/Tools/Tongs) in m)))
					m.aux_output("You need Tongs equipped to transfer with a forge.")
					return

			if(m.Item_Limit - m.Items >= weight)
				. = TRUE
				//	item stacks
				if(Stackable && Stacked > 1)
					//	bulk-moving
					if(do_bulk)
						var bulk
						while(bulk < 10 && Stacked && \
						m.Item_Limit - m.Items >= weight)
							bulk ++
							m.Items += weight

							var obj/Item/item = new type
							split_as(item)
							item.Move(m)
							m.storage.unstored(item)

							Stack_Check(1)
						m.StorageGrid()

					//	not bulk-moving
					else
						var obj/Item/item = new type
						split_as(item)
						item.Move(m)
						m.storage.unstored(item)

						Stack_Check(1)
						m.StorageGrid()

				//	item doesn't stack
				else
					m.StorageGrid(src)
					Move(m)
					Stack_Check()

				//	not a bag
				if(m.storage.loc != m)
					for(var/mob/M in ohearers(1, m.storage))
						if(M != m && M.storage == m.storage)
							M.StorageGrid()

			else m.aux_output("You cannot carry any more.")

		grabbed_by(mob/m)
			set_step()

		dropped_by(mob/m)
			surface_check(m.dir)

		//	Snap to the center of a surface like a counter or table
		surface_check(dir = 2)
			#if PIXEL_MOVEMENT
			var obj/Built/surface
			if(!loc) return
			for(surface in obounds()) if(surface.is_table) break
			if(!surface) return

			var offset[] = dir2offset(turn(dir, 180))
			if(istype(surface, /obj/Built/Counter))
				if(surface.dir & VERT)
					offset[1] *= 12
					offset[2] = 4
				else
					offset[1] = 0
					offset[2] = offset[2] * 10 + 8
			else
				offset[1] *= 12
				offset[2] = offset[2] * 4
			Move(surface.loc, 0, surface.step_x + offset[1], surface.step_y + offset[2])
			layer = surface.layer + 1
			#endif

		DropInFront(mob/m)
			var turf/t = get_step(m, m.dir)
			if(!t) return
			for(var/atom/a in t)
				if(a.opacity) return
				if(istype(a, /obj/Resource)) return
			Drop(m, vec2_scale(dir2offset(m.dir), 8))

		GetAll(mob/m)
			for(var/n in 1 to min(10, Stacked, weight ? (m.Item_Limit - m.Items) / weight : 1.#INF)) Get(m)
			return TRUE

		DropAll(mob/m, ignorebulk)
			for(var/n in 1 to min(10, Stacked)) Drop(m)
			return TRUE

		//	m is the dropper
		Drop(mob/m, location = -1)
			if(!m.can_drop(src)) return

			if(location == -1) location = m.loc
			var v[] = is_vec2(location) && location
			if(v) location = m.loc
			else v = vec2_zero

			if(is_humanoid(m))
				var mob/humanoid/h = m
				if(h.is_equipped(src) && !h.unequip(src)) return

			if(Stacked > 1)
				Stacked --

				var obj/Item/item = new type
				. = split_as(item)
				if(location) item.Move(location)

			else . = src

			layer = initial(layer)

			var obj/Item/o = .
			if(location)
				if(v)
					#if PIXEL_MOVEMENT
					o.Move(location, 0, m.step_x + v[1], m.step_y + v[2] - 12)
					#else
					o.Move(get_step(location, (v[1] && (v[1] > 0 ? EAST : WEST)) | (v[2] && (v[2] > 0 ? NORTH : SOUTH))))
					#endif
				else o.Move(location, 0, m.step_x, m.step_y)
			else o.loc = null
			o.dropped_by(m)

			Stack_Check()

		Get(mob/humanoid/m)
			if(!m.can_get(src)) return

			if(istype(src, /obj/Item/Clothing/Bag))
				winshow(m, "Storage", 0)

			if(m.Item_Limit - m.Items >= weight)

				AnimatePickup(m)

				if(Stacked > 1)
					Stacked --

					var obj/Item/item = new type
					. = split_as(item)
					item.Move(m)

				else
					Move(m)
					. = src

				var obj/Item/o = .
				o.grabbed_by(m)
				o.fingerprints += m.key

				Stack_Check()
				return . || 1

		AnimatePickup(atom/target)
			set waitfor = FALSE
			var obj/o = new
			o.loc = loc
			o.step_x = step_x
			o.step_y = step_y
			o.appearance = appearance
			o.overlays -= num2overlay(Stacked)
			animate(o, time = 3, flags = SINE_EASING, 
				pixel_x = target.cx() - cx(),
				pixel_y = target.cy() - cy(), 
				alpha = 0
			)
			sleep 10
			o.loc = null

		LoseAmount(amount)
			Stack_Check(amount)

		Stack_Check(remove = 0)
			Stacked -= remove

			if(loc && Stacked < 1)
				var mob/m = loc
				if(istype(m))
					m.InventoryGrid(src)

				else
					var obj/Built/Storage/s = loc
					if(istype(s))
						for(var/mob/M in ohearers(1, s))
							if(s == M.storage)
								M.StorageGrid(src)
				set_loc()

			else if(Stackable)
				for(var/obj/Item/o in (isturf(loc) ? bounds() : loc))
					if(o.Stackable && o != src && o.type == type)
						if(istype(src, /obj/Item/Ores))
							var obj/Item/Ores
								src_ore = src
								other_ore = o
							if(src_ore.ForgeTime() != other_ore.ForgeTime())
								continue
								
						if(istype(src, /obj/Item/Food/Meat))
							var obj/Item/Food/Meat
								meat1 = src
								meat2 = o
							if(meat1.cooked != meat2.cooked)
								continue

						if(istype(o, /obj/Item/Head))
							if(o.icon_state != icon_state)
								continue

						if(istype(o, /obj/Item/Metal/Coins))
							if(o.name != name)
								continue

						var mob/humanoid/m = loc
						if(istype(m) && m.is_equipped(o))
							continue

						Stacked += o.Stacked
						o.complete_delete = 1

						del o

					overlays = list(num2overlay(Stacked))

				var mob/m = loc
				if(istype(m))
					m.InventoryGrid()

				else
					var obj/Built/Storage/s = loc
					if(istype(s))
						for(var/mob/M in ohearers(1, s))
							if(s == M.storage)
								M.StorageGrid(src)

		num2overlay(n = 0)
			var LAYER = z ? 100 : 205

			if(n <= 1)
				return

			if(n >= 1000)
				return image('code/Icons/Numbers.dmi', "+999", layer = LAYER)

			if(n < 10)
				return image('code/Icons/Numbers.dmi', "[n]", layer = LAYER)

			if(n < 1000)
				if(!num_overlays["[n]"])
					var text = "[n]", length = length(text)
					var digits[0]

					var start = 1
					while(start <= length)
						digits.Insert(1, copytext(text, start, ++start))

					var icon/i = icon('code/Icons/Numbers.dmi', digits[1])
					digits.Cut(1, 2)

					var pos
					for(var/digit in digits)
						var icon/i2 = icon('code/Icons/Numbers.dmi', digit)
						i2.Shift(WEST, ++pos * 7)
						i.Blend(i2, ICON_OVERLAY)

					num_overlays["[n]"] = image(i)

				var image/i = num_overlays["[n]"]
				i.layer = LAYER
				return num_overlays["[n]"]

var num_overlays[0]

obj/Item
	New()
		..()
		if("item" in icon_states(icon))
			icon_state = "item"