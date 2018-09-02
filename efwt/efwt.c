#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

extern unsigned long crc32(unsigned long crc, const unsigned char* buf, unsigned int len);

char* FIRMWARE = "firmware.fw";
char* HEADER = "ODROIDGO_FIRMWARE_V00_01";

#define FIRMWARE_DESCRIPTION_SIZE (40)
char FirmwareDescription[FIRMWARE_DESCRIPTION_SIZE];

// ffmpeg -i tile.png -f rawvideo -pix_fmt rgb565 tile.raw
uint8_t tile[86 * 48 * 2];


int main(int argc, char *argv[])
{
    if (argc < 3)
    {
        printf("usage: %s firmware_file  output_file\n", argv[0]);
    }
    else
    {
        FILE* file = fopen(argv[1], "rb");
        if (!file) abort();
	printf("Opened %s \n", argv[1]);

	FILE* output = fopen(argv[2], "wb");
        if (!output) abort();
	printf("Opened %s \n", argv[2]);

        size_t count;
	
	char READ_HEADER[sizeof(HEADER)];
	
        count = fread(READ_HEADER, 1, sizeof(READ_HEADER), file);

	if(!strncmp(HEADER,READ_HEADER,strlen(HEADER)))
	{
	    abort();
	}
	else
	{
	    printf("HEADERS match\n");
	    printf("HEADER='%s'\n", HEADER);
	}	

        count = fread(FirmwareDescription, FIRMWARE_DESCRIPTION_SIZE, 1, file);
        printf("FirmwareDescription='%s'\n", FirmwareDescription);

	fseek ( file , 16 , SEEK_CUR); //mkfw writes 16 bytes offset after the description, set file postion 16 byte forward
	
        count = fread(tile, 1, sizeof(tile), file);
        if (count != sizeof(tile))
        {
            printf("invalid tile \n");
            abort();
        }
	
	count = fwrite(tile, 1, sizeof(tile), output);
        printf("tile: wrote %d bytes.\n", (int)count);

    }
    return 0;
}
