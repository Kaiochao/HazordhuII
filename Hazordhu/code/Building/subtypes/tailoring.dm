builder/tailoring
	main_tool = /obj/Item/Tools/NeedleThread
	skill = TAILORING
	allowed_in_tutorial = TRUE

	thread
		name = "Thread"
		icon = 'code/tailoring/thread.dmi'
		desc = "Use a Carding Tool to card Phluf into Thread. Also requires a Spool. <br>\
			(You can also right-click the Phluf.)<br>\
			1 Phluf"
		main_tool = /obj/Item/Tools/Carding_Tool
		allowed_races = HUMAN
		req = list(PHLUF = 1)
		built = THREAD

		base_build_time()
			return 30

		tool_check(mob/m)
			. = ..()
			if(!(locate(/obj/Item/Tools/NeedleThread) in m)) 
				m.aux_output("You need a Spool in your inventory.")
				return FALSE

	pants
		name = "Pants"
		icon = 'code/Clothes/Trousers.dmi'

		desc = "A quick Phluf pair of pants<br />\
				2 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	2)
		built = /obj/Item/Clothing/Pants/Trousers

	shirt
		name = "Shirt"
		icon = 'code/Clothes/Shirt.dmi'

		desc = "A quick Phluf shirt<br />\
				2 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	2)
		built = /obj/Item/Clothing/Shirt/Shirt

	shoes
		name = "Shoes"
		icon = 'code/Clothes/Shoes.dmi'

		desc = "A quick Phluf pair of shoes<br />\
				1 Thread"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	1)
		built = /obj/Item/Clothing/Feet/Shoes

	boots
		name = "Boots"
		icon = 'code/Clothes/Boots.dmi'

		desc = "A quick Phluf pair of boots<br />\
				2 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	2)
		built = /obj/Item/Clothing/Feet/Boots

	belt
		name = "Belt"
		icon = 'code/Clothes/Belt.dmi'

		desc = "For holding up your pants<br />\
				1 Thread"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	1)
		built = /obj/Item/Clothing/Belt/Belt

	robe_shirt
		name = "Robe Shirt"
		icon = 'code/Clothes/shiekrobe.dmi'

		desc = "Most suitable with a dress to complete it<br />\
				4 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	4)
		built = /obj/Item/Clothing/Shirt/Robe_Shirt

	dress
		name = "Dress"
		icon = 'code/Clothes/Dress.dmi'

		desc = "For ladies, or robed wizards<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Pants/Dress

	gown
		name = "Gown"
		icon = 'code/Clothes/Princess.dmi'

		desc = "For ladies<br />\
				5 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	5)
		built = /obj/Item/Clothing/Shirt/Gown

	hood
		name = "Hood"
		icon = 'code/Clothes/Hood.dmi'

		desc = "Required to look mysterious<br />\
				1 Thread"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	1)
		built = /obj/Item/Clothing/Hood/Hood

	patch_left
		name = "Left Eyepatch"
		icon = 'code/Clothes/eyepatch_L.dmi'

		desc = "I need tha bugger so I can see!<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Accessory/patch_left

	patch_right
		name = "Right Eyepatch"
		icon = 'code/Clothes/eyepatch_R.dmi'

		desc = "I need tha bugger so I can see!<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Accessory/patch_right

	turban
		name = "Turban"
		icon = 'code/Clothes/turban.dmi'

		desc = "For a hot day near the deserts<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Hood/Turban

	sulteen
		name = "Sulteen"
		icon = 'code/Clothes/Sultan_hat.dmi'

		desc = "The fashion of the Sand-People<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Hood/Sulteen

	hat
		name = "Hat"
		icon = 'code/Clothes/Fedorah.dmi'

		desc = "A fancy hat<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Hood/Hat

	cloak
		name =	"Cloak"
		icon = 'code/Clothes/Cloak.dmi'

		desc = "Also required to look mysterious!<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Back/Cloak

	desert_cloak
		name =	"Desert Cloak"
		icon = 'code/Clothes/desert_cloak.dmi'

		desc = "It helps keep the sand out!<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Back/Desert_Cloak

	cape
		name = "Cape"
		icon = 'code/Clothes/Cape.dmi'

		desc = "A cape suitable for adventurers<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Back/Cape

	short_sleeve
		name = "Short Sleeve"
		icon = 'code/Clothes/Shirt_S-Sleeve.dmi'

		desc = "For hot Bloomstides<br />\
				2 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	2)
		built = /obj/Item/Clothing/Shirt/Short_Sleeve_Shirt

	gloves
		name = "Gloves"
		icon = 'code/Clothes/Gloves.dmi'

		desc = "Not as warm as mittens, but quick<br />\
				1 Thread"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	1)
		built = /obj/Item/Clothing/Hands/Gloves

	tabard
		name = "Tabard"
		icon = 'code/Clothes/Tabard.dmi'

		desc = "A Phluf tabard to show whose side you are on<br />\
				3 Threads"
		tooltipRows = 3

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Back/Tabard

	pouch
		name = "Pouch"
		icon = 'code/Clothes/Pouch.dmi'
		icon_state = "item"

		desc = "A small pouch for carrying items<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Clothing/Bag/Pouch

	sack
		name = "Sack"
		icon = 'code/Clothes/Sack.dmi'
		icon_state = "item"

		desc = "A sack for carrying several items<br />\
				5 Threads"
		tooltipRows = 2

		req = list(	THREAD	=	5)
		built = /obj/Item/Clothing/Bag/Sack

	bag
		name = "Bag"
		icon = 'code/Clothes/Bag.dmi'
		icon_state = "item"

		desc = "A large bag which can hold many items<br />\
				10 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req	= list(	THREAD	=	10)
		built = /obj/Item/Clothing/Bag/Bag

	mattress
		name = "Mattress"
		icon = 'code/Tailoring/Matress.dmi'

		desc = "You need this and a bed frame to sleep<br />\
				5 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	5)
		built = /obj/Item/Tailoring/Mattress

	pillow
		name = "Pillow"
		icon = 'code/Tailoring/Pillow.dmi'

		desc = "Can be put on a bed for comfort<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Tailoring/Pillow

	blanket
		name = "Blanket"
		icon = 'code/tailoring/blanket.dmi'
		desc = "Oh so cozy <br>\
				6 Thread <br>\
				2 Phluf"
		allowed_races = HUMAN
		req = list(THREAD = 6, PHLUF = 2)
		built = /obj/Item/Tailoring/Blanket

	cushion
		name = "Cushion"
		icon = 'code/Tailoring/Cushion.dmi'

		desc = "Can be put on a bed for extra comfort<br />\
				3 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	3)
		built = /obj/Item/Tailoring/Cushion

	flag
		name = "Flag"
		icon = 'code/Flags/Flags.dmi'
		icon_state = "Neutral"

		desc = "Claim your territory!<br />\
				4 Threads"
		tooltipRows = 2

		req = list(	THREAD	=	4)
		built = /obj/Item/Tailoring/Flag

	bearer_flag
		name = "Bearers' Flag"
		icon = 'code/Weapons/bearer flag.dmi'
		group_only = 1

		desc = "Represent your hood with this stylish banner!<br />\
				4 Threads<br />\
				2 Logs"
		tooltipRows = 4

		req = list(	THREAD	=	4,
					LOG		=	2)
		built = /obj/Item/Weapons/Flag

	carpet
		name = "Carpet"
		icon = 'code/Tailoring/Carpet.dmi'
		group_only = 1

		desc = "Used for decorating your floors<br />\
				5 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	5)
		built = /obj/Item/Tailoring/Carpet

	rope
		name = "Rope"
		icon = 'code/Tailoring/Rope.dmi'

		desc = "A long coil of rope used for several things<br />\
				3 Threads"
		tooltipRows = 2

		req = list(	THREAD	=	3)
		built = /obj/Item/Tailoring/Rope

	ball
		name = "Ball"
		icon = 'code/Icons/ball.dmi'

		desc = "A ball that you can kick and use for sports!<br />\
				10 Threads"
		tooltipRows = 2

		req = list(	THREAD	=	10)
		built = /obj/Item/Ball

	muzzle
		name = "Muzzle"
		icon = 'code/Tailoring/muzzle.dmi'

		desc = "Prevents the user from speaking<br />\
				5 Threads"
		tooltipRows = 2

		req = list(	THREAD	=	5)
		built = /obj/Item/binders/Muzzle

	blindfold
		name = "Blindfold"
		icon = 'code/Tailoring/blindfold.dmi'

		desc = "Blocks the user's sight<br />\
				5 Threads"
		tooltipRows = 2

		req = list(	THREAD	=	5)
		built = /obj/Item/binders/Blindfold

	stoof_cloak
		name = "Stoof Cloak"
		icon = 'code/Animals/animal_armour.dmi'
		icon_state = "stoof cloak"
		group_only = 1

		desc = "A must have for that special steed<br />\
				13 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	13)
		built = /obj/Item/Armour/Animal/stoof_cloak

	chef
		name = "Toque Blanche"
		icon = 'code/Clothes/Chef_Hat.dmi'

		desc = "The King wants a sandwich!<br />\
				4 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	4)
		built = /obj/Item/Clothing/Helmet/Chef

	apron
		name = "Half Apron"
		icon = 'code/Clothes/Apron_bottom_half.dmi'

		desc = "Keep it clean!<br />\
				4 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	4)
		built = /obj/Item/Clothing/Back/Half_Apron

	full_apron
		name = "Full Apron"
		icon = 'code/Clothes/Apron.dmi'

		desc = "Keep it cleaner!<br />\
				5 Threads"
		tooltipRows = 2

		allowed_races = HUMAN

		req = list(	THREAD	=	5)
		built = /obj/Item/Clothing/Back/Apron