import os
import argparse
from pathlib import Path
from PIL import Image, ImageFilter
import numpy as np


# def iter_image(directory: Path):
#     dirs = os.listdir(directory)
#     if "hr" not in dirs:# or "lr" not in dirs:
#         raise Exception("hr and/or lr directory not found. Make sure to point the program to the Blender output directory")
    
#     for resolution in ["hr"]:
#         path = directory.joinpath(resolution)
#         directionDirs = ["north", "east", "south", "west"]
#         for d in directionDirs:
#             yield Image.open(path.joinpath(d).joinpath("Machine").joinpath("0001.png")), resolution, d

def iter_image(directory: Path):
    yield Image.open("C:/Users/Jurgen/AppData/Roaming/Factorio/mods/my_first_mod_0.0.2/graphics/stills/test2.png"), "hr", "all2"


def resize(im: Image, scale: int) -> Image:
    return im.resize((im.size[0] // scale, im.size[1] // scale))


def toGrayscale(im: Image) -> Image:
    return im.convert("LA")


def flip(im: Image) -> Image:
    return im.transpose(Image.FLIP_TOP_BOTTOM)


def blur(im: Image, radius: float) -> Image:
    radius = int(radius)
    width, height = im.size
    new_width = int(width + 2 * radius * 2)
    new_height = int(height + 2 * radius * 2)

    new_im = Image.new("LA", (new_width, new_height))
    new_im.paste(im, (radius * 2, radius * 2))
    # plt.imshow(np.array(im.filter(ImageFilter.GaussianBlur(radius=radius))))
    # plt.show()
    return new_im.filter(ImageFilter.GaussianBlur(radius=radius))


def toRedScale(im: Image) -> Image:
    arr = np.array(im, dtype=np.uint8)

    grayscale = arr[:, :, 0]
    alpha = arr[:, :, 1]

    grayscale[alpha > 0] = 255
    return Image.fromarray(
        np.dstack((
            grayscale,
            np.zeros(arr.shape[:2], dtype=np.uint8),
            np.zeros(arr.shape[:2], dtype=np.uint8),
            alpha)),
        mode="RGBA")


def minimize(im: Image) -> Image:
    orig_width, orig_height = im.size

    bbox = im.getbbox()
    left, upper, right, lower = bbox

    width = right - left
    height = lower - upper

    shift_x = (orig_width - left - right) / -2
    shift_y = (orig_height - upper - lower) / -2
    print(f"Shift: x: {shift_x}, y: {shift_y}")
    return im.crop((left, upper, right, lower))

def parse_arguments():
    parser = argparse.ArgumentParser(description="Sprite Packer")
    parser.add_argument("--dir", "-d", help="Root directory of the blender output. This should contain the /hr/ directory", required=True)
    parser.add_argument("--output", "-o", help="Root directory for the output. This should contain the /hr/ directory", required=True)
    parser.add_argument("--scale", "-s", help="Scale reduction factor. The size will be reduced by size/$s", type=int, default=1)
    parser.add_argument("--radius", "-r", help="Gaussian radius. This is applied after the rescaling", type=float, default=4)

    args = parser.parse_args()

    args.dir = Path(args.dir)
    args.output = Path(args.output)

    return args


def main():
    import matplotlib.pyplot as plt

    args = parse_arguments()
    print(args)
    for im, res, direction in iter_image(args.dir):
        print(im.size, res, direction)
        arr = toRedScale(minimize(blur(flip(resize(toGrayscale(im), args.scale)), args.radius)))

        plt.imshow(arr)
        plt.imsave(args.output.joinpath(f"reflection-{direction}.png"), arr)
        #plt.show()


if __name__ == "__main__":
    main()
