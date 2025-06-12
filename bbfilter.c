// Provided under the GPL v2 license. See the included LICENSE.txt for details.

/*
     bBfilter
	filters out the huge dasm "Unresolved Symbols" list, which is useless
	for us since all of the optional language features own several
	harmless unresolved symbols.
	We now use a dasm that complains about the exact symbols that caused
	the assembly to be unresolvable.
*/

#define BUFSIZE 4096

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void  dasm_error_glue(char *linebuffer);
void  report_basic_line_from_asm(char *asm_filename, long int asm_line_number, char *asm_code);
void  removeCR(char *string);

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
        dasm_error_glue(linebuffer);
    }
    return (0);
}

void dasm_error_glue(char *linebuffer)
{
    char *mnemonic_error = NULL;
    char *asm_filename = NULL;
    char *asm_line_number_str = NULL;
    char *asm_code = NULL;
    char *temp_point = NULL;
    long int asm_line_number = -1;

    if (linebuffer == NULL)
        return;
    mnemonic_error = strstr (linebuffer, "error: Unknown Mnemonic"); 
    if (mnemonic_error == NULL)
        return;

    removeCR(linebuffer);


    // we're going to try to open the reported assembly file and figure
    // out the nearest problem basic line. if we run into any syntax
    // issues along the way we'll just abort the attempt.

    // here's sample syntax of the dasm error, for reference:
    // mygame.bas.asm (1696): error: Unknown Mnemonic 'lda FooBar'.

    // ** 1. Get the offending assembly line string and clean it up...
    asm_code = strchr(linebuffer,'\'');
    if (asm_code == NULL)
        return;
    asm_code++; // skip the first quote
    temp_point = strchr(asm_code,'\'');
    if (temp_point == NULL)
        return;
    *temp_point = 0; // end the string as the second quote

    // ** 2. Get our assembly line number
    // ** a. find the string data and make it look like a regular C string...
    asm_line_number_str = strchr(linebuffer,'(');
    if (asm_line_number_str == NULL)
        return;
    asm_line_number_str++; // skip the '('
    temp_point = strchr(asm_line_number_str,')');
    if (temp_point == NULL)
        return;
    *temp_point = 0;
    // ** b. convert the string to a long value, with sanity checking...
    asm_line_number = atol (asm_line_number_str);        
    if ((asm_line_number == 0) && (strcmp(asm_line_number_str,"0")!=0))
        return;
    if (asm_line_number < 0)
        return;

    // ** 3. Get our assembly file name
    // ** a. to allow for spaces in our file name, we need to use the 
    //       '(###)' line number string as the name delimiter 
    temp_point = strchr(linebuffer,'(');
    if (temp_point == NULL)
        return; // shouldn't be possible, but better to be safe...
    if (temp_point == linebuffer)
        return; // leave if somehow the assembly filename was omitted!
    temp_point--; 
    *temp_point = 0;
    asm_filename = linebuffer;

    // We have everything we need to try and figure out the basic line
    // that generated the error...
    report_basic_line_from_asm(asm_filename, asm_line_number, asm_code);

}

void  report_basic_line_from_asm(char *asm_filename, long int asm_line_number, char *asm_code)
{
    long int t;
    char linebuffer[BUFSIZE];
    char line_save_str [BUFSIZE];
    FILE *asm_filehandle      = NULL;
    char *temp_point          = NULL;
    char *bas_line_str        = NULL;
    char *bas_str             = NULL;
    long int last_tagged_line = -1;
    long int line_save_long   = -1;
    char last_basic_line      = -1;


    // quick sanity check
    if (asm_filename == NULL)
        return;
    if (asm_line_number < 0)
        return;

    asm_filehandle = fopen (asm_filename, "rb");
    if (asm_filehandle == NULL)
        return;

    t=0;
    while (fgets (linebuffer, BUFSIZE, asm_filehandle) != NULL)
    {
        removeCR(linebuffer);
        t++;

        // take note of embedded BASIC line numbers...
        // sample line with embedded line number:  .L02 ;;line 3;; bar = foo
        bas_line_str = strstr(linebuffer, ";;line ");
        if (bas_line_str != NULL)
        {
            bas_line_str = bas_line_str + 7;
            temp_point = strstr(bas_line_str, ";;");
            if (temp_point == NULL)
                continue; // malformed line
            *temp_point = 0;
            if (atol (bas_line_str) < 1 ) // basic starts at line 1
                continue;
            line_save_long = atol (bas_line_str) ;
            bas_str = temp_point + 2;
            strncpy(line_save_str,bas_str,BUFSIZE);
            last_tagged_line = t;
        }
	
        // Only report with helpful info if we saw the basic line number
        // in the last 8 assembly lines. We only want to report on asm
        // that was generated from basic code.
        if ((t==asm_line_number)&&(last_tagged_line > 0) && ((t-last_tagged_line) < 8) )
        {
            printf("    The likely source is line %ld in your basic source code:\n",line_save_long);
            printf("    %s\n",line_save_str);
            fclose(asm_filehandle);
            return;
        }
    }
    fclose(asm_filehandle);
    return;
}

void removeCR (char *string)
{
    char *CR;
    if (string == 0)
        return;
    CR = strrchr (string, (unsigned char) 0x0A);
    if (CR != NULL)
        *CR = 0;
    CR = strrchr (string, (unsigned char) 0x0D);
    if (CR != NULL)
        *CR = 0;
}

