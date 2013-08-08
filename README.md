picturecdcreator
================

This script uses common utilities found on Linux systems to approximate the 
creation of Kodak Picture CDs. Since I do not have official specifications
I can make no statement toward official compliance, the resulting ISO images
will likely not be perfectly compliant. The prime use-case would smooth 
and easy viewing on DVD/Bluray appliances.

Requirements:
 - bash (or dash)
 - genisoimage
 - graphicsmagick (not imagemagick because of -auto-orient)
 - md5sum

Usage:

$ bash picturecdcreator.sh dir-with-jpegs1 [dir-with-jpegs2] [...]

What happens:
 - Images are scaled to 2048px x 2048px maximum size 
     (for compatibility with old devices and faster from disc load times)
 - Images are converted to sRGB
 - Images will be auto-rotated
 - Images will have metadata stripped
     (to reduce risk of old devices tripping up on metadata)
 - Images are renamed to a sequential per directory scheme
 - MD5sums are calculated for the images 
     (so file integrity can be verified when 
      disc are suspected of degredation)
 - The ISO is generated

The script is very simple, and it's very easy to modify to your own liking.
