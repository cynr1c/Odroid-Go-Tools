# Make Goplay

Build a new go-play.fw from scratch.

## Prerequisites
* https://github.com/OtherCrashOverride/esp-idf
* https://docs.espressif.com/projects/esp-idf/en/latest/get-started/linux-setup.html
* An original go-play image, see https://github.com/OtherCrashOverride to extract the tile
* An odroid go flashed with a go-play image and connected to the computer to extract springboard.bin
* The source code of go-play see also https://github.com/OtherCrashOverride

## Installation
Make sure to change the paths in make_go_play.sh to your real paths
Connect your Odroid Go to your PC (for reading the flash)

## Usage
chmod +x make_go_play.sh
./make_go_play.sh

To convert the extracted tile to a png do:
ffmpeg -f rawvideo -pixel_format rgb565 -video_size 86x48 -i tile.raw output.png
