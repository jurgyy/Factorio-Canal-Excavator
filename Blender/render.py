import sys
import os
sys.path.append(os.path.abspath("."))

import bpy
from typing import Generator
from pathlib import Path
from PIL import Image

from packer import reflection

for scene in bpy.data.scenes:
    scene.cycles.device = 'GPU'

# -- Blender expects directories to end with a separator, but pathlib removes them --
def dirToString(self):
    return str(self) + os.sep

Path.dirToString = dirToString
del(dirToString)
# ----

outputRoot = Path(os.getcwd()).joinpath("output/8/")
modRoot = Path(os.getcwd()).join("..")
mainAnimationStart = 1
mainAnimationStop = 64
floorDustAnimationStart = 48
floorDustAnimationStop = 111
worldBackgroundStrength = 3.000

resolutions = {
    "hr": 1080,
    #"lr": 540
}

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

def setCollectionRayVisibility(col: bpy.types.Collection, value=True):
    for objName in iterAllObjectNames(col):
        bpy.data.objects[objName].visible_camera = value

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

def opposite(direction: str) -> str:
    # Normally light always comes from the right and the lights are named after the camera direction, not the light direction.
    # This function returns the name of the light opposite of the given camera direction.
    if direction == "North":
        return "West"
    if direction == "South":
        return "East"
    if direction == "West":
        return "South"
    return "North"

def hideEverythingBut(objName = None, colName = None):
    hideCollection("Hopper Dust")
    hideCollection("Floor Dust")
    hideCollection("Main Render")
    hideCollection("Drop")
    hide(f"Shadow Catcher")

    if objName is not None:
        if type(objName) is list:
            for name in objName:
                hide(name, False)
        else:
            hide(objName, False)

    if colName is not None:
        if type(colName) is list:
            for name in colName:
                hideCollection(name, False)
        else:
            hideCollection(colName, False)
    

def renderReflections(scale=5):
    # Reflection is just a blurred shadow facing the camera. 
    # After the render the individual images get blurred, rescaled, made red and combined in a single image.
    
    setMainAnimationStartEndFrame()
    hideEverythingBut(objName="Shadow Catcher", colName="Main Render")

    mainCollection = bpy.data.collections["Main Render"]
    holdOutCollection(mainCollection, value=False, unhide=True)
    setCollectionRayVisibility(mainCollection, value=False)

    for direction in iterDirectionNames():
        setSceneDirection(direction, strenght=0)
        hide(f"Ground Shadow Light {opposite(direction)}", False)
        
        for name, res in resolutions.items():
            bpy.context.scene.render.resolution_x = res
            bpy.context.scene.render.resolution_y = res
            bpy.context.scene.render.filepath = str(outputRoot.joinpath(f"{name}/Reflections-{direction}"))
            bpy.ops.render.render(write_still=True)
        
        hide(f"Ground Shadow Light {opposite(direction)}", True)
    
    setCollectionRayVisibility(mainCollection, value=True)
    
    name = "hr"
    res = resolutions[name]

    min_left, min_upper, max_right, max_lower = res, res, 0, 0
    directions = ["North", "East", "South", "West"]
    ims = []
    for i, direction in enumerate(directions):
        im = Image.open(str(outputRoot.joinpath(f"{name}/Reflections-{direction}.png")))
        im = reflection.resize(reflection.toRedScale(reflection.blur(reflection.toGrayscale(im), radius=20)), scale=scale)
        #im.save(str(outputRoot.joinpath(f"{name}/Reflections-Blurred-{direction}")))
        ims.append(im)

        left, upper, right, lower = im.getbbox()

        if left < min_left:
            min_left = left
        if right > max_right:
            max_right = right
        if upper < min_upper:
            min_upper = upper
        if lower > max_lower:
            max_lower = lower
    
    mid = int((res / scale) // 2)
    dx = max(max_right - mid, mid - min_left)
    dy = max(max_lower - mid, mid - min_upper)
    width = dx * 2
    height = dy * 2

    combined_im = Image.new("RGBA", (width * 4, height))
    print(f"Individual resolution: ({width} x {height})")
    
    for i, (direction, im) in enumerate(zip(directions, ims)):
        min_im = im.crop((mid - dx, mid - dy, mid + dx, mid + dy))
        combined_im.paste(min_im, (i * width, 0))
    
    combined_im.save(str(modRoot.joinpath("graphics/reflections.png")))



def renderMachineStills():
    disableLights()

    hideEverythingBut(colName="Main Render")
    
    holdOutCollection(bpy.data.collections["Main Render"], value=False, unhide=True)
    hideCollection("Animated")
    
    for direction in iterDirectionNames():
        setSceneDirection(direction)
        bpy.context.scene.frame_set(1)
        
        for name, res in resolutions.items():
            bpy.context.scene.render.resolution_x = res
            bpy.context.scene.render.resolution_y = res
            bpy.context.scene.render.filepath = str(outputRoot.joinpath(f"{name}/Still-{direction}"))
            bpy.ops.render.render(write_still=True)
    
    
    for name, res in resolutions.items():
        min_left, min_upper, max_right, max_lower = res, res, 0, 0
        for i, direction in enumerate(["North", "East", "South", "West"]):
            im = Image.open(str(outputRoot.joinpath(f"{name}/Still-{direction}.png")))

            left, upper, right, lower = im.getbbox()
            if left < min_left:
                min_left = left
            if right > max_right:
                max_right = right
            if upper < min_upper:
                min_upper = upper
            if lower > max_lower:
                max_lower = lower
        
        mid = res // 2
        dx = max(max_right - mid, mid - min_left)
        dy = max(max_lower - mid, mid - min_upper)
        width = dx * 2
        height = dy * 2

        combined_im = Image.new("RGBA", (width * 4, height))
        
        for i, direction in enumerate(["North", "East", "South", "West"]):
            im = Image.open(str(outputRoot.joinpath(f"{name}/Still-{direction}.png")))
            min_im = im.crop((mid - dx, mid - dy, mid + dx, mid + dy))
            combined_im.paste(min_im, (i * width, 0))
        
        combined_im.save(str(modRoot.joinpath("graphics/stills/stills.png")))

    hideCollection("Animated", False)

def renderMachine():
    disableLights()

    hideEverythingBut(colName="Main Render")
    setMainAnimationStartEndFrame()

    holdOutCollection(bpy.data.collections["Main Render"], value=False, unhide=True)

    for direction in iterDirectionNames():
        
        setSceneDirection(direction)
        
        for name, res in resolutions.items():
            bpy.context.scene.render.resolution_x = res
            bpy.context.scene.render.resolution_y = res
            bpy.context.scene.render.filepath = outputRoot.joinpath(f"{name}/{direction}/Machine/").dirToString()
            bpy.ops.render.render(animation=True)


def renderHopperDust():
    disableLights()
    setMainAnimationStartEndFrame()
    
    hideEverythingBut(colName=["Hopper Dust", "Main Render", "Drop"])
    holdOutCollection(bpy.data.collections["Main Render"], value=True, unhide=True)
    
    for direction in iterDirectionNames():
        setSceneDirection(direction)
        
        for name, res in resolutions.items():
            bpy.context.scene.render.resolution_x = res
            bpy.context.scene.render.resolution_y = res
            bpy.context.scene.render.filepath = outputRoot.joinpath(f"{name}/{direction}/HopperDust/").dirToString()
            bpy.ops.render.render(animation=True)


def renderShadows():
    setMainAnimationStartEndFrame()
    hideEverythingBut(objName="Shadow Catcher", colName=["Main Render"])
    setCollectionRayVisibility(bpy.data.collections["Main Render"], False)
    
    bpy.context.scene.objects["Camera-East"].location.x *= -1

    for direction in iterDirectionNames():
        setSceneDirection(direction, strenght=0)
        hide(f"Ground Shadow Light {direction}", False)
        
        for name, res in resolutions.items():
            bpy.context.scene.render.resolution_x = res
            bpy.context.scene.render.resolution_y = res
            bpy.context.scene.render.filepath = outputRoot.joinpath(f"{name}/{direction}/Shadows/").dirToString()
            bpy.ops.render.render(animation=True)
        
        hide(f"Ground Shadow Light {direction}", True)

    bpy.context.scene.objects["Camera-East"].location.x *= -1
    setCollectionRayVisibility(bpy.data.collections["Main Render"], True)

def renderFloorDust():
    disableLights()
    hideEverythingBut(colName=["Floor Dust", "Main Render"])
    holdOutCollection(bpy.data.collections["Main Render"], value=True, unhide=True)

    for direction in iterDirectionNames():
        setSceneDirection(direction)
        for name, res in resolutions.items():
            bpy.context.scene.frame_start = floorDustAnimationStart
            bpy.context.scene.frame_end = floorDustAnimationStop
            bpy.context.scene.render.resolution_x = res
            bpy.context.scene.render.resolution_y = res
            bpy.context.scene.render.filepath = outputRoot.joinpath(f"{name}/{direction}/FloorDust/").dirToString()
            bpy.ops.render.render(animation=True)

            renderFloorDustAnimation(direction, name, res)


def renderFloorDustAnimation(direction, resName, res):
    bpy.context.scene.frame_start = mainAnimationStart
    bpy.context.scene.frame_end = mainAnimationStop
    sourcePath = outputRoot.joinpath(f"{resName}/{direction}/FloorDust/").dirToString()
    outputPath = outputRoot.joinpath(f"{resName}/{direction}/FloorDustCombined/").dirToString()

    if not bpy.context.scene.sequence_editor:
        bpy.context.scene.sequence_editor_create()

    bpy.context.scene.render.resolution_x = res
    bpy.context.scene.render.resolution_y = res

    first, *rest = sorted(os.listdir(sourcePath))
    image_path = sourcePath + '/' + first

    imstrip = bpy.context.scene.sequence_editor.sequences.new_image(
        name="animation",
        filepath=image_path,
        channel=1,
        frame_start=-16,
        fit_method='ORIGINAL'
    )

    for image in rest:
        imstrip.elements.append(image)
    for image in [first] + rest:
        imstrip.elements.append(image)
    

    bpy.context.scene.render.filepath = outputPath
    bpy.ops.render.render(animation=True)
    bpy.context.scene.sequence_editor_clear()

def renderDrop():
    hideEverythingBut(colName="Drop")
    holdOutCollection("Main Render", value=True, unhide=True)

    for direction in iterDirectionNames():
        setSceneDirection(direction)
        for name, res in resolutions.items():
            bpy.context.scene.render.resolution_x = res
            bpy.context.scene.render.resolution_y = res
            bpy.context.scene.render.filepath = outputRoot.joinpath(f"{name}/{direction}/Drop/").dirToString()
            bpy.ops.render.render(animation=True)


def main():
    renderMachine()
    renderHopperDust()
    renderFloorDust()
    renderShadows()
    renderReflections()
    #renderMachineStills()
    #renderDrop()


if __name__ == "__main__":
    main()