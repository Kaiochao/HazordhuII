
var npc_dialogue[] = list(
"gathering" = "\
	<b>Gathering</b> is the way of getting raw material from a source. \
	To gather, you double-click the thing you want to gather from. \
	<br><br>\
	For example, you mine metal from a metal deposit, chop wood from a tree, and so on.",

"building" = "\
	<b>Building</b> is the way of using refined materials to create an object or building. \
	This is done using the <b>Crafting</b> tab in the <b>My Character</b> pane. <br><br> \
	When you mouse-over a craftable, you'll see a description and required materials. <br> \
	Click and drag whatever you want to build onto the map. Squares will appear to show you where you can build. ",

"processing" = "\
	<b>Processing</b> is the way of refining (usually by right clicking them) \
	raw materials, such as wood and stone, so they can be used in crafting. \
	Keep in mind that not all things require processing.",

"smithing" = "\
	To do <b>blacksmithing</b>, you need metal to smith with and wood to light a fire in the forge. \
	You can get both of these just across from my shop.\
	<br><br>\
	To <b>smelt</b>, place fuel and ore into the forge and right-click it to turn it on. \
	Ore will eventually turn into bars, used for smithing. \
	<br><br>\
	To <b>smith</b>, stand next to an anvil and go to the Smithing tab.",

"combat" = "\
	Hello, I'm the combat trainer. \
	Battles in Hazordhu are very different than other games in the sense that you <i>must</i> roleplay them. \
	If battles aren't roleplayed, anyone taking part in them can have their combat privilege taken away. \
	There are three steps to roleplaying a battle. \
	<br><br>\
	First is showing <b>Courtesy</b> before you start the battle. \
	Take a moment to OOCly acknowledge that all players partaking in the battle know how to roleplay one properly, \
	and also decide who will attack first.\
	<br><br>\
	Second is the <b>Attack</b>. At this point, the attacker will make his move. \
	Press Tab to toggle Combat mode. \
	This is a very critical part in the battle. Attacks <i>must always</i> be emoted every time you attack someone. \
	Attack emotes should never actually state a hit, rather an attempt. If the attacker is using a ranged weapon, \
	he should emote at least once that he intends to shoot a player. \
	<br><br>\
	Third is <b>Defense</b>. \
	You can hold the right mouse button in Combat mode to defend. \
	Emote your defense, whether it failed or not. \
	You can also fit a counter-attack emote into your defense emote. \
	<br><br>\
	For a more detailed guide, visit http://hazordhu.com/forum/viewtopic.php?f=5&t=682.",

"religion" = "\
	This is an <b>altar</b>. \
	Here, you can pray to the Aels or even offer them items by interacting with the altar. \
	If they want to, they will even answer your prayers!\
	<br><br>\
	In fact, there's a Rune Circle at the end of this path. \
	If you stand on it and interact with it, the Aels will whisk you away to your new life!"
)

mob
	tutor
		parent_type = /mob/NPC

		new_ai = FALSE

		var dialogue_type
		var dialog
		attackable = FALSE

		interact(mob/humanoid/m)
			m << output(dialog, "npc_dialog.npc_browser")
			winshow(m, "npc_dialog")

		New()
			..()
			dialog = npc_dialogue[dialogue_type]
			name = "[capitalize(dialogue_type)] Tutor"

		human
			icon = 'code/Mobs/Human/m_tan.dmi'
			Race = "Human"
			clothe()
				equip(new /obj/Item/Clothing/Shirt/Short_Sleeve_Shirt (src))
				equip(new /obj/Item/Clothing/Pants/Trousers (src))
				equip(new /obj/Item/Clothing/Hood/Hood (src))
				equip(new /obj/Item/Clothing/Feet/Boots (src))
			gathering/dialogue_type = "gathering"
			building/dialogue_type = "building"
			processing/dialogue_type = "processing"
			smithing/dialogue_type = "smithing"
			combat/dialogue_type = "combat"
			religion/dialogue_type = "religion"

		orc
			icon = 'code/Mobs/Orc/m_warcry.dmi'
			Race = "Orc"
			clothe()
				equip(new /obj/Item/Clothing/Shirt/Grawl_Shirt (src))
				equip(new /obj/Item/Clothing/Pants/Grawl_Pants (src))
				equip(new /obj/Item/Clothing/Hood/Grawl_Hood (src))
				equip(new /obj/Item/Clothing/Feet/Grawl_Boots (src))
			gathering/dialogue_type = "gathering"
			building/dialogue_type = "building"
			processing/dialogue_type = "processing"
			smithing/dialogue_type = "smithing"
			combat/dialogue_type = "combat"
			religion/dialogue_type = "religion"