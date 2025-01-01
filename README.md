# Canal Excavator Mod
The Canal Excavator Mod is a mod for the game Factorio. This mod introduces a way for players to dig canals. Contrary to previous water mods, the canal excavator mod can only create water nearby other bodies of water. Bringing water to a desert will be a large undertaking.

## Key Features
1. **The Canal Excavator**
The centerpiece of this mod is the Canal Excavator: A large 7x3 structure that serves as tool for digging canals. This machine can be placed on special tiles and once powered will begin excavating the designated area.

2. **Excavatable Tiles**
To facilitate the creation of canals, the mod introduces special excavatable tiles. These tiles be placed like any other tiles, but unlike other tiles, they can be mined for stone. 

3. **Water Transition**
After an excavatable tile has been depleted by the Canal Excavator, the tile transitions into a _dug_ state. If the tile is connected to a water tile, the dug tile changes in a water tile as well. It then checks if other neighbouring tiles are dug which in turn will transitioned as well. 

## Spage Age
The mod is compatible with spage age but will only work for planets with the same atmosphere as Nauvis and only for water. In the future I want to support all vanilla planets and later add a way to automatically work with modded planets or add an interface with which planet mods can configure all the required information to automatically work correctly.

## Mod Compatibility

**Space Exploration**
This mod was created with Space Exploration in mind. Other water mods often allow you to create water on planets where no source exists. This mod limits you to only create water nearby existing bodies of water.

**Cargo Ships**
The size of the Excavator was decided such that it stretches the complete width of a canal that fits the cargo ships nicely.

**Other mods**
This mod should be compatible with most other mods since it only adds new objects and doesn't modify any existing ones. Though this mod does add two tile prototypes and currently Factorio has a hard limit of 255. If you run multiple mods that add a lot of types, you might encounter this limit. For this reason there is a world setting called "Don't introduce new tiles". By default this is off but when enabled it reuses the "Yellow Refined Concrete" and "Brown Refined Concrete" that are already in the base game. If the mods you are using don't touch these two, you can enable this setting without any problems although it won't look as pretty.

If a mod adds new water tiles, this mod probably won't recognize them when checking if a dug tile touches water. If you encounter such issue, please contact me with the info about which mods you are using and I'll add support for it.


## Known Issues
 * In vanilla, the excavator can't be placed on shallow water. Unfortunately, without messing with the collision mask of all entities, this is impossible. If a mod, as Alien Biomes does, changes the collision mask to not collide with the object-layer it will work.  
 * Items don't get picked up when an excavator gets build on top of it. I can't add the "item-layer" collision mask to the excavator's mask, since water tiles have that layer as well which would prevent the excavator from being placable on water and it will be destroyed when a water tile gets created under it.
 * When the Excavatable Surface is removed by another mod, it leaves the ore/stone behind. A workaround is to place the tiles again and remove them by hand or by using bots. After 2.0 releases I want to look into fixing this.

## Q&A
*Q: A tile won't transition into water even though it is touching another water tile*  
*A:* Open console with the ` button and type "/canex-transition-dug" without the quotes and press enter. Did it transition? If not, please contact me at the Github page bellow.

## Encountering an issue or have a suggestion?
If you do encounter any issue, due to mod compatibility or otherwise, please open an issue [on the Github page](https://github.com/jurgyy/Factorio-Canal-Excavator/issues). If you have a suggestion for new features and such, please open a thread [on the mod's discussion page](https://mods.factorio.com/mod/canal-excavator/discussion). Want to help translating, please open a pull request with the added locale files.