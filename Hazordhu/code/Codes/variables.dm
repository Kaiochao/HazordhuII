#define INIT_FPS 24
var fps = INIT_FPS

var/const
	AUTUMN = "Harvestfall"
	WINTER = "Shiverstide"
	SPRING = "Frostmelt"
	SUMMER = "Bloomstide"

	TEMPERATE = "Temperate"
	DROUGHT = "Drought"
	RAIN = "Rain"
	SNOW = "Snow"

	combat_log	=	"Logs/combat.log"

obj/var/degrade_rate

var
	fire_log = ""
	dest_log = ""

//	This is the current build of the game.
// Every time it's uploaded, change this,
//	so you can see if it patched.
	const/build = BUILD
	NewGods[0]

	Admins[] = list(
		"f0lak",
		"ayemel",
		"ceojac",
		"eksadus",
		"kai",
		"kaiochao",
		"zerstorung",
		"nadrew"
	)

	StaffLog = ""
	Climate = TEMPERATE

var
	DevelopmentServer = DEVMODE
	OfficialServer = OFFICIALSERVER

var
	WarTime = 0

	Hairs[] = list(
		"None",
		"Long"		=	'code/Mobs/Hair/Long.dmi',
		"Short"		=	'code/Mobs/Hair/Short.dmi',
		"Curly"		=	'code/Mobs/Hair/Curly.dmi',
		"LongCurly"=	'code/Mobs/Hair/Long_Curly.dmi',
		"Mohawk"	=	'code/Mobs/Hair/Mohawk.dmi',
		"Tail"		=	'code/Mobs/Hair/Tail.dmi',
		"Matted"	=	'code/Mobs/Hair/Matted.dmi',
		"Ponytail"	=	'code/Mobs/Hair/Ponytail.dmi',
		"Dreadlocks"=	'code/Mobs/Hair/Rasta.dmi',
	)

	AnimalAI
	jousting_tournament

	TOS_List[0]
	TOS = {"<u><b>Terms of Use</b></u>
I (the reader) hereby agree to the following conditions during my time on Hazordhu II and on the forums:

 - I am aware that Hazordhu is a <a href="http://www.google.ca/search?sourceid=chrome&ie=UTF-8&q=define:Roleplay">Roleplay</a> game.
 - I will help to create a fun, fair, and friendly roleplay environment for everyone.
 - I will not negatively effect the enjoyment or creativity of others roleplay, or roleplay events.
 - I will be respectful of all of those online at all times.
 - I will <b>not</b> be a negative influence on the roleplay of others.
 - I will <b>not</b> complain, ask for things, or in any other way pester the staff at any time.
 - I will <b>not</b> use the OOC Channel to broadcast anything that has to do with mine or any other character, past, present, or future.
 - I will <b>not</b> spam, advertise other games, or excessively cuss.
 - I will keep all debates of a public nature in a respectable and mature manner.
 - I am aware that ignorance or voluntary disobedience of this agreement is not an excuse for violation.

   I also agree that, in the event I have been considered by the staff of Hazordhu II to have broken this agreement, I will accept the punishment given without complaint or comment.

More detailed information on what is and is not acceptable can be found <a href="http://www.hazordhu.com/forum/viewtopic.php?f=20&t=278">here</a>.
"}

var const/newgods_save = "Data/new gods.sav"


world
	view = 8
	hub = "F0lak.Hazordhu"
	name = "Hazordhu II"
	fps = INIT_FPS
	version = build

	New()
		..()
		SetConfig("APP/admin", "Kaiochao", "role=root")

		name = "Hazordhu II ([BUILD])"

		if(!(MAPSAVE & SAVE_FLAG))
			name += " (NO MAP SAVE)"

		status = name

		if(fexists(newgods_save))
			var savefile/s = new (newgods_save)
			s["newgods"] >> NewGods
		if(!NewGods) NewGods = list()
		else
			for(var/k in NewGods)
				if(k != ckey(k))
					NewGods -= k
					NewGods |= ckey(k)

		load_login_message()

	Del()
		save_login_message()

		fdel(newgods_save)
		if(NewGods.len)
			var savefile/s = new (newgods_save)
			s["newgods"] << NewGods
		..()

atom/movable
	icon = 'code/Icons/NoIcon.dmi'
	var
		Health	=	100
		MaxHealth =	100

area/layer = 0
client
	default_verb_category = null
	control_freak = 1

	New()
		view = "19x17"
		. = ..()

mob
	SET_TBOUNDS( "12,4 to 21,8")

	layer = MOB_LAYER
	see_in_dark = 5

	player/var
		cid

		charID

		tmp
			isSubscriber
			isBYONDMember

		MemBens = 0
		SubBens = 0

		Ael = "Ael"	//	Sets the Ael name for admins

		can_ooc			=	TRUE
		ooc_listen		=	TRUE
		can_admin_help	=	TRUE
		pvp				=	TRUE

		Made			=	FALSE	//	Defining whether the player has created their character yet

		//	Admin Variables
		Mute = FALSE	//	If TRUE, the player cannot speak

		//	Medal variable
		hasMined[]


	var
		_Gender

		icon_turn
		Bleeding
		Age			//	Sets how old each mob is.
		moon		//	Sets the players birthmoon
		aeon		//	Sets the players birthaeon

		baby = FALSE	//	has the person laid an egg this year?

		//	Various Variables
		tmp/Locked		=	FALSE	//	if TRUE, the player cannot move

		Items			=	0	//	Determines how many items the person has.
		Item_Limit		=	15	//	Determines how many items people can carry.

		SkinType				//	Type of skin dropped when skinned
		MeatType				//	Type of meat dropped when skinned.
		obj/Hair/HairObj

		Cursed = FALSE	//	If TRUE, the player turns undead when they would have normally died.


		//	Character Variables
		Race = "None"	//	The race of the player. Human, Orc, Elf, Undead.

		Heritage = ""

		Stamina = 100
		MaxStamina = 100

		Blood = 100
		MaxBlood = 100

		//	0 is lowest, 100 is highest and damages player.
		Hunger = 0
		Thirst = 0

		//	Language Variables
		Speaking = "Common"	//	Language the player is currently speaking.
		Languages[] = list("Common")	//	List of known languages to the player.

		Hood_Concealed = FALSE

		//	Adds delay betwen pointing.
		tmp/Pointing = FALSE

		//	Equipment Variables
//		Swapping = 0	//	Swapping hands

		//	Alchemy effect variables.
		tmp
			Poisoned
			Waterwalk

		//	Combat variables
		Strength = 5
		Defense = 5
		Deaths = 0
		Kills = 0
		tmp
			KO = FALSE
			Dead = FALSE
			Resting	=	FALSE

			StrengthBuff = 0
			DefenseBuff = 0

obj
	layer = OBJ_LAYER
	var no_save
	var Type

	Built
		layer = OBJ_LAYER + 1
		var Owner

	Item/Tailoring
		Mattress/layer = OBJ_LAYER + 2
		Pillow/layer = OBJ_LAYER + 3

	Item/var
		Equipped
		Attack = 0

		value = 10

		tmp
			mob/humanoid/Owner

//	var
//		Built

var Animals[0]
var Carts[0]

mob/Animal
	New()
		Animals += src
		..()

	Del()
		Animals -= src
		..()

obj/Built/Storage/Cart
	New()
		Carts += src
		..()

	Del()
		Carts -= src
		..()

atom
	proc/Bumped(O)

atom/movable
	Bump(atom/A)
		if(istype(A))
			A.Bumped(src)	// tell A that src bumped into it
		..()
