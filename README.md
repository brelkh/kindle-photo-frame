# kindle-photo-frame

This project was made to add a revolving photo album to a kindle paperwhite 6th gen.

Outline of project:
1) Jailbreak the kindle (https://kindlemodding.org/jailbreaking/index.html)
2) Add NetworkUSB to SSH into the kindle (Download NetworkUSB tar extension from here and add it to /mnt/us/extensions on the kindle: https://www.mobileread.com/forums/showthread.php?t=225030)
3) Preprocess photos with ImageMagick on mac
4) Display photos using FBInk
5) Add google photo compatibility

## Commands for ImageMagick
```
# For most photos (tuned to handle sharp contrast, highlights, and gradients in greyscale)
magick *.jpeg \                           
  -auto-orient \
  -resize 758x1024^ \
  -gravity center \
  -extent 758x1024 \
  -colorspace Gray \
  -contrast-stretch 1%x1% \
  -level 5%,95% \
  -ordered-dither o8x8,12 \
  -depth 8 \
  -strip \
  kindle_%03d.png

# For photos that are too bright and need more tuning to avoid losing facial features in greyscale
magick *.jpeg -auto-orient -resize 758x1024^ -gravity center -extent 758x1024 -colorspace Gray -contrast-stretch 0.2%x0.2% -level 2%,98% -gamma 0.95 -ordered-dither o8x8,16 -depth 8 -strip kindle_%03d.png
```

## Commands for FBInk
```
# Display image using FBInk
/mnt/us/bin/FBInk-v1.25.0-kindle/PW2/bin/fbink -c -f -W GC16 -
i /mnt/us/photos/[IMAGE_NAME]
```
