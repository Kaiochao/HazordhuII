
obj
	Woodcutting
		density = TRUE
		Flammable = TRUE

		var fruit
		var max_fruit
		var fruit_type = /obj/Item/Food/Berry

		proc/pick_fruit(mob/m)
			if(!fruit) return
			fruit = max(0, fruit - 1)
			m.get_item(new /obj/Item/Food/Berry)
			if(!fruit) icon_state = "Spring"
			return TRUE

		/*interact_right(mob/m)
			if(fruit != null)
				return pick_fruit(m)
			else return ..()*/

		season_update(season)
			..()
			if(!istype(src, /obj/Woodcutting/Jungle/Bush) && (season == WINTER || season == AUTUMN))
				fruit = 0
			else
				if(!max_fruit) max_fruit = initial(fruit)
				if(max_fruit) fruit = max_fruit
				if(fruit) icon_state = "Summer"

		Bush
			SET_BOUNDS(12, 4, 8, 8)
			icon = 'code/Woodcutting/Berry Bush.dmi'
			icon_state = "Summer"
			resources = 3
			experience = 1
			fruit = 3

		Tree
			icon = 'code/Woodcutting/Tree.dmi'
			icon_state = "Summer"
			resources = 25
			experience = 2
			pixel_x = -32
			pixel_y = 8

		Tree2
			icon = 'code/Woodcutting/Tree2.dmi'
			icon_state = "Summer"
			name = "Tree"
			resources = 15
			experience = 2
			pixel_x = -32
			pixel_y = 8

		Thin_Tree
			icon = 'thin tree.dmi'
			resources = 5
			experience = 1
			SET_TBOUNDS("10,1 to 23,11")

		Jungle
			Tree
				icon = 'code/Woodcutting/JungleTree.dmi'
				pixel_x = -32
				pixel_y = 8
				resources = 25
				experience = 2
				icon_state = "1"
			Tree2
				icon = 'code/Woodcutting/JungleTree.dmi'
				pixel_x = -32
				pixel_y = 8
				resources = 15
				experience = 2
				icon_state = "2"
			Tree3
				icon = 'code/Woodcutting/JungleTree.dmi'
				pixel_x = -32
				pixel_y = 8
				resources = 20
				experience = 2
				icon_state = "3"

			Bush
				icon = 'code/Woodcutting/Berry Bush.dmi'
				icon_state = "Summer"
				SET_BOUNDS(12, 4, 8, 8)
				resources = 5
				experience = 1
				fruit = 3

			Thin_Tree
				icon = 'thin tree.dmi'
				resources = 5
				experience = 1
				SET_TBOUNDS("10,1 to 23,11")

		Desert
			Cactus
				SET_BOUNDS(12, 11, 8, 8)
				pixel_y = 9
				resources = 2
				experience = 1
				icon = 'Cactus.dmi'
				name = "Cactus"
				Bumped(mob/mortal/m)
					if(istype(m))
						m.take_damage(rand(1, 3), "a cactus")
						m.Bleed()

				Cactus1 icon_state = "1"
				Cactus2 icon_state = "2"
				Cactus3 icon_state = "3"

		//Dead Trees
		Dead
			icon_state = "Winter"
			Tree
				icon = 'code/Woodcutting/Tree.dmi'
				resources = 25
				experience = 1
				pixel_x = -32
				pixel_y = 8

			Tree2
				icon = 'code/Woodcutting/Tree2.dmi'
				name = "Tree"
				pixel_x = -32
				pixel_y = 8
				experience = 1
				resources = 15

			Bush
				icon = 'code/Woodcutting/Berry Bush.dmi'
				resources = 3
				experience = 1
				pixel_y = 8

			Thin_Tree
				icon = 'thin tree.dmi'
				resources = 5
				experience = 1
				SET_TBOUNDS("10,1 to 23,11")

	Item
		Wood
			Flammable = TRUE

			Log
				value = 1
				icon = 'code/Woodcutting/Log.dmi'
/*
				proc/MakeBoards(mob/humanoid/m)
					if(m.Locked) return
					if(m.has_hatchet())
						icon_state = "chop"
						m.emote("begins chopping a log into boards")
						m._do_work(30)
						var boards = rand(1, 3)
						m.emote("makes [boards] board[boards > 1 ? "s":] from a log")

						for(var/n in 1 to boards)
							. = new /obj/Item/Wood/Board (m.loc)

						icon_state = ""
						Stack_Check(1)

						var mob/player/player = is_player(m) && m
						if(player) player.gain_experience(WOODCUTTING, 1)
*/
			Board
				value = 2
				icon = 'code/Woodcutting/Board.dmi'