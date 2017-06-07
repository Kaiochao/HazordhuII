BuildGrid
	var tmp/visible = FALSE
	var tmp/mob/player/anchor
	var tmp/cells[0]

	var tmp/BuildGrid/build_cell/current_cell

	var tmp/builder/builder

	proc/toggle() return visible ? hide() : show()

	proc/show(builder/b) if(!visible)
		builder = b
		visible = TRUE
		game_loop.add(src)
		return TRUE

	proc/hide() if(visible)
		visible = FALSE
		for(var/BuildGrid/build_cell/c in cells) c.hide()
		select()
		return TRUE

	proc/select(BuildGrid/build_cell/cell)
		current_cell && deselect(current_cell)
		current_cell = cell
		current_cell && current_cell.selected()

	proc/deselect(BuildGrid/build_cell/cell)
		if(!cell) cell = current_cell
		if(cell) cell.deselected()
		current_cell = null

	New(mob/player/p)
		anchor = p
		for(var/x in -1 to 1)
			for(var/y in -1 to 1)
				cells += new /BuildGrid/build_cell (src, x, y)

	Del()
		for(var/BuildGrid/build_cell/c in cells)
			c.set_loc()
		..()

	proc/tick()
		if(visible)
			for(var/BuildGrid/build_cell/c in cells)
				c.update()

	build_cell
		parent_type = /obj
		icon = null
		override = TRUE
		animate_movement = FALSE

		var BuildGrid/parent
		var mob/player/owner
		var image/i
		var visible = FALSE

		var dx
		var dy

		proc/update()
			if(!parent.visible) return hide()
			var turf/center = owner.cloc()
			set_loc(locate(center.x + dx, center.y + dy, owner.z))
			if(parent.builder.valid_loc(loc, owner) && owner.raycast_to(loc))
				show()
			else hide()

		proc/hide() if(visible)
			set_loc()
			visible = FALSE
			owner.client.images -= i
			if(parent.current_cell == src)
				parent.select()

		proc/show() if(!visible)
			visible = TRUE
			owner.client.images |= i

		var is_selected
		proc/selected()
			is_selected = TRUE
			i.icon_state = "selected"

		proc/deselected()
			is_selected = FALSE
			i.icon_state = ""

		New(BuildGrid/g, x, y)
			i = image('build square.dmi', src, layer = 100)
			dx = x
			dy = y
			parent = g
			owner = parent.anchor

mob/player
	var tmp/BuildGrid/BuildGrid

	PostLogin()
		..()
		BuildGrid = new (src)

	Del()
		del BuildGrid
		..()