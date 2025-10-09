#!/bin/bash

# Crop images to 480x230
for img in *.jpg; do
    ffmpeg -i "$img" -vf "crop=480:230:0:0" "cropped_480x230_$img"
done

# To crop a specific image to 480x600, you can add:
# ffmpeg -i "specific_image.jpg" -vf "crop=480:600:0:0" "cropped_480x600_specific_image.jpg"
