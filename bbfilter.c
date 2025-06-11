// Provided under the GPL v2 license. See the included LICENSE.txt for details.

/*
     7800filter
	filters out the huge dasm "Unresolved Symbols" list, which is useless
	for us since all of the optional language features own several
	harmless unresolved symbols.
	We now use a dasm that complains about the exact symbols that caused
	the assembly to be unresolvable.
*/

#define BUFSIZE 1000

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (int argc, char **argv)
{
    char linebuffer[BUFSIZE];
    int t, match = 0;
    while (fgets (linebuffer, BUFSIZE, stdin) != NULL)
    {
        if (strncmp(linebuffer,"--- Unresolved Symbol List", 26) == 0)
	{
    		match = 1;
		continue;
	}
        if ((strncmp(linebuffer,"--- ", 4) == 0) && (strstr(linebuffer,"Unresolved Symbols")!=NULL))
	{
    		match = 0;
		continue;
	}
	if (match == 1)
		continue;
	fputs (linebuffer, stdout);
    }
    return (0);
}
