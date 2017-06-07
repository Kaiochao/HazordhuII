mob/player
	verb/Suicide()
		set hidden = TRUE
		for(var/obj/Item/i in src)
			if(is_equipped(i))
				unequip(i)
			i.set_loc(loc)
		InventoryGrid()
		lose_health(Health, "suicide")

	die()
		status_clear()
		..()

mob
	proc
		KO(time = 900)
			if(KO) return
			KO = TRUE

			sight |= BLIND
			Locked = TRUE
			Resting = 2

			if(is_humanoid(src))
				var mob/humanoid/h = src
				if(h.mount)
					h.mount.dismount(h)

				h.icon_turn(90)

			spawn(time)
				WakeUp()

		WakeUp()
			if(!KO) return
			KO = FALSE

			sight &= ~BLIND
			Locked = FALSE
			Resting = FALSE

			if(is_humanoid(src))
				var mob/humanoid/h = src
				h.icon_turn(0)
				h.Gethair()

			status_refresh()

		death_check(cause)
			if(Dead) return
			Health = clamp(Health, 0, MaxHealth)
			if(!Health) die(cause)

		die(cause)
			//	Cause of death message
			if(istext(cause))
				emote("dies from [cause]")
			else if(is_mortal(cause))
				if(is_player(cause))
					var mob/player/p = cause
					var killer
					if(p.GodMode)
						killer = p.Ael
					else
						if(is_player(src)) p.Kills ++
						killer = p.key

					if(is_player(src))
						AdminsOnline << "<font color=red>[key] has been killed by [killer] [ADMIN_TELE(src)]"
						combat_log   << "\[[time2text(world.realtime)]] [p.name] ([p.key]) attacked [name] ([key])\n"

						var mob/player/a = p
						var mob/player/b = src
						a.log_action("killed [b.key] ([b.charID])")
						b.log_action("was killed by [a.key] ([a.charID])")

				if(is_npc(cause))
					var mob/NPC/npc = cause
					npc.killed_target(src)
				emote("is slain")
			else emote("dies mysteriously")

			//	Create a corpse when not on water
			var turf/Environment/Water/w = loc
			if(!is_water(w) || istype(w) && w.is_frozen())
				status_clear()
				new /mob/Corpse (src)

			set_loc()

		//	Spawn a zombie of similar appearance.
		zombify()
			if(CurrentZombies >= MaxZombies) return
			var mob/NPC/Zombie/z = new (loc)
			z.overlays += overlays
			z.leader = infection_leader

		//	Turn into an Undead race.
		turn_undead()
			aux_output("Your curse causes you to become undead!")
			Cursed = FALSE
			Race = "Undead"
			Speaking = "Undead"
			Health = MaxHealth
			Blood = 100

		StaminaCheck()
			if(istype(src, /mob/NPC) || Race == "Undead") return
			Stamina = clamp(Stamina, 0, MaxStamina)
			if(KO) return

			if(!Stamina)
				aux_output("You pass out from exhaustion")
				take_damage(10, "exhaustion")
				Resting = 2
				KO()

		BloodCheck(mob/m)
			if(Blood > 0) return
			take_damage(Health, "blood loss")

mob
	Animal
		die(mob/player/killer)
			if(is_player(killer))
				killer.medalMsg("Hunter")
			if(rider) dismount(rider)
			if(is_harnessed())
				var obj/Item/Tailoring/Harness/h = locate() in src
				h.Move(loc, 0, step_x, step_y)
			posted = FALSE
			..()

	NPC
		Zombie
			die()
				..()
				CurrentZombies --

	humanoid
		die()
			if(Cursed)
				turn_undead()
				return

			if(mount) mount.dismount(src)

			if(boat)
				boat.remove_rider(src)
				if(boat && !boat.passengers.len)
					view(src) << "The [boat] sinks."
					del boat

			for(var/obj/Item/binders/o in binders)
				o.remove(src, loc)

			if(pulling_cart) stop_pulling_cart()
			if(dragging_body) stop_dragging()
			..()

	player
		die()
			..()
			combat_off()
			set_health(0)
			Dead = TRUE
			pixel_x = 0
			pixel_y = 0
			zombie_infection = 0

			Deaths ++
			var respawn_time = 250 + Kills * 50
			aux_output("Wait [respawn_time / 10] seconds to respawn.")
			spawn(respawn_time)
				Respawn()


var looper/regen_loop = new ("life tick", 200)

mob
	New()
		..()
		MaxHealth = max(Health, MaxHealth)

	proc/set_health(n) Health = clamp(n, 0, MaxHealth)
	proc/gain_health(amount) set_health(Health + amount)
	proc/take_damage(amount, cause)
		set_health(Health - amount)
		display_damage(src, amount)
		death_check(cause)
	proc/lose_health(amount, cause) take_damage(amount, cause)

	proc/set_stamina(n) Stamina = clamp(n, 0, MaxStamina)
	proc/gain_stamina(amount) set_stamina(Stamina + amount)
	proc/lose_stamina(amount)
		set_stamina(Stamina - amount)
		StaminaCheck()
	proc/drain_stamina(amount) lose_stamina(amount)
	proc/use_stamina(amount, cause)
	#if WORK_STAMINA
		if(Stamina < max(amount, 10))
			aux_output("You're too tired to [cause]!")
			return FALSE
		drain_stamina(amount)
	#endif
		return TRUE

	player
		//	Lower hunger/thirst is better
		proc/set_hunger(n) Hunger = clamp(n, 0, 100)
		proc/set_thirst(n) Thirst = clamp(n, 0, 100)

		//	happens gradually over time
		proc/gain_hunger(amount)
			var pre_hunger = Hunger

			set_hunger(Hunger + amount)

			if(pre_hunger < 95 && Hunger >= 95)			aux_output("You are about to die of starvation!", src)
			else if(pre_hunger < 80 && Hunger >= 80)	aux_output("You feel very hungry.", src)
			else if(pre_hunger < 60 && Hunger >= 60)	aux_output("You feel a bit hungry.", src)

		proc/gain_thirst(amount)
			var pre_thirst = Thirst

			set_thirst(Thirst + amount)

			if(pre_thirst < 95 && Thirst >= 95)			aux_output("You are about to die of dehydration!", src)
			else if(pre_thirst < 80 && Thirst >= 80)	aux_output("You feel very thirsty.", src)
			else if(pre_thirst < 60 && Thirst >= 60)	aux_output("You feel a bit thirsty.", src)

		//	happens when you eat/drink
		proc/lose_hunger(amount) set_hunger(Hunger - amount)
		proc/lose_thirst(amount) set_thirst(Thirst - amount)

		proc/Regen() regen_loop.add(src)

		proc/life_tick()
			//	Aels and Dead people have no effect
			if(GodMode || Dead) return

			//	Sleeping removes all normal hunger/thirst increases.
			if(!Sleeping)
				//	Normal hunger/thirst increase.
				if(Race != "Undead")
					gain_hunger(0.1)
					gain_thirst(0.2)

				//	Thirst rises faster in the summer
				if(get_season() == SUMMER)
					gain_thirst(0.5)

			else gain_health(0.1)

			//	Normal stamina regeneration.
			//	More stamina regenerated when resting.
			if(Stamina < MaxStamina)
				gain_stamina(1 + Resting)

			//	Poison depletes health and increases hunger and thirst.
			if(Poisoned)
				take_damage(10 * Poisoned, "poison")
				gain_hunger(10 * Poisoned)
				gain_thirst(12 * Poisoned)

			//	Health regeneration. Does not happen when poisoned.
			else if(Health < MaxHealth)
				gain_health(0.5 + Resting)

				//	When injured, hunger and thirst rise faster.
				if(Race != "Undead")
					gain_hunger(0.5)
					gain_thirst(0.7)
					if(body_heat >= 75)
						gain_thirst(1)

			//	Blood regeneration.
			if(Blood < 100) Blood += rand(0.5, 1) + Resting

			Blood = clamp(Blood, 0, 100)

			HungerCheck()

		proc/HungerCheck()
			if(Race == "Undead") return

			if(Hunger >= 100)
				var damage = rand(10, 30)
				if(!KO)
					aux_output("<font color=red>You lose [damage] stamina due to starvation!</font>", src)
					lose_stamina(damage)
				else
					aux_output("<font color=red>You lose [damage] health due to starvation!</font>")
					take_damage(damage, "starvation")

			if(Thirst >= 100)
				var damage = rand(10, 30)
				if(!KO)
					aux_output("<font color=red>You lose [damage] stamina due to dehydration!</font>", src)
					lose_stamina(damage)
				else
					aux_output("<font color=red>You lose [damage] health due to dehydration!</font>", src)
					take_damage(damage, "dehydration")

mob/player
	proc/get_flag_spawn()
		var flag_path = text2path("/obj/Flag/[Race]")
		if(!ispath(flag_path)) return
		var obj/Flag/flag = locate(flag_path)
		if(!flag) return
		return flag.loc

	proc/get_obelisk_spawn()
		var obj/Item/Hazium/Crystal/c = (locate() in src) || (locate(/obj/Item/Armour/Accessory/Amulet) in src) // get_equipped(/obj/Item/Armour/Accessory/Amulet)
		if(!c) return
		for(var/obj/Built/spawnstones/main/m)
			if(m.id != c.id || !m.check()) continue

			flick("activate", m)
			sleep(SECOND)
			return get_step(m, 2)

	proc/get_starter_spawn() return locate("tutorial spawn")

	proc/Respawn(starter)
		set_loc(!starter && (get_obelisk_spawn() || get_flag_spawn()) || get_starter_spawn())

		WakeUp()
		Dead = FALSE

		Health = MaxHealth
		Stamina = MaxStamina
		Blood =	MaxBlood
		Hunger = 0
		Thirst = 0

		drunk_loop = 0
		drunk = 0
		zombie_infection = 0

		sight = initial(sight)