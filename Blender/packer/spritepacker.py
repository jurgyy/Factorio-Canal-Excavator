import argparse
import os
from pathlib import Path
from PIL import Image

_upper_bound = 99999


def iter_image(files, directory: Path, extension: str, sort=False):
    for fname in sorted(files) if sort else files:
        if not fname.endswith(extension):
            continue
        fpath = os.path.join(directory, fname)

        yield Image.open(fpath)


def pack(directory: Path, output: Path, extension: str, scale=None, threshold=None):
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

        left, upper, right, lower = im.getbbox()
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

    print("\t-- Include shift if you want to keep centering of the original image:")
    if scale is not None:
        print(f"\tshift = util.by_pixel({shift_x * scale}, {shift_y * scale}),")
    else:
        print(f"\tshift = util.by_pixel({shift_x}, {shift_y}), -- Multiply these two values by your animation scale")

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

    args = parser.parse_args()

    args.dir = Path(args.dir)
    args.output = Path(args.output)

    return args


def main():
    args = parse_arguments()
    pack(args.dir, args.output, args.extension, args.scale, args.threshold)


if __name__ == "__main__":
    main()
