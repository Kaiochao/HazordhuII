obj/Item/Ores
	var
		forge_time = 0
		forge_finish_time = 500
		ingot_type

	proc
		/* Time spent in a lit forge. */
		ForgeTime()
			return forge_time
		
		/* Forge time required to be finished smelting. */
		ForgeFinishTime()
			return forge_finish_time
		
		IngotType()
			return ingot_type
	
		AddForgeTime(time)
			forge_time += time

		ResetForgeTime()
			forge_time = 0

	Metal
		ingot_type = /obj/Item/Bars/Metal
	
	Hazium
		ingot_type = /obj/Item/Bars/Hazium
		forge_finish_time = 1000

obj/Built/NewForge
	name = "Forge"
	icon = 'code/Masonry/Forge.dmi'
	density = TRUE
	bound_width = 24
	bound_height = 12
	bound_y = 10
	pixel_y = 10

	// Forge-specific properties.
	var
		looping = FALSE
		fuel_time = 0
		on = FALSE
	
	#if MAPSAVE
	save_to(savedatum/s)
		..()
		s.data["fuel_time"] = fuel_time

	load_from(savedatum/s)
		..()
		icon_state = ""
		fuel_time = s.data["fuel_time"]
	#endif
	
	// Implement the Forge as a container.
	is_storage = TRUE

	// Only allow ores and fuel to be added to the forge. 
	can_store(obj/Item/item)
		return IsOre(item) || IsFuel(item)
	
	// Reset the forge time of ore when removed from the forge. 
	unstored(obj/Item/item)
		if(IsOre(item))
			var obj/Item/Ores/ore = item
			ore.ResetForgeTime()
	
	// Turn on or off. 
	interact_right(mob/m)
		if(on)
			TurnOff()
			return TRUE
		else if(FindFuel())
			TurnOn()
			return TRUE
		return ..()
	
	// Helper functions. 
	proc
		TurnOn()
			set waitfor = FALSE

			on = TRUE
			icon_state = "lit"

			if(looping) return
			looping = TRUE
			var const/delta_time = 1
			do
				fuel_time = max(0, fuel_time - delta_time)

				if(fuel_time <= 0)
					var obj/Item/fuel = FindFuel()
					if(fuel)
						fuel_time += FuelTimeOf(fuel)

						// Consume a unit of the fuel. 
						fuel.LoseAmount(1)

						UpdateStorageViewers()
				
				// Add forge time to ores. 
				for(var/obj/Item/Ores/ore in src)
					ore.AddForgeTime(delta_time)
					if(ore.ForgeTime() >= ore.ForgeFinishTime())
						var ingot_type = ore.IngotType()
						while(ore.Stacked > 0)
							new ingot_type(src)
							ore.LoseAmount(1)
						UpdateStorageViewers()

				sleep delta_time
			while(on && fuel_time > 0)
			looping = FALSE
			TurnOff()

		TurnOff()
			on = FALSE
			icon_state = ""

		IsOre(obj/Item/item)
			var global/list/ore_types = list(
				/obj/Item/Ores/Metal,
				/obj/Item/Ores/Hazium
			)
			for(var/ore_type in ore_types)
				if(istype(item, ore_type))
					return TRUE
			return FALSE
			
		IsFuel(obj/Item/item)
			return FuelTimeOf(item) > 0
		
		/* Return any fuel item contained in the forge. */
		FindFuel()
			for(var/obj/Item/item in src)
				if(IsFuel(item))
					return item
			return null
		
		/* Return the amount of time that this fuel item lasts for. */
		FuelTimeOf(obj/Item/fuel)
			var global/list/fuel_type_times = list(
				/obj/Item/Wood/Log = 600,
				/obj/Item/Wood/Board = 400,
				/obj/Item/Coal = 300
			)
			for(var/fuel_type in fuel_type_times)
				if(istype(fuel, fuel_type))
					return fuel_type_times[fuel_type]
			return 0
		UpdateStorageViewers()
			// Make sure the storage grid gets updated for people looking in. 
			for(var/mob/viewer in ohearers(1, src))
				if(viewer.storage == src)
					viewer.StorageGrid()
//