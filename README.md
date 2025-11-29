# ffmpeg-image-utils

A collection of simple bash scripts for image processing.

## Requirements

-   [FFmpeg](https://ffmpeg.org/)

---

## Image Cropping Script (`crop_images.sh`)

Automatically crops images based on their orientation (portrait or landscape).

### Usage

```bash
./crop_images.sh [options]
```

### Options

-   `-l, --landscape <WxH>`: Set dimensions for landscape images (default: 480x230).
-   `-p, --portrait <WxH>`: Set dimensions for portrait images (default: 480x600).
-   `-o, --output <dir>`: Set the output directory (default: `cropped_images`).
-   `-f, --file <file>`: Process a single file instead of all images in the directory.
-   `-d, --directory <dir>`: Process all images in the specified directory.
-   `-c, --circle`: Crop images into a circular shape. Output will always be PNG.
-   `-cs, --circle-size <SIZE>`: Set the diameter for circular crops (default: 400).

### Example

```bash
./crop_images.sh -l 800x600 -o my_crops
```

To process a single file:
```bash
./crop_images.sh -f my_image.jpg -o my_crops
```

To process all images in a specific directory:
```bash
./crop_images.sh -d /path/to/images -o my_crops
```

To crop images into a circle:
```bash
./crop_images.sh -f my_image.jpg -c -cs 200
```


---

## WebP Conversion Script (`convert_to_webp.sh`)

Converts `.jpg`, `.jpeg`, and `.png` images to `.webp` format.

### Usage

```bash
./convert_to_webp.sh [options]
```

### Options

-   `-q, --quality <0-100>`: Set the WebP quality (default: 80).
-   `-o, --output <dir>`: Set the output directory (default: `webp_images`).
-   `-f, --file <file>`: Process a single file instead of all images in the directory.
-   `-d, --directory <dir>`: Process all images in the specified directory.

### Example

To convert images with a quality of 90 and save them in a `converted` directory:

```bash
./convert_to_webp.sh -q 90 -o converted
```

To convert all images in a specific directory:
```bash
./convert_to_webp.sh -d /path/to/images -q 90 -o converted
```
