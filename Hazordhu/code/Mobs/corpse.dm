mob/Corpse
	density = FALSE
	layer = MOB_LAYER - 2
	Flammable = TRUE
	Dead = TRUE

	var ol[0]
	var deg
	var hair_overlay
	var head_state
	var is_animal

	New(mob/m)
		set waitfor = FALSE
		..()
		if(istype(m, /mob/Animal))
			name = "Dead [m]"
			is_animal = TRUE

		set_loc(m.loc)

		SkinType = m.SkinType
		MeatType = m.MeatType

		icon = m.icon
		icon_state = m.icon_state
		overlays = m.overlays
		transform = turn(matrix(), pick(90, -90))

		dir = NORTH

	#if PIXEL_MOVEMENT
		step_x = m.step_x
		step_y = m.step_y
	#endif

		pixel_x = m.pixel_x
		pixel_y = m.pixel_y

		SET_TBOUNDS(m.bounds)

		head_state = get_head(m)

		if(istype(loc, /turf/Environment/Water)) if(get_season() != WINTER) del src
		if(istype(loc, /turf/Environment/Ocean)) del src

		if(istype(m, /mob/Animal/Flargl))
			pixel_x -= 32
			pixel_y -= 32

		sleep 10 * MINUTE
		if(findtext(name, "Corpse"))
			skelefy()
			sleep HOUR
		loc = null

	interact(mob/humanoid/m)
		Skin(m)

	proc
		skelefy()
			if(is_animal) return
			icon = 'code/mobs/skeleton.dmi'
			icon_state = ""
			name = "Skeleton"
			head_state = "skeleton"
			MeatType = /obj/Item/Bone
			SkinType = null
			overlays.Cut()

		Skin(mob/humanoid/skinner)
			if(skinner.Locked) return

			if(skinner.has_hatchet())
				skinner.emote("starts beheading the [src]")
				skinner._do_work(30)
				skinner.emote("finishes beheading the [src]")
				skinner.used_tool()

				var obj/Item/Head/h = new (loc)
				h.icon_state = head_state || icon_state
				set_loc()

			else if(skinner.has_knife())
				skinner.emote("starts skinning the [src]")
				skinner._do_work(30)
				skinner.emote("finishes skinning the [src]")
				skinner.used_tool()

				var list/products = list()

				if(SkinType)
					if(prob(33))
						products += new SkinType
					products += new SkinType

				if(MeatType)
					products += new MeatType
				
				for(var/obj/product in products)
					product.Move(loc, 0, step_x, step_y)

				if(is_animal)
					if(prob(50))
						set_loc()
				else if(name == "Skeleton")
					if(prob(75))
						set_loc()
				else skelefy()

				return TRUE

		get_head(mob/m)  // The icon state for a head that's given.
			switch(m.type)
				if(/mob/Animal/Flargl)			return "flargl"
				if(/mob/Animal/Troll)			return "troll"
				if(/mob/Animal/Flurm)			return "flurm"
				if(/mob/Animal/Flurm/Flurm1)	return "flurm1"
				if(/mob/Animal/Grawl)			return "grawl"
				if(/mob/Animal/Grawl/North) 	return "ngrawl"
				if(/mob/Animal/Olihant) 		return "olihant"
				if(/mob/Animal/Bux)				return "bux"
				if(/mob/Animal/Rar)				return "rar"
				if(/mob/Animal/Agriner)			return "agriner"
				if(/mob/NPC/Baby)				return "baby_[copytext(lowertext(m.Race), 1, 2)]"
				else
					switch(m.Race)
						if("Human") switch(m.Heritage)
							if("Southshores")	return "Black"
							if("Plainsman")		return "Tan"
							if("Northern")		return "White"
							if("Chiprock")		return "Pale"
						if("Orc") switch(m.Heritage)
							if("Stonehammer")	return "Stonehammer"
							if("Warcry")		return "Warcry"
							if("Windhowl")		return "Windhowl"
			if(istype(m, /mob/NPC/Zombie))		return "zombie"