obj/Item/Clothing/Belt/Toolbelt
	clothtype="belt"
	can_color = 1
	value = 26
	heat_added = 0
	icon = 'code/Clothes/Belt.dmi'
	Click(location,control,params)
		if(params)
			params = params2list(params)
			if(params["right"])
				if((src in usr))
					if(src.contents && src.contents.len)
						var/obj/Item/selected_remove = input("What tool do you want to remove from the toolbelt?")as null|anything in src.contents
						if(isnull(selected_remove)) return
						src.RemoveTool(usr,selected_remove)
					else
						usr << "That toolbelt is empty."

	proc
		AddTool(mob/user,obj/Item/Tools/tool)
			if(!tool) return
			if((locate(tool.type) in src))
				user << "You already have a tool of that type stored in that toolbelt."
				return
			user << "You have added [tool.name] to this toolbelt."
			tool.Move(src)
			user.InventoryGrid()

		RemoveTool(mob/user,obj/Item/Tools/tool)
			if(!tool) return
			if(!(tool in src)) return
			tool.Move(user)


		HasTool(mob/user,tool_type)
			return (locate(tool_type) in src)

mob/proc/ToolbeltCheck(tool_type)
	if(equipment["belt"])
		if(istype(equipment["belt"],/obj/Item/Clothing/Belt/Toolbelt))
			var/obj/Item/Clothing/Belt/Toolbelt/toolbelt = equipment["belt"]
			return toolbelt.HasTool(src,tool_type)