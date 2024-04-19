import argparse
import os
from pathlib import Path
from PIL import Image


class AnchorShift:
    def __init__(self, anchorXOffset, anchorYOffset, anchorXShift, anchorYShift):
        if anchorXOffset is None \
        or anchorYOffset is None \
        or anchorXShift is None \
        or anchorYShift is None:
            raise Exception("All offset and shift arguments have to have a value")
        
        self.AnchorXOffset = anchorXOffset
        self.AnchorYOffset = anchorYOffset
        self.AnchorXShift = anchorXShift
        self.AnchorYShift = anchorYShift

    def CalcAnchorOffset(self, scale, xOffset, yOffset):
        def calc(anchor, given, newGiven):
            return newGiven * scale + anchor - given
        
        if scale is None:
            scale = 1

        return calc(self.AnchorXOffset, self.AnchorXShift, xOffset), \
               calc(self.AnchorYOffset, self.AnchorYShift, yOffset)


_upper_bound = 99999


def offset(scale, fixedOffset, givenOffset, secondGivenOffset):
  scaleOffset = givenOffset * scale
  totalOffset = fixedOffset - scaleOffset
  return secondGivenOffset * scale + totalOffset


def pack(directory: Path, output: Path, extension: str, scale=None, threshold: float = None,
         anchorShift: AnchorShift = None):
    print(directory)
    print(output)

    files = os.listdir(directory)
    n = len(files)
    if n > 64:
        raise Exception("Can't pack more than 64 files")

    min_left, max_right = _upper_bound, 0
    min_upper, max_lower = _upper_bound, 0
    orig_size = None
    for im in iter_image(files, directory, extension):
        if threshold is not None:
            # Set pixels over the alpha threshold to 0
            pixels = im.load()
            for i in range(im.size[0]):
                for j in range(im.size[1]):
                    r, g, b, a = pixels[i, j]
                    if a < threshold:
                        im.putpixel((i, j), (r, g, b, 0))

        bbox = im.getbbox()
        if bbox is None:
            continue
        left, upper, right, lower = bbox
        if orig_size is None:
            orig_size = im.size
        elif im.size != orig_size:
            raise Exception("All images should be the same size")

        if left < min_left:
            min_left = left
        if right > max_right:
            max_right = right
        if upper < min_upper:
            min_upper = upper
        if lower > max_lower:
            max_lower = lower

    orig_width, orig_height = orig_size
    print(f"Original size: {orig_width} x {orig_height}")
    print(f"Content bbox: ({min_left}, {min_upper}) x ({max_right}, {max_lower})")

    single_width = max_right - min_left
    single_height = max_lower - min_upper

    print(f"Images can be reduced to {single_width} x {single_height}")

    div = n // 8
    rem = n % 8

    cols = 8 if n > 8 else n
    rows = div
    if rem > 0:
        rows += 1

    print(f"Pack will be {cols} cols x {rows} rows of images")

    pack_width = cols * single_width
    pack_height = rows * single_height

    print(f"So the pack will be {pack_width} x {pack_height}")

    packing = Image.new("RGBA", (pack_width, pack_height))

    for i, im in enumerate(iter_image(files, directory, extension, sort=True)):
        col_pos = i % 8
        row_pos = i // 8
        packing.paste(im.crop((min_left, min_upper, max_right, max_lower)), (col_pos * single_width, row_pos * single_height))

    output_fpath = output.joinpath("packing.png")

    print(f"Writing to {output_fpath}")
    packing.save(output_fpath)

    print("Done")
    print("Factorio fields, copy-past this to your animation table:")
    print(f"\tline_length = {cols},")
    print(f"\twidth = {single_width},")
    print(f"\theight = {single_height},")

    shift_x = (orig_width - min_left - max_right) / -2
    shift_y = (orig_height - min_upper - max_lower) / -2

    if anchorShift is not None:
        print(f"\t-- Shift before offset: {shift_x}, {shift_y}")
        shift_x, shift_y = anchorShift.CalcAnchorOffset(scale, shift_x, shift_y)
    elif scale is not None:
        shift_x = shift_x * scale
        shift_y = shift_y * scale
    else:
        print("\t-- Multiply these two values by your animation scale:")
    print("\t-- Include shift if you want to keep centering of the original image:")
    print(f"\tshift = util.by_pixel({shift_x}, {shift_y}), ")

    print(f"\tframe_count = {n}, -- Depends on your frame_sequence")


def parse_arguments():
    parser = argparse.ArgumentParser(description="Sprite Packer")
    parser.add_argument("--dir", "-d", help="The directory with the individual sprites to be packed", required=True)
    parser.add_argument("--output", "-o", help="The directory where to store the result", required=True)
    parser.add_argument("--extension", "-e", help="The extension of the input sprites, defaults to .png", default=".png")
    parser.add_argument("--scale", "-s", help="Scale as given by your animation.scale field", type=float)
    parser.add_argument("--threshold", "-t", help="Alpha channel threshold $alpha < $t is seen as 0 for the bounding "
                                                  "box calculations such that you can remove nearly transparent "
                                                  "pixels. This will significantly slow down the execution", type=int)
    parser.add_argument("--xoffset", "-xo", help="X-offset for a given anchor. This is the shift used in the mod "
                                                 "code for the anchor.", type=float)
    parser.add_argument("--yoffset", "-yo", help="Y-offset for a given anchor. This is the shift used in the mod "
                                                 "code for the anchor.", type=float)
    parser.add_argument("--xshift", "-xs", help="X-shift as determined by this program for the anchor object", type=float)
    parser.add_argument("--yshift", "-ys", help="Y-shift as determined by this program for the anchor object", type=float)

    args = parser.parse_args()

    args.dir = Path(args.dir)
    args.output = Path(args.output)

    return args


def main():
    args = parse_arguments()
    print(args)

    anchorShift = None
    if any([args.xoffset, args.yoffset, args.xshift, args.yshift]):
        anchorShift = AnchorShift(args.xoffset, args.yoffset, args.xshift, args.yshift)

    pack(args.dir, args.output, args.extension, args.scale, args.threshold, anchorShift)


if __name__ == "__main__":
    main()
