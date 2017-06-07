obj/game_plane
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	screen_loc = "1,1"
	plane = 0
	var
		const
			MaxZoom = 10
		zoom_level = 1

client
	var obj/game_plane/game_plane

	MouseWheel(object, delta_x, delta_y, location, control, params)
		..()
		if(!game_plane)
			game_plane = new
			screen += game_plane
		if(control == "screen.map" && game_plane && delta_y)
			var new_zoom = clamp(game_plane.zoom_level + sign(delta_y), 1, game_plane.MaxZoom)
			if(game_plane.zoom_level != new_zoom)
				game_plane.zoom_level = new_zoom
				animate(game_plane, time = 2, transform = matrix(game_plane.zoom_level, MATRIX_SCALE))
