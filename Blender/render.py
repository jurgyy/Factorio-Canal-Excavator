import bpy
from typing import Generator
import os
from pathlib import Path

# -- Blender expects directories to end with a separator, but pathlib removes them --
def dirToString(self):
    return str(self) + os.sep

Path.dirToString = dirToString
del(dirToString)
# ----

outputRoot = Path(os.getcwd()).joinpath("output/2/")
mainAnimationStart = 1
mainAnimationStop = 64
floorDustAnimationStart = 48
floorDustAnimationStop = 111
worldBackgroundStrength = 3.000

startDirection=None#"West" 
startFrame=None#64

def iterAllObjectNames(col: bpy.types.Collection) -> Generator[str, None, None]:
    names = [obj.name for obj in col.all_objects]
    for name in names:
        yield name

def hideCollection(colName: str, value=True):
    bpy.data.collections[colName].hide_render = value
    bpy.data.collections[colName].hide_viewport = value

def hide(objName: str, value=True):
    bpy.data.objects[objName].hide_render = value
    bpy.data.objects[objName].hide_viewport = value
    
def holdOutCollection(col: bpy.types.Collection, value=True, unhide=False):
    for objName in iterAllObjectNames(col):
        bpy.data.objects[objName].is_holdout = value
        if unhide:
            hide(objName, False)

def disableLights():
    for obj in bpy.context.scene.objects:
        if obj.type == 'LIGHT':
            hide(obj.name)
            
def iterDirectionNames() -> Generator[str, None, None]:
    global startDirection
    
    sceneCol = bpy.data.collections["Scene"]
    names = [col.name for col in sceneCol.children]
    
    if startDirection is not None and startDirection not in names:
        raise Exception(f"{startDirection} not in {names}")
    
    for directionCol in sceneCol.children:
        name = directionCol.name
        if startDirection is not None:
            if name == startDirection:
                startDirection = None
            else:
                continue
        yield name
    
def setSceneDirection(direction: str, strenght: float = worldBackgroundStrength):
    print(f"Setting direction to {direction}")
    for name in [obj.name for obj in bpy.data.collections[direction].objects]:
        if bpy.data.objects[name].type == "CAMERA":
            bpy.context.scene.camera = bpy.data.objects[name]
    world = bpy.data.worlds.get(f"World-{direction}")
    world.node_tree.nodes["Background"].inputs[1].default_value = strenght
    bpy.context.scene.world = world

def setMainAnimationStartEndFrame():
    if startFrame is None:
        bpy.context.scene.frame_start = mainAnimationStart
    else:
        bpy.context.scene.frame_start = startFrame
    bpy.context.scene.frame_end = mainAnimationStop

def renderMachine():
    disableLights()

    hide("Shadow Catcher")
    hideCollection("Floor Dust")
    hideCollection("Hopper Dust")

    setMainAnimationStartEndFrame()

    holdOutCollection(bpy.data.collections["Main Render"], value=False, unhide=True)

    for direction in iterDirectionNames():
        
        setSceneDirection(direction)
        
        bpy.context.scene.render.resolution_x = 1080
        bpy.context.scene.render.resolution_y = 1080
        bpy.context.scene.render.filepath = outputRoot.joinpath(f"hr/{direction}/Machine/").dirToString()

        bpy.ops.render.render(animation=True)

        bpy.context.scene.render.resolution_x = 540
        bpy.context.scene.render.resolution_y = 540
        bpy.context.scene.render.filepath = outputRoot.joinpath(f"lr/{direction}/Machine/").dirToString()

        bpy.ops.render.render(animation=True)


def renderHopperDust():
    disableLights()
    setMainAnimationStartEndFrame()

    for direction in iterDirectionNames():
        setSceneDirection(direction)
        
        holdOutCollection(bpy.data.collections["Main Render"], value=True, unhide=True)
        
        hideCollection("Hopper Dust", False)
        hideCollection("Floor Dust")
        hide("Shadow Catcher")
        
        bpy.context.scene.render.resolution_x = 1080
        bpy.context.scene.render.resolution_y = 1080
        bpy.context.scene.render.filepath = outputRoot.joinpath(f"hr/{direction}/HopperDust/").dirToString()
        
        bpy.ops.render.render(animation=True)
        
        bpy.context.scene.render.resolution_x = 540
        bpy.context.scene.render.resolution_y = 540
        bpy.context.scene.render.filepath = outputRoot.joinpath(f"lr/{direction}/HopperDust/").dirToString()
        
        bpy.ops.render.render(animation=True)


def renderShadows():
    holdOutCollection(bpy.data.collections["Main Render"], value=True, unhide=True)
    setMainAnimationStartEndFrame()

    for direction in iterDirectionNames():
        hideCollection("Hopper Dust")
        
        setSceneDirection(direction, strenght=0)
        
        hide(f"Ground Shadow Light {direction}", False)
        hide(f"Shadow Catcher", False)
        
        bpy.context.scene.render.resolution_x = 1080
        bpy.context.scene.render.resolution_y = 1080
        bpy.context.scene.render.filepath = outputRoot.joinpath(f"hr/{direction}/Shadows/").dirToString()
        
        bpy.ops.render.render(animation=True)
        
        bpy.context.scene.render.resolution_x = 540
        bpy.context.scene.render.resolution_y = 540
        bpy.context.scene.render.filepath = outputRoot.joinpath(f"lr/{direction}/Shadows/").dirToString()
        
        bpy.ops.render.render(animation=True)
        hide(f"Ground Shadow Light {direction}", True)


def renderFloorDust():
    holdOutCollection(bpy.data.collections["Main Render"], value=True, unhide=True)
    hideCollection("Hopper Dust")

    for direction in iterDirectionNames():
        hide("Shadow Catcher")
        setSceneDirection(direction, strenght=worldBackgroundStrength)
        hideCollection("Floor Dust", False)
        
        bpy.context.scene.frame_start = floorDustAnimationStart
        bpy.context.scene.frame_end = floorDustAnimationStop
        
        bpy.context.scene.render.resolution_x = 1080
        bpy.context.scene.render.resolution_y = 1080
        bpy.context.scene.render.filepath = outputRoot.joinpath(f"hr/{direction}/FloorDust/").dirToString()
        
        bpy.ops.render.render(animation=True)
        
        bpy.context.scene.render.resolution_x = 540
        bpy.context.scene.render.resolution_y = 540
        bpy.context.scene.render.filepath = outputRoot.joinpath(f"lr/{direction}/FloorDust/").dirToString()
        
        bpy.ops.render.render(animation=True)

def main():
    renderMachine()
    renderHopperDust()
    renderShadows()
    renderFloorDust()


if __name__ == "__main__":
    main()