# Image Cropping Script

A simple bash script to automatically crop images based on their orientation (portrait or landscape).

## Requirements

-   [FFmpeg](https://ffmpeg.org/)

## Usage

The script processes all `.jpg`, `.jpeg`, and `.png` files in the current directory.

```bash
./crop_images.sh [options]
```

### Options

-   `-l, --landscape <WxH>`: Set dimensions for landscape images (default: 480x230).
-   `-p, --portrait <WxH>`: Set dimensions for portrait images (default: 480x600).
-   `-o, --output <dir>`: Set the output directory (default: `cropped_images`).

### Example

To crop landscape images to 800x600 and save them in a directory named `my_crops`:

```bash
./crop_images.sh -l 800x600 -o my_crops
```