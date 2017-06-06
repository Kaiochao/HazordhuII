var hatch_list[] = list(
	"Bux", "Hoge", "Mur", "Olihant",
	"Rar", "Ret", "Ruff", "Sty",
	"Stoof", "Peek", "Flargl",
	"Grawl", "Grawl1", "Agriner",
	"Shomp", "Kaw", "Scree"
)

obj
	Built
		Nest
			SET_TBOUNDS("8,7 to 25,11")
			base_health = 100
			icon = 'code/Animals/Nests.dmi'
			icon_state = "race"
			Flammable = TRUE
			var egg
			var hatch_time

	Nest
		var/baby
		var/egg = 1
		var/egg_type	// The path for the food egg
		Health=500
		attackable = 1
		icon='Nests.dmi'
		New()
			..()
			name = "[src] nest"

		interact(mob/m) return get_egg(m)

		proc/get_egg(mob/thief)
			if(egg && egg_type)
				thief.emote("takes an egg from the [src]")
				egg = 0
				new egg_type (thief)
				icon_state = ""
				return TRUE

		Del()
			if(locate(/obj/Built) in loc)
				for(var/mob/Animal/animal in range(3,src))
					if(animal.bred || (locate(/obj/Item/Tailoring/Harness) in animal))
						continue
					if(animal.type == baby)
						del animal
			..()

		Peek
			icon_state="peek"
			egg_type = /obj/Item/Food/Egg/Peek
			baby = /mob/Animal/Peek
		Stoof
			icon_state="stoof"
			egg_type = /obj/Item/Food/Egg/Stoof
			baby = /mob/Animal/Stoof
		Rar
			icon_state="rar"
			egg_type = /obj/Item/Food/Egg/Rar
			baby = /mob/Animal/Rar
		ruff
			icon_state="rar"
			egg_type = /obj/Item/Food/Egg/Ruff
			baby = /mob/Animal/Ruff
		Hoge
			icon_state="mur"
			egg_type = /obj/Item/Food/Egg/Hoge
			baby = /mob/Animal/Hoge
		Bux
			icon_state="bux"
			egg_type = /obj/Item/Food/Egg/Bux
			baby = /mob/Animal/Bux
		Sty
			icon_state="sty"
			egg_type = /obj/Item/Food/Egg/Sty
			baby = /mob/Animal/Sty
		Ret
			icon_state="ret"
			egg_type = /obj/Item/Food/Egg/Ret
			baby = /mob/Animal/Ret
		Mur
			icon_state="mur"
			egg_type = /obj/Item/Food/Egg/Mur
			baby = /mob/Animal/Mur
		Flargl
			icon_state="flargl"
			egg_type = /obj/Item/Food/Egg/Flargl
			baby = /mob/Animal/Flargl
		Flurm
			icon_state="flurm"
			egg = 0
			baby = /mob/Animal/Flurm
			Flurm1
				name = "Flurm"
				baby = /mob/Animal/Flurm/Flurm1
		Ramar
			icon_state="ramar"
			baby = /mob/Animal/Ramar
			standing = FALSE
			get_egg() return

		Grawl
			icon_state="grawl"
			baby = /mob/Animal/Grawl
			egg_type = /obj/Item/Food/Egg/Grawl
			North
				baby = /mob/Animal/Grawl/North
				egg_type = /obj/Item/Food/Egg/GrawlNorth
		Agriner
			icon_state="agriner"
			baby = /mob/Animal/Agriner
			egg_type = /obj/Item/Food/Egg/Agriner
		Shomp
			icon_state="shomp"
			baby = /mob/Animal/Shomp
			egg_type = /obj/Item/Food/Egg/Shomp
		Kaw
			icon_state="peek"
			egg_type = /obj/Item/Food/Egg/Kaw
			baby = /mob/Animal/Olihant
		Scree
			icon_state="peek"
			egg_type = /obj/Item/Food/Egg/Scree
			baby = /mob/Animal/Olihant
		Olihant
			icon_state="olihant"
			egg_type = /obj/Item/Food/Egg/Olihant
			baby = /mob/Animal/Olihant