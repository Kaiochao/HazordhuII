client
	var tmp/CharCreator/char_creator
	proc/start_char_create()
		if(char_creator) return

		var mob/player/p = mob
		if(fexists(p.save_path()))
			if("No" == alert(
			"You already have a character. Creating a new one will overwrite it. Continue?",
			"New Character", "Yes", "No")) return
			else
				var group/g
				for(g in groups) if(key in g.members)
					if(g.members[key] == 1) break
					else g.members -= key
				if(g)
					CHOOSE
					var choice = (g.members.len == 1 ? (alert("You are the only member of your group. It will be disbanded.","Disbanded","OK") && "Disband") : alert("You are the leader of the group, \"[g.name].\" Do you want to disband it or transfer ownership?", "Group Leader", "Disband", "Transfer"))
					switch(choice)
						if("Transfer")
							TRANSFER
							var/totransfer = input("Who will you transfer group ownership to?") as null|anything in g.members-key
							if(totransfer)
								if("Yes" == alert("Are you sure you want [totransfer] to own your group?", "Transfer Ownership", "No", "Yes"))
									g.members[totransfer] = 1
									g.members -= key
									var mob/m
									for(m in Players) if(m.key == totransfer) break
									if(m) spawn alert(m, "You are now the leader of your group.","Ownership Transferred","OK")
								else goto TRANSFER
							else goto CHOOSE
						else
							for(var/mob/m in Players) if(m.key in g.members)
								spawn alert(m, "The group has been disbanded.","Disbanded","OK")
							del g
				fdel(p.save_path())

		for(var/obj/Title_Screen/t in screen) screen -= t
		char_creator = new (src)
		return TRUE

	proc/finish_char_create()
		if(!char_creator) return
		if(!char_creator.kind) return
		if(!char_creator.hair) return

		var mob/player/p	=	mob

		p.name			=	char_creator.name
		p.gender		=	char_creator.gender
		p.Race			=	char_creator.kind.race
		p.Heritage		=	char_creator.kind.heritage
		p.MaxHealth		=	char_creator.kind.max_health
		p.MaxStamina	=	char_creator.kind.max_stamina
		p.Strength		=	char_creator.kind.strength
		p.Hair			=	char_creator.hair.style
		p.HairColor		=	char_creator.hair_color.Color

		p.charID		=	string()
		p.Health		=	p.MaxHealth
		p.Stamina		=	p.MaxStamina

		p.Languages		+=	p.native_language()

		screen			-=	char_creator.parts
		char_creator	=	null

		p.HeritageIcon()

		p.moon = get_moon()
		src << "Your birthmoon is Moon [p.moon] of the celestial Aeon [get_aeon()]."
		src << ""
		src << "<i>Since this is a role-playing game, you do not automatically know the names of other people. "
		src << "<i>You can give names to people (including yourself) that only you will see, by right-clicking them or clicking their name in the text output. "
		src << ""
		src << "<i>You are in the tutorial area. <b>Talk to the NPCs around for some information about how to play the game.</b> "
		src << "<i>Hit <u>E</u> while standing on the Rune Circle at the end of this path to leave this area. "

		p.Respawn(1)

		p.contents = newlist(
			/obj/Item/Tools/Hatchet,
			/obj/Item/Tools/Knife,
			/obj/Item/Tools/Tongs)
		p.equip(new /obj/Item/Clothing/Pants/Loincloth	(p))
		p.equip(new /obj/Item/Clothing/Back/Fur_Cape	(p))
		p.equip(new /obj/Item/Clothing/Feet/Fur_Boots	(p))
		if(p.gender == FEMALE) p.equip(new /obj/Item/Clothing/Shirt/Loincloth_Top (p))

		return TRUE

CharCreator
	var client/client
	var parts[]

	New(client/c)
		client = c

		parts = new
		draw_hair()
		draw_kind()
		draw_gender()
		draw_preview()

		select_hair(locate(/CharCreator/Hair/Short) in parts)
		select_kind(locate(/CharCreator/Kind/Human/Plainsman) in parts)
		select_gender(MALE)
		name = c.key

		parts += new /CharCreator/Done
		client.screen += parts

	Done
		parent_type = /obj/Title_Screen
		icon				= 'code/flash hud/hud icons wide.dmi'
		layer				= 200
		maptext				= "<font size=1 align=center valign=middle>Done"
		maptext_width		= 48
		screen_loc			= "CENTER:168,CENTER-3"
		MouseEntered() animate_selection()
		MouseExited() normalize_selection()
		Click()
			if(usr.client.char_creator)
				if("Yes" == alert("Are you sure you want this character?", "Character Creation", "No", "Yes"))
					usr.client.finish_char_create()

	Preview
		parent_type = /obj
		layer = 200
		icon = 'code/flash hud/hud icons 32.dmi'
		screen_loc	= "CENTER:176,CENTER:-63"
		var/obj
			preview_hair
			preview_body
			preview_pants
			preview_shirt
		New()
			preview_hair = new()
			preview_body = new()
			preview_pants = new()
			preview_shirt = new()

			preview_shirt.icon = 'Code/Hunting/Top.dmi'
			preview_pants.icon = 'Code/Hunting/Loin Cloths.dmi'

			preview_hair.layer = FLOAT_LAYER-0.1
			preview_pants.layer = FLOAT_LAYER-0.2
			preview_shirt.layer = FLOAT_LAYER-0.2
			preview_body.layer = FLOAT_LAYER-0.3

			overlays += preview_pants
		proc
			remove_hair()
				overlays -= preview_hair
			add_hair(CharCreator/Hair/h)
				preview_hair.icon = h.icon
				overlays += preview_hair
			remove_body()
				overlays -= preview_body
			add_body(CharCreator/Kind/k)
				preview_body.icon = k.icon
				overlays += preview_body
			add_shirt()
				overlays += preview_shirt
			remove_shirt()
				overlays -= preview_shirt

	proc/draw_preview()
		preview = new()
		parts += preview
		client.screen += preview

	proc/draw_hair()
		hairs = new

		var hair_styles[] = typesof(/CharCreator/Hair) - /CharCreator/Hair
		var dx, dy
		for(var/style in hair_styles)
			var CharCreator/Hair/h = new style
			hairs += h
			h.screen_loc = "CENTER+[3 + dx]:-16,CENTER+[3 + dy]"

			var hud/box/hair_label = new /hud/box (client,
				"CENTER+[4 + dx]", "CENTER+[3 + dy]", 2, 1, -16, 0,
				"<font size=1 align=center valign=middle>[h.style]", h.style)
			parts += hair_label.parts

			dy --
			if(dy == -5)
				dy = 0
				dx = 4

		hair_color = new
		parts += hair_color
		parts += hairs

	proc/draw_kind()
		kinds = new

		var heritages[] = typesof(/CharCreator/Kind) - list(/CharCreator/Kind, /CharCreator/Kind/Human, /CharCreator/Kind/Orc)
		var dy
		for(var/heritage in heritages)
			var CharCreator/Kind/k = new heritage
			kinds += k
			k.screen_loc = "CENTER-8:-16,CENTER+[3 + dy]"
			var hud/box/heritage_label = new /hud/box (client,
				"CENTER-7", "CENTER+[3 + dy]", 3, 1, -16, 0,
				"<font size=1 align=center valign=middle>[k.heritage]", k.heritage)
			parts += heritage_label.parts
			dy --

		kind_desc = new /hud/box (client,
			"CENTER-5", "CENTER-3", 6, 7, 16, 0)
		parts += kind_desc.parts

		parts += kinds

	proc/draw_gender()
		genders = newlist(/CharCreator/Gender/Male, /CharCreator/Gender/Female)
		parts += genders


	var name
	var gender

	var CharCreator/Preview/preview

	var CharCreator/Hair/hair
	var CharCreator/HairColor/hair_color

	var CharCreator/Kind/kind

	var hud/box/kind_desc

	var hairs[]
	var kinds[]
	var genders[]

	proc/set_name(n)
		name = n

	proc/select_hair(CharCreator/Hair/h)
		if(hair)
			preview.remove_hair()
			hair.underlays -= image('code/flash hud/hud icons 32.dmi', "down")
			hair.underlays += 'code/flash hud/hud icons 32.dmi'
		hair = h
		preview.add_hair(hair)
		hair.underlays -= 'code/flash hud/hud icons 32.dmi'
		hair.underlays += image('code/flash hud/hud icons 32.dmi', "down")

	proc/select_hair_color()
		if(hair) preview.remove_hair()
		for(var/CharCreator/Hair/h in hairs)
			h.icon = initial(h.icon)
			h.icon += hair_color.Color
		if(hair) preview.add_hair(hair)

	proc/select_kind(CharCreator/Kind/k)
		if(kind)
			preview.remove_body()
			kind.underlays -= image('code/flash hud/hud icons 32.dmi', "down")
			kind.underlays += 'code/flash hud/hud icons 32.dmi'
		kind = k
		preview.add_body(kind)
		kind.underlays -= 'code/flash hud/hud icons 32.dmi'
		kind.underlays += image('code/flash hud/hud icons 32.dmi', "down")
		kind_desc.set_maptext("<font align=left valign=top>[k.desc]")

		//	set heritage description

	proc/select_gender(g)
		gender = g
		preview.remove_body()

		for(var/CharCreator/Gender/G in genders)
			if(G.gender == g)
				G.icon_state = "down"
			else G.icon_state = ""

		switch(g)
			if(MALE)
				for(var/CharCreator/Kind/k in kinds)
					k.icon = k.m_icon
					preview.remove_shirt()
			if(FEMALE)
				for(var/CharCreator/Kind/k in kinds)
					k.icon = k.f_icon
					preview.add_shirt()

		preview.add_body(kind)

	Name
		parent_type	= /obj/Title_Screen
		maptext		= "<font size=1 align=center valign=middle>Name"
		layer		= 200
		MouseEntered() animate_selection()
		MouseExited() normalize_selection()
		Click() if(usr.client.char_creator)
			var name = input("What is your name?", "Name", usr.client.char_creator.name)
			usr.client.char_creator.set_name(name)

	Gender
		parent_type = /obj/Title_Screen
		layer = 200
		MouseEntered() animate_selection()
		MouseExited() normalize_selection()
		Click() if(usr.client.char_creator) usr.client.char_creator.select_gender(gender)

		icon = 'code/flash hud/hud icons wide.dmi'
		Male
			gender			= MALE
			maptext			= "<font size=1 align=center valign=middle>Male"
			maptext_width	= 48
			screen_loc		= "CENTER-2:-16,CENTER+4"

		Female
			gender			= FEMALE
			maptext			= "<font size=1 align=center valign=middle>Female"
			maptext_width	= 48
			screen_loc		= "CENTER-1,CENTER+4"

	HairColor
		parent_type		= /obj/Title_Screen
		icon			= 'code/flash hud/hud icons wide.dmi'
		screen_loc		= "CENTER:168,CENTER+4"
		maptext			= "<font size=1 align=center valign=middle>Set Color"
		maptext_width	= 48
		layer			= 200

		var Color
		MouseEntered() animate_selection()
		MouseExited() normalize_selection()
		Click() if(usr.client.char_creator)
			icon_state = "down"
			Color = input("Select a hair color.", "Hair Color", Color) as color
			icon_state = ""
			usr.client.char_creator.select_hair_color(Color)

	Hair
		parent_type = /obj/Title_Screen
		layer = 200

		var style

		New()
			style = name
			underlays = list('code/flash hud/hud icons 32.dmi')

		MouseEntered() animate_selection()
		MouseExited() normalize_selection()
		Click() if(usr.client.char_creator) usr.client.char_creator.select_hair(src)

		None		icon = 'code/Mobs/Hair/Hair.dmi'
		Long		icon = 'code/Mobs/Hair/Long.dmi'
		Short		icon = 'code/Mobs/Hair/Short.dmi'
		Mohawk		icon = 'code/Mobs/Hair/Mohawk.dmi'
		Tail		icon = 'code/Mobs/Hair/Tail.dmi'
		Matted		icon = 'code/Mobs/Hair/Matted.dmi'
		Ponytail	icon = 'code/Mobs/Hair/Ponytail.dmi'
		Curly		icon = 'code/Mobs/Hair/Curly.dmi'
		LongCurly	icon = 'code/Mobs/Hair/Long_Curly.dmi'
		Dreadlocks	icon = 'code/Mobs/Hair/Rasta.dmi'

	Kind
		parent_type = /obj/Title_Screen
		layer = 200
		var m_icon
		var f_icon

		var heritage
		var race
		var max_health
		var max_stamina
		var strength

		New()
			underlays = list('code/flash hud/hud icons 32.dmi')

		MouseEntered() animate_selection()
		MouseExited() normalize_selection()
		Click() if(usr.client.char_creator) usr.client.char_creator.select_kind(src)

		proc/stats() return "\
			\n\n<u><b>Stats:</b></u>\n\
			Health: <b>[max_health]</b>\n\
			Stamina: <b>[max_stamina]</b>\n\
			Strength: <b>[strength]</b>"

		New()
			..()
			desc += stats()
			icon = m_icon

		Human
			race = "Human"
			Southshores
				m_icon		= 'code/mobs/human/m_black.dmi'
				f_icon		= 'code/mobs/human/f_black.dmi'
				desc		= "You are of the Southshores bloodline. Your people are from the southern coast of the Mainland. "
				heritage	=	"Southshores"
				max_health	=	130
				max_stamina	=	120
				strength	=	10

			Plainsman
				m_icon		= 'code/mobs/human/m_tan.dmi'
				f_icon		= 'code/mobs/human/f_tan.dmi'
				desc		= "You are a plainsman. Your people have lived on the open plains of the land since time immemorable. "
				heritage	=	"Plainsman"
				max_health	=	100
				max_stamina	=	85
				strength	=	20

			Northern
				m_icon		= 'code/mobs/human/m_white.dmi'
				f_icon		= 'code/mobs/human/f_white.dmi'
				desc		= "You are a Northerner. You and your kin hail from the snowy peaks of the north."
				heritage	=	"Northern"
				max_health	=	90
				max_stamina	=	145
				strength	=	15

			Chiprock
				m_icon		= 'code/mobs/human/m_pale.dmi'
				f_icon		= 'code/mobs/human/f_pale.dmi'
				desc		= "You are from the Chiprock clan. Your ancestors were noble warriors who have recently emerged from the underground."
				heritage	=	"Chiprock"
				max_health	=	85
				max_stamina	=	70
				strength	=	25

		Orc
			race = "Orc"
			Warcry
				m_icon		= 'code/mobs/orc/m_warcry.dmi'
				f_icon		= 'code/mobs/orc/f_warcry.dmi'
				desc		= "You are a member of Clan Warcry. Once the most powerful Orc clan in Hazordhu."
				heritage	=	"Warcry"
				max_health	=	140
				max_stamina	=	125
				strength	=	30
			Stonehammer
				m_icon		= 'code/mobs/orc/m_stonehammer.dmi'
				f_icon		= 'code/mobs/orc/f_stonehammer.dmi'
				desc		= "You are a member of Clan Stonehammer. You live for combat, and yearn for an honorable death."
				heritage	=	"Stonehammer"
				max_health	=	140
				max_stamina	=	95
				strength	=	35
			Windhowl
				m_icon		= 'code/mobs/orc/m_windhowl.dmi'
				f_icon		= 'code/mobs/orc/f_windhowl.dmi'
				desc		= "You are a member of Clan Windhowl. Your ancestors were revered as mighty hunters."
				heritage	=	"Windhowl"
				max_health	=	100
				max_stamina	=	160
				strength	=	15

obj/Title_Screen
	proc
		animate_selection()
			animate(src, transform = matrix() * (8/7), time = 1)
			plane = 2

		normalize_selection()
			animate(src, transform = matrix(), time = 1)
			plane = 1
