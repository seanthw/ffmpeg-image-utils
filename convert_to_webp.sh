#!/bin/bash

# Default values
QUALITY=80
OUTPUT_DIR="webp_images"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -q|--quality)
            QUALITY="$2"
            shift; shift
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift; shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-q quality] [-o output_dir]"
            exit 1
            ;;
    esac
done

mkdir -p "$OUTPUT_DIR"

echo "Converting images to WebP with quality ${QUALITY}..."
echo "Output directory: ./${OUTPUT_DIR}/"

for img in *.jpg *.jpeg *.png; do
    [ -e "$img" ] || continue
    
    output_file="${img%.*}.webp"
    
    echo "Converting: $img -> ${OUTPUT_DIR}/${output_file}"
    
    ffmpeg -i "$img" -q:v "$QUALITY" -loglevel error "${OUTPUT_DIR}/${output_file}"
done

echo "All images converted!"