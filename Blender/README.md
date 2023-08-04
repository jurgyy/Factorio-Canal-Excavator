# Render steps

## East

### Objects

1. Disable all lights
2. Set World Surface Strength to 1.000
3. Ensure animation start is 1 and end is 64

#### Gantry

1. Change Scene > Output > path to [..]\east\gantry\
2. Disable Render for:
  a. Gearbox collection
  b. Through
  c. DustDomain
  d. (Optionally) Disable DustDomain > physics > Fluid viewport for more performance
3. Enable masks (disable others):
  a. ScrewNearMaskEastLeft
  b. ScrewNearMaskEastRight
4. Ensure gantry is at start position:
  a. Enable animation on Controller-Gear
  b. Go to first frame
  c. Disable animation on Controller-Gear
5. Enable animation on Controller-Belt
6. Render animation

#### Gearbox far bot

 1. Change Scene > Output > path to [..]\east\gearbox-far-bot\
 2. Disable Center collection
 3. Enable Gearbox collection
 4. Enable Controller-Gear animation
 5. Enable GearMaskLeft, disable the rest
 6. Render animation

#### Gearbox far top

 1. Change Scene > Output > path to [..]\east\gearbox-far-top\
 2. Enable GearsTopMask
 3. Enable GearboxPlugMask
 4. Disable other masks
 5. Render animation

#### Gearbox near

 1. Change Scene > Output > path to [..]\east\gearbox-near\
 2. Enable GearMaskRight
 3. Disable other masks
 4. Render animation

#### Screw Far
 1. Change Scene > Output > path to [..]\east\screw-far\
 2. Disable Gearbox Coollection
 3. Enable Center collection
 4. Disable Gantry collection
 5. Enable ScrewNearMaskEastRight
 6. Enable ScrewNearMaskEastRight Transformation constraint
 7. Set animation end frame to 10
 8. Render animation
 9. Set animation and frame to 64

#### Trough

 1. Change Scene > Output > path to [..]\east\through\
 2. Disable ScrewNearMaskEastRight Transformation constraint
 3. Enable Gantry collection
 4. Disable ScrewBack and ScrewFront
 4. Select all objects from Gantry collection
 5. Go to Object Properties > Visibility > Ray Visibility > hold alt and uncheck Camera
 6. Select GantryPlaceHolder
 7. Go to Constraints > Move with screw > Y Source Axis > Max > multiply by 4.25
 8. Disable all masks
 9. Enable Trough
 10. Render animation
 11. Go to Constraints > Move with screw > Y Source Axis > Max > divide by 4.25
 12. Select all objects from Gantry collection
 13. Go to Object Properties > Visibility > Ray Visibility > hold alt and check Camera (if already checked, double click the box)
 

#### Dust

 1. Change Scene > Output > path to [..]\east\dust\
 2. Enable all objects in Center collection
 3. Select all objects from Center collection
 4. Go to Object Properties > Visibility > hold alt and check Holdout
 5. Hide Trough
 6. Enable DustDomain
 7. Select DustDomain and enable Physics > Fluid in viewport
 8. Go to frame 1
 9. Disable ControllerGear animation. If already disabled, enable it, then disable it.
 10. Set animation End to 192
 11. Prerender animation
 12. Render animation
 
 Open dust-animation.blend
 1. Add > Image Sequence > Select all 192 frames
 2. Move sequence to frame 1
 3. Duplicate to frame -63
 4. Select duplicate and Add > Effect Strip > Transform
 5. Select the Transform and modify Position X to 0.14
 6. Uncheck channel with the duplicate
 7. Duplicate one more time to frame -126
 8. Change Scene > Output > path to [..]\east\dust-combined\
 9. Render animation


## Shadows

1. Enable light environment.sun
2. Set World Surface Strength to 0.000