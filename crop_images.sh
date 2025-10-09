#!/bin/bash

# Default values
LANDSCAPE_DIMS="480x230"
PORTRAIT_DIMS="480x600"
OUTPUT_DIR="cropped_images"

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
        -o|--output)
            OUTPUT_DIR="$2"
            shift; shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-l WxH] [-p WxH] [-o output_dir]"
            exit 1
            ;;
    esac
done

# Extract dimensions
LANDSCAPE_W=${LANDSCAPE_DIMS%x*}
LANDSCAPE_H=${LANDSCAPE_DIMS#*x}
PORTRAIT_W=${PORTRAIT_DIMS%x*}
PORTRAIT_H=${PORTRAIT_DIMS#*x}

mkdir -p "$OUTPUT_DIR"

echo "Processing images..."
echo "  Landscape: ${LANDSCAPE_W}x${LANDSCAPE_H}"
echo "  Portrait:  ${PORTRAIT_W}x${PORTRAIT_H}"
echo "  Output:    ./$OUTPUT_DIR/"

for img in *.jpg *.jpeg *.png; do
    [ -e "$img" ] || continue
    
    dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$img")
    width=$(echo "$dimensions" | cut -d',' -f1)
    height=$(echo "$dimensions" | cut -d',' -f2)
    
    echo "Processing: $img (${width}x${height})"
    
    if [ "$height" -gt "$width" ]; then
        ffmpeg -i "$img" -vf "scale=${PORTRAIT_W}:-1, crop=${PORTRAIT_W}:${PORTRAIT_H}" -loglevel error "$OUTPUT_DIR/cropped_${img%.*}.jpg"
        echo "  Cropped to portrait: ${PORTRAIT_W}x${PORTRAIT_H}"
    else
        ffmpeg -i "$img" -vf "scale=${LANDSCAPE_W}:-1, crop=${LANDSCAPE_W}:${LANDSCAPE_H}" -loglevel error "$OUTPUT_DIR/cropped_${img%.*}.jpg"
        echo "  Cropped to landscape: ${LANDSCAPE_W}x${LANDSCAPE_H}"
    fi
    echo "Done: $img"
    echo
done

echo "All images saved to: ./$OUTPUT_DIR/"
