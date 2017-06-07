//	shows "Test Server" in the title bar
#define DEVMODE 0

//	shows "Official Server" in the title bar
#define OFFICIALSERVER 1
#define BUILD 6032

#define MAP_OTF 0

#if MAP_OTF
	#define MAPSAVE 0
	#include "Map Save On the Fly.dm"
#else

//	Set this instead of the var to get a warning
#define MAPSAVE ALL_FLAG
#endif

#define PLAYERSAVE 1

// Is multikeying (multiple simultaneous characters on the same PC) not allowed?
#define NO_MULTIKEY 0

//	Experimental
#define LIGHTING 0
#define ITEM_DECAY 0
#define ITEM_DURABILITY 0
#define ITEM_WEIGHT 1
#define WORK_STAMINA 0
#define FURN_GRAB 0

#define HUD_CRAFTING 1
#define HUD_ALL 1
#define THIN_SKIN 0
#define NEW_RUNES 0

#define CHUNKS 1

#if !MAPSAVE
	#warning - Map Save is OFF!
#endif

#if !PLAYERSAVE
	#warning - Player Saving is OFF!
#endif


#if DEVMODE
	#warning - Development Mode enabled
#endif

#if !OFFICIALSERVER
	#warning - Unofficial Server build
#endif

#if LIGHTING
	#warning - Lighting is ON!
#endif

#if !PIXEL_MOVEMENT
	#warning - Pixel movement is OFF!
#endif