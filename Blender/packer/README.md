# Spritepacker.py

A simple script to pack a directory of images into a single sprite sheet such that Factorio can use it.  
It also outputs the exact Lua code that you can copy-paste into the animation table.

## Arguments

| Argument    | Short | Required                                               | Description | Type   |
|-------------|-------|--------------------------------------------------------|-------------|--------|
| --dir       | -d    | The directory with the individual sprites to be packed | Yes         | String |
| --output    | -o    | The directory where to store the result                | Yes         | String |
| --extension | -e    | The extension of the input sprites, defaults to .png   | No          | String |
| --scale     | -s    | Scale as given by your animation.scale field           | No          | float  |

## Requirements

 * Python 3
 * Pillow 

I tested it on Python 3.11 and Pillow 9.4.0 but since the program is fairly simple I assume it works on earlier versions
of either of those but let me know if you encounter any limitations.

## Example

`` python spritepacker.py --dir ..\sprites\render\ --output ..\sprites\packed\ --scale 0.5 ``

Output:

```
Original size: 1024 x 1024
Content bbox: (98, 210) x ((874, 529))
Images can be reduced to 776 x 319
Pack will be 8 cols x 8 rows of images
So the pack will be 6208 x 2552
Writing to ..\sprites\packed\packing.png
Done
Factorio fields, copy-past this to your animation table:
	line_length = 8,
	width = 776,
	height = 319,
	frame_count = 64,
	-- Include shift if you want to keep centering of the original image:
	shift = util.by_pixel(-13.0, -71.25),
```
