obj/game_plane
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	screen_loc = "1,1"
	plane = 0
	var
		const/max_zoom = 10
		zoom_level = 1

client
	var/tmp
		obj/game_plane/game_plane
	MouseWheel(object,delta_x,delta_y,location,control,params)
		..()
		if(!game_plane)
			game_plane = new /obj/game_plane
			screen += game_plane
		if(control == "screen.map")
			if(game_plane)
				if(delta_y > 0)
					if(game_plane.zoom_level < game_plane.max_zoom)
						game_plane.zoom_level += 0.5
						animate(game_plane,transform = matrix(game_plane.zoom_level,MATRIX_SCALE),time = 3)
				if(delta_y < 0)
					if(game_plane.zoom_level > 1)
						game_plane.zoom_level -= 0.5
						animate(game_plane,transform = matrix(game_plane.zoom_level,MATRIX_SCALE),time = 3)