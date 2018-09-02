#!/bin/bash

#Names of the binaries needed: gnuboy-go.bin  nesemu-go.bin  smsplusgx-go.bin springboard.bin
#You have to change the GOPLAY_PATH to the path of your goplay code
#Also plug in your running Odroid to a USB port and make sure the serial connection is working.
#The odroid has to have flashed a version of go-play in order to extract springboard.bin from flash
#You also need the changed esp idf version from https://github.com/OtherCrashOverride/esp-idf installed to ~/esp
#The script will then compile everything and create a new image

export PATH="$PATH:$HOME/esp/xtensa-esp32-elf/bin"
export IDF_PATH=~/esp/esp-idf
GOPLAY_SOURCE_PATH=""
PATH_ORIG=`pwd`
SERIAL_PORT="/dev/ttyUSB0"
GO_PLAY_ORIG_FW_PATH="Go-Play.fw"
EFWT_PATH="../efwt" 
MKFW_PATH="."

echo "Compiling Gnuboy"
cd $GOPLAY_SOURCE_PATH/gnuboy-go
make all
echo ""
cp ./build/gnuboy-go.bin $PATH_ORIG

echo "Compiling Nesemu"
cd ../nesemu-go
make all
echo ""
cp ./build/nesemu-go.bin $PATH_ORIG

echo "Compiling Smsplusgx"
cd ../smsplusgx-go
make all
echo ""
cp ./build/smsplusgx-go.bin $PATH_ORIG

cd $PATH_ORIG

if [ ! -f springboard.bin ]; then
	echo "Reading springboard from flash"
	./esptool.py --port $SERIAL_PORT --baud 921600 read_flash 0x100000 0x100000 springboard.bin
fi

echo "Building mkfw"
cd $MKFW_PATH
make 

if [ ! -f tile.raw ]; then
	cd $EFWT_PATH
	make
	chmod +x efwt

	cd $PATH_ORIG

	echo "Extracting tile from original go-play.fw"
	$EFWT_PATH/efwt $GO_PLAY_ORIG_FW_PATH tile.raw
fi

cd $PATH_ORIG
$MKFW_PATH/mkfw Go-Play tile.raw 0 16 1048576 springboard springboard.bin 0 17 1048576 nesemu nesemu-go.bin 0 18 1048576 gnuboy gnuboy-go.bin 0 19 2097152 smsplusgx smsplusgx-go.bin
mv firmware.fw Go-Play-New.fw

#To convert the picture into a png run:
#ffmpeg -f rawvideo -pixel_format rgb565 -video_size 86x48 -i tile.raw output.png
#display output.png
