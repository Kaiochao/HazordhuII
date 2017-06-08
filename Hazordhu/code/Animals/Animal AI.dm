client
	move_tick()
		. = ..()
		if(.) wake_animals()

	proc/wake_animals()
		if(virtual_turf)
			var extended_view = "[round(bound_width / 32 + 1)]x[round(bound_height / 32 + 1)]"
			for(var/mob/Animal/a in orange(extended_view, virtual_turf))
				if(!a.ai_active)
					a.ai_wake(mob)

mob/Admin
	verb/active_animals()
		src << "[active_animals.len] animal\s active"

mob/player
	proc/in_range(atom/o)
		if(!client) return
		var turf/a = client.virtual_turf
		if(!a) return
		var turf/b = turf_of(o)
		if(!b) return
		return abs(b.x - a.x) <= client.bound_width / 64 && abs(b.y - a.y) <= client.bound_height / 64

world/New()
	..()
	animal_loop()

proc/animal_loop()
	set waitfor = FALSE
	for()
		sleep 1
		for(var/mob/Animal/a in active_animals)
			if(world.time >= a.ai_next_tick)
				a.ai_tick()

var active_animals[0]

turf/Environment
	Enter(mob/Animal/a)
		if(istype(a))
			if(a.is_fish) return is_water && !is_frozen()
			if(a.is_bird)
				if(opacity) return FALSE
				for(var/obj/Built/b in src)
					if(b.opacity) return FALSE
		return ..()

obj/Cross(mob/Animal/a)
	if(istype(a))
		if(a.is_bird)
			if(!opacity)
				return TRUE
	return ..()

mob
	Animal
		var tmp/next_move

		Move(Loc, Dir, StepX, StepY)
			if(rider || Locked || boat) 
				walk(src, 0)
				return
			#if !PIXEL_MOVEMENT
			if(world.time < next_move) return
			var diagonal = Dir & (Dir - 1)
			var distance_factor = diagonal ? sqrt(2) : 1
			glide_size = round(distance_factor * move_speed(), 1)
			var move_delay =  32 * distance_factor * world.tick_lag / (glide_size || 1)
			next_move = world.time + move_delay
			#endif
			return ..()

		move_speed()
			return charging ? 4 : 2

		Del()
			ai_deactivate()
			..()

		New()
			..()
			if(gender == NEUTER)
				if(istype(src, /mob/Animal/Bux))
					if(prob(66))
						icon_state = "f"
						gender = FEMALE
					else
						icon_state = ""
						mood = "aggressive"
						gender = MALE

				else if(istype(src, /mob/Animal/Stoof))
					if(prob(5))
						if(prob(66))
							icon_state = "wf"
							gender = FEMALE
						else
							icon_state = "w"
							gender = MALE
					else if(prob(5))
						if(prob(66))
							icon_state = "bf"
							gender = FEMALE
						else
							icon_state = "b"
							gender = MALE
					else if(prob(66))
						icon_state = "f"
						gender = FEMALE
					else
						icon_state = ""
						gender = MALE

				else
					if(prob(50))
						icon_state = "f"
						gender = FEMALE
					else
						icon_state = ""
						gender = MALE

		die()
			if(aggro_warning)
				overlays -= aggro_warning
				status_clear()
			..()

		var
			tmp
				mob/charging

				mob/following

				ai_active = FALSE
				ai_next_tick = 0
				ai_ticking = FALSE

				wakers[]
				prey_near[]

				is_bird
				is_fish

				next_wander

				image/aggro_warning

		Peek/is_bird = TRUE
		Kaw/is_bird = TRUE
		Scree/is_bird = TRUE

		Ramar/is_fish = TRUE

		proc
			ai_wake(waker)
				if(rider) return
				if(ai_active) return
				if(active_animals[src]) return

				active_animals |= src
				ai_active = TRUE

				if(!wakers) wakers = new
				wakers |= waker

				return TRUE

			ai_deactivate()
				ai_active = FALSE
				active_animals -= src

				walk(src, FALSE)
				return TRUE

			ai_tick()
				set waitfor = FALSE
				if(ai_ticking) return
				if(charging) return

				ai_ticking = TRUE
				if(ai_pre() && ai_step())
					ai_end()
				else if(ai_active)
					ai_deactivate()

				ai_ticking = FALSE

				if(ai_active && !(src in active_animals))
					ai_deactivate()

			ai_pre()
				if(Locked || rider)
					ai_deactivate()
					return
				return check_targets()

			can_wander()
				return next_wander <= world.time && !(rider || boat)

			ai_step()
				if(Locked) return

				var can_wander = can_wander()
				if(can_wander)
					if(is_harnessed())
						can_wander = prob(25)
					else if(mood == "aggressive" && ai_combat())
						can_wander = FALSE

				if(can_wander)
					next_wander = world.time
					if(following)
						next_wander += rand(5, 15)
					else next_wander += rand(30, 60)

					if(following)
						walk_to(src, following)

					else
						var turfs[0]
						var mob/center = following || src
						var distance = following ? 1 : 3
						for(var/turf/t in center.nearby_turfs(distance))
							if(is_bird || !t.density)
								turfs += t

						if(turfs.len)
							var turf/t = pick(turfs)
							if(t)
								if(is_bird)
									if(t.density)
										start_flying()
									else stop_flying()
								walk_to(src, t)

				return TRUE

			ai_end()
				ai_next_tick = world.time + 10
				return TRUE

			//	returns whether or not to stay awake
			check_targets()
				prey_near = new

				var nearby[] = ohearers(6, src)
				for(var/mob/Animal/m in nearby)
					if(m.type == type)
						continue
					prey_near += m

				for(var/mob/player/p in nearby)
					if(!wakers)
						wakers = list(p)
					else wakers |= p

				if(wakers)
					while(wakers.Remove(null));
					for(var/mob/player/m in wakers)
						if(!m.in_range(src))
							wakers -= m
					if(!wakers.len)
						wakers = null
					else return TRUE
				return FALSE

			is_target(mob/m)
				if(m.type == /mob/title) return
				if(!ismob(m)) return
				if(m.GodMode) return
				if(!Enter(m.loc)) return
				if(get_dist(src, m) > 7) return
				return 1

			find_targets()
				. = list()
				for(var/mob/m as mob in wakers|prey_near)
					if(is_target(m))
						. += m

			find_target()
				var targets[] = find_targets()
				if(targets.len)
					. = pick(targets)

			ai_combat(target)
				if(Locked) return
				if(ai_warn(target) && ai_charge(target))
					return ai_attack(target)

			ai_warn(target)
				if(Locked || is_harnessed()) return
				var nearby_targets[]
				if(target)
					if(get_dist(src, target) > 5)
						return

				else
					nearby_targets = find_targets()
					if(!nearby_targets.len)
						return

				if(!aggro_warning)
					aggro_warning = new
					aggro_warning.icon = 'code/Icons/aggressive.dmi'
					aggro_warning.layer = FLOAT_LAYER
					aggro_warning.pixel_x = -pixel_x
					aggro_warning.pixel_y = -pixel_y
					if(istype(src, /mob/Animal/Flargl)	|| \
					  istype(src, /mob/Animal/Olihant)	|| \
					  istype(src, /mob/Animal/Troll)
					 )
						aggro_warning.pixel_y += 32
					if(istype(src, /mob/Animal/Agriner)	|| \
					  istype(src, /mob/Animal/Ramar)		|| \
					  istype(src, /mob/Animal/Shomp)
					 )
						aggro_warning.pixel_y += 16

				emote(pick(warn_list))
				play_aggressive()

				Locked = TRUE
				overlays += aggro_warning

				var warn_duration = 20
				if(target)
					dir = get_dir(src, target)
					sleep warn_duration

				else
					var time = warn_duration / nearby_targets.len
					for(var/mob/m in nearby_targets)
						dir = get_dir(src, m)
						sleep time

				overlays -= aggro_warning
				Locked = FALSE
				return TRUE

			ai_charge(target)
				if(Locked || is_harnessed()) return
				if(charging) return

				if(!target) target = find_target()
				if(!target) return
				if(!(target in ohearers(src))) return

				charging = target

				if(bounds_dist(src, charging) < 2)
					return TRUE

				var textIcon = textIcon()
				var warning = pick(charge_list)
				for(var/mob/M in ohearers(src))
					M << "*[textIcon] <b>[src]</b> [warning] [M.nameShown(target)].*"

				walk(src, 0)

				var charge_end = world.time + 30
				var charge_speed = 4
				while(world.time < charge_end)

					if(is_bird) start_flying()

					step_to(src, charging, 0, charge_speed)

					if(bounds_dist(src, charging) <= charge_speed)
						return TRUE

					sleep(world.tick_lag)
					if(is_bird) stop_flying()
				charging = null

			ai_attack(mob/mortal/target)
				set waitfor = FALSE
				if(Locked || is_harnessed()) return
				if(!target) target = charging
				if(!target) return
				charging = null

				var textIcon = textIcon()
				var warning = pick(attack_list)
				for(var/mob/M in ohearers(src))
					M << "*[textIcon] <b>[src]</b> [warning] [M.nameShown(target)].*"

				target.knockback(src, 8)

				var result = combat_result(src, target)
				switch(result)
					if("parry")
						target.emote("parries the attack")
						target.view_sound(sound('code/Sounds/steel slash.wav'))
					if("block")
						target.emote("blocks the attack")
						target.view_sound(sound('code/Sounds/sword slash.wav'))
					else if(isnum(result))
						target.take_damage(result, "a creature in the wilderness")
				return TRUE

			play_passive()
				if(passive_sounds && passive_sounds.len)
					. = pick(passive_sounds)
					for(var/mob/m in ohearers(src))
						m.hear_sound(.)

			play_aggressive()
				if(aggressive_sounds && aggressive_sounds.len)
					. = pick(aggressive_sounds)
					for(var/mob/m in ohearers(src))
						m.hear_sound(.)

			playerFound()
				return 0
				for(var/mob/m as mob in ohearers(world.view + 2, src))
					if(m.key || m.type == /mob/title)
						return TRUE

		Flargl
			ai_charge(mob/target)
				if(prob(55)) return ..()

				if(charging) return
				if(!target) target = find_target()
				if(!target) return
				if(!(target in ohearers(src))) return
				charging = target
				if(bounds_dist(src, charging) < 2)
					return TRUE

				var textIcon = textIcon()
				for(var/mob/M in ohearers(src))
					M << "*[textIcon] <b>[src]</b> breathes fire at [M.nameShown(target)]*"

				var turf/start = loc
				var obj/Fire/f = new (start)

				var p1[] = vec2(cx(), cy())
				var p2[] = vec2(target.loc.cx(), target.loc.cy())
				var d[] = vec2_to(p1, p2)
				var dist = vec2_mag(d)
				var speed = 8
				var v[] = vec2_setmag(d, speed)

				for(var/n in 1 to dist step speed)
					if(!f) break
					p1 = vec2_add(p1, v)
					f.set_loc(locate(
						p1[1] / 32 + 1,
						p1[2] / 32 + 1,
						start.z),
						p1[1] % 32, p1[2] % 32)

					var obj/Fire/f2 = new (f.loc)
					var a = rand(360)
					f2.set_step(f.step_y + rand(2, 6) * sin(a), f.step_y + rand(2, 6) * cos(a))
					sleep world.tick_lag

				if(f) for(var/turf/t in oview(1, f))
					if(t.density) continue
					var obj/Fire/f2 = new (f.loc)
					var a = angle_to(f.loc, t) + rand(-30, 30)

					f2.set_step(f.step_x + rand(6, 12) * sin(a), f.step_y + rand(6, 12) * cos(a))

				charging = null

		Agriner
			ai_charge(target)
				if(Locked || is_harnessed()) return
				if(charging) return

				if(!target) target = find_target()
				if(!target) return
				if(!(target in ohearers(src))) return

				charging = target

				if(bounds_dist(src, charging) < 2) return TRUE

				var textIcon = textIcon()
				var warning = pick(charge_list)
				for(var/mob/m in ohearers(src)) m << "*[textIcon] <b>[src]</b> [warning] [m.nameShown(target)].*"

				walk(src, 0)

				hit_target = FALSE
				dir = get_dir(src, charging)
				var charge_end = world.time + 30
				var charge_speed = 6
				var vel[] = vec2p(charge_speed, angle_to(src, target))
				while(world.time < charge_end)
					move(vel)

					if(hit_target) return TRUE
					if(bumped)
						if(is_attackable(bumped))
							var mob/m = bumped
							var result = combat_result(src, m)
							if(isnum(result)) m.take_damage(result, src)
						break

					sleep world.tick_lag
				charging = null

			var tmp/hit_target = FALSE
			Bump(mob/m)
				if(m == charging)
					hit_target = TRUE
				else ..()

mob
	proc/knockback(atom/movable/from, distance)
		var t = from.loc
		var d = dir
		for(var/n in 1 to distance)
			step_away(src, from && from.z ? from : t, 5, 4)
			dir = d
			sleep world.tick_lag