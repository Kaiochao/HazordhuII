
//	a list containing the active title-screen wanderers
var Titles[0]

//	a list containing all players (non NPCs)
var Players[0]

//	a list containing online admins.
var AdminsOnline[0]

world
	mob = /mob/player

mob/player
	var
		tmp/AtTitleScreen = FALSE

		//	the changelog is only shown if there's changes you haven't seen yet
		last_version_seen

	proc/view_login_message()
		client.center_window("login_message")
		src << output(null, "loginoutput")
		src << output(LoginMessage(), "loginoutput")
		winshow(src, "login_message")

mob/player
	Login()
		..()

		get_client_info(client)
		winset(src, null, "reset=true")
		winset(src, DMF_WINDOW, "is-maximized=true")

		client.focus = src

		cid = client.computer_id

		AdminCheck()

		set_loc()

		var const/BYOND_VERSION = 498
		if(client.byond_version < BYOND_VERSION)
			spawn(-1) s_alert("This game was made in \n\tBYOND [BYOND_VERSION] (yours is [client.byond_version]) \n\nPick up the latest version <a href='http://www.byond.com/download/build/LATEST/'>here</a>.","Warning", "OK")
			del src

		AdminsOnline << "<i>[key] is logging in.</i>"

		#if NO_MULTIKEY
		for(var/client/C)
			if(C == client) continue
			if(is_admin(C))) continue
			else
				if(C.computer_id == client.computer_id)
					spawn(-1) s_alert("Only one user can be logged in from your computer at a time.", "Invalid Login", "OK")
					del src
					return
		#endif

		client.screen += newlist(	/obj/Title_Screen/Hazordhu,
									/obj/Title_Screen/II,
									/obj/Title_Screen/Newgame2)

		world.log << "([time2text(world.realtime,"MM DD hh:mm")])[src] logs in."

	#if PLAYERSAVE
		if(fexists(save_path())) client.screen += new/obj/Title_Screen/Loadgame2
	#endif

		icon = null
		Locked = TRUE
		Players |= src

		AtTitleScreen = TRUE

		#if !THIN_SKIN
		sleep 10
		set_title_screen()
		#endif

		move_loop.add(client)

		var title_list[0]
		for(var/mob/title/m) title_list.Add(m)
		var mob/title/title = pick(title_list)
		title.start_wandering(client)

		while(AtTitleScreen || client.char_creator) sleep 1

		#if !THIN_SKIN
		set_game_screen()
		#endif

		title.stop_wandering(client)
		for(var/obj/Title_Screen/ts in client.screen)
			client.screen -= ts

		see_invisible = FALSE
		Locked = FALSE
		Made = TRUE

		if(!DevelopmentServer)
			if(!(key in TOS_List))
				client.center_window("tos")
				src << output(null, "terms")
				src << output(TOS, "terms")
				winshow(src, "tos")

		Regen()
		if(!KO)
			var conc = Hood_Concealed
			icon_reset()
			Hood_Concealed = conc

		else
			KO = FALSE
			KO()

		if(!GodMode)
			if(istype(loc, /turf/Environment/Ocean) && !(locate(/obj/Built) in loc))
				die("drowning")

		death_check()
		InventoryGrid()

		LoginCheck()

		_Gender = "[uppertext(copytext(gender, 1,2))][copytext(gender,2)]"
		if(!aeon) aeon = get_aeon()
		if(!moon) moon = get_moon()
		if(!x) Respawn()
		if(zombie_infection > 0)
			spawn(1) ZombieInfected()

		if(ooc_listen)
			winset(src, null, "ooc_toggle_button.is-checked=true; ooc_button.is-disabled=false")
		else
			winset(src, null, "ooc_toggle_button.is-checked=false; ooc_button.is-disabled=true")

		if(locate(/obj/Built/Stocks) in loc) Locked = 1

		if(!GodMode)
			emote("materializes from the void!")
			for(var/obj/Mining/cave_walls/d in loc)
				if(d.density)
					die("a cave-in")
					break
			for(var/obj/Woodcutting/t in loc)
				step_rand(src)
				break

		if(drunk_loop)
			drunk_loop = FALSE
			drunk_loop()

		if(!charID) charID = string()

		status_clear()

		icon_turn()

		if(GodMode)
			GodMode = 0
			var mob/Admin/a = src
			a.GhostForm()

			if(invisibility)
				invisibility = 0
				a.Toggle_Visibility()

		SET_TBOUNDS("11,4 to 22,12")

		PostLogin()

		if(!ghost_logged) world << "<i>[key] has logged in.</i>"

	PostLogin()
		set waitfor = FALSE
		..()
		if(last_version_seen != BUILD)
			last_version_seen = BUILD
			view_login_message()

		season_update()
		season_update()

	Logout()
		PreLogout()

		if(!ghost_logged) world << "<i>[key] has logged out.</i>"
		status_clear()

		if(!GodMode) emote("vanishes into the void!")

		Players -= src
		AdminsOnline -= src

		if(Made) Save()

		if(mount) del mount

		world.log << "(([time2text(world.realtime,"MM DD hh:mm")]))[key] logs out."
		del src

	Del()
		Players -= src
		..()