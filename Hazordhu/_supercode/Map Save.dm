
var
	MAP_SAVE = MAPSAVE

	map_loading = 0
	save_areas[0]

atom/movable
	var
		saved_x
		saved_y
		saved_z
		saveable

	proc/map_loaded()

atom/movable
	proc/save_to(savedatum/s)
	proc/load_from(savedatum/s)

savedatum

#if MAPSAVE

var last_save
var save_period = 30	//	minutes

mob/Admin/verb
	set_save_period() save_period = input(src, "How many minutes should the auto-saver wait between saves?", "Save Period", save_period) || save_period

	Save_All() world.save_all()
	Load_Map() world.load_all()

world
	proc
		save_all(gradual = TRUE)
			world << "Saving everything..."
			SavePlayers()
			if(MAP_SAVE & SAVE_FLAG)
				if(gradual) sleep(-1)

				manage_npc("save")
				savegroups()

				if(gradual) sleep(-1)

				var saved_stuff[0]
				for(var/region/region)
					region.save(gradual)
					saved_stuff += region.saved_stuff
					if(gradual) sleep(-1)

				var types[0]
				for(var/atom/o in saved_stuff)
					types[o.type] ++

				var log = "Saved Stuff ([types.len] thing\s):"
				for(var/type in types)
					log += {"
[types[type]]	[type]\s"}

				fdel("Data/Map/saved stuff.txt")
				text2file(log, "Data/Map/saved stuff.txt")
			world << "Everything saved."

		load_all(gradual = TRUE)
			if(MAP_SAVE & LOAD_FLAG)
				map_loading = 1

//				for(var/mob/m in Players)
//					if(m.client)
//						m.update_map_load()

				manage_npc("load")
				if(gradual) sleep(-1)
				loadgroups()
				if(gradual) sleep(-1)

				var loaded_stuff[0]
				for(var/region/region)
					map_loading ++
					region.load(gradual)
					loaded_stuff += region.loaded_stuff
					if(gradual) sleep(-1)

				var types[0]
				for(var/atom/movable/o in loaded_stuff)
					o.map_loaded()
					types[o.type] ++

				var log = "Loaded Stuff ([types.len] thing\s):"
				for(var/type in types)
					log += {"
[types[type]]	[type]\s"}

				fdel("Data/Map/loaded stuff.txt")
				text2file(log, "Data/Map/loaded stuff.txt")

				map_loading = 0

			else world.log << "MAP_SAVE is off"

	New()
		..()
		if(save_areas.len)
			load_all()
			if(MAP_SAVE & SAVE_FLAG)
				SaveLoop()

	proc/SaveLoop()
		set waitfor = FALSE
		for()
			sleep 1
			if(world.time >= last_save + save_period * 600)
				last_save = world.time
				save_all(TRUE)

	Del()
		save_all()
		for(var/mob/player/p) del p
		..()

savedatum
	var
		data[0]

		save_x
		save_y
		save_z
		save_sx
		save_sy
		save_dir
		save_type
		save_contents[]
		save_name
		save_state
		save_opacity
		save_density
		save_bounds
		save_gender

		save_invisibility
		save_incandescence
		//Building Variables
		save_durability
		save_locked
		save_haslock
		save_egg

		//Sign Variable
		save_write_log
		save_message

		//Item Variables
		save_stack
		save_stackable
		save_colour

		//	Amount of cook-ness for cooked food
		save_cooked

		save_sharpness
		save_mod

		save_seasons
		save_age

		//Writing Variables (parchment)
		save_writing

		save_id
		//Animal Variables
		save_post
		save_bred
		save_mood

		save_ruff
		save_ruff_owner
		save_ruff_friends
		save_ruff_commanders

		//Flags
		save_group

		//Books
		save_pages
		save_page_title
		save_author

		//	support beams
		save_supported[]

		atom/movable/item

		//	Item durability
		save_health

		//	Totem
		save_totem_range
		save_totem_active

	proc
		load()
			if(!text2path(save_type))
				world.log << "Path caught: [save_type]!"
				return

			var turf/saved_loc = locate(save_x, save_y, save_z)
			item = new save_type (saved_loc)
			if(!item) return

			item.set_loc(saved_loc, save_sx, save_sy)
			item.dir = save_dir
			item.name = save_name

			item.icon_state = save_state
			item.opacity = save_opacity
			item.density = save_density

			item.load_from(src)

			if(save_gender) item.gender = save_gender

			if(save_bounds) item.bounds = save_bounds

			if(save_totem_range)
				var obj/Built/Totem/totem = item
				totem.range = save_totem_range
				totem.active = save_totem_active

			if(save_invisibility) item.invisibility = save_invisibility

			if(save_contents) item.contents = save_contents

			if(save_locked)
				var obj/Built/Doors/building = item
				building.Locked = save_locked
				building.icon_state = "locked"

			if(save_stack)
				var/obj/Item/object = item
				object.Stacked = save_stack
				object.Stackable = save_stackable

			if(save_colour)
				var/obj/Item/Clothing/clothing = item
				clothing.Color = save_colour
				clothing.apply_color()

			if(save_cooked) item.vars["cooked"] = save_cooked

			if(save_id)
				if("id" in item.vars)
					item.vars["id"] = save_id

				else
					if(istype(item,/obj/Item/Metal/Key))
						var/obj/Item/Metal/Key/key = item
						key.id = save_id

					else if(istype(item,/obj/Item/Metal/Lock))
						var/obj/Item/Metal/Lock/lock = item
						lock.id = save_id

					else if(istype(item,/obj/Item/Mould))
						var/obj/Item/Mould/mould = item
						mould.id = save_id

					else if(istype(item, /obj/Item/Metal/Coins) || istype(item, /obj/Item/Metal/Metal_Coins))
						var obj/Item/Metal/Coins/coin = item
						coin.stamp_id = save_id

			if(save_haslock) item.vars["haslock"] = save_haslock

			if(save_sharpness) item.vars["Sharpness"] = save_sharpness

			if(save_mod) item.vars["Mod"] = save_mod

			if(save_post)
				var mob/Animal/animal = item
				animal.posted = save_post
				animal.Locked = save_post

			if(save_bred) item.vars["bred"] = save_bred

			if(save_ruff)
				var/mob/Animal/Ruff/ruff = item
				ruff.name = save_ruff
				ruff.owner = save_ruff_owner
				ruff.friends = save_ruff_friends
				ruff.commanders = save_ruff_commanders

			if(save_mood) item.vars["mood"] = save_mood

			if(save_writing) item.vars["writing"] = save_writing

			if(save_group)
				var obj/Flag/f = item
				f.group_id = save_group

				var group/group = f.get_group()
				if(group)
					var icon/over = group.Group_Icon(f.col_icon, icon('code/Icons/group_flags.dmi', group.flag_design))
					var icon/i = icon(f.icon)
					i.Blend(over, ICON_OVERLAY)
					f.icon = i

			if(istype(item, /mob/Animal))
				var obj/Item/Tailoring/Harness/harness = locate() in item
				if(harness)
					harness.overlayo = icon(harness.icon, item.name)
					item.overlays += harness.overlayo

				for(var/obj/Item/Armour/Animal/armor in item)
					armor.overlayo = icon(armor.icon, armor.icon_state)
					item.overlays += armor.overlayo

				if(istype(item, /mob/Animal/Ruff))
					var obj/Item/Tailoring/Collar/collar = locate() in item
					if(collar)
						collar.overlayo = icon(collar.icon, "on")
						item.overlays += collar.overlayo

				if(istype(item, /mob/Animal/Peek))
					item.vars["owner_id"] = save_id
					game_loop.add(item)

			if(istype(item, /obj/Built/Doors))
				var obj/Item/Metal/Lock/lock = locate() in item
				if(lock) item.overlays += lock.icon

			if(save_pages) item.vars["pages"] = save_pages
			if(save_page_title) item.vars["title"] = save_page_title
			if(save_author) item.vars["author"] = save_author

			if(save_supported) spawn(10)
				var obj/Built/beam = item
				for(var/t in save_supported)
					var d[] = text2dim(t, ",")
					var obj/Mining/cave_walls/cave = locate() in locate(beam.x + d[1], beam.y + d[2], beam.z)
					if(cave) cave.deplete()

			if(save_egg) item.vars["egg"] = save_egg
			if(save_health) item.vars["health"] = save_health

			item.New(item.loc)

			if(istype(item,/obj/Item/Farming/plant))
				var obj/Item/Farming/plant/plant = item
				plant.set_age(save_age)

			if(istype(item, /obj/Built))
				for(var/mob/Animal/a in item.loc)
					if(!a.bred && !(locate(/obj/Item/Tailoring/Harness) in a))
						del a

				if(istype(item, /obj/Built/Transporter))
					var obj/Built/Transporter/rune = item
					if(rune.icon_state == "off")
						rune.buried = 0
					else rune.buried = 1

		save(atom/movable/item)
			save_x = item.x
			save_y = item.y
			save_z = item.z
			save_sx = item.step_x
			save_sy = item.step_y

			save_type = "[item.type]"
			save_dir = item.dir
			save_name = item.name
			save_gender = item.gender

			save_state = item.icon_state
			save_density = item.density
			save_opacity = item.opacity
			save_invisibility = item.invisibility

			item.save_to(src)

			if(item.bounds != initial(item.bounds))
				save_bounds = item.bounds

			if(item.contents.len)
				save_contents = item.contents

			if(istype(item, /obj/Built/Totem))
				var obj/Built/Totem/totem = item
				save_totem_range = totem.range
				save_totem_active = totem.active

			if(istype(item, /obj/Built))
				var obj/Built/beam = item
				if(beam.can_support)
					save_supported = list()
					for(var/obj/Mining/cave_walls/cave in range(beam.can_support, beam))
						if(cave.invisibility)
							save_supported += "[cave.x - beam.x],[cave.y - beam.y]"

				if(istype(item,/obj/Built/Doors))
					var/obj/Built/Doors/door = item
					save_locked = door.Locked

				if(istype(item,/obj/Built/Storage/Chest))
					var/obj/Built/Storage/Chest/chest = item
					var/obj/Item/Metal/Lock/lock = locate() in chest.haslock.contents
					if(lock)
						save_haslock = lock.id

			if(istype(item,/obj/Item))
				var/obj/Item/object = item

				if(object.cooked)
					save_cooked = object.cooked

				if(!isnull(object.health))
					save_health = object.health

				if(object.Stacked)
					save_stack = object.Stacked
					save_stackable = object.Stackable

				if(istype(item, /obj/Item/Metal/Coins) || istype(item, /obj/Item/Metal/Metal_Coins))
					var obj/Item/Metal/Coins/coin = item
					save_id = coin.stamp_id

				if(istype(object, /obj/Item))
					var/obj/Item/Tailoring/i = object
					if(i.Color)
						save_colour = i.Color

				if(istype(object,/obj/Item/Clothing))
					var/obj/Item/Clothing/clothing = object
					if(clothing.can_color)
						save_colour = clothing.Color

				if(istype(object,/obj/Item/Tools))
					var/obj/Item/Tools/tool = object
					save_sharpness = tool.Sharpness

				if(istype(object,/obj/Item/Weapons))
					var/obj/Item/Weapons/weapon = object
					save_sharpness = weapon.Sharpness

					if(istype(weapon,/obj/Item/Weapons/archery/Bow))
						var/obj/Item/Weapons/archery/Bow/bow = weapon
						save_mod = bow.Mod

				if(istype(object,/obj/Item/Farming/plant))
					var obj/Item/Farming/plant/plant = object
					save_age = plant.age

				if(istype(object,/obj/Built/Nest) && ("egg" in object.vars))
					save_egg = object.vars["egg"]

				if(("id" in item.vars) && issaved(item.vars["id"]))
					save_id = item.vars["id"]

				else
					if(istype(item,/obj/Item/Metal/Key))
						if(!save_id) del item
						var/obj/Item/Metal/Key/key = item
						save_id = key.id

					if(istype(item,/obj/Item/Metal/Lock))
						var/obj/Item/Metal/Lock/lock = item
						save_id = lock.id

					if(istype(item,/obj/Item/Hazium/Crystal))
						var/obj/Item/Hazium/Crystal/crystal = item
						save_id = crystal.id

					if(istype(item,/obj/Built/spawnstones/main))
						var obj/Built/spawnstones/main/obelisk = item
						save_id = obelisk.id

					if(istype(item,/obj/Item/Mould))
						var/obj/Item/Mould/mould = item
						save_id = mould.id

				if(istype(item,/obj/Item/Parchment/Written))
					var obj/Item/Parchment/Written/written = item
					save_writing = written.writing

				if(istype(item,/obj/Item/Book))
					var obj/Item/Book/book = item
					save_pages = book.pages
					save_author = book.author

				if(istype(item, /obj/Item/Book) || istype(item, /obj/Item/Parchment/Written))
					var obj/Item/Book/book = item
					save_page_title = book.title

			if(istype(item, /obj/Flag))
				var obj/Flag/f = item
				if(f.group_id) save_group = f.group_id
				if(f.Color) save_colour = f.Color

			if(istype(item,/mob/Animal))
				var mob/Animal/animal = item
				if(animal.posted) save_post = animal.posted
				if(animal.bred) save_bred = animal.bred
				if(istype(animal, /mob/Animal/Ruff) && (locate(/obj/Item/Tailoring/Collar) in animal))
					var mob/Animal/Ruff/ruff = animal
					save_ruff = ruff.name
					save_ruff_owner = ruff.owner
					save_ruff_friends = ruff.friends
					save_ruff_commanders = ruff.commanders
				if(istype(animal, /mob/Animal/Peek)) save_id = animal.vars["owner_id"]
			return 1




region
	var saved_stuff[0]
	var loaded_stuff[0]

	New()
		..()
		name = icon_state
		save_areas += src

	proc
		save_path() return "Data/Map/[name].sav"

		save(gradual = FALSE)
			saved_stuff = new

			var path = save_path()
			if(fexists(path)) fdel(path)

			var savefile/savefile = new (path)

			var savelist[]
			var save

			//	Save all items in the area
			savelist = new
			for(var/obj/Item/item in src)
				if(item.no_save) continue

				//	Item is decaying
			//	if(item.check_decay()) continue

				if(gradual) sleep(-1)

				var/savedatum/newsave = new /savedatum
				if(newsave.save(item))
					savelist += newsave

				saved_stuff += item

			if(savelist.len)
				save = 1
				savefile["items"] << savelist

			if(gradual) sleep(-1)

			//	Save all buildings in the area
			savelist = new
			for(var/obj/Built/item in src)
				if(item.no_save) continue

				if(gradual) sleep(-1)

				var/savedatum/newsave = new /savedatum
				if(newsave.save(item))
					savelist += newsave

				saved_stuff += item

			if(savelist.len)
				save = 1
				savefile["buildings"] << savelist

			if(gradual) sleep(-1)

			//	Save all flags in the area
			savelist = new
			for(var/obj/Flag/item in src)

				if(gradual) sleep(-1)

				var/savedatum/newsave = new /savedatum
				if(newsave.save(item))
					savelist += newsave

				saved_stuff += item

			if(savelist.len)
				save = 1
				savefile["flags"] << savelist

			if(gradual) sleep(-1)

			//	Save all animals in the area
			savelist = new
			for(var/mob/Animal/item in src)
				var is_saved = !item.rider && (item.tamed || item.bred || (locate(/obj/Item/Tailoring/Harness) in item) || (locate(/obj/Item/Tailoring/Collar) in item))
				if(!is_saved && istype(item, /mob/Animal/Peek))
					var mob/Animal/Peek/peek = item
					if(peek.owner_id) is_saved = TRUE
				if(is_saved)
					var/savedatum/newsave = new /savedatum
					if(newsave.save(item))
						savelist += newsave

				saved_stuff += item

				if(gradual) sleep(-1)

			if(savelist.len)
				save = 1
				savefile["animals"] << savelist

			if(gradual) sleep(-1)

			if(!save) fdel(path)
		//	else if(saved_stuff.len) world.log << "([time2text(world.timeofday)]) Saved [name]"

		load(gradual = FALSE)
			loaded_stuff = new

			var path = save_path()
			var loadlist[0]

			if(fexists(path))
				var savefile/savefile = new (path)

				if("caves" in savefile)
					savefile -= "caves"

				for(var/a in savefile)
					savefile["[a]"] >> loadlist

					for(var/savedatum/item in loadlist)
						item.load()
						loaded_stuff += item.item
						if(gradual) sleep (-world.tick_lag)

		//		if(loaded_stuff.len) world.log << "([time2text(world.timeofday)]) Loaded [name]"
				return 1
			else return 0
#endif