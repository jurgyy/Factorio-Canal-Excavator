[![Release](https://github.com/jurgyy/Factorio-Canal-Excavator/actions/workflows/release.yml/badge.svg?branch=master)](https://github.com/jurgyy/Factorio-Canal-Excavator/actions/workflows/release.yml)

# Canal Excavator Mod
The Canal Excavator Mod is a mod for the game Factorio. This mod introduces a way for players to dig canals. Contrary to previous water mods, the canal excavator mod can only create water nearby other bodies of water. Bringing water to a desert will be a large undertaking.

## Key Features
1. **The Canal Excavator**
The centerpiece of this mod is the Canal Excavator: A large 7x3 structure that serves as tool for digging canals. This machine can be placed on special tiles and once powered will begin excavating the designated area.

2. **Excavatable Tiles**
To facilitate the creation of canals, the mod introduces special excavatable tiles. These tiles be placed like any other tiles, but unlike other tiles, they can be mined for stone. 

3. **Water Transition**
After an excavatable tile has been depleted by the Canal Excavator, the tile transitions into a _dug_ state. If the tile is connected to a water tile, the dug tile changes in the same water tile as well. It then checks if other neighbouring tiles are dug which in turn will transitioned as well. 

## Space Age
The mod is fully compatible with space age. When placed on other planets a different kind of resource will be spawned corresponding to that planet. Excavating on Fulgora, for instance, will mine scrap and places the Heavy Oil tiles once fully dug. Modded planets do have to support my mod before the tiles can placed on those planets. See the Modding Interface chapter for more information on how to support your planet or how to modify the configuration for the vanilla planets.

## Mod Compatibility

**Space Exploration**
This mod was created with Space Exploration in mind. Other water mods often allow you to create water on planets where no source exists. This mod limits you to only create water nearby existing bodies of water.

**Cargo Ships**
The size of the Excavator was decided such that it stretches the complete width of a canal that fits the cargo ships nicely.

**Other mods**
This mod should be compatible with most other mods since it only adds new objects and doesn't modify any existing ones. Though this mod does add two tile prototypes and currently Factorio has a hard limit of 255. If you run multiple mods that add a lot of types, you might encounter this limit. For this reason there is a world setting called "Don't introduce new tiles". By default this is off but when enabled it reuses the "Yellow Refined Concrete" and "Brown Refined Concrete" that are already in the base game. If the mods you are using don't touch these two, you can enable this setting without any problems although it won't look as pretty.

## Known Issues
 * Items don't get picked up when an excavator gets build on top of it. I can't add the "item-layer" collision mask to the excavator's mask, since water tiles have that layer as well which would prevent the excavator from being placable on water and it will be destroyed when a water tile gets created under it.
 * When the Excavatable Surface is removed by another mod, it leaves the ore/stone behind. A workaround is to place the tiles again and remove them by hand or by using bots. After 2.0 releases I want to look into fixing this.

## Q&A
*Q: A tile won't transition into water even though it is touching another water tile*  
*A:* Open console with the ` button and type "/canex-transition-dug" without the quotes and press enter. Did it transition? If not, please contact me at the Github page bellow.

*Q: I get the message "Cannot excavate landfill"*  
*A:* By design you cannot excavate tiles such as Landfill, Foundation, Ice Platform and such. You should be able to mine those by hand. If you encounter this message while you cannot mine the tile, please let me know. See the Issue section bellow on how to contact me.

*Q: I get the message "Unable to dig on this planet"*  
*A:* This means the planet you are on isn't configured to work with my mod. If this happens on one of the vanilla planet (Nauvis, Vulcanus, Fulgora, Gleba or Aquilo), please let me know. If this happens on a modded planet, you should request that mod maker to support my mod. Link them to the Modding Interface section bellow. That should contain all the information they need.

## Encountering an issue or have a suggestion?
If you do encounter any issue, due to mod compatibility or otherwise, please open an issue [on the Github page](https://github.com/jurgyy/Factorio-Canal-Excavator/issues) or if you don't have Github account or if you have a suggestion for new features and such, please open a thread [on the mod's discussion page](https://mods.factorio.com/mod/canal-excavator/discussion). Want to help translating, please open a pull request with the added locale files.

## Modding Interface
By default surfaces are not excavatable. This mods has a simple mod interface to enable surfaces introduced by other mods. There are two ways of doing so. The first and simplest method is to add a mod-data prototype of the structure [`CanexSurfaceConfig` (click)](https://github.com/jurgyy/Factorio-Canal-Excavator/blob/master/global/surfaceConfigHelper.lua#L1-L21) somewhere in the data, or data-updates stage. This prototype allows you to define the number of resources that are mined, the item that mining yields and the tint of the ore. For an example of this method you can look at the implementations of the Space Age planets [here](https://github.com/jurgyy/Factorio-Canal-Excavator/blob/master/prototypes/surfaceConfig.lua). This is everything required for your surface to be compatible with this mod.

However, some mods introduce tons of similar surfaces or don't have deterministic surface properties during the data stage. To support those type of surfaces this mod also introduces a `mod-data` prototype called [`CanexSurfaceTemplate` (click)](https://github.com/jurgyy/Factorio-Canal-Excavator/blob/master/global/surfaceConfigHelper.lua#L24-L35). This prototype allows you to define a template for a surface that can be assigned in the runtime stage during an `on_surface_created` event. To support this you need to implement the aforementioned `CanexSurfaceTemplate` prototype and also another prototype called [`CanexSurfaceCreatedRemote` (click)](https://github.com/jurgyy/Factorio-Canal-Excavator/blob/master/global/surfaceConfigHelper.lua#L38-L49). This last prototype references a remote function of your mod that takes a `LuaSurface` object and returns the name of a `CanexSurfaceTemplate` prototype the surface should use or `nil` if your remote doesn't know this surface. Then during the `on_surface_created` event this mod asks all the registered remote functions for the name of the template to use and uses the first one that gets returned.

An example of how to use the templating method can be found in the [Space Exploration compatability file here](https://github.com/jurgyy/Factorio-Canal-Excavator/blob/master/compatability/space-exploration/prototypes.lua). This file contains templates for Vitamelange planets, icy planets and rocky planets. Furthermore, at the bottom of that file the remote configuration is implemented that references the remote function that can be found [here](https://github.com/jurgyy/Factorio-Canal-Excavator/blob/master/control/remote.lua#L3-L34). The `se_get_zone_template` function calls an Space Exploration remote to get information about the planet and uses that to determine which template to use. Similarly you can write your own remote that uses your mod's logic to assign a template to the surfaces you have added.

Additionally, if you want to add custom excavators, you can use the [`CanexExcavatorConfig` (click)](https://github.com/jurgyy/Factorio-Canal-Excavator/blob/master/global/surfaceConfigHelper.lua#L61-L73) mod-data object. This object references an existing MiningDrill entity and adds the additional resource_category the mod uses for its excavatable resources. My mod doesn't modify the collision mask of the excavator so make sure not to collide with water tiles otherwise the entity will be destroyed when water tiles get created under it.

Lastly, both surface, template and excavator configs contain a field `custom_resource_category`. This field is optional and can be set to a custom resource category if you want to your surface to require a special excavator. Do note that if you set it on a surface/template you also need to create a `CanexExcavatorConfig` or else the resource will be unminable.

### In short
Do you introduce just one or a few fixed surfaces: Create a `CanexSurfaceConfig` for each of those surfaces you want to be excavatable.  
Do you introduce a ton of surfaces, multiple copies of a the same surface or surfaces that aren't deterministic during the data stage, create one or more `CanexSurfaceTemplate`s for the them and a `CanexSurfaceCreatedRemote` with the associated remote function to retrieve the right template during runtime.  
Do you want to introduce a new type of excavator create a `CanexExcavatorConfig` for it. And if you want it to mine its own resources, set the `custom_resource_category` field on both the excavator config as well as the surface/template config.


I hope this is enough to implement your own compatability but if you have any questions or suggestions, please don't hesitate to open a thread on the mod page or contact me on the Factorio Discord server.

