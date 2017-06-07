login_changelog
	v6032
		name = "6032"

		additions = list(
			"Bricks now weigh less than stones",
			"Boards now weigh less than logs", 
			"Tailoring now includes a recipe for Thread", 
			"You can zoom in with the scroll wheel",
			"The mouse cursor matches what you craft when dragging a recipe",
			"Masonry now includes actions for digging",
			"Emptying a cauldron now asks for confirmation",
			"Chests with locks can now be closed by locking, just like doors",
			"Items now have a pick-up animation",
			"Fishing now has a skill level that affects your fishing speed and success chance",
			"Forges are now containers of fuel and ore. \
				Left-click the forge to open, \
				drag and drop items to transfer materials, \
				and right-click the forge to toggle the fire."
		)

		fixed_bugs = list(
			"Mounts placed on boats will no longer move away", 
			"Making quills works now", 
			"Buckets can now be crafted into the inventory like other crafted items",
			"Combat mode now is disabled on death",
			"Medium dead trees can now be chopped like the non-dead ones",
			"Snow bushes are now as small as the non-snow bushes", 
			"Animal skinning products/heads now spawn aligned with the corpse"
		)

		fixed_glitches = list(
			"Northern metal helmet's overlay was incomplete",
			"Boats and mounts now match speed with the rider", 
			"\"Flurm Nest nest\" is now just \"Flurm nest\"",
			"Crafting grid squares no longer slide around"
		)

	v6031
		name = "6031"

		additions = list(
			"Plants are now layered as if they stand out of the ground.",
			"All crafting tabs are visible at all times.",
			"Client framerate is increased.",
			"Stamina is no longer spent when gathering.",
			"Tools no longer break."
		)

		fixed_bugs = list(
		)

		fixed_glitches = list(
			"Character creation text appears correctly.",
			"The map is now flush with the top of the window contents.",
			"Medal messages no longer appear when not appropriate."
		)

	v6030
		name = "6030"

		additions = list(
			"Some control consistency updates",
		)

		fixed_bugs = list(
			"Paths no longer attach over cliff edges",
		)

	v6029
		name = "6029"

		additions = list(
			"Some cliff edge icons now fit their purpose more",
			"Added some animal sounds",
			"New foliage details added",
		)

		fixed_bugs = list(
			"Yeese now have a proper yield when harvested",
			"The bearer flag icons have been updated and are colourable",
			"Farmed crops should no longer disappear under farm paths",
			"Carts no longer warp away when moving diagonally",
			"Ice can no longer be made to be chiseled over and over again",
			"Grinding stones powered by water wheels are usable again",
		)

		fixed_glitches = list(
			"Fishing rod icons fixed",
		)

	v6028
		name = "6028"

		additions = list(
			"Shurgercanes now have a use",
		)

	v6027
		name = "6027"

		additions = list(
			"Re-added some awesome ambient water noise",
			"Added a bit of river edge detail",
		)

		fixed_bugs = list(
			"Dead bushes could be picked",
			"Couldn't make blankets",
			"Couldn't drag bodies",
			"Couldn't drop balls",
		)

		fixed_glitches = list(
			"Could chip waterfalls",
		)

	v6026
		name = "6026"
		additions = list(
			"More things can be rotated",
			"Improvements for beds and things that go on them",
			"Sink has been removed (too unrealistic)",
			"Some very MINOR map adjustments",
		)

		fixed_bugs = list(
			"Couldn't drink from rivers or ponds",
			"Could unmount through fence",
			"Fixed ball physics a bit",
			"Crafting on a pile of required materials would make the pile disappear",
		)

	v6025
		name = "6025"
		additions = list(
			"Fence gates",
			"Glass cups",
			"Sink can be toggled on and off",
			"Better support for wild plants in the new farming system",
			"Quick and likely-buggy character description system through right-click",
		)

		fixed_bugs = list(
			"Cliff edges block building properly",
			"Carts didn't follow through caves",
			"Reading signs with the keyboard showed its message twice",
			"Water Wheels and Grinding Stones didn't always spin properly",
			"Tanning frames stopped working after being used once",
		)

		fixed_glitches = list(
			"Grass edges would bleed through cliff edges",
			"Fixed snowy cliffs around the volcano",
		)

	v6024
		name = "6024"
		additions = list(
			"Jungle tree icons have been improved.",
			"Big farming change. Crops grow with time instead of seasons, and certain crops only grow in certain seasons.",
			"Added plantable lettif and shurgercane.",
			"Can now defend against animal attacks",
			"The flag of the group is displayed by its name in the group tab",
			"Boards and Bricks have been moved to Carving and Masonry, for consistency",
			"Peeks are tamed with regular interact instead of double-right-click",
			"Harvesting a crop un-plows its farmland",
			"Digging with shovels changed to right-click the shovel",
			"Bookshelf can now store books (and nothing else)",
			"Internal interaction changes (casts a ray instead of checks distance)",
			"Agriners attack differently now",
		)

		fixed_bugs = list(
			"Yeese and Murshums are their own seeds.",
			"Crafting into the inventory past your weight limit will drop excess",
			"Plants no longer teleport with the obelisk",
			"Improved how items are placed on tables and counters",
			"Balls didn't bounce properly",
			"Sink wasn't craftable",
			"InfernoSplosion bow didn't work",
			"Metal Coins were called \"Hazium Coins\"",
		)

		fixed_glitches = list(
			"A couple jungle glitches: cave exiting in the wrong place, and a trap waterfall",
			"Snowy riverbanks get footprints"
		)

	v6023
		name = "6023"
		additions = list(
			"Coin stamp. Group-based. "
		)

		fixed_bugs = list(
		)

		fixed_glitches = list(
		)

	v6022
		name = "6022"

		additions = list(
		)

		fixed_bugs = list(
			"Certain carts were disappearing on reboots.",
			"Firepits would be created as charcoal"
		)

		fixed_glitches = list(
		)

	v6021
		name = "6021"

		additions = list(
		)

		fixed_bugs = list(
			"A couple behind-the-scenes fixes."
		)

		fixed_glitches = list(
		)

	v6020
		name = "6020"

		additions = list(
		)

		fixed_bugs = list(
			"Taking food off of a cooking range would rotate it instead",
			"Mounts load better now on reboots and relogs (they log out with the rider now)",
			"Harvesting planted seeds would give more seeds",
			"Hitting the Cancel button in Set Language would cause you to \"says in : \"",
			"Mounts sometimes took stamina while speeding, causing the rider to pass out",
			"Couldn't write on Statues or Tombstones",
			"Couldn't mylk murs, which didn't properly spawn gendered",
			"Water wheel with Grinding Stone didn't update properly through seasons",
			"Probably some other small stuff",
		)

		fixed_glitches = list(
		)

	v6019
		name = "6019"

		additions = list(
			"The world saves automatically every 30 minutes",
		)

		fixed_bugs = list(
			"Titling books didn't work, but is now done with Ctrl+RightClick."
		)

		fixed_glitches = list(
		)

	v6018
		name = "6018"

		additions = list(
			"Re-added the combat zone and mouse-controlled melee. Archery has keyboard controls, too; simply take your mouse off the map and your direction will be based on your movement. Press R to load an arrow, and Space to fire.",
			"Middle-clicking an equippable item will equip it. ",
			"(not new) The new crafting system will automatically equip the required tool if it's in your inventory.",
			"Interaction distance has been reduced."
		)

		fixed_bugs = list(
			"Couldn't fill containers with water.",
			"Items used on the ground could create items in the player, exceeding the player's item limit.",
			"Water currents didn't push boats without a driver. They now push boats that have a player passenger, paddle or not. ",
			"Couldn't build on bridges.",
			"Waterfalls are now too strong to paddle up."
		)

		fixed_glitches = list(
			"The Plumed Plate Helmet with Visor disappeared when trying to color it."
		)

	v6017
		name = "6017"

		additions = list(
			"Added a visible button for Main Menu (it can still be accessed with Escape).",
			"The Main Menu has a few new buttons for setting resolution and swapping the main window panes.",
			"Added a visible Help button to ask for help from admins.",
			"Slightly changed the stat bars. They are now always at least somewhat visible. When one is low, it becomes more visible. You can still hold X to make all of them solid. ",
			"Hunger and Thirst now go from full to empty, to be consistent with Health and Stamina.",
			"Sharp rocks do damage to boats again. Careful!",
			"Bags can no longer store arrows or bolts. Use a quiver for those!"
		)

		fixed_bugs = list(
			"Hopefully likable improvements on the screen size issue.",
			"Some possible improvements regarding boats, water, bridges, waterfalls.",
			"Parchments can now be read.",
			"Bags can no longer be stored in other bags."
		)

	v6016
		name = "6016"
		fixed_bugs = list(
			"Smithing buildables like anvils, cauldrons, etc. were not accessible.",
			"Open windows could be walked through. (major bug)",
			"Boats were being dumb. Also you can put animals on them now.",
			"A temporary solution has been put into place for players with tiny screen resolutions.",
			"The on-screen name label was showing incorrect names for people.",
			"Minor improvements to tame Ruff AI."
		)

	v6015
		name = "6015"
		additions = list(
			{"A few minor interface changes."},
			{"Building has been changed: drag and drop onto build squares. X no longer does anything."},
			{"Aels can spawn totems upon request to protect buildings from being attacked."},
			{"Melee has been changed to simply attack ahead of you. Archery has not changed."},
			{"Added group chat."}
		)

		fixed_bugs = list(
			{"Fixed being able to build non-bridges on water."},
			{"Fixed not being able to walk on ice."},
			{"Fixed carts not following you on bridges."},
			{"Fixed being able to mount an animal when someone else is riding it."},
			{"Fixed dropping balls."},
			{"Fixed building bridges over lava."},
			{"Fixed brewing wine and beer."},
			{"Fixed a bunch of other stuff that isn't listed here."}
		)

		fixed_glitches = list(
			{"Stat bars have icons again."}
		)

	v6014
		name = "6014"
		additions = list(
			{"Log Door and Window (credit to Vrocaan for the art)"},
			{"Slightly different building system, requires pressing X"}
		)

		fixed_bugs = list(
			{"Fixed bridge-making."},
			{"Languages work properly now."},
			{"Some other fixes."}
		)

	v6013
		name = "6013"
		additions = list(
			{"Minor interface changes. Keep Z and C handy!"}
		)

		fixed_bugs = list(
			{"Some bugs that aren't fixed from 6012's changes."}
		)

		fixed_glitches = list(
			{"A couple glitches with the map.."}
		)


	v6012
		name = "6012"
		additions = list(
			{"Movement tweaks: Toggle Run has been removed. Holding shift will make you move faster on mounts and boats, along with running on foot. "},
			{"Mine cave-ins tweaked: Made slower and more natural, and more efficient."},
		#if ITEM_DURABILITY
			{"Experimental: Tools and weapons will wear out after a certain number of uses. Damage can be seen on the item in your inventory."},
		#endif
		#if ITEM_WEIGHT
			{"Experimental: Items have varying weights (e.g. feathers are weightless, berries weigh less than rocks)."},
		#endif
		#if WORK_STAMINA
			{"Experimental: Chopping wood and mining require and drain stamina. "},
		#endif
			{"Experimental: Completely new interface. Z and C toggle the panes on the left and right."},
			{"The new interface comes with some new controls. See the Controls guide in the Main Menu (Escape)."},
			{"Toggle "Grid Mode" with X: It displays a grid around you and slides you to the center of the tile you're standing on."},
			{"Resting tweaks: The Rest button has been removed. To rest, you must be standing still without speaking ICly for at least a minute."},
			{"Animals drop their harness on death."}
		)

		fixed_bugs = list(
			{"Item decay wasn't properly included. It is set for an hour."},
			{"Languages weren't working properly."},
			{"Super secret obelisk bug fixed."}
		)

		fixed_glitches = list(
			{"Fixed bed layering."},
			{"Fixed a cave entrance being able to be entered from the wrong side."}
		)

	v6011
		name = "6011"
		additions = list(
			{"Starting towns have been removed."},
			{"The tutorial has been updated for the current control scheme."},
			{"Items on the ground and not on a built object (floor, path) will decay after an hour."},
			{"Interface tweaks."},
			{"Craftable descriptions are in their own separate panel instead of a glitchy tooltip."},
			{"Interaction tweaks."},
			{"Harnesses are now tools."}
		)

		fixed_bugs = list(
			{"You can now acquire the Blacksmith and Farmer medals again"},
			{"mounts will teleport with you when using rune circles."},
			{"You can no longer exit a boat through a cliff border."},
			{"You can no longer dismount through walls."},
			{"You can drink from canteens now."}
		)

		fixed_glitches = list(
			{"Experimenting with a new layering system. Hopefully problems like flickering clothes are fixed."},
			{"Mining cave walls should collapse properly."}
		)

	v6010
		name = "6010"
		additions = list(
			{"Bowls, Buckets, and Canteens replenish a finite amount of water"}
		)
		fixed_bugs = list(
			{"<a href="?show_url='http://www.byond.com/forum/?forum=2393&command=search&scope=local&text=resolved%3a6010'">A bunch of stuff.</a>"}
		)

	v6009
		name = "6009"
		fixed_bugs = list(
			{"Hopefully fixed a game crasher"}
		)

	v6008
		name = "6008"

		additions = list(
			{"New Hazium Amulet allows you to wear a Hazium Crystal"},
			{"The icon size setting is now saved/loaded (Sjaelen)"},
			{"Buildings now kill crops when placed over them (DigTK)"}
		)

		fixed_bugs = list(
			{"Fixed a couple run-time errors"},
			{"Rune circles now save properly by staying uncovered"},
			{"Respawning using crystals wasn't working properly"},
			{"Growing crops save properly on reboot"}
		)

		fixed_glitches = list(
			{""Plate Helmet Plume" had no icon (DigTK)"},
			{"Increased cave transport accuracy (DigTK)"},
			{"Red flurms can no longer be harnessed (DigTK)"},
			{"Ghost "seed" item removed (DigTK)"},
			{"Single plowed paths were invisible (DigTK)"}
		)

	v6007
		name = "6007"

		additions = list(
			{"Baking, cooking, and food prep have been added along with a variety of new foods"}
		)

		fixed_bugs = list(
			{"All things related to the alert boxes (renaming, creating groups, etc.) should work now"},
			{"Logs can be chopped into boards again"},
			{"Admin's note wasn't being updated properly when edited by an administrator"}
		)

	v6006
		//	name is required
		name = "6006"

		additions = list(
			{"Shiny new login message"},
			{"Re-added riverbanks to the map"},
			{"Re-added on-map sign-reading"},
			{"Updated Controls (see Controls in the Menu)"},
			{"Pressing CTRL (entering combat mode) won't change your direction until you move your mouse into the screen"},
			{"Combat mode displays an oval showing the "attack zone""},
			{"Updated Main Menu (added Bug Report and Feature Request buttons)"},
			{"Browser links in the Main Menu are also shown in the browser that opens up"}
		)

		fixed_bugs = list(
			{"Carts stopped being pull-able after the first time"},
			{"Hostile animals weren't aggressive"}
		)

		fixed_glitches = list(
			{"Some cliff edges on the mainland were the wrong type and didn't conform to the seasons"},
			{"Fences now join to Cliffs and opened doors"}
		)





//	implementation below






























var LoginMessage/LoginMessage = new

//	javascript in here lets you toggle sections to show/hide them
//	yay for javascript
proc/LoginMessage() return LoginMessage.message

login_changelog
	var name
	var additions[]
	var fixed_bugs[]
	var fixed_glitches[]
	proc/summary()
		clean_list(additions)
		clean_list(fixed_bugs)
		clean_list(fixed_glitches)

		var add = "No new additions"
		if(additions && additions.len > 0)
			add = "[additions.len] addition"
			if(additions.len > 1)
				add += "s"
		var bug = "no new bugs fixed"
		if(fixed_bugs && fixed_bugs.len > 0)
			bug = "[fixed_bugs.len] fixed bug"
			if(fixed_bugs.len > 1)
				bug += "s"
		var glitch = "no new glitches fixed"
		if(fixed_glitches && fixed_glitches.len > 0)
			glitch = "[fixed_glitches.len] fixed glitch"
			if(fixed_glitches.len > 1)
				glitch += "es"

		return \
			{"
			<h3><a href=javascript:toggle_section("[name]")>[name]</a> - [add], [bug], and [glitch]</h3>
			<ul id="[name]">
			<li>Additions:			[LoginMessage.list2ul(additions)]		</li>
			<li>Fixed bugs:			[LoginMessage.list2ul(fixed_bugs)]		</li>
			<li>Fixed glitches:		[LoginMessage.list2ul(fixed_glitches)]	</li>
			</ul>
			"}

LoginMessage
	var message
	var message_from_admins

	New()
		LoginMessage = src
		update()

	proc/update()
		message = get()

	proc/list2ul(L[])
		if(L && L.len)
			var innerHTML = ""
			for(var/line in L)
				innerHTML += "<li>[line]</li>"
			return "<ul>[innerHTML]</ul>"

		else
			return "None"

	var section_js = \
		{"
		<script type="text/javascript">
		function toggle_section(id)
		{
			var e = document.getElementById(id)
			if(e.style.display == "none")	{ e.style.display = "block" }
			else							{ e.style.display = "none"  }
		}
		</script>
		"}

	proc/body_style() return \
		{"
		<body
			bgcolor=[rgb(140,120,57)]
			link=[rgb(180,160,97)]
			alink=[rgb(180,160,97)]
			vlink=[rgb(180,160,97)]
		>
		"}

	proc/admin_note() return \
		{"
		<h2>Administrators' Note:</h2>
		<em>[message_from_admins]</em>
		"}

	proc/changes()
		. = "<h2>Changes</h2>"

		var login_changelog/v
		var first
		for(var/version_path in typesof(/login_changelog))
			v = new version_path
			if(v.name)
				. += v.summary()
				if(first)
					. += {"<script type="text/javascript">toggle_section("[v.name]")</script>"}
				else
					first = 1

	proc/get() return \
		{"
		[section_js]
		[body_style()]
		<center><h1>Hazordhu II</h1></center>
		[admin_note()]
		[changes()]
		</body>
		"}

/*
{"
Welcome to Hazordhu II.

This is a temporary development server that I put up to test a couple things, like a possible fix of the slowness that comes after a while.

You don't have to play on this server if you don't want to, but it would be a better test if conditions were as similar as possible.
"}
*/
/*
{"Welcome to Hazordhu II.

Welcome to the release of the much anticipated Version 6.0.  We've done a few pretty major things in this version, so it's important that returning players check the <a href="http://hazordhu.com/forum/viewtopic.php?f=5&t=320&p=1034#p1034m">change log</a> to see what's new.

To the new players, welcome to Hazordhu.  Feel free to ask anyone for help, as we have a fun and helpful community who have all been there before.

Thank you for your support and testing for this release.  We are aware that this version still has some kinks in it, and we would appreciate <b>any and all bug reports to be posted on the <a href="http://www.byond.com/forum/?forum=2393">Bug Tracker</a></b>.

- The Hazordhu II Team
"}
*/
/*
{"Welcome to Hazordhu II!
If you're new, be sure to follow the tutorial.  It will explain everything you need to know to get started!

Don't forget to register for free on the forums and get to know the community and stay up to date with game updates!

There have been some major changes in this version.  See the Change Log for details.

Thank you.
	- Hazordhu Staff
"}
*/