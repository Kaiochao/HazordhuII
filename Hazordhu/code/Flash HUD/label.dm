hud/label
	parent_type = /hud/button
	screen_loc = "NORTHWEST"
	icon = 'code/icons/blank.dmi'
	text_size = 3
	plane = 1
	var shadows[]
	set_text(t)
		if(isnull(t)) t = maptext
		..()
		if(!shadows)
			shadows = newlist(
			//	/obj { pixel_x = -1; pixel_y = -1; layer = 200; icon = 'code/icons/blank.dmi' },
			//	/obj { pixel_x = -1; pixel_y =  1; layer = 200; icon = 'code/icons/blank.dmi' },
			//	/obj { pixel_x =  1; pixel_y = -1; layer = 200; icon = 'code/icons/blank.dmi' },
			//	/obj { pixel_x =  1; pixel_y =  1; layer = 200; icon = 'code/icons/blank.dmi' },
				/obj { pixel_x =  0; pixel_y = -1; layer = -1; plane = 1; icon = 'code/icons/blank.dmi' },
				/obj { pixel_x =  0; pixel_y =  1; layer = -1; plane = 1; icon = 'code/icons/blank.dmi' },
				/obj { pixel_x =  1; pixel_y =  0; layer = -1; plane = 1; icon = 'code/icons/blank.dmi' },
				/obj { pixel_x = -1; pixel_y =  0; layer = -1; plane = 1; icon = 'code/icons/blank.dmi' },
			)
		else underlays -= shadows
		for(var/obj/shadow in shadows)
			shadow.maptext_width = maptext_width
			shadow.maptext_height = maptext_height
			shadow.maptext = "<font color=[rgb(0, 0, 0)]>[maptext]"
		maptext = "<font color=[rgb(166, 159, 111)]>[maptext]"
		underlays += shadows