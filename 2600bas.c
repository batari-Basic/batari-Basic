// Provided under the GPL v2 license. See the included LICENSE.txt for details.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "statements.h"
#include "keywords.h"
#include <math.h>
#define BB_VERSION_INFO "batari Basic v1.8 (c)2025\n"

extern int bank;

extern int bs;
extern int numconstants;
extern int playfield_index[];
extern int line;

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
    char finalcode[500];
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

    fprintf(stderr, BB_VERSION_INFO);

    printf("game\n");		// label for start of game
    header_open(header);
    init_includes(path);

    playfield_index[0]=0;

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
        int k_def_search; // Use a different loop variable to avoid conflict with outer 'i'
        for (k_def_search = 0; k_def_search < 495; ++k_def_search)
	    if (code[k_def_search] == ' ')
		break;
        if (k_def_search < 495 && code[k_def_search] == ' ' && /* Ensure space was found */
            (k_def_search + 4 < 499) && /* Bounds check for code access */
        code[k_def_search + 1] == 'd' && code[k_def_search + 2] == 'e' && 
        code[k_def_search + 3] == 'f' && code[k_def_search + 4] == ' ')
	{			// found a define
	    int current_pos = k_def_search + 5; // current_pos now points to start of define name.

	    if (defi >= 499) { // Max 500 defines (0-499)
	        fprintf(stderr, "(%d) ERROR: Maximum number of defines (500) reached.\n", bbgetline());
	        exit(1);
	    }

	    for (j = 0; current_pos < 499 && code[current_pos] != ' ' && code[current_pos] != '\0' && code[current_pos] != '\n' && code[current_pos] != '\r'; current_pos++)
	    {
	        if (j >= 99) {
	            fprintf(stderr, "(%d) ERROR: Define name too long (max 99 chars).\n", bbgetline());
		    exit(1);
		}
		def[defi][j++] = code[current_pos];
	    }
	    def[defi][j] = '\0';

	    if (j == 0) { // Empty define name
	        fprintf(stderr, "(%d) ERROR: Malformed define statement. Empty define name.\n", bbgetline());
	         exit(1);
	    }

	    // Expect " = " sequence after define name
	    if (!(current_pos < 497 && code[current_pos] == ' ' && code[current_pos+1] == '=' && code[current_pos+2] == ' ')) {
	        fprintf(stderr, "(%d) ERROR: Malformed define statement. Expected \" = \" after define name '%s'.\n", bbgetline(), def[defi]);
		exit(1);
	    }
	    current_pos += 3; // Skip " = "

	    for (j = 0; current_pos < 499 && code[current_pos] != '\0' && code[current_pos] != '\n' && code[current_pos] != '\r'; current_pos++)
	    {
	        if (j >= 99) {
	            fprintf(stderr, "(%d) ERROR: Define replacement string too long (max 99 chars) for define '%s'.\n", bbgetline(), def[defi]);
	            exit(1);
	        }
	        defr[defi][j++] = code[current_pos];
	    }
	    defr[defi][j] = '\0';
	    removeCR(defr[defi]);
	    printf (";PARSED_DEFINE: .%s. = .%s.\n", def[defi], defr[defi]); // Clarified debug print
	    defi++;
	}
	else if (defi) // This 'i' refers to the outer loop variable for iterating through existing defines
	{
            int def_idx;
	    for (def_idx = 0; def_idx < defi; ++def_idx) // Use new loop var def_idx
	    {
		codeadd = NULL;
		finalcode[0] = '\0';
		defcount = 0;
		while (1)
		{
		    if (defcount++ > 500)
		    {
			fprintf(stderr, "(%d) Infinitely repeating definition or too many instances of a definition\n",
				bbgetline());
			exit(1);
		    }
		    codeadd = strstr (mycode, def[def_idx]);
		    if (codeadd == NULL)
			break;
		    for (j = 0; j < 500; ++j)
			finalcode[j] = '\0';
		    strncpy(finalcode, mycode, strlen(mycode) - strlen(codeadd));
		    strcat (finalcode, defr[def_idx]);
		    strcat (finalcode, codeadd + strlen (def[def_idx]));
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
            printf (".%s ;;line %d;; %s\n", statement[0], line, displaycode);
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
