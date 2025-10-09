#!/bin/bash

for img in *.jpg; do
    # Get image dimensions using ffprobe
    dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$img")
    width=$(echo "$dimensions" | cut -d',' -f1)
    height=$(echo "$dimensions" | cut -d',' -f2)
    
    echo "Processing: $img (${width}x${height})"
    
    # Determine orientation and apply appropriate crop
    if [ "$height" -gt "$width" ]; then
        # Portrait orientation - crop to 480x600
        echo "  Detected portrait orientation, cropping to 480x600"
        ffmpeg -i "$img" -vf "scale=480:-1, crop=480:600" "cropped_${img}"
    else
        # Landscape or square orientation - crop to 480x230
        echo "  Detected landscape orientation, cropping to 480x230"
        ffmpeg -i "$img" -vf "scale=480:-1, crop=480:230" "cropped_${img}"
    fi
done

echo "All images processed!"
