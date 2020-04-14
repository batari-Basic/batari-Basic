// Provided under the GPL v2 license. See the included LICENSE.txt for details.

#include "keywords.h"
#include "statements.h"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

// Check for then, && or ||
BOOL swaptest(char *value) {
	return MATCH(value, "then") || MATCH(value, "&&") || MATCH(value, "||");
}

void keywords(char **cstatement) {
	char errorcode[100];
	char **statement;
	int i, j, k;
	int colons = 0;
	int currentcolon = 0;
	char **pass2elstatement;
	char **elstatement;
	char **orstatement;
	char **swapstatement;
	//char **deallocstatement;
	//char **deallocorstatement;
	//char **deallocelstatement;
	int door;
	int foundelse = 0;
	statement = (char **) malloc(sizeof(char *) * 200);

	orstatement = (char **) malloc(sizeof(char *) * 200);
	for (i = 0; i < 200; ++i)
		orstatement[i] = (char *) malloc(sizeof(char) * 200);

	elstatement = (char **) malloc(sizeof(char *) * 200);
	for (i = 0; i < 200; ++i)
		elstatement[i] = (char *) malloc(sizeof(char) * 200);

	//for (i=0;i<20;++i)fprintf(stderr,"%s ",cstatement[i]);
	//fprintf(stderr,"\n");
	//deallocstatement=statement; // for deallocation purposes
	//deallocorstatement=orstatement; // for deallocation purposes
	//deallocelstatement=elstatement; // for deallocation purposes
	// check if there are boolean && or || in an if-then.
	// change && to "then if"
	// change || to two if thens
	// also change operands around to allow <= and >, since
	// currently all we can do is < and >=
	// if we encounter an else, break into two lines, and the first line jumps ahead.
	door = 0;
	for (k = 0; k <= 190; ++k) { // reversed loop since last build, need to check for rems first!
		if (MATCH(cstatement[k + 1], "rem"))
			break;              // if statement has a rem, do not process it
		if (MATCH(cstatement[k + 1], "if")) {
			for (i = k + 2; i < 200; ++i) {
				if (MATCH(cstatement[i], "if")) break;
				if (MATCH(cstatement[i], "else")) foundelse = i;
			}
			if (   MATCH(cstatement[k + 3], ">")
				&& MATCH(cstatement[k + 1], "if")
				&& swaptest(cstatement[k + 5])
			) {
				// swap operands and switch compare
				strcpy(cstatement[k + 3], cstatement[k + 2]);   // stick 1st operand here temporarily
				strcpy(cstatement[k + 2], cstatement[k + 4]);
				strcpy(cstatement[k + 4], cstatement[k + 3]);   // get it back
				strcpy(cstatement[k + 3], "<"); // replace compare
			}
			else if (  MATCH(cstatement[k + 3], "<=")
					&& MATCH(cstatement[k + 1], "if")
					&& swaptest(cstatement[k + 5])
			) {
				// swap operands and switch compare
				strcpy(cstatement[k + 3], cstatement[k + 2]);
				strcpy(cstatement[k + 2], cstatement[k + 4]);
				strcpy(cstatement[k + 4], cstatement[k + 3]);
				strcpy(cstatement[k + 3], ">=");
			}
			if (MATCH(cstatement[k + 3], "&&")) {
				shiftdata(cstatement, k + 3);
				sprintf(cstatement[k + 3], "then%d", ors++);
				strcpy(cstatement[k + 4], "if");
			}
			else if (MATCH(cstatement[k + 5], "&&")) {
				shiftdata(cstatement, k + 5);
				sprintf(cstatement[k + 5], "then%d", ors++);
				strcpy(cstatement[k + 6], "if");
			}
			else if (MATCH(cstatement[k + 3], "||")) {
				if (   MATCH(cstatement[k + 5], ">")
					&& MATCH(cstatement[k + 1], "if")
					&& swaptest(cstatement[k + 7])
				) { // swap operands and switch compare
					strcpy(cstatement[k + 5], cstatement[k + 4]);       // stick 1st operand here temporarily
					strcpy(cstatement[k + 4], cstatement[k + 6]);
					strcpy(cstatement[k + 6], cstatement[k + 5]);       // get it back
					strcpy(cstatement[k + 5], "<");     // replace compare
				}
				else if (  MATCH(cstatement[k + 5], "<=")
						&& MATCH(cstatement[k + 1], "if")
						&& swaptest(cstatement[k + 7])
				) { // swap operands and switch compare
					strcpy(cstatement[k + 5], cstatement[k + 4]);
					strcpy(cstatement[k + 4], cstatement[k + 6]);
					strcpy(cstatement[k + 6], cstatement[k + 5]);
					strcpy(cstatement[k + 5], ">=");
				}

				for (i = 2; i < 198 - k; ++i)
					strcpy(orstatement[i], cstatement[k + i + 2]);

				if (MATCH(cstatement[k + 5], "then"))
					compressdata(cstatement, k + 3, k + 2);
				else if (MATCH(cstatement[k + 7], "then"))
					compressdata(cstatement, k + 3, k + 4);

				strcpy(cstatement[k + 3], "then");
				sprintf(orstatement[0], "%dOR", ors++);
				strcpy(orstatement[1], "if");
				door = 1;

				// todo: need to skip over the next statement!
			}
			else if (MATCH(cstatement[k + 5], "||")) {
				if (   MATCH(cstatement[k + 7], ">")
					&& MATCH(cstatement[k + 1], "if")
					&& swaptest(cstatement[k + 9])
				) { // swap operands and switch compare
					strcpy(cstatement[k + 7], cstatement[k + 6]);       // stick 1st operand here temporarily
					strcpy(cstatement[k + 6], cstatement[k + 8]);
					strcpy(cstatement[k + 8], cstatement[k + 7]);       // get it back
					strcpy(cstatement[k + 7], "<");     // replace compare
				}
				else if (  MATCH(cstatement[k + 7], "<=")
						&& MATCH(cstatement[k + 1], "if")
						&& swaptest(cstatement[k + 9])
				) { // swap operands and switch compare
					strcpy(cstatement[k + 7], cstatement[k + 6]);
					strcpy(cstatement[k + 6], cstatement[k + 8]);
					strcpy(cstatement[k + 8], cstatement[k + 7]);
					strcpy(cstatement[k + 7], ">=");
				}
				for (i = 2; i < 196 - k; ++i)
					strcpy(orstatement[i], cstatement[k + i + 4]);
				if (MATCH(cstatement[k + 7], "then"))
					compressdata(cstatement, k + 5, k + 2);
				else if (MATCH(cstatement[k + 9], "then"))
					compressdata(cstatement, k + 5, k + 4);
				strcpy(cstatement[k + 5], "then");
				sprintf(orstatement[0], "%dOR", ors++);
				strcpy(orstatement[1], "if");
				door = 1;
			}
		}
		if (door) break;
	}
	if (foundelse) {
		pass2elstatement = door ? orstatement : cstatement;
		for (i = 1; i < 200; ++i) {
			if (MATCH(pass2elstatement[i], "else")) {
				foundelse = i;
				break;
			}
		}

		for (i = foundelse; i < 200; ++i)
			strcpy(elstatement[i - foundelse], pass2elstatement[i]);
		if (!islabelelse(pass2elstatement)) {
			strcpy(pass2elstatement[foundelse++], ":");
			strcpy(pass2elstatement[foundelse++], "goto");
			sprintf(pass2elstatement[foundelse++], "skipelse%d", numelses);
		}
		for (i = foundelse; i < 200; ++i)
			pass2elstatement[i][0] = '\0';
		if (islabelelse(elstatement)) {
			strcpy(elstatement[2], elstatement[1]);
			strcpy(elstatement[1], "goto");
		}
		if (door) {
			for (i = 1; i < 200; ++i) if (MATCH(cstatement[i], "else")) break;
			for (k = i; k < 200; ++k) cstatement[k][0] = '\0';
		}

	}


	if (door) {
		swapstatement = orstatement;    // swap statements because of recursion
		orstatement = cstatement;
		cstatement = swapstatement;

		// this hacks off the conditional statement from the copy of the statement we just created
		// and replaces it with a goto.  This can be improved (i.e., there is no need to copy...)

		if (!islabel(orstatement)) { // make sure islabel function works right!

			// find end of statement
			i = 3;
			//while (orstatement[i++][0]){} // not sure if this will work...
			while (strncmp(orstatement[i++], "then\0", 4)) { } // not sure if this will work...
			// add goto to it
			if (i > 190) {
				i = 190;
				fprintf(stderr, "%d: Cannot find end of line - statement may have been truncated\n", linenum());
			}
			//strcpy(orstatement[i++],":");
			strcpy(orstatement[i++], "goto");
			sprintf(orstatement[i++], "condpart%d", getcondpart() + 1); // goto unnamed line number for then statemtent
			for (; i < 200; ++i) orstatement[i][0] = '\0'; // clear out rest of statement
		}

		keywords(orstatement);  // recurse
	}
	if (foundelse) {
		swapstatement = elstatement;    // swap statements because of recursion
		elstatement = cstatement;
		cstatement = swapstatement;
		keywords(elstatement);  // recurse
	}
	for (i = 0; i < 200; ++i) {
		statement[i] = cstatement[i];
		//printf("%s ",cstatement[i]);
	}
	//printf("\n");
	for (i = 0; i < 200; ++i) {
		if (statement[i][0] == '\0') break;
		if (statement[i][0] == ':') colons++;
	}

	if (MATCH(statement[0], "then"))
		sprintf(statement[0], "%dthen", numthens++);

	invalidate_Areg();

	while (1) {
		i = 0;
	    if (CMATCH(1, '\0')) 					return;
		if (SMATCH(1, "def"))					return;
		if (SMATCH(0, "end"))					endfunction();
		else if (SMATCH(1, "includesfile"))		create_includes(statement[2]);
		else if (SMATCH(1, "include"))			add_includes(statement[2]);
		else if (SMATCH(1, "inline"))			add_inline(statement[2]);
		else if (SMATCH(1, "function"))			function(statement);
		else if (statement[1][0] == ' ')		return;
		else if (SMATCH(1, "if")) {				doif(statement); break; }
		else if (SMATCH(1, "goto"))				dogoto(statement);
		else if (SMATCH(1, "bank"))				newbank(atoi(statement[2]));
		else if (SMATCH(1, "sdata"))			sdata(statement);
		else if (SMATCH(1, "data"))				data(statement);
		else if (  SMATCH(1, "on")
				&& SMATCH(3, "go"))				ongoto(statement);  // on ... goto or on ... gosub
		else if (SMATCH(1, "const"))			doconst(statement);
		else if (SMATCH(1, "dim"))				dim(statement);
		else if (SMATCH(1, "for"))				dofor(statement);
		else if (SMATCH(1, "next"))				next(statement);
		else if (SMATCH(1, "next\n"))			next(statement);
		else if (SMATCH(1, "next\r"))			next(statement);
		else if (SMATCH(1, "gosub"))			gosub(statement);
		else if (SMATCH(1, "pfpixel"))			pfpixel(statement);
		else if (SMATCH(1, "pfhline"))			pfhline(statement);
		else if (SMATCH(1, "pfclear"))			pfclear(statement);
		else if (SMATCH(1, "pfvline"))			pfvline(statement);
		else if (SMATCH(1, "pfscroll"))			pfscroll(statement);
		else if (SMATCH(1, "drawscreen"))		drawscreen();
		else if (SMATCH(1, "asm"))				doasm();
		else if (SMATCH(1, "pop"))				dopop();
		else if (SMATCH(1, "rem")) { 			rem(statement); return; }
		else if (SMATCH(1, "asm\n"))			doasm();
		else if (SMATCH(1, "pop\n"))			dopop();
		else if (SMATCH(1, "rem\n")) {			rem(statement); return; }
		else if (SMATCH(1, "asm\r"))			doasm();
		else if (SMATCH(1, "pop\r"))			dopop();
		else if (SMATCH(1, "rem\r")) {			rem(statement); return; }
		else if (SMATCH(1, "set"))				set(statement);
		else if (SMATCH(1, "return"))			doreturn(statement);
		else if (SMATCH(1, "reboot"))			doreboot();
		else if (SMATCH(1, "vblank"))			vblank();
		else if (SMATCH(1, "return\n"))			doreturn(statement);
		else if (SMATCH(1, "reboot\n"))			doreboot();
		else if (SMATCH(1, "vblank\n"))			vblank();
		else if (SMATCH(1, "return\r"))			doreturn(statement);
		else if (SMATCH(1, "reboot\r"))			doreboot();
		else if (SMATCH(1, "vblank\r"))			vblank();
		else if (  IMATCH(1, "pfcolors:")
				|| IMATCH(1, "pfheights:"))		playfieldcolorandheight(statement);
		else if (IMATCH(1, "bkcolors:"))		bkcolors(statement);
		else if (SMATCH(1, "playfield:"))		playfield(statement);
		else if (SMATCH(1, "scorecolors:"))		scorecolors(statement);
		else if (SMATCH(1, "lives:"))			lives(statement);
		else if (  SMATCH(1, "player0:") || SMATCH(1, "player1:")
				|| SMATCH(1, "player2:") || SMATCH(1, "player3:")
				|| SMATCH(1, "player4:") || SMATCH(1, "player5:")
				|| SMATCH(1, "player6:") || SMATCH(1, "player7:")
				|| SMATCH(1, "player8:") || SMATCH(1, "player9:")
				|| SMATCH(1, "player1-") || SMATCH(1, "player2-")
				|| SMATCH(1, "player3-") || SMATCH(1, "player4-")
				|| SMATCH(1, "player5-") || SMATCH(1, "player6-")
				|| SMATCH(1, "player7-") || SMATCH(1, "player8-")
				|| SMATCH(1, "player0color:") || SMATCH(1, "player1color:")
				|| SMATCH(1, "player2color:") || SMATCH(1, "player3color:")
				|| SMATCH(1, "player4color:") || SMATCH(1, "player5color:")
				|| SMATCH(1, "player6color:") || SMATCH(1, "player7color:")
				|| SMATCH(1, "player8color:") || SMATCH(1, "player9color:")
		)										player(statement);
		else if (SMATCH(2, "="))				dolet(statement);
		else if (SMATCH(1, "let"))				dolet(statement);
		else if (SMATCH(1, "dec"))				dec(statement);
		else if (SMATCH(1, "macro"))			domacro(statement);
		else if (SMATCH(1, "push"))				do_push(statement);
		else if (SMATCH(1, "pull"))				do_pull(statement);
		else if (SMATCH(1, "stack"))			do_stack(statement);
		else if (SMATCH(1, "callmacro"))		callmacro(statement);
		else if (SMATCH(1, "extra"))			doextra(statement[1]);
		else {
			//sadly, a kludge for complex statements followed by "then label"
			int lastc = strlen(statement[0]) - 1;
			if (lastc > 3
				&& (   ISNUM(statement[0][lastc - 4])
					&& statement[0][lastc - 3] == 't'
					&& statement[0][lastc - 2] == 'h'
					&& statement[0][lastc - 1] == 'e'
					&& statement[0][lastc - 0] == 'n'
				)
			)
				return;
			sprintf(errorcode, "Error: Unknown keyword: %s\n", statement[1]);
			prerror(&errorcode[0]);
			exit(1);
		}
		// see if there is a colon
		if (!colons || currentcolon == colons) break;
		currentcolon++;
		i = k = 0;
		while (i != currentcolon) if (cstatement[k++][0] == ':') i++;

		for (j = k; j < 200; ++j) statement[j - k + 1] = cstatement[j];
		for (; (j - k + 1) < 200; ++j) statement[j - k + 1][0] = '\0';
	}
	if (foundelse)
		printf(".skipelse%d\n", numelses++);
}
