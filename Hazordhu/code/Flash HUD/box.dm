hud/box
	var name = ""
	var maptext = ""
	var maptext_width = 32
	var maptext_height = 32
	var maptext_x = 0
	var maptext_y = 0
	var x = "WEST"
	var px = 0
	var y = "SOUTH"
	var py = 0
	var width = 1
	var height = 1

	var parts[]

	var hud/box/part/maptext_anchor

	var client/client
	New(
		client/client,
		x,			y,
		width,	height,
		px,			py,
		maptext, name
	)
		src.x = x; src.px = px
		src.y = y; src.py = py
		src.width = width
		src.height = height

		src.client = client

		src.maptext_width = 32 * width - 8
		src.maptext_height = 32 * height - 8
		src.maptext_x = 4
		src.maptext_y = 4
		src.maptext = maptext

		draw()

	proc/draw()
		var visible = is_visible()
		hide()
		parts = new
		for(var/x in 0 to width - 1)
			for(var/y in 0 to height - 1)
				var hud/box/part/p = new
				parts += p
				p.name = name
				p.screen_loc = "[src.x]+[x]:[px],[src.y]+[y]:[py]"

				//	get the icon state
				var d = 0
				if(width - 1)
					if(!x) d |= EAST
					if(x == width - 1) d |= WEST
				if(height - 1)
					if(!y) d |= NORTH
					if(y == height - 1) d |= SOUTH
				if(x > 0 && x < width - 1) d |= EAST|WEST
				if(y > 0 && y < height - 1) d |= NORTH|SOUTH
				if(d) p.icon_state = "[d]"

				//	maptext attached to bottom-left corner
				if(!x && !y)
					maptext_anchor = p
					maptext_anchor.layer = 500

		set_maptext()

		if(visible) show()

	proc/set_maptext(text, width, height)
		if(!isnull(text))
			maptext = text

		if(!isnull(width) || !isnull(height))
			maptext_width = width
			maptext_height = height

		maptext_anchor.maptext_width = maptext_width
		maptext_anchor.maptext_height = maptext_height
		maptext_anchor.maptext_x = maptext_x
		maptext_anchor.maptext_y = maptext_y
		maptext_anchor.maptext = maptext

	var visible = FALSE
	proc/is_visible() return visible

	proc/toggle() visible ? hide() : show()

	proc/show() if(visible)
		visible = TRUE
		client.screen |= parts

	proc/hide() if(visible)
		visible = FALSE
		client.screen -= parts

	part
		parent_type = /obj
		icon = 'code/flash hud/hudbox.dmi'
		layer = 199
		plane = 1