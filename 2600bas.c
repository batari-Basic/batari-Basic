// Provided under the GPL v2 license. See the included LICENSE.txt for details.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "statements.h"
#include "keywords.h"
#include <math.h>
#define BB_VERSION_INFO "batari Basic v1.7 (c)2022\n"

int bank = 1;

int main(int argc, char *argv[])
{
    char **statement;
    int i, j, k;
    int unnamed = 0;
    int defcount = 0;
    char *c;
    char single;
    char code[500];
    char displaycode[500];
    FILE *header = NULL;
    int multiplespace = 0;
    char *includes_file = "default.inc";
    char *filename = "2600basic_variable_redefs.h";
    char *path = 0;
    char def[500][100];
    char defr[500][100];
    char *codeadd;
    char mycode[500];
    int defi = 0;
    // get command line arguments
    while ((i = getopt(argc, argv, "i:r:v")) != -1)
    {
	switch (i)
	{
	case 'i':
	    path = (char *) malloc(500);
	    path = optarg;
	    break;
	case 'r':
	    filename = (char *) malloc(100);
	    //strcpy(filename, optarg);
	    filename = optarg;
	    break;
	case 'v':
	    printf("%s", BB_VERSION_INFO);
	    exit(0);
	case '?':
	    fprintf(stderr, "usage: %s -r <variable redefs file> -i <includes path>\n", argv[0]);
	    exit(1);
	}
    }
    condpart = 0;
    last_bank = 0;		// last bank when bs is enabled (0 for 2k/4k)
    bank = 1;			// current bank: 1 or 2 for 8k
    bs = 0;			// bankswtiching type; 0=none
    ongosub = 0;
    superchip = 0;
    optimization = 0;
    smartbranching = 0;
    line = 0;
    numfixpoint44 = 0;
    numfixpoint88 = 0;
    ROMpf = 0;
    ors = 0;
    numjsrs = 0;
    numfors = 0;
    numthens = 0;
    numelses = 0;
    numredefvars = 0;
    numconstants = 0;
    branchtargetnumber = 0;
    doingfunction = 0;
    sprite_index = 0;
    multisprite = 0;
    lifekernel = 0;
    playfield_number = 0;
    playfield_index[0] = 0;
    extra = 0;
    extralabel = 0;
    extraactive = 0;
    macroactive = 0;

    fprintf(stderr, BB_VERSION_INFO);

    printf("game\n");		// label for start of game
    header_open(header);
    init_includes(path);

    statement = (char **) malloc(sizeof(char *) * 200);
    for (i = 0; i < 200; ++i)
    {
	statement[i] = (char *) malloc(sizeof(char) * 200);
    }

    while (1)
    {				// clear out statement cache
	for (i = 0; i < 200; ++i)
	{
	    for (j = 0; j < 200; ++j)
	    {
		statement[i][j] = '\0';
	    }
	}
	c = fgets(code, 500, stdin);	// get next line from input
	incline();
	strcpy(displaycode, code);

	// look for defines and remember them
	strcpy(mycode, code);
	for (i = 0; i < 500; ++i)
	    if (code[i] == ' ')
		break;
	if (code[i + 1] == 'd' && code[i + 2] == 'e' && code[i + 3] == 'f' && code[i + 4] == ' ')
	{			// found a define
	    i += 5;
	    for (j = 0; code[i] != ' '; i++)
	    {
		def[defi][j++] = code[i];	// get the define
	    }
	    def[defi][j] = '\0';

	    i += 3;

	    for (j = 0; code[i] != '\0'; i++)
	    {
		defr[defi][j++] = code[i];	// get the definition
	    }
	    defr[defi][j] = '\0';
	    removeCR(defr[defi]);
	    printf(";.%s.%s.\n", def[defi], defr[defi]);
	    defi++;
	}
	else if (defi)
	{
	    for (i = 0; i < defi; ++i)
	    {
		codeadd = NULL;
		defcount = 0;
		while (1)
		{
		    if (defcount++ > 500)
		    {
				fprintf(stderr, "(%d) Infinitely repeating definition or too many instances of a definition\n",
				bbgetline());
				exit(1);
		    }
		    codeadd = strstr(mycode, def[i]);
		    if (codeadd == NULL) break;
		    char finalcode[500];
		    snprintf(finalcode, sizeof(finalcode) - 1, "%s%s%s", mycode, defr[i], codeadd + strlen(def[i]));
		    strcpy(mycode, finalcode);
		}
	    }
	}
	if (strcmp(mycode, code))
	    strcpy(code, mycode);
	if (!c)
	    break;		//end of file

// preprocessing removed in favor of a simplistic lex-based preprocessor

	i = 0;
	j = 0;
	k = 0;

// look for spaces, reject multiples
	while (code[i] != '\0')
	{
	    single = code[i++];
	    if (single == ' ')
	    {
		if (!multiplespace)
		{
		    j++;
		    k = 0;
		}
		multiplespace++;
	    }
	    else
	    {
		multiplespace = 0;
		if (k < 199)	// avoid overrun with long horizontal separators
		    statement[j][k++] = single;
	    }

	}
	if (j > 190)
	{
	    fprintf(stderr, "(%d) Warning: long line\n", bbgetline());
	}
	if (statement[0][0] == '\0')
	{
	    sprintf(statement[0], "L0%d", unnamed++);
	}
	else
	{
	    if (strchr(statement[0], '.') != NULL)
	    {
		fprintf(stderr, "(%d) Invalid character in label.\n", bbgetline());
		exit(1);
	    }

	}
	if (strncmp(statement[0], "end\0", 3))
	    printf(".%s ; %s\n", statement[0], displaycode);	//    printf(".%s ; %s\n",statement[0],code);
	else
	    doend();

	keywords(statement);
        if(numconstants==(MAXCONSTANTS-1))
        { 
		fprintf(stderr, "(%d) Maximum number of constants exceeded.\n", bbgetline());
		exit(1);
        }

    }
    bank = bbank();
    bs = bbs();
    barf_sprite_data();

    printf(" if ECHOFIRST\n");
    if (bs == 28)
	printf("       echo \"    \",[(DPC_graphics_end - *)]d , \"bytes of ROM space left");
    else
	printf("       echo \"    \",[(scoretable - *)]d , \"bytes of ROM space left");
    if (bs == 8)
	printf(" in bank 2");
    if (bs == 16)
	printf(" in bank 4");
    if (bs == 28)
	printf(" in graphics bank");
    if (bs == 32)
	printf(" in bank 8");
    if (bs == 64)
	printf(" in bank 16");
    printf("\")\n");
    printf(" endif \n");
    printf("ECHOFIRST = 1\n");
    printf(" \n");
    printf(" \n");
    printf(" \n");
    header_write(header, filename);
    create_includes(includes_file);
    fprintf(stderr, "2600 Basic compilation complete.\n");
    return 0;
}
