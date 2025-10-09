#!/bin/bash

# Process all JPEGs for landscape cropping (480x230)
for img in *.jpg; do
  ffmpeg -i "$img" -vf "scale=480:-1, crop=480:230" "landscape_${img}"
done

# To crop a specific image to 480x600, you can add:
# ffmpeg -i "specific_image.jpg" -vf "crop=480:600:0:0" "cropped_480x600_specific_image.jpg"
