# Make Goplay

Build a new go-play.fw from scratch.

## Prerequisites
* https://github.com/OtherCrashOverride/esp-idf
* https://docs.espressif.com/projects/esp-idf/en/latest/get-started/linux-setup.html
* An original go-play image, see https://github.com/OtherCrashOverride/go-play/releases to extract the tile
* An odroid go flashed with a go-play image and connected to the computer to extract springboard.bin
* The source code of go-play see also https://github.com/OtherCrashOverride/go-play

## Installation
Make sure to change the paths in make_go_play.sh to your real paths.
Connect your Odroid Go to your PC (for reading the flash).

* Paths:
* export PATH="$PATH:$HOME/esp/xtensa-esp32-elf/bin"   Path of the ESP bins
* export IDF_PATH=~/esp/esp-idf       Path of the esp-idf
* GOPLAY_SOURCE_PATH=""               Path of the Go-play source code
* PATH_ORIG=`pwd`                     Path where the script is located
* SERIAL_PORT="/dev/ttyUSB0"          Which serial device to use
* GO_PLAY_ORIG_FW_PATH="Go-Play.fw"   Path of the original Go-Play Firmware file
* EFWT_PATH="../efwt"                 Path of efwt
* MKFW_PATH="."                       Path of mkfw

## Usage
chmod +x make_go_play.sh
./make_go_play.sh

To convert the extracted tile to a png do:
ffmpeg -f rawvideo -pixel_format rgb565 -video_size 86x48 -i tile.raw output.png
