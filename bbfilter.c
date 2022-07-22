/**
 * bAtari-Basic
 * Copyright (c) 2021
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 */

/**
 * bbfilter.c
 * Read from stdin, filter out a bunch of bB symbol names, and write to stdout.
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
    "^qtcontroller ",
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
