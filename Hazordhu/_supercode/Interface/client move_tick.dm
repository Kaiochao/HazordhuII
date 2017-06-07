client
	#if DM_VERSION >= 511
	fps = 100
	#endif

	var apparent_season
	var turf/_virtual_turf	//	previous
	var turf/virtual_turf	//	current
	var next_season_check
	var season_check_delay = 1

	var _range[0]
	var _old_range[0]
	var _old_loc

	//	returns TRUE when the eye moved
	proc/move_tick()
		set waitfor = FALSE
		if(world.time < next_season_check) return
		next_season_check = world.time + season_check_delay

	#if CHUNKS
		if(mob)
			var season = get_season()
			virtual_turf = turf_of(virtual_eye)
			if(apparent_season != season)
				apparent_season = season
				map.Moved(mob, virtual_turf)
			else if(virtual_turf != _virtual_turf)
				map.Moved(mob, virtual_turf, _virtual_turf)
				_virtual_turf = virtual_turf

		return TRUE

	#else
		var season = get_season()
		virtual_turf = turf_of(virtual_eye)
		if(apparent_season != season || virtual_turf != _virtual_turf)
			if(apparent_season != season) _old_range = null

			apparent_season = season
			_virtual_turf = virtual_turf
			if(!virtual_turf) return
			if(!season) return
			_range = range("[view_size[1] + 5]x[view_size[2] + 5]", virtual_turf)
			var close_range[] = _old_range ? _range - _old_range : _range
			_old_range = _range

			#if MAP_OTF
			if(!global.new_world)
				for(var/turf/t in close_range)
					if(!t.loaded)
						t.loaded = TRUE
						map_data.LoadLoc(t)
			#endif

			for(var/atom/a in close_range)
				_old_range -= a
				if(!a.initialized)
					a.initialize()
					a.initialized = TRUE
				if(a.season_updates && (!a.apparent_season || a.apparent_season != season))
					a.season_update(season)
				sleep(-1)
			return TRUE
	#endif