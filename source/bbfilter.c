// Provided under the GPL v2 license. See the included LICENSE.txt for details.

/*
     bbfilter
     reads from stdin, filters out a bunch of bB symbol names, and writes 
     to stdout.
*/

#define BUFSIZE 1000

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Our term list. If the term starts with ^ it will only be matched at the
// start of a line...

char *filterterm[] = {
    "^pfcenter ",
    "^shakescreen ",
    "^rand16 ",
    "^debugscore ",
    "^pfscore ",
    "^noscore ",
    "^vblank_bB_code ",
    "^PFcolorandheight ",
    "^pfrowheight ",
    "^PFmaskvalue ",
    "^overscan_time ",
    "^vblank_time ",
    "^no_blank_lines ",
    "^DPC_kernel_options ",
    "^superchip ",
    "^ROM2k ",
    "^NO_ILLEGAL_OPCODES ",
    "^bankswitch_hotspot ",
    "^kernelmacrodef ",
    "^minikernel ",
    "^vertical_reflect ",
    "^pfhalfwidth ",
    "^font ",
    "^debugcycles ",
    "^mincycles ",
    "^legacy ",
    "^pfres ",
    "^PFcolors ",
    "^playercolors ",
    "^player1colors ",
    "^backgroundchange ",
    "^scorefade ",
    "^interlaced ",
    "^readpaddle ",
    "^multisprite ",
    "^PFheights ",
    "^bankswitch ",
    "^screenheight ",
    "^dpcspritemax ",
    "^_NUSIZ1 ",
    "^fontchar",
    "^player9height",
    "^fontchar",
    "^mk_96x2",
    "^mk_48x",
    "^mk_gameselect_on",
    "^mk_player_on",
    "^bmp_96x",
    "^bmp_48x",
    "^FASTFETCH ",
    "^lives_centered ",
    "^score_kernel_fade ",
    "^0.title_vblank ",
    "^pal ",
    "^mk_score_on ",
    " Unresolved Symbols",
    ""
};

int main(int argc, char **argv)
{
    char linebuffer[BUFSIZE];
    int t, match;
    while (fgets(linebuffer, BUFSIZE, stdin) != NULL)
    {
	match = 0;
	for (t = 0; filterterm[t][0] != '\0'; t++)
	{
	    if (filterterm[t][0] == '^')
	    {
		if (strncmp(linebuffer, filterterm[t] + 1, strlen(filterterm[t] + 1)) == 0)
		{
		    match = 1;
		    break;
		}
	    }
	    else
	    {
		if (strstr(linebuffer, filterterm[t]) != NULL)
		{
		    match = 1;
		    break;
		}
	    }
	}
	if (match == 0)
	    fputs(linebuffer, stdout);
    }
    return (0);
}
