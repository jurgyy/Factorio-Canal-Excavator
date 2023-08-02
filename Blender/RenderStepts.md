# Render steps

## East

### Objects

1. Disable all lights
2. Set World Surface Strength to 1.000

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

#### Gearbox far top

#### Gearbox near

#### Screw Far

#### Trough

#### Dust

## Shadows

1. Enable light environment.sun
2. Set World Surface Strength to 0.000