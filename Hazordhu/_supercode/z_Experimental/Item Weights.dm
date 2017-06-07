#if ITEM_WEIGHT
/* item.weight = 1
	How much inventory space an item takes up.
*/

var const
	WEIGHT_NONE = 0
	WEIGHT_TINY = 0.25
	WEIGHT_SMALL = 0.5
	WEIGHT_MEDIUM = 0.75
	WEIGHT_NORMAL = 1

obj/Item
	Armour
		Accessory
			Amulet/weight = WEIGHT_SMALL
			Crown/weight = WEIGHT_MEDIUM
			Ring/weight = WEIGHT_TINY
		Helmet
			Tiara/weight = WEIGHT_SMALL

	Bars
		Metal/weight = WEIGHT_MEDIUM

	Bone/weight = WEIGHT_SMALL

	Book/weight = WEIGHT_SMALL

	Clothing
		weight = WEIGHT_SMALL

	Coal/weight = WEIGHT_TINY

	Metal
		Coins/weight = WEIGHT_NONE
		Metal_Coins/weight = WEIGHT_NONE
		Nails/weight = WEIGHT_TINY

	Feather/weight = WEIGHT_NONE
	Farming
		seed/weight = WEIGHT_TINY
		crop
			Huff/weight = WEIGHT_TINY
			Phluf/weight = WEIGHT_TINY

	Tools
		Brush/weight = WEIGHT_SMALL
		Carding_Tool/weight = WEIGHT_SMALL
		Coin_Stamp/weight = WEIGHT_SMALL
		NeedleThread/weight = WEIGHT_TINY
		Scissors/weight = WEIGHT_SMALL
		Quill/weight = WEIGHT_NONE
		Torch/weight = WEIGHT_SMALL

	Projectile/weight = WEIGHT_TINY

	Food
		Berry/weight = WEIGHT_TINY
		Egg
			weight = WEIGHT_TINY
			Flargl/weight = WEIGHT_NORMAL

		Cooking
			Bacon/weight = WEIGHT_TINY
			Cookie/weight = WEIGHT_TINY
			Muffin/weight = WEIGHT_TINY

	Clothing/weight = WEIGHT_SMALL

	Parchment/weight = WEIGHT_TINY
	Pipe/weight = WEIGHT_TINY

	Mould/weight = WEIGHT_SMALL

	Wood
		Board
			weight = WEIGHT_TINY
	
	Stone
		Brick
			weight = WEIGHT_MEDIUM
#endif