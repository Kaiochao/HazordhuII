#if !THIN_SKIN
mob/player
	var tmp/hud/label/info_bar

	PostLogin()
		..()
		info_bar = new (client)
		info_bar.screen_loc = "WEST,NORTH-1"
		info_bar.maptext_width = client.bound_width
#endif
atom
	MouseEntered()
		usr.update_statusbar(name)
		..()

	MouseExited()
		..()
		usr.update_statusbar("")

mob/proc/update_statusbar(t)

mob/player

	update_statusbar(t)
		info_bar && info_bar.set_text(t)

	MouseEntered()
		..()
		usr.update_statusbar(usr.nameShown(src))