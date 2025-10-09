#!/bin/bash

# Default values
LANDSCAPE_DIMS="480x230"
PORTRAIT_DIMS="480x600"

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
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-l WxH] [-p WxH]"
            exit 1
            ;;
    esac
done

# Extract dimensions
LANDSCAPE_W=${LANDSCAPE_DIMS%x*}
LANDSCAPE_H=${LANDSCAPE_DIMS#*x}
PORTRAIT_W=${PORTRAIT_DIMS%x*}
PORTRAIT_H=${PORTRAIT_DIMS#*x}

echo "Landscape: ${LANDSCAPE_W}x${LANDSCAPE_H}"
echo "Portrait:  ${PORTRAIT_W}x${PORTRAIT_H}"

# Process images (same logic as above)
for img in *.jpg *.jpeg *.png; do
    [ -e "$img" ] || continue
    
    dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$img")
    width=$(echo "$dimensions" | cut -d',' -f1)
    height=$(echo "$dimensions" | cut -d',' -f2)
    
    if [ "$height" -gt "$width" ]; then
        ffmpeg -i "$img" -vf "scale=${PORTRAIT_W}:-1, crop=${PORTRAIT_W}:${PORTRAIT_H}" "cropped_${img%.*}.jpg"
    else
        ffmpeg -i "$img" -vf "scale=${LANDSCAPE_W}:-1, crop=${LANDSCAPE_W}:${LANDSCAPE_H}" "cropped_${img%.*}.jpg"
    fi
done
