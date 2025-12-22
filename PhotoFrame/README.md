# kindle-photo-frame

This project was made to add a revolving photo album to a kindle paperwhite 6th gen.

Outline of project:
1) Jailbreak the kindle (https://kindlemodding.org/jailbreaking/index.html)
2) Add [NetworkUSB](https://wiki.mobileread.com/wiki/USBNetwork) to allow SSHing into the kindle (Download NetworkUSB tar extension from here and add it to /mnt/us/extensions on the kindle: https://www.mobileread.com/forums/showthread.php?t=225030)
3) Preprocess photos with ImageMagick on mac
4) Display photos using FBInk
5) Run photo rotation script
6) Extension: Add google photo compatibility (Inspired by: https://github.com/mattzzw/kindle-gphotos)

## Commands for ImageMagick (Mac)
```
magick *.jpg -auto-orient -resize 758x1024^ -gravity center -extent 758x1024 -colorspace Gray -contrast-stretch 0.3%x0.3% -depth 8 -strip "kindle_$(date +%Y%m%d_%H%M%S)_%03d.png"
```

## Commands for FBInk
```
# Display image using FBInk
/mnt/us/bin/FBInk-v1.25.0-kindle/PW2/bin/fbink -c -f -W GC16 -D ORDERED -i /mnt/us/photos/[IMAGE_NAME]
```

# Shell commands for Kindle
```
# SSH into kindle
# 1) Ensure kindle NetworkUSB is toggled to active
# 2) Connect kindle via usb cable
# 3) Ensure laptop is on same subnet as kindle (192.168.15.xxx)
ssh root@192.168.15.244

# Transfer files to kindle
scp [FILENAME_TO_TRANSFER] root@192.168.15.244:/mnt/us/[FILEPATH]
```
