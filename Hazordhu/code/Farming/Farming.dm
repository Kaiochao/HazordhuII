
//	the farming loop calls grow() every second
var looper/farming_loop = new ("grow", SECOND)

var growing_seasons[] = list(
	/obj/Item/Farming/plant/Tumeta		= list(SPRING),
	/obj/Item/Farming/plant/Phluf		= list(SPRING, SUMMER),
	/obj/Item/Farming/plant/Lettif		= list(SUMMER),
	/obj/Item/Farming/plant/Kurn		= list(AUTUMN),
	/obj/Item/Farming/plant/Huff		= list(AUTUMN),
	/obj/Item/Farming/plant/Shurgercane	= list(AUTUMN),
	/obj/Item/Farming/plant/Puteta		= list(AUTUMN, WINTER),
	/obj/Item/Farming/plant/Karet		= list(AUTUMN, WINTER),
	/obj/Item/Farming/plant/Murshum		= list(SPRING, SUMMER, AUTUMN, WINTER),
	/obj/Item/Farming/plant/Yeese		= list(SPRING, SUMMER, AUTUMN, WINTER)
)

var underground_plants[] = list(
	/obj/Item/Farming/plant/Murshum,
	/obj/Item/Farming/plant/Yeese
)

turf/Environment
	season_update()
		..()
		for(var/obj/Item/Farming/plant/plant in src)
			if(plant.wild)
				del plant
		spawn_wild_plant()

	//	each tile gets a probability of spawning a wild plant per season
	proc/wild_plant_chance() return 0
	Grass/wild_plant_chance() return 1
	Dirt/wild_plant_chance() return 0.3

	proc/spawn_wild_plant()
		if(locate(/obj/Built) in src) return

		if(prob(wild_plant_chance()))

			//	only spawn a plant that can grow this season
			var potential[0]
			var season = get_season()
			for(var/path in growing_seasons)
				if(path in underground_plants)
					if(z == 1) continue
				else if(z == 2) continue

				if(season in growing_seasons[path])
					potential += path

			if(!potential.len) return

			//	spawn plants in clusters!
			for(var/n in 1 to rand(10, 35))
				var path = pick(potential)
				var obj/Item/Farming/plant/plant = new path (src)
				plant.wild = TRUE
				plant.no_save = TRUE

				//	randomize the plant's position within the tile because why not
				#if PIXEL_MOVEMENT
				var angle = randn(0, 360)
				var dist = 0.25 * n * n
				plant.Move(src, 0, sin(angle) * dist, cos(angle) * dist)
				#endif

				var turf/Environment/t = plant.loc
				if(!istype(t) || !t.wild_plant_chance() || (locate(/obj/Built) in t))
					del plant
					continue

				//	the spawned wild plant's age will be random
				plant.set_age(randn(0, plant.growth_freq * (plant.stages - 1)))

obj
	Item
		Farming
			Flammable = TRUE
			icon = 'Farming.dmi'

			plant
				Stackable = FALSE
				layer = TURF_LAYER + 1.1
				standing = TRUE
				bottom_offset = 8

				/savedatum
					var growth_rate

				save_to(savedatum/s)
					..()
					s.growth_rate = growth_rate

				load_from(savedatum/s)
					..()
					growth_rate = s.growth_rate
					farming_loop.add(src)

				//	current age, in minutes
				var age = 0
				var growth_rate = 1 		//	1 minute per grow
				var tmp/growth_freq = 30	//	grows per stage

				var stage = 1
				var tmp/stages = 3			//	planted, growing, grown

				var tmp/has_seed = TRUE
				var tmp/has_crop = FALSE

				var tmp/grow_underground = FALSE

				var wild = FALSE

				New()
					if(loc) for(var/obj/Item/Farming/plant/plant in obounds()) del plant
					..()
					update_stage()
					farming_loop.add(src)

				Del()
					set_loc()
					farming_loop.remove(src)

				Karet

				Phluf

				Kurn

				Puteta

				Tumeta

				Huff

				Lettif

				Shurgercane

				Yeese
					has_seed = FALSE
					grow_underground = TRUE

				Murshum
					has_seed = FALSE
					grow_underground = TRUE

				Get()

				proc
					grow()
						// the plant stops growing when the season changes to one it doesn't like
						// or if it's not in a proper environment
						if((grow_underground && z == 1) || (!(get_season() in growing_seasons[type])))
							stop_growing()

						if(growth_rate)
							set_age(age + growth_rate / 60)

					set_age(value)
						age = value
						update_stage()

					update_stage()
						var new_stage = clamp(1 + round(age / growth_freq), 1, stages)
						if(stage != new_stage)
							stage = new_stage
						if(icon_state != "[stage][name]")
							icon_state = "[stage][name]"
						if(stage == stages)
							has_crop = TRUE
							stop_growing()

					die()
						del src

					stop_growing()
						growth_rate = 0
						farming_loop.remove(src)

			crop
				var Hunger
				New(loc)
					..()
					Hunger = rand(1, 15)

				use(mob/player/m)
					m.lose_hunger(Hunger)
					m.gain_health(round(Hunger / 2))
					m.aux_output("You eat [src].")
					m.lose_item(src)

				Karet/icon_state = "Karet"
				Tumeta/icon_state = "Tumeta"
				Phluf/icon_state = "Phluf"
				Kurn/icon_state = "Kurn"
				Huff/icon_state = "Huff"
				Puteta/icon_state = "Puteta"
				Lettif/icon_state = "Lettif"
				Murshum/icon_state = "Murshum"
				Yeese/icon_state = "Yeese"
				Shurgercane/icon_state = "Shurgercane"

			seed
				MouseDrop(obj/Item/Bowl/Water/water_bowl)
					..()
					if(istype(water_bowl))
						make_tannin(usr, water_bowl)

				proc/make_tannin(mob/player/p, obj/Item/Bowl/Water/water_bowl)
					p.lose_item(water_bowl)
					p.lose_item(src)
					p.get_item(new /obj/Item/Bowl/Tannin)
					p.aux_output("You crush some seeds into tannin.")

				Karet
					icon_state = "KaretSeeds"
					name = "Karet Seed"
				Tumeta
					icon_state = "TumetaSeeds"
					name = "Tumeta Seed"
				Phluf
					icon_state = "PhlufSeeds"
					name = "Phluf Seed"
				Kurn
					icon_state = "KurnSeeds"
					name = "Kurn Seed"
				Huff
					icon_state = "HuffSeeds"
					name = "Huff Seed"
				Puteta
					icon_state = "PutetaSeeds"
					name = "Puteta Seed"
				Lettif
					icon_state = "LettifSeeds"
					name = "Lettif Seed"
				Yeese
					icon_state = "YeeseSeeds"
					name = "Yeese Seed"
				Shurgercane
					icon_state = "ShurgercaneSeeds"
					name = "Shurgercane Seed"




/***************************
* Stuff for the farm stuff *
***************************/

obj/Item/Farming/crop
	Phluf
		use(mob/player/m)
			var has_carding_tool = m.is_equipped(/obj/Item/Tools/Carding_Tool)
			var has_spool = locate(/obj/Item/Tools/NeedleThread) in m
			if(has_carding_tool && has_spool)
				m.emote("begins to card the Phluf into thread")
				m._do_work(30)
				m.emote("makes thread from the Phluf.")
				m.lose_item(src)
				m.get_item(/obj/Item/Tailoring/Thread)
			else m.aux_output("You need a carding tool in your main hand to card phluf, and a spool in your inventory. ")

	Huff
		MouseDrop(obj/Item/Pipe/P)
			if(loc == usr && istype(P) && P.loc == usr)
				P.Insert_Huff(usr)
			..()