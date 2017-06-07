//	This stuff used to be in Interaction.dm

var obj/click_void/click_void = new
obj/click_void
	parent_type = /obj
	name = ""
	icon = 'code/Icons/black.dmi'
	plane = -100
	layer = BACKGROUND_LAYER
	mouse_opacity = 2
	screen_loc = "SOUTHWEST to NORTHEAST"

mob
	player
		key_down(k)
			if(k == "tab")
				if(!in_tutorial())
					combat_toggle()
			else if(k == "space")
				if(combat_mode)
					_attack()
			else if(k == "r")
				if(combat_mode)
					if(!archery_toggle())
						block_start()
			else ..()

		key_up(k)
			if(k == "r")
				block_stop()
			else ..()

		PostLogin()
			..()
			if(client && click_void)
				client.screen += click_void

	var tmp/combat_mode = FALSE

	move_tick()
		. = ..()
		if(combat_mode)
			combat_tick()

	proc/combat_tick()
		var new_dir = dir
		if(client.mouse.over)
			new_dir = angle2dir(client.mouse.angle)

		if(dir != new_dir)
			dir = new_dir
			if(is_humanoid(src))
				var mob/humanoid/h = src
				h.update_equipment_layers()

		update_combat_zone()

	proc/combat_toggle()
		if(combat_mode)
			combat_off()
		else combat_on()

	proc/combat_on()
		combat_mode = TRUE
		status_overlay("combat")

	proc/combat_off()
		combat_mode = FALSE
		status_overlay_remove("combat")
		update_combat_zone()
		if(is_humanoid(src))
			var mob/humanoid/h = src
			if(h.shooting)
				h.archery_stop()

	var tmp/blocking
	proc/block_start()
		if(blocking || attacking) return
		if(is_humanoid(src))
			var mob/humanoid/h = src
			if(h.shooting)
				return
		blocking = TRUE
		icon_state = "block"

	proc/block_stop()
		if(!blocking) return
		blocking = FALSE
		icon_state = ""

client
	MouseDown(o,l,c,pa)
		var mob/player/player = mob
		if(player.combat_mode)
			var p[] = params2list(pa)
			if(p["right"])
				return player.block_start()
		..()

	MouseUp(o, l, c, pa)
		var mob/player/player = mob
		var p[] = params2list(pa)
		if(p["right"])
			if(player.combat_mode && player.is_equipped(/obj/Item/Weapons/archery))
				player.archery_toggle()
			return player.block_stop()

		else if(p["left"])
			if(player.combat_mode)
				return player._attack()
		..()