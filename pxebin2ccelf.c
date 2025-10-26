#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

uint8_t pxeBuffer[128 * 1024];
uint8_t preBuffer[256 * 1024];
uint8_t postBuffer[256 * 1024];

const uint8_t CartGuid[16] = {0xCC, 0xA9, 0xF7, 0x4A, 0x19, 0x50, 0x45, 0x36, 0x93, 0x97, 0xE1, 0xDF, 0x0F, 0x8D, 0x31, 0x05};

bool parseGuid(const char *guidStr, uint8_t guid[16]);
int findBytes(size_t bufferLength, const uint8_t *buffer, size_t patternLength, const uint8_t *pattern);
void printGuid(const uint8_t guid[16]);

int main(int argc, char **argv)
{

    if (argc < 6)
    {
        printf("Usage: %s <pxe.bin path> <PXE_CC_pre.arm path> <PXE_CC_post.arm path> <Vendor UUID> <Game UUID>\n", argv[0]);
        printf("Vendor UUID should be unique to each game creator.\n");
        printf("Game UUID should be generated every time this is run.\n");
        return EXIT_FAILURE;
    }

    FILE *fpPxeBin = fopen(argv[1], "rb");
    if (fpPxeBin == NULL)
    {
        fprintf(stderr, "Error: Unable to open file. Path: %s\n", argv[1]);
        return EXIT_FAILURE;
    }
    int pxeBinSize = fread(pxeBuffer, sizeof(pxeBuffer[0]), sizeof(pxeBuffer), fpPxeBin);
    fclose(fpPxeBin);

    int payloadIndex = findBytes(pxeBinSize, pxeBuffer, 7, (const uint8_t *)"PXE-ROM");

    if (payloadIndex < 0 || payloadIndex + 64 * 1024 >= pxeBinSize)
    {
        printf("pxebin2ccelf skipped. %s is not a PXE file.\n", argv[1]);
        return 0;
    }
    printf("%s is a PXE file.\n", argv[1]);
    
    uint8_t vendorGuid[16];
    if (!parseGuid(argv[4], vendorGuid))
    {
        printf("Invalid Vender GUID: %s\n", argv[4]);
        return EXIT_FAILURE;
    }
    uint8_t gameGuid[16];
    if (!parseGuid(argv[5], gameGuid))
    {
        printf("Invalid Game GUID: %s\n", argv[5]);
        return EXIT_FAILURE;
    }
    printf("Vendor Guid: ");
    printGuid(vendorGuid);
    printf("\nGame Guid: ");
    printGuid(gameGuid);
    printf("\n");


    FILE *fpPre = fopen(argv[2], "rb");
    if (fpPre == NULL)
    {
        fprintf(stderr, "Error: Unable to open pre file. ErrorCode: %d Path: %s\n", errno, argv[2]);
        return EXIT_FAILURE;
    }

    int preSize = fread(preBuffer, sizeof(preBuffer[0]), sizeof(preBuffer), fpPre);
    int cartGuidIndex = findBytes(preSize, preBuffer, 16, CartGuid);
    if (cartGuidIndex < 0)
    {
        fclose(fpPre);
        fprintf(stderr, "Error: Unable to locate Cart UUID in %s\n", argv[2]);
        return EXIT_FAILURE;
    }
    printf("Cart Guid found at: %d\n", cartGuidIndex);

    FILE *fpPost = fopen(argv[3], "rb");
    if (fpPost == NULL)
    {
        fclose(fpPre);
        fprintf(stderr, "Error: Unable to open file. Path: %s\n", argv[3]);
        return EXIT_FAILURE;
    }
    
    int postSize = fread(postBuffer, sizeof(postBuffer[0]), sizeof(postBuffer), fpPost);
    
    char elfFileName[512] = {0};
    int binNameLength = strlen(argv[1]);
    sprintf(elfFileName, "%s", argv[1]);
    sprintf(&elfFileName[binNameLength - 4], "-cc.elf");
    printf("Generating Chameleon Cart image: %s", elfFileName);

    FILE *fpElf = fopen(elfFileName, "wb");
    if (fpPost == NULL)
    {
        fclose(fpPost);
        fclose(fpPre);
        fprintf(stderr, "Error: Unable to create file. Path: %s\n", elfFileName);
        return EXIT_FAILURE;
    }
    fwrite(preBuffer, 1, cartGuidIndex + 16, fpElf);
    fwrite(vendorGuid, 1, 16, fpElf);
    fwrite(gameGuid, 1, 16, fpElf);
    fwrite(&preBuffer[cartGuidIndex + 48], 1, preSize - (cartGuidIndex + 48), fpElf);
    fwrite(&pxeBuffer[payloadIndex], 1, 64 * 1024, fpElf);
    fwrite(postBuffer, 1, postSize, fpElf);

    fclose(fpElf);

    fclose(fpPost);
    fclose(fpPre);
    return 0;
}

bool parseGuid(const char *guidStr, uint8_t guid[16])
{
    for (int i = 0; i < 32; i++)
    {
        while (*guidStr == '-')
        {
            guidStr++;
        }
        if (guidStr == 0)
        {
            return false;
        }
        uint8_t value = 0;
        if ('0' <= *guidStr && *guidStr <= '9')
        {
            value = *guidStr - '0';
        }
        else if ('a' <= *guidStr && *guidStr <= 'f')
        {
            value = *guidStr - 'a' + 10;
        }
        else if ('A' <= *guidStr && *guidStr <= 'F')
        {
            value = *guidStr - 'A' + 10;
        }
        else
        {
            return false;
        }

        if (i & 1)
        {
            guid[i >> 1] |= value;
        }
        else
        {
            guid[i >> 1] = value << 4;
        }

        guidStr++;
    }
    return true;
}

int findBytes(size_t bufferLength, const uint8_t *buffer, size_t patternLength, const uint8_t *pattern)
{
    for (int i = 0; i < bufferLength - patternLength; i++)
    {
        int j = 0;
        for (; j < patternLength; j++)
        {
            if (buffer[i + j] != pattern[j])
            {
                break;
            }
        }
        if (j == patternLength)
        {
            return i;
        }
    }
    return -1;
}

void printGuid(const uint8_t guid[16])
{
    for (int i = 0; i < 16; i++)
    {
        if (i == 4 || i == 6 || i == 8 || i == 10)
        {
            printf("-");
        }
        printf("%02x", guid[i]);
    }
}