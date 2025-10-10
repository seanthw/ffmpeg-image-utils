#!/bin/bash

# Default values
QUALITY=80
OUTPUT_DIR="webp_images"
INPUT_FILE=""

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
        -f|--file)
            INPUT_FILE="$2"
            shift; shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-q quality] [-o output_dir] [-f file]"
            exit 1
            ;;
    esac
done

mkdir -p "$OUTPUT_DIR"

echo "Converting images to WebP with quality ${QUALITY}..."
echo "Output directory: ./${OUTPUT_DIR}/"

if [ -n "$INPUT_FILE" ]; then
    if [ -e "$INPUT_FILE" ]; then
        output_file="${INPUT_FILE%.*}.webp"
        echo "Converting: $INPUT_FILE -> ${OUTPUT_DIR}/${output_file}"
        ffmpeg -i "$INPUT_FILE" -q:v "$QUALITY" -loglevel error "${OUTPUT_DIR}/${output_file}"
    else
        echo "Error: File not found: $INPUT_FILE"
        exit 1
    fi
else
    for img in *.jpg *.jpeg *.png; do
        [ -e "$img" ] || continue
        
        output_file="${img%.*}.webp"
        
        echo "Converting: $img -> ${OUTPUT_DIR}/${output_file}"
        
        ffmpeg -i "$img" -q:v "$QUALITY" -loglevel error "${OUTPUT_DIR}/${output_file}"
    done
fi

echo "All images converted!"