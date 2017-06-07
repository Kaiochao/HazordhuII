var const
	//	Default controls
	DMF_WINDOW = "default"
	DMF_MAP = "map"
	DMF_INPUT = "input"

var controls_to_hide[] = list(
	"chat_channel",
	"set_language", "learn_language",
	"item_button", "character_button"
)

client
	set_keys()
		. = ..()
		keys |= list("z", "c", "escape")

mob/player
	verb/toggle_menu()
		set hidden = TRUE
		if("false" == winget(src, "main_menu", "is-visible"))
			map_focus()
			client.center_window("main_menu")
			winshow(src, "main_menu")
		else winshow(src, "main_menu", 0)

	verb/swap_panes()
		set hidden = TRUE
		var new_splitter = 100 - text2num(winget(src, "child_main", "splitter"))
		if("chat" == winget(src, "child_main", "left"))
			winset(src, null, "child_main.left=screen; child_main.right=chat; child_main.splitter=[new_splitter]")
		else winset(src, null, "child_main.left=chat; child_main.right=screen; child_main.splitter=[new_splitter]")

	proc/toggle_items()
		if("false" == winget(src, "child_left", "is-visible"))
			show_items()
		else hide_items()

	proc/show_items()
		if(AtTitleScreen) return
		winshow(src, "child_left")

	proc/hide_items()
		winshow(src, "child_left", 0)
		if(storage) stop_storage()

	proc/toggle_crafting()
		if("false" == winget(src, "child_right", "is-visible"))
			show_crafting()
		else hide_crafting()

	proc/show_crafting()
		if(AtTitleScreen) return
		winshow(src, "child_right")

	proc/hide_crafting()
		winshow(src, "child_right", 0)

	key_down(k)
		switch(k)
			if("z") toggle_items()
			if("c")	toggle_crafting()
			if("escape") toggle_menu()
			else ..()

	proc/PostLogin()
	proc/PreLogout()
	proc/set_title_screen()
	proc/set_game_screen()

	set_title_screen()
		var params[0]
		params["[DMF_WINDOW].pos"] = "0,0"
		params["[DMF_WINDOW].size"] = "10000x10000"
		params["[DMF_WINDOW].is-maximized"] = "true"
		params["[DMF_WINDOW].titlebar"] = "true"
		params["[DMF_INPUT].command"] = "!Say \""
		params["input.command"] = "!OOC \""

		for(var/control in controls_to_hide)
			params["[control].is-visible"] = "false"

		winset(src, null, list2params(params))
		client.center_window(DMF_WINDOW)
		..()

	set_game_screen()
		var params[0]
		params["[DMF_WINDOW].titlebar"] = "true"
		params["input.command"] = "!Say \""
		for(var/control in controls_to_hide)
			params["[control].is-visible"] = "true"

		winset(src, null, list2params(params))

		..()
