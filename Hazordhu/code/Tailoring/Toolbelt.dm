obj/Item/Clothing/Belt/Toolbelt
	clothtype = "belt"
	can_color = 1
	value = 26
	heat_added = 0
	icon = 'code/Clothes/Belt.dmi'

	use(mob/player/user)
		if(length(contents))
			var/obj/Item/selected_remove = input(user, 
				"What tool do you want to remove from the toolbelt?"
			) as null | anything in src
			if(selected_remove)
				RemoveTool(user, selected_remove)
		else
			user.aux_output("That toolbelt is empty.")

	proc
		AddTool(mob/player/user, obj/Item/Tools/tool)
			if(!tool) return
			if(locate(tool.type) in src)
				user.aux_output("You already have a tool of that type stored in that toolbelt.")
				return
			user.aux_output("You have added [tool.name] to this toolbelt.")
			tool.Move(src)
			user.InventoryGrid()

		RemoveTool(mob/user, obj/Item/Tools/tool)
			if(!tool) return
			if(tool.loc == src) 
				tool.Move(user)

		HasTool(tool_type)
			return locate(tool_type) in src

mob/proc/ToolbeltCheck(tool_type)
	if(istype(equipment["belt"], /obj/Item/Clothing/Belt/Toolbelt))
		var/obj/Item/Clothing/Belt/Toolbelt/toolbelt = equipment["belt"]
		return toolbelt.HasTool(tool_type)
