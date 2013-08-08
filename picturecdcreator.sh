#!/bin/sh
#
# Copyright (c) 2013 Pascal de Bruijn <pmjdebruijn@pcode.nl>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

OUTPUT_DIRECTORY=KODAKCD

mkdir -p ${OUTPUT_DIRECTORY}/PICTURES

TOTAL_FILE_SEQUENCE=0

DIRECTORY_SEQUENCE=0

for INPUT_DIRECTORY in $*; do

  FILE_SEQUENCE=0

  for INPUT_IMAGE_FILENAME in ${INPUT_DIRECTORY}/*.jpg; do

    OUTPUT_IMAGE_FILENAME=${OUTPUT_DIRECTORY}/PICTURES/$(printf '%03d' ${DIRECTORY_SEQUENCE})_$(printf '%04d' ${FILE_SEQUENCE}).JPG

    printf "processing ${INPUT_IMAGE_FILENAME} into ${OUTPUT_IMAGE_FILENAME} ...\n"

    convert ${INPUT_IMAGE_FILENAME} -colorspace RGB -filter Lanczos2 -resize 2048x2048 -colorspace sRGB \
                                    -unsharp 1x1+0.10 \
                                    -quality 95 -sampling-factor 2x2 -define jpeg:optimize-coding=false -auto-orient -strip \
                                    ${OUTPUT_IMAGE_FILENAME}

    FILE_SEQUENCE=$((${FILE_SEQUENCE} + 1))

    TOTAL_FILE_SEQUENCE=$((${TOTAL_FILE_SEQUENCE} + 1))

  done

  DIRECTORY_SEQUENCE=$((${DIRECTORY_SEQUENCE} + 1))

done

INFO_CD_IMAGES=$((${TOTAL_FILE_SEQUENCE} + 1))
INFO_CD_DATE=$(date "+%Y:%m:%d %H:%M:%S")

cat << EOF | todos > ${OUTPUT_DIRECTORY}/INFO.CD
Disc = KODAK PICTURE CD
NumberOfImagesSession2 = ${INFO_CD_IMAGES}
LabIdentifier = XXXX0
MachineId = 00000000
BatchId = 00000000
OrderId = 1
Date = ${INFO_CD_DATE}
AccessCode = NONE
IRetailer = NONE
IDealerId = NONE
EOF

cat << EOF | todos > ${OUTPUT_DIRECTORY}/CONTENT.DAT
Disc = KODAK PICTURE CD
CDVersion = 8.0
ContentVolume = 0
ContentIssue = 0
PCContentRelease = 00.00.01
Region = WW
Language = EN_US
EOF

cd ${OUTPUT_DIRECTORY}
md5sum PICTURES/* | tr 'A-Z' 'a-z' | todos > MD5SUMS.TXT
cd -

genisoimage -verbose \
            -iso-level 1 \
            -sysid "LINUX" \
            -V "KODAKCD" \
            -A "GENISOIMAGE - HAVE A NICE DAY" \
            -publisher "KODAK" \
            -p "KODAK_PICTURE_CD" \
            -output ${OUTPUT_DIRECTORY}.ISO ${OUTPUT_DIRECTORY}
