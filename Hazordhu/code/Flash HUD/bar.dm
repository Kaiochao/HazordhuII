
hud/bar
//	HUD bar properties
	//	identifies the bar and sets the icon_state in 'HUD icons.dmi'
	var name as text

	//	how many segments the bar is displayed as
	var length = 5

	//	the direction of the bar
	var dir = EAST

	//	list of .part screen-objects
	var parts[]

	//	list of clients that can see this
	var clients[0]

	proc/fill_state() return name
	proc/empty_state() return "[name] empty"

	//	screen_loc position
	var x = 1, y = 1
	var px = 0, py = 0

	var part_size = 16

//	HUD bar procedures
	proc/show_to(client/c)
		if(ismob(c)) c = c:client
		c.screen |= parts
		clients |= c

	proc/hide_from(client/c)
		if(ismob(c)) c = c:client
		c.screen -= parts
		clients -= c

	proc/hide()
		for(var/client/c in clients)
			c.screen -= parts

	proc/show()
		for(var/client/c in clients)
			c.screen |= parts

	var value = 1
	proc/set_value(percent)
		value = percent
		update()

	proc/update()
		var parts = round(length * value, 1)
		for(var/n in 1 to length)
			if(n > parts)
				empty_part(n)
			else fill_part(n)

	proc/empty_part(index)
		ASSERT(index in 1 to parts.len)
		var hud/bar/part/part = parts[index]
		ASSERT(part)
		part.icon_state = empty_state()

	proc/fill_part(index)
		ASSERT(index in 1 to parts.len)
		var hud/bar/part/part = parts[index]
		ASSERT(part)
		part.icon_state = fill_state()

	New(client/c)
		build_parts()

		if(c) show_to(c)

	proc/build_parts()
		parts = new
		for(var/n in 1 to length)
			var hud/bar/part/part = new
			parts += part

			var dx = 0, dy = 0
			switch(dir)
				if(EAST)  dx = n - 1
				if(WEST)  dx = 1 - n
				if(NORTH) dy = n - 1
				if(SOUTH) dy = 1 - n
				else CRASH("Unexpected HUD dir: [dir]")

			var sx = "[x]:[px + dx * part_size]"
			var sy = "[y]:[py + dy * part_size]"
			part.screen_loc = "[sx],[sy]"

	Del()
		for(var/client/c in clients)
			hide_from(c)
		..()

	part
		parent_type = /obj
		icon = 'code/Flash HUD/HUD icons.dmi'
		mouse_opacity = FALSE
		layer = 200
		plane = 1