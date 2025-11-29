#!/bin/bash

# Default values
LANDSCAPE_DIMS="480x230"
PORTRAIT_DIMS="480x600"
CIRCLE_SIZE="400"
OUTPUT_DIR="cropped_images"
INPUT_FILES=()
INPUT_DIR="."
MODE="rect" # Default mode is rectangular crop

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -l|--landscape)
            LANDSCAPE_DIMS="$2"
            shift; shift
            ;;
        -p|--portrait)
            PORTRAIT_DIMS="$2"
            shift; shift
            ;;
        -c|--circle)
            MODE="circle"
            shift
            ;;
        -cs|--circle-size)
            CIRCLE_SIZE="$2"
            shift; shift
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift; shift
            ;;
        -f|--file)
            shift
            while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                INPUT_FILES+=("$1")
                shift
            done
            ;;
        -d|--directory)
            INPUT_DIR="$2"
            shift; shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-l WxH] [-p WxH] [-c] [-cs SIZE] [-o output_dir] [-f file1 file2 ...] [-d directory]"
            exit 1
            ;;
    esac
done

# Extract dimensions for rect mode
LANDSCAPE_W=${LANDSCAPE_DIMS%x*}
LANDSCAPE_H=${LANDSCAPE_DIMS#*x}
PORTRAIT_W=${PORTRAIT_DIMS%x*}
PORTRAIT_H=${PORTRAIT_DIMS#*x}

mkdir -p "$OUTPUT_DIR"

echo "Processing images..."
if [ "$MODE" == "circle" ]; then
    echo "  Mode:      Circle (${CIRCLE_SIZE}px)"
else
    echo "  Mode:      Rectangular"
    echo "  Landscape: ${LANDSCAPE_W}x${LANDSCAPE_H}"
    echo "  Portrait:  ${PORTRAIT_W}x${PORTRAIT_H}"
fi
echo "  Output:    ./$OUTPUT_DIR/"

process_image() {
    img=$1
    # Check if file exists to avoid ffmpeg errors on empty glob expansion
    if [ ! -f "$img" ]; then
        return
    fi

    # Get dimensions
    dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$img")
    width=$(echo "$dimensions" | cut -d',' -f1)
    height=$(echo "$dimensions" | cut -d',' -f2)

    echo "Processing: $img (${width}x${height})"

    if [ "$MODE" == "circle" ]; then
        # Circle Mode
        # 1. scale=...:force_original_aspect_ratio=increase: Ensures the image covers the square area completely
        # 2. crop=...: Centers the crop to a square
        # 3. format=rgba: Adds an alpha channel
        # 4. geq=...: Applies the circular math to the alpha channel (a)

        # Determine output filename (force .png for transparency)
        filename=$(basename "$img")
        filename="${filename%.*}"
        out_file="$OUTPUT_DIR/${filename}_circle.png"

        # Define the complex filter string in a variable to avoid quoting issues
        FILTER="scale=${CIRCLE_SIZE}:${CIRCLE_SIZE}:force_original_aspect_ratio=increase,crop=${CIRCLE_SIZE}:${CIRCLE_SIZE},format=rgba,geq=r='r(X,Y)':g='g(X,Y)':b='b(X,Y)':a='if(lte(pow(X-W/2,2)+pow(Y-H/2,2),pow(min(W,H)/2,2)),255,0)'"

        ffmpeg -i "$img" -vf "$FILTER" -y -loglevel error "$out_file"

        echo "  Saved circular crop: $out_file"

    else
        # Rectangular Mode (Original Logic)
        out_file="$OUTPUT_DIR/cropped_${img##*/}"

        if [ "$height" -gt "$width" ]; then
            ffmpeg -i "$img" -vf "scale=${PORTRAIT_W}:${PORTRAIT_H}:force_original_aspect_ratio=increase,crop=${PORTRAIT_W}:${PORTRAIT_H}" -y -loglevel error "$out_file"
            echo "  Cropped to portrait: ${PORTRAIT_W}x${PORTRAIT_H}"
        else
            ffmpeg -i "$img" -vf "scale=${LANDSCAPE_W}:${LANDSCAPE_H}:force_original_aspect_ratio=increase,crop=${LANDSCAPE_W}:${LANDSCAPE_H}" -y -loglevel error "$out_file"
            echo "  Cropped to landscape: ${LANDSCAPE_W}x${LANDSCAPE_H}"
        fi
    fi
    echo
}

if [ ${#INPUT_FILES[@]} -gt 0 ]; then
    for img in "${INPUT_FILES[@]}"; do
        if [ -e "$img" ]; then
            process_image "$img"
        else
            echo "Error: File not found: $img"
        fi
    done
else
    # Process common image formats
    # Use nullglob to handle case where no files match patterns
    shopt -s nullglob
    files=("${INPUT_DIR}"/*.jpg "${INPUT_DIR}"/*.jpeg "${INPUT_DIR}"/*.png "${INPUT_DIR}"/*.webp)
    shopt -u nullglob
    
    if [ ${#files[@]} -eq 0 ]; then
        echo "No images found in ${INPUT_DIR}"
    else
        for img in "${files[@]}"; do
            process_image "$img"
        done
    fi
fi
echo "Done!"