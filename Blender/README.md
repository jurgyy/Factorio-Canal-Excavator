# Render steps

Steps given for eastward direction but should be identical for all the others as well.

Sprite packing can be done as soon as the first animation sequence is rendered while rendering the next animation sequence.

## HDRI orientation

1. Go to Shading  
2. Change Shader Type to World  
3. Change the Mapping angle to:  
  * East: (-4d, 0d, 147d)
  * West: (0d, -3d, 321d)
    * hr
      * "-s", "0.5",
      * "-xo", "-59.5",
      * "-yo", "-56",
      * "-xs", "-2",
      * "-ys", "10.25",
    * lr
      * "-s", "1",
      * "-xo", "-59",
      * "-yo", "-56",
      * "-xs", "-2",
      * "-ys", "10",
  * South: (-6.7d, 16.9d, 33.6d)


### Machine

1. Disable all light  
2. Set World Strength to 3.000  
3. Disable Shadow Catcher  
4. Disable Floor Dust collection  
5. Disable Hopper Dust collection  
6. Set animation start and stop to 1 and 64  
7. Click on an object in the Main Render collection  
8. Right click Main Render collection > Select Objects  
9. Go to Object Properties and Alt + click on Holdout and disable it (if it was already disabled, click twice to ensure it is properly set to each object)  
10. Go to random frame and do a test render (F12)  
11. Go to Output and set both X and Y resolution to 1080.
12. Change the output path to (...)/hr/east/Machine/
13. Render animation.  
14. Set resolution to 540 and output path to (...)/lr/east/Machine/
15. Render animation.

## Hopper Dust

1. Click on an object in the Main Render collection  
2. Right click Main Render collection > Select Objects  
3. Go to Object Properties and Alt + click on Holdout and enable it  
4. Enable Hopper Dust collection
5. Change output path to (...)/lr/east/HopperDust/
6. Go to frame 30 and do a test render. Is the dust visible and everything else heldout?
7. Render animation.
8. Set resolution to 1080 and output path to (...)/hr/east/HopperDust/
9. Render animation.

## Shadows

1. Disable Hopper Dust collection  
2. Set World Strength to 0.000  
3. Enable Ground Shadow Light East  
4. Enable Shadow Catcher  
5. Do a test render. Do you see the shadows and is everything else heldout?  
6. Change output path to (...)/hr/east/Shadows/  
7. Render animation.  
8. Set resolution to 540 and output path to (...)/lr/east/Shadows/  
9. Render animation.

## Floor Dust

1. Disable Shadow Catcher  
2. Disable Ground Shadow Light East  
3. Set World Strength to 3.000
4. Enable Floor Dust collection
5. Set Start frame to 48 and end frame to 111
6. Go to frame 100 and do a test render. Is everything except for the dust heldout?
7. Change output path to (...)/hr/east/FloorDust/
8. Render animation.
9. Set resolution to 540 and output path to (...)/lr/east/FloorDust/  
10. Render animation.

## Floor Dust Part 2

1. Open dust-animation.blend  
2. Set Resolution to 1080  
3. Set cursor to frame 48  
4. Shift + A > Add Image Sequence > (...)/hr/east/FloorDust/ > Select All > Add  
5. Select the image sequence > Shift + D and set it before it starting at frame -16  
6. Add the HR Excavator image sequence and start it on frame 1.  
7. Do the two sequences align?  
8. Disable Excavator Channel(s)  
9. Set output to (...)/hr/east/FloorDustCombined/  
10. Render animation.  
11. Disable HR Dust Channel.  
12. Set Resolution to 540  
13. Shift + A > Add Image Sequence > (...)/lr/east/FloorDust/ > Select All > Add  
14. Select the image sequence > Shift + D and set it before it starting at frame -16  
15. Add the LR Excavator image sequence and start it on frame 1.  
16. Do the two sequences align?  
17. Disable Excavator Channel(s)  
18. Set output to (...)/lr/east/FloorDustCombined/  
19. Render animation.  

# Sprite Sheet Packing steps

## Machine

1. Set -d argument to "(...)/hr/east/Machine/"  
2. Set -o argument to "./graphics/sprites/hr/east/"  
3. Set -n argument to "machine"  
4. Set -s argument to "0.5"  
5. Comment out all other arguments
6. Run the script.
7. If you didn't change the size of the render result compared to the previous version, the animation should be working immediatly. If you did change the size, check in Factorio if the machine is still in the right place, if not, change the graphics_set.animation.east.layers[x].hr_version.shift values in prototypes\excavator-animations.lua until it's correct. Then change the -xo and -yo values in the launch.json accordingly and the -xs and -ys values with the given values by the packer's output: "shift = util.by_pixel($xs, $ys)".  
8. Set -d argument to "(...)/lr/east/Machine/"  
9. Set -o argument to "./graphics/sprites/lr/east/"  
10. Set -s argument to "1"  
11. Run the script.
12. Repeat step 7 for the low ress animation

## Hopper Dust

1. Set -d argument to "(...)/lr/east/HopperDust/"  
3. Set -n argument to "hopperDust"  
4. Uncomment all other arguments.  
5. Run the script.  
6. Set -d argument to "(...)/hr/east/HopperDust/"  
7. Set -s argument to "0.5"  
8. Set -o argument to "./graphics/sprites/hr/east/"  
9. Run the script.  

## Floor Dust

1. Set -d argument to "(...)/hr/east/FloorDustCombined/"  
3. Set -n argument to "floorDust"  
4. Uncomment all other arguments.  
5. Run the script.  
6. Set -d argument to "(...)/lr/east/HopperDust/"  
7. Set -s argument to "1"  
8. Set -o argument to "./graphics/sprites/lr/east/"  
9. Run the script.  