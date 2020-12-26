// Provided under the GPL v2 license. See the included LICENSE.txt for details.

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <math.h>
#include "statements.h"
#include "keywords.h"

BOOL includesfile_already_done = false;
int decimal = 0;

char* immedtok(char *value) { return isimmed(value) ? " #" : " "; }

char* indexpart(char *mystatement, int myindex) {
  static char outstr[50];
  if (!myindex)
    sprintf(outstr, "%s%s", immedtok(mystatement), mystatement);
  else
    sprintf(outstr, "%s,x", mystatement); // indexed with x!
  return outstr;
}

// The fractional part of a declared 8.8 fixpoint variable
char* fracpart(char *item) {
  int i;
  static char outstr[50];
  for (i = 0; i < numfixpoint88; ++i) {
    strcpy(outstr, fixpoint88[1][i]);
    if (!strcmp(fixpoint88[0][i], item)) return outstr;
  }
  // must be immediate value
  if (findpoint(item) < 50)
    sprintf(outstr, "#%d", (int)(immed_fixpoint(item) * 256.0));
  else
    sprintf(outstr, "#0");

  return outstr;
}

void asm_printf(const char* format, ...) {
  va_list args;
  va_start(args, format);
  vprintf(format, args);
  va_end(args);
}

#define a(ASM) "\t" ASM "\n"
#define ap(ASM, ...) asm_printf(a(ASM), ##__VA_ARGS__)

void currdir_foundmsg(char *foundfile) {
	fprintf(stderr, "User-defined %s found in the current directory\n", foundfile);
}

void doreboot() {
	ap("JMP ($FFFC)");
}

int linenum() {
	// returns current line number in source
	return line;
}

void vblank() {
	// code that will be run in the vblank area
	// subject to limitations!
	// must exit with a return [thisbank if bankswitching used]
	printf("vblank_bB_code\n");
}

void pfclear(char **statement) {
	char getindex0[200];
	int index = 0;

	invalidate_Areg();

	if (bs == 28) {
		ap("LDA #<C_function");
		ap("STA DF0LOW");
		ap("LDA #(>C_function) & $0F");
		ap("STA DF0HI");
		ap("LDX #28");
		ap("STX DF0WRITE");
	}

	if (!statement[2][0] || statement[2][0] == ':')
		ap("LDA #0");
	else {
		index = getindex(statement[2], &getindex0[0]);
		if (index) loadindex(&getindex0[0]);
		ap("LDA %s", indexpart(statement[2], index));
	}
	if (bs == 28) {             // DPC+
		ap("STA DF0WRITE");
		ap("LDA #255");
		ap("STA CALLFUNCTION");
	}
	else {
		removeCR(statement[1]);
		jsr(statement[1]);
	}

}

void do_push(char **statement) {
	int k, i = 2;
	// syntax: push [vars]
	// eg: vars can be a b c d e or a-e
	removeCR(statement[4]);
	if (statement[3][0] == '-') { // range
		ap("LDX #255-%s+%s", statement[4], statement[2]);
		printf("pushlabel%s\n", statement[0]);
		ap("LDA %s+1,x", statement[4]);
		ap("STA DF7PUSH");
		ap("INX");
		ap("BMI pushlabel%s", statement[0]);
	}
	else {
		while (statement[i][0] != ':' && statement[i][0] != '\0') {
			for (k = 0; k < 200; ++k)
				if (statement[i][k] == '\n' || statement[i][k] == '\r')
					statement[i][k] = '\0';
			ap("LDA %s", statement[i++]);
			ap("STA DF7PUSH");
		}
	}

}

void do_pull(char **statement) {
	int k, i = 2;
	int savei;
	// syntax: pull [vars]
	// eg: vars can be a b c d e or a-e
	removeCR(statement[4]);
	if (statement[3][0] == '-') { // range
		ap("LDX #%s-%s", statement[4], statement[2]);
		printf("pulllabel%s\n", statement[0]);
		ap("LDA DF7DATA");
		ap("STA %s,x", statement[2]);
		ap("DEX");
		ap("BPL pulllabel%s", statement[0]);
	}
	else {

		savei = i;
		while (statement[i][0] != ':' && statement[i][0] != '\0') i++;
		i--;
		while (i >= savei) {
			for (k = 0; k < 200; ++k)
				if (statement[i][k] == '\n' || statement[i][k] == '\r')
					statement[i][k] = '\0';
			ap("LDA DF7DATA");
			ap("STA %s", statement[i--]);
		}
	}

}

void do_stack(char **statement) {
	removeCR(statement[2]);
	ap("LDA #<(STACKbegin+%s)", statement[2]);
	ap("STA DF7LOW");
	ap("LDA #(>(STACKbegin+%s)) & $0F", statement[2]);
	ap("STA DF7HI");
}

void bkcolors(char **statement) {
	char data[200];
	char label[200];
	int l = 0;
	if (multisprite == 2) {
		sprintf(label, "backgroundcolor%s\n", statement[0]);
		removeCR(label);
		ap("LDA #<BKCOLS");
		ap("STA DF0LOW");
		ap("LDA #(>BKCOLS) & $0F");
		ap("STA DF0HI");
		ap("LDA #<%s", label);
		ap("STA PARAMETER");
		ap("LDA #((>%s) & $0f) | (((>%s) / 2) & $70)", label, label);     // DPC+
		ap("STA PARAMETER");
		ap("LDA #0");
		ap("STA PARAMETER");

		sprintf(sprite_data[sprite_index++], "%s\n", label);
		while (1) {
			if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
				prerror("Error: Missing \"end\" keyword at end of bkcolors declaration\n");
				exit(1);
			}
			line++;
			if (MATCH(data, "end")) break;
			sprintf(sprite_data[sprite_index++], "\t.byte %s", data);
			l++;
		}
		if (l > 255)
			prerror("Error: too much data in bkcolors declaration\n");
		ap("LDA #%d", l);
		ap("STA PARAMETER");
		ap("LDA #1");
		ap("STA CALLFUNCTION");
		return;                 // get out
	}
	else {
		prerror("Error: bkcolors only works in DPC+ kernels\n");
		exit(1);
	}
}

void playfieldcolorandheight(char **statement) {
	char data[200];
	char rewritedata[200];
	int i = 0, j = 0, l;
	int pfpos = 0, pfoffset = 0, indexsave;
	char label[200];
	// PF colors and/or heights
	// PFheights use offset of 21-31
	// PFcolors use offset of 84-124
	// if used together: playfieldblocksize-88, playfieldcolor-87
	if (IMATCH(1, "pfheights:")) {
		if ((kernel_options & 48) == 32) {
			sprintf(sprite_data[sprite_index++], " ifconst pfres\n");
			sprintf(sprite_data[sprite_index++], "  if (<*) > 235-pfres\n");
			sprintf(sprite_data[sprite_index++], "   repeat (265+pfres-<*)\n" a(".byte 0"));
			sprintf(sprite_data[sprite_index++], "   repend\n  endif\n");
			sprintf(sprite_data[sprite_index++], "  if (<*) < (pfres+9)\n");
			sprintf(sprite_data[sprite_index++], "   repeat ((pfres+9)-(<*))\n" a(".byte 0"));
			sprintf(sprite_data[sprite_index++], "   repend\n");
			sprintf(sprite_data[sprite_index++], "  endif\n");
			sprintf(sprite_data[sprite_index++], " else\n");
			sprintf(sprite_data[sprite_index++], "  if (<*) > 223\n");
			sprintf(sprite_data[sprite_index++], "   repeat (277-<*)\n" a(".byte 0"));
			sprintf(sprite_data[sprite_index++], "   repend\n");
			sprintf(sprite_data[sprite_index++], "  endif\n");
			sprintf(sprite_data[sprite_index++], "  if (<*) < 21\n");
			sprintf(sprite_data[sprite_index++], "   repeat (21-(<*))\n" a(".byte 0"));
			sprintf(sprite_data[sprite_index++], "   repend\n");
			sprintf(sprite_data[sprite_index++], "  endif\n");
			sprintf(sprite_data[sprite_index++], " endif\n");
			sprintf(sprite_data[sprite_index], "pfcolorlabel%d\n", sprite_index);
			indexsave = sprite_index;
			sprite_index++;
			while (1) {
				if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
					prerror("Error: Missing \"end\" keyword at end of pfheight declaration\n");
					exit(1);
				}
				line++;
				if (MATCH(data, "end")) break;
				removeCR(data);
				if (!pfpos) {
					ap("LDA #%s", data);
					ap("STA playfieldpos");
				}
				else
					sprintf(sprite_data[sprite_index++], a(".byte %s"), data);
				pfpos++;
			}
			printf(" ifconst pfres\n");
			ap("LDA #>(pfcolorlabel%d-pfres-9)", indexsave);
			printf(" else\n");
			ap("LDA #>(pfcolorlabel%d-21)", indexsave);
			printf(" endif\n");
			ap("STA pfcolortable+1");
			printf(" ifconst pfres\n");
			ap("LDA #<(pfcolorlabel%d-pfres-9)", indexsave);
			printf(" else\n");
			ap("LDA #<(pfcolorlabel%d-21)", indexsave);
			printf(" endif\n");
			ap("STA pfcolortable");
		}
		else if ((kernel_options & 48) != 48) {
			prerror("PFheights kernel option not set");
			exit(1);
		}
		else {                   //pf color and heights enabled
			sprintf(sprite_data[sprite_index++], " ifconst pfres\n");
			sprintf(sprite_data[sprite_index++], " if (<*) > (254-pfres)\n");
			sprintf(sprite_data[sprite_index++], "      align 256\n     endif\n");
			sprintf(sprite_data[sprite_index++], " if (<*) < (136-pfres*pfwidth)\n");
			sprintf(sprite_data[sprite_index++], "      repeat ((136-pfres*pfwidth)-(<*))\n" a(".byte 0"));
			sprintf(sprite_data[sprite_index++], "      repend\n        endif\n");
			sprintf(sprite_data[sprite_index++], " else\n");
			sprintf(sprite_data[sprite_index++], " if (<*) > 206\n");
			sprintf(sprite_data[sprite_index++], "      align 256\n     endif\n");
			sprintf(sprite_data[sprite_index++], " if (<*) < 88\n");
			sprintf(sprite_data[sprite_index++], "      repeat (88-(<*))\n" a(".byte 0"));
			sprintf(sprite_data[sprite_index++], "      repend\n        endif\n");
			sprintf(sprite_data[sprite_index++], " endif\n");
			sprintf(sprite_data[sprite_index++], "playfieldcolorandheight\n");

			pfcolorindexsave = sprite_index;
			while (1) {
				if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
					prerror("Error: Missing \"end\" keyword at end of pfheight declaration\n");
					exit(1);
				}
				line++;
				if (MATCH(data, "end")) break;
				removeCR(data);
				if (!pfpos) {
					ap("LDA #%s", data);
					ap("STA playfieldpos");
				}
				else
					sprintf(sprite_data[sprite_index++], a(".byte %s,0,0,0"), data);
				pfpos++;
			}
		}
	}
	else {                      // has to be pfcolors
		if (multisprite == 2) {
			l = 0;
			sprintf(label, "playfieldcolor%s\n", statement[0]);
			removeCR(label);
			ap("LDA #<PFCOLS");
			ap("STA DF0LOW");
			ap("LDA #(>PFCOLS) & $0F");
			ap("STA DF0HI");
			ap("LDA #<%s", label);
			ap("STA PARAMETER");
			ap("LDA #((>%s) & $0f) | (((>%s) / 2) & $70)", label, label);     // DPC+
			ap("STA PARAMETER");
			ap("LDA #0");
			ap("STA PARAMETER");

			sprintf(sprite_data[sprite_index++], "%s\n", label);
			while (1) {
				if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
					prerror("Error: Missing \"end\" keyword at end of pfcolor declaration\n");
					exit(1);
				}
				line++;
				if (MATCH(data, "end")) break;
				sprintf(sprite_data[sprite_index++], "\t.byte %s", data);
				l++;
			}
			if (l > 255)
				prerror("Error: too much data in pfcolor declaration\n");
			ap("LDA #%d", l);
			ap("STA PARAMETER");
			ap("LDA #1");
			ap("STA CALLFUNCTION");
			return;             // get out
		}
		if ((kernel_options & 48) == 16) {
			if (!pfcolornumber) {
				sprintf(sprite_data[sprite_index++], " ifconst pfres\n");
				sprintf(sprite_data[sprite_index++], " if (<*) > (254-pfres*pfwidth)\n");
				sprintf(sprite_data[sprite_index++], "  align 256\n     endif\n");
				sprintf(sprite_data[sprite_index++], " if (<*) < (136-pfres*pfwidth)\n");
				sprintf(sprite_data[sprite_index++], "  repeat ((136-pfres*pfwidth)-(<*))\n" a(".byte 0"));
				sprintf(sprite_data[sprite_index++], "  repend\n        endif\n");
				sprintf(sprite_data[sprite_index++], " else\n");

				sprintf(sprite_data[sprite_index++], " if (<*) > 206\n");
				sprintf(sprite_data[sprite_index++], "  align 256\n     endif\n");
				sprintf(sprite_data[sprite_index++], " if (<*) < 88\n");
				sprintf(sprite_data[sprite_index++], "  repeat (88-(<*))\n" a(".byte 0"));
				sprintf(sprite_data[sprite_index++], "  repend\n        endif\n");
				sprintf(sprite_data[sprite_index++], " endif\n");
				sprintf(sprite_data[sprite_index], "pfcolorlabel%d\n", sprite_index);
				sprite_index++;
			}
			//indexsave=sprite_index;
			pfoffset = 1;
			while (1) {
				if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
					prerror("Error: Missing \"end\" keyword at end of pfcolor declaration\n");
					exit(1);
				}
				line++;
				if (MATCH(data, "end")) break;
				removeCR(data);
				if (!pfpos) {
					ap("LDA #%s", data);
					ap("STA COLUPF");
					if (!pfcolornumber) pfcolorindexsave = sprite_index - 1;
					pfcolornumber = (pfcolornumber + 1) % 4;
					pfpos++;
				}
				else {
					//if ((pfcolornumber%3)!=1) // add to existing table (possible correction?)
					if (pfcolornumber != 1) {   // add to existing table
						j = 0;
						i = 0;
						while (j != (pfcolornumber + 3) % 4) {
							if (sprite_data[pfcolorindexsave + pfoffset][i++] == ',') j++;
							if (i > 199) {
								prerror("Warning: size of subsequent pfcolor tables should match\n");
								break;
							}
						}
						//fprintf(stderr,"%s\n",sprite_data[pfcolorindexsave+pfoffset]);
						strcpy(rewritedata, sprite_data[pfcolorindexsave + pfoffset]);
						rewritedata[i - 1] = '\0';
						if (i < 200)
							sprintf(sprite_data[pfcolorindexsave + pfoffset++], "%s,%s%s", rewritedata, data, rewritedata + i + 1);
					}
					else {       // new table
						sprintf(sprite_data[sprite_index++], a(".byte %s,0,0,0"), data);
						// pad with zeros - later we can fill this with additional color data if defined
					}
				}
			}
			printf(" ifconst pfres\n");
			ap("LDA #>(pfcolorlabel%d-%d+pfres*pfwidth)", pfcolorindexsave,
				   85 + 48 - pfcolornumber - ((((pfcolornumber << 1) | (pfcolornumber << 2)) ^ 4) & 4));
			printf(" else\n");
			ap("LDA #>(pfcolorlabel%d-%d)", pfcolorindexsave,
				   85 - pfcolornumber - ((((pfcolornumber << 1) | (pfcolornumber << 2)) ^ 4) & 4));
			printf(" endif\n");
			ap("STA pfcolortable+1");
			printf(" ifconst pfres\n");
			ap("LDA #<(pfcolorlabel%d-%d+pfres*pfwidth)", pfcolorindexsave,
				   85 + 48 - pfcolornumber - ((((pfcolornumber << 1) | (pfcolornumber << 2)) ^ 4) & 4));
			printf(" else\n");
			ap("LDA #<(pfcolorlabel%d-%d)", pfcolorindexsave,
				   85 - pfcolornumber - ((((pfcolornumber << 1) | (pfcolornumber << 2)) ^ 4) & 4));
			printf(" endif\n");
			ap("STA pfcolortable");
		}
		else if ((kernel_options & 48) != 48) {
			prerror("PFcolors kernel option not set");
			exit(1);
		}
		else {				// pf color fixed table
			while (1) {
				if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
					prerror("Error: Missing \"end\" keyword at end of pfcolor declaration\n");
					exit(1);
				}
				line++;
				if (MATCH(data, "end")) break;
				removeCR(data);

				if (!pfpos) {
					ap("LDA #%s", data);
					ap("STA COLUPF");
				}
				else {
					j = i = 0;
					while (!j) {
						if (sprite_data[pfcolorindexsave + pfoffset][i++] == ',') j++;
						if (i > 199) {
							prerror("Warning: size of subsequent pfcolor tables should match\n");
							break;
						}
					}
					//fprintf(stderr,"%s\n",sprite_data[pfcolorindexsave+pfoffset]);
					strcpy(rewritedata, sprite_data[pfcolorindexsave + pfoffset]);
					rewritedata[i - 1] = '\0';
					if (i < 200)
						sprintf(sprite_data[pfcolorindexsave + pfoffset++], "%s,%s%s", rewritedata, data, rewritedata + i + 1);
				}
				pfpos++;
			}

		}

	}

}

void jsrbank1(char *location) {
	// bankswitched jsr to bank 1
	// determines whether to use the standard jsr (for 2k/4k or bankswitched stuff in current bank)
	// or to switch banks before calling the routine
	if ((!bs) || (bank == 1)) {
		ap("JSR %s", location);
		return;
	}
	// we need to switch banks
	ap("STA temp7");
	// first create virtual return address
	// if it's 64k banks, store the bank directly in the high nibble
	if (bs == 64)
		ap("LDA #(((>(ret_point%d-1)) & $0F) | $%1x0)", ++numjsrs, bank - 1);
	else
		ap("LDA #>(ret_point%d-1)", ++numjsrs);
	ap("PHA");

	ap("LDA #<(ret_point%d-1)", numjsrs);
	ap("PHA");
	// next we must push the place to jsr to
	ap("LDA #>(%s-1)", location);
	ap("PHA");
	ap("LDA #<(%s-1)", location);
	ap("PHA");
	// now store regs on stack
	ap("LDA temp7");
	ap("PHA");
	ap("TXA");
	ap("PHA");
	// select bank to switch to
	ap("LDX #1");
	ap("JMP BS_jsr");
	printf("ret_point%d\n", numjsrs);
}

void playfield(char **statement) {
	// for specifying a ROM playfield
	char zero = '.';
	char one = 'X';
	int i, j, k, l = 0;
	char data[200];
	char pframdata[255][200];
	if (statement[2][0] > ' ') zero = statement[2][0];
	if (statement[3][0] > ' ') one = statement[3][0];

	// read data until we get an end
	// stored in global var and output at end of code

	while (1) {
		if ((!fgets(data, sizeof(data), stdin)) || ((data[0] != zero) && (data[0] != one) && (data[0] != 'e'))) {
			prerror("Error: Missing \"end\" keyword at end of playfield declaration\n");
			exit(1);
		}
		line++;
		if (MATCH(data, "end")) break;
		if (ROMpf) {			// if playfield is in ROM:
			pfdata[playfield_number][playfield_index[playfield_number]] = 0;
			for (i = 0; i < 32; ++i) {
				if ((data[i] != zero) && (data[i] != one)) break;
				pfdata[playfield_number][playfield_index[playfield_number]] <<= 1;
				if (data[i] == one)
					pfdata[playfield_number][playfield_index[playfield_number]] |= 1;
			}
			playfield_index[playfield_number]++;
		}
		else {
			strcpy(pframdata[l++], data);
		}

	}

	if (ROMpf) {			// if playfield is in ROM:
		ap("LDA #<PF1_data%d", playfield_number);
		ap("STA PF1pointer");
		ap("LDA #>PF1_data%d", playfield_number);
		ap("STA PF1pointer+1");

		ap("LDA #<PF2_data%d", playfield_number);
		ap("STA PF2pointer");
		ap("LDA #>PF2_data%d", playfield_number);
		ap("STA PF2pointer+1");
		playfield_number++;
	}
	else if (bs != 28) {	// RAM pf, as in std_kernel, not DPC+
		printf("  ifconst pfres\n");
		//ap("LDX #4*pfres-1");
		ap("LDX #(%d>pfres)*(pfres*pfwidth-1)+(%d<=pfres)*%d", l, l, l * 4 - 1);
		printf("  else\n");
		//ap("LDX #47");
		//ap("LDX #%d",l*4-1>47?47:l*4-1);
		ap("LDX #((%d*pfwidth-1)*((%d*pfwidth-1)<47))+(47*((%d*pfwidth-1)>=47))", l, l, l);
		printf("  endif\n");
		ap("JMP pflabel%d", playfield_number);

		// no need to align to page boundaries

		printf("PF_data%d\n", playfield_number);
		for (j = 0; j < l; ++j) { // stored right side up
			printf("\t.byte %%");
			// the below should be changed to check for zero instead of defaulting to it
			for (k = 0; k < 8; ++k)
				printf(pframdata[j][k] == one ? "1" : "0");
			printf(", %%");
			for (k = 15; k >= 8; k--)
				printf(pframdata[j][k] == one ? "1" : "0");
			printf("\n  if (pfwidth>2)\n\t.byte %%");
			for (k = 16; k < 24; ++k)
				printf(pframdata[j][k] == one ? "1" : "0");
			printf(", %%");
			for (k = 31; k >= 24; k--)
				printf(pframdata[j][k] == one ? "1" : "0");
			printf("\n endif\n");
		}

		printf("pflabel%d\n", playfield_number);
		ap("LDA PF_data%d,x", playfield_number);
		if (superchip) {
			//printf("  ifconst pfres\n");
			//ap("STA playfield+48-pfres*pfwidth-128,x");
			//printf("  else\n");
			ap("STA playfield-128,x");
			//printf("  endif\n");
		}
		else {
			//printf("  ifconst pfres\n");
			//ap("STA playfield+48-pfres*pfwidth,x");
			//printf("  else\n");
			ap("STA playfield,x");
			//printf("  endif\n");
		}
		ap("DEX");
		ap("BPL pflabel%d", playfield_number);
		playfield_number++;
	}
	else {                       // RAM pf in DPC+
		// l is pf data height
		playfield_number++;
		ap("LDY #%d", l);
		ap("LDA #<PF_data%d", playfield_number);
		ap("LDX #((>PF_data%d) & $0f) | (((>PF_data%d) / 2) & $70)", playfield_number, playfield_number);
		jsrbank1("pfsetup");

		// use sprite data recorder for pf data
		sprintf(sprite_data[sprite_index++], "PF_data%d\n", playfield_number);
		for (j = 0; j < l; ++j) { // stored right side up
			sprintf(data, "\t.byte %%");
			for (k = 31; k >= 24; k--)
				strcat(data, pframdata[j][k] == one ? "1" : "0");
			strcat(data, "\n");
			strcpy(sprite_data[sprite_index++], data);
		}

		for (j = 0; j < l; ++j) { // stored right side up
			sprintf(data, "\t.byte %%");
			for (k = 16; k < 24; ++k)
				strcat(data, pframdata[j][k] == one ? "1" : "0");
			strcat(data, "\n");
			strcpy(sprite_data[sprite_index++], data);
		}

		for (j = 0; j < l; ++j) { // stored right side up
			sprintf(data, "\t.byte %%");
			for (k = 15; k >= 8; k--)
				strcat(data, pframdata[j][k] == one ? "1" : "0");
			strcat(data, "\n");
			strcpy(sprite_data[sprite_index++], data);
		}

		for (j = 0; j < l; ++j) { // stored right side up
			sprintf(data, "\t.byte %%");
			for (k = 0; k < 8; ++k)
				strcat(data, pframdata[j][k] == one ? "1" : "0");
			strcat(data, "\n");
			strcpy(sprite_data[sprite_index++], data);
		}
	}
}

int bbank() { return bank; }

int bbs() { return bs; }

void jsr(char *location) {
	// determines whether to use the standard jsr (for 2k/4k or bankswitched stuff in current bank)
	// or to switch banks before calling the routine
	if ((!bs) || (bank == last_bank)) {
		ap("JSR %s", location);
		return;
	}
	// we need to switch banks
	ap("STA temp7");
	// first create virtual return address
	if (bs == 64)
		ap("LDA #(((>(ret_point%d-1)) & $0F) | $%1x0)", ++numjsrs, bank - 1);
	else
		ap("LDA #>(ret_point%d-1)", ++numjsrs);
	ap("PHA");
	ap("LDA #<(ret_point%d-1)", numjsrs);
	ap("PHA");
	// next we must push the place to jsr to
	ap("LDA #>(%s-1)", location);
	ap("PHA");
	ap("LDA #<(%s-1)", location);
	ap("PHA");
	// now store regs on stack
	ap("LDA temp7");
	ap("PHA");
	ap("TXA");
	ap("PHA");
	// select bank to switch to
	ap("LDX #%d", last_bank);
	ap("JMP BS_jsr");
	printf("ret_point%d\n", numjsrs);
}

int switchjoy(char *input_source) {
	// place joystick/console switch reading code inline instead of as a subroutine
	// standard routines needed for pretty much all games
	// read switches, joysticks now compiler generated (more efficient)

	// returns 0 if we need BEQ/BNE, 1 if BVC/BVS, and 2 if BPL/BMI

	//invalidate_Areg()  // do we need this?

	if (MATCH(input_source, "switchreset")) {
		ap("LDA #1");
		ap("BIT SWCHB");
		return 0;
	}
	if (MATCH(input_source, "switchselect")) {
		ap("LDA #2");
		ap("BIT SWCHB");
		return 0;
	}
	if (MATCH(input_source, "switchleftb")) {
		ap("LDA #$40");
		ap("BIT SWCHB");
		return 1;
	}
	if (MATCH(input_source, "switchrightb")) {
		ap("LDA #$80");
		ap("BIT SWCHB");
		return 2;
	}
	if (MATCH(input_source, "switchbw")) {
		ap("LDA #8");
		ap("BIT SWCHB");
		return 0;
	}
	if (MATCH(input_source, "joy0up")) {
		ap("LDA #$10");
		ap("BIT SWCHA");
		return 0;
	}
	if (MATCH(input_source, "joy0down")) {
		ap("LDA #$20");
		ap("BIT SWCHA");
		return 0;
	}
	if (MATCH(input_source, "joy0left")) {
		ap("LDA #$40");
		ap("BIT SWCHA");
		return 1;
	}
	if (MATCH(input_source, "joy0right")) {
		ap("LDA #$80");
		ap("BIT SWCHA");
		return 2;
	}
	if (MATCH(input_source, "joy1up")) {
		ap("LDA #1");
		ap("BIT SWCHA");
		return 0;
	}
	if (MATCH(input_source, "joy1down")) {
		ap("LDA #2");
		ap("BIT SWCHA");
		return 0;
	}
	if (MATCH(input_source, "joy1left")) {
		ap("LDA #4");
		ap("BIT SWCHA");
		return 0;
	}
	if (MATCH(input_source, "joy1right")) {
		ap("LDA #8");
		ap("BIT SWCHA");
		return 0;
	}
	if (MATCH(input_source, "joy0fire")) {
		ap("LDA #$80");
		ap("BIT INPT4");
		return 2;
	}
	if (MATCH(input_source, "joy1fire")) {
		ap("LDA #$80");
		ap("BIT INPT5");
		return 2;
	}
	prerror("invalid console switch/controller reference\n");
	exit(1);
}

void newbank(int bankno) {
	FILE *bs_support;
	char line[500];
	char fullpath[500];
	int len;

	if (bankno == 1) return;		// "bank 1" is ignored

	fullpath[0] = '\0';
	if (includespath[0]) {
		strcpy(fullpath, includespath);
		if (includespath[strlen(includespath) - 1] == '\\' || includespath[strlen(includespath) - 1] == '/')
			strcat(fullpath, "includes/");
		else
			strcat(fullpath, "/includes/");
	}
	strcat(fullpath, "banksw.asm");

	// from here on, code will compile in the next bank
	// for 8k bankswitching, most of the libaries will go into bank 2
	// and majority of bB program in bank 1

	bank = bankno;
	if (bank > last_bank) prerror("bank not supported\n");

	printf(" if ECHO%d\n", bank - 1);
	printf(" echo \"    \",[(start_bank%d - *)]d , \"bytes of ROM space left in bank %d\")\n", bank - 1, bank - 1);
	printf(" endif\n");
	printf("ECHO%d = 1\n", bank - 1);

	// now display banksw.asm file

	if ((bs_support = fopen("banksw.asm", "r")) == NULL) {		// open file in current dir
		if ((bs_support = fopen(fullpath, "r")) == NULL) {		// open file
			fprintf(stderr, "Cannot open banksw.asm for reading\n");
			exit(1);
		}
	}
	else
		currdir_foundmsg("banksw.asm");
	while (fgets(line, 500, bs_support)) {
		if (MATCH(line, ";size=")) break;
	}
	len = atoi(line + 6);

	if (bs == 64) len = len + 4;	// kludge

	if (bank == 2)
		sprintf(redefined_variables[numredefvars++], "bscode_length = %d", len);

	if (bs == 64)
		printf(" ORG $%1XFE0-bscode_length\n", bank - 1);
	else
		printf(" ORG $%dFF4-bscode_length\n", bank - 1);

	if (bs == 28)
		printf(" RORG $%XF4-bscode_length\n", (2 * (bank - 1) - 1) * 16 + 15);
	else if (bs == 64)
		printf(" RORG $%XE0-bscode_length\n", (31 - bs / 2 + 2 * (bank - 1)) * 16 + 15);
	else
		printf(" RORG $%XF4-bscode_length\n", (15 - bs / 2 + 2 * (bank - 1)) * 16 + 15);

	printf("start_bank%d", bank - 1);

	while (fgets(line, 500, bs_support))
		if (line[0] == ' ') printf("%s", line);

	fclose(bs_support);

	printf(" ORG $%1XFFC\n", bank - 1);

	if (bs == 28)
		printf(" RORG $%XFC\n", (2 * (bank - 1) - 1) * 16 + 15);
	else if (bs == 64)
		printf(" RORG $%XFC\n", (31 - bs / 2 + 2 * (bank - 1)) * 16 + 15);
	else
		printf(" RORG $%XFC\n", (15 - bs / 2 + 2 * (bank - 1)) * 16 + 15);

	ap(".word (start_bank%d & $ffff)", bank - 1);
	ap(".word (start_bank%d & $ffff)", bank - 1);

	// now end
	printf(" ORG $%1X000\n", bank);
	if (bs == 28) {
		printf(" RORG $%X00\n", (2 * bank - 1) * 16);
		switch (bank) {
			case 2:         // probably a better way to do this!!!
				printf("HMdiv\n");
				ap(".byte 0, 0, 0, 0, 0, 0, 0");
				ap(".byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2");
				ap(".byte 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3");
				ap(".byte 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4");
				ap(".byte 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5");
				ap(".byte 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6");
				ap(".byte 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7");
				ap(".byte 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8");
				ap(".byte 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9");
				ap(".byte 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10");
				ap(".byte 10,10,10,10,10,10,0,0,0");
				break;
			default:
				printf(" repeat 129\n");
				ap(".byte 0");
				printf(" repend\n");
		}
	}
	else if (bs == 64)
		printf(" RORG $%X00\n", (31 - bs / 2 + 2 * bank) * 16);
	else
		printf(" RORG $%X00\n", (15 - bs / 2 + 2 * bank) * 16);

	if (superchip) {
		printf(" repeat 256\n");
		ap(".byte $ff");
		printf(" repend\n");
	}

	if (bank == last_bank)
		printf("; bB.asm file is split here\n");

	// not working yet - need to :
	// do something I forgot
}

float immed_fixpoint(char *fixpointval) {
	int i = findpoint(fixpointval);
	if (i == 50) return 0;		// failsafe
	char decimalpart[50];
	fixpointval[i] = '\0';
	sprintf(decimalpart, "0.%s", fixpointval + i + 1);
	return atof(decimalpart);
}

int findpoint(char *item) {		// determine if fixed point var
	int i;
	for (i = 0; i < 50; ++i) {
		if (item[i] == '\0') return 50;
		if (item[i] == '.') return i;
	}
	return i;
}

void freemem(char **statement) {
	int i;
	for (i = 0; i < 200; ++i) free(statement[i]);
	free(statement);
}

int isfixpoint(char *item) {
	// determines if a variable is fixed point, and if so, what kind
	int i;
	removeCR(item);
	for (i = 0; i < numfixpoint88; ++i)
		if (!strcmp(item, fixpoint88[0][i])) return 8;
	for (i = 0; i < numfixpoint44; ++i)
		if (!strcmp(item, fixpoint44[0][i])) return 4;
	if (findpoint(item) < 50) return 12;
	return 0;
}

void set_romsize(char *size) {
	if (MATCH(size, "2k"))
		strcpy(redefined_variables[numredefvars++], "ROM2k = 1");
	else if (MATCH(size, "8k")) {
		bs = 8;
		last_bank = 2;
		if (MATCH(size, "8kEB"))
			strcpy(redefined_variables[numredefvars++], "bankswitch_hotspot = $083F");
		else
			strcpy(redefined_variables[numredefvars++], "bankswitch_hotspot = $1FF8");
		strcpy(redefined_variables[numredefvars++], "bankswitch = 8");
		strcpy(redefined_variables[numredefvars++], "bs_mask = 1");
		if (MATCH(size, "8kSC")) {
			strcpy(redefined_variables[numredefvars++], "superchip = 1");
			create_includes("superchip.inc");
			superchip = 1;
		}
		else
			create_includes("bankswitch.inc");
	}
	else if (MATCH(size, "16k")) {
		bs = 16;
		last_bank = 4;
		strcpy(redefined_variables[numredefvars++], "bankswitch_hotspot = $1FF6");
		strcpy(redefined_variables[numredefvars++], "bankswitch = 16");
		strcpy(redefined_variables[numredefvars++], "bs_mask = 3");
		if (MATCH(size, "16kSC")) {
			strcpy(redefined_variables[numredefvars++], "superchip = 1");
			create_includes("superchip.inc");
			superchip = 1;
		}
		else
			create_includes("bankswitch.inc");
	}
	else if (MATCH(size, "32k")) {
		bs = 32;
		last_bank = 8;
		strcpy(redefined_variables[numredefvars++], "bankswitch_hotspot = $1FF4");
		strcpy(redefined_variables[numredefvars++], "bankswitch = 32");
		strcpy(redefined_variables[numredefvars++], "bs_mask = 7");
		//if (multisprite == 1) create_includes("multisprite_bankswitch.inc");
		//else
		if (MATCH(size, "32kSC")) {
			strcpy(redefined_variables[numredefvars++], "superchip = 1");
			create_includes("superchip.inc");
			superchip = 1;
		}
		else
			create_includes("bankswitch.inc");
	}
	else if (MATCH(size, "64k")) {
		bs = 64;
		last_bank = 16;
		strcpy(redefined_variables[numredefvars++], "bankswitch_hotspot = $1FE0");
		strcpy(redefined_variables[numredefvars++], "bankswitch = 64");
		strcpy(redefined_variables[numredefvars++], "bs_mask = 15");
		if (MATCH(size, "64kSC")) {
			strcpy(redefined_variables[numredefvars++], "superchip = 1");
			create_includes("superchip.inc");
			superchip = 1;
		}
		else
			create_includes("bankswitch.inc");
	}
	else if (!MATCH(size, "4k")) {
		fprintf(stderr, "Warning: unsupported ROM size: %s Using 4k.\n", size);
	}
}

void add_includes(char *myinclude) {
	if (includesfile_already_done)
		fprintf(stderr, "%d: Warning: include ignored (includes should typically precede other commands)\n", line);
	strcat(user_includes, myinclude);
}

void add_inline(char *myinclude) {
	printf(" include %s\n", myinclude);
}

void init_includes(char *path) {
	if (path)
		strcpy(includespath, path);
	else
		includespath[0] = '\0';
	user_includes[0] = '\0';
}

void barf_sprite_data() {
	int i, j, k;
	// go to the last bank before barfing the graphics
	if (!bank) bank = 1;
	for (i = bank; i < last_bank; ++i)
		newbank(i + 1);

	//{
	//  bank=1;
	//  printf(" echo \"   \",[(start_bank1 - *)]d , \"bytes of ROM space left in bank 1\"\n");
	//}
	//for (i=bank;i<last_bank;++i)
	//  printf("; bB.asm file is split here\n\n\n\n");

	for (i = 0; i < sprite_index; ++i)
		printf("%s", sprite_data[i]);

	// now we must regurgitate the PF data

	for (i = 0; i < playfield_number; ++i) {
		if (ROMpf) {
			printf(" if ((>(*+%d)) > (>*))\n ALIGN 256\n endif\n", playfield_index[i]);
			printf("PF1_data%d\n", i);
			for (j = playfield_index[i] - 1; j >= 0; j--) {
				printf("\t.byte %%");

				for (k = 15; k > 7; k--)
					printf((pfdata[i][j] & (1 << k)) ? "1" : "0");
				printf("\n");
			}

			printf(" if ((>(*+%d)) > (>*))\n ALIGN 256\n endif\n", playfield_index[i]);
			printf("PF2_data%d\n", i);
			for (j = playfield_index[i] - 1; j >= 0; j--)
			{
				printf("\t.byte %%");
				for (k = 0; k < 8; ++k) // reversed bit order!
					printf((pfdata[i][j] & (1 << k)) ? "1" : "0");
				printf("\n");
			}
		}
		else {				// RAM pf
			// do nuttin'
		}
	}
}

void create_includes(char *includesfile) {
	FILE *includesread, *includeswrite;
	char dline[500];
	char fullpath[500];
	int i;
	int writeline;
	removeCR(includesfile);
	if (includesfile_already_done) return;
	includesfile_already_done = true;
	fullpath[0] = '\0';
	if (includespath[0]) {
		strcpy(fullpath, includespath);
		if ((includespath[strlen(includespath) - 1] == '\\') || (includespath[strlen(includespath) - 1] == '/'))
			strcat(fullpath, "includes/");
		else
			strcat(fullpath, "/includes/");
	}
	strcat(fullpath, includesfile);
	//for (i=0;i<strlen(includesfile);++i) if (includesfile[i]=='\n') includesfile[i]='\0';
	if ((includesread = fopen(includesfile, "r")) == NULL) {	// try again in current dir
		if ((includesread = fopen(fullpath, "r")) == NULL) {	// open file
			fprintf(stderr, "Cannot open %s for reading\n", includesfile);
			exit(1);
		}
	}
	else
		currdir_foundmsg(includesfile);
	if ((includeswrite = fopen("includes.bB", "w")) == NULL) {	// open file
		fprintf(stderr, "Cannot open includes.bB for writing\n");
		exit(1);
	}

	while (fgets(dline, 500, includesread)) {
		writeline = 0;
		for (i = 0; i < 500; ++i) {
			if (dline[i] == ';' || dline[i] == '\n' || dline[i] == '\r') break;
			if (dline[i] > ' ') { writeline = 1; break; }
		}
		if (writeline) {
			if (!strncasecmp(dline, "bb.asm", 6))
				if (user_includes[0] != '\0')
					fprintf(includeswrite, "%s", user_includes);
			fprintf(includeswrite, "%s", dline);
		}
	}
	fclose(includesread);
	fclose(includeswrite);
}

void loadindex(char *myindex) {
	if (!MATCH(myindex, "TSX")) // Not TSX...
		ap("LDX %s%s", immedtok(myindex), myindex);
}

int getindex(char *mystatement, char *myindex) {
	int i, j, index = 0;
	for (i = 0; i < 200; ++i) {
		if (mystatement[i] == '\0') { i = 200; break; }
		if (mystatement[i] == '[') { index = 1; break; }
	}
	if (i < 200) {
		strcpy(myindex, mystatement + i + 1);
		myindex[strlen(myindex) - 1] = '\0';
		if (myindex[strlen(myindex) - 2] == ']') myindex[strlen(myindex) - 2] = '\0';
		if (myindex[strlen(myindex) - 1] == ']') myindex[strlen(myindex) - 1] = '\0';
		for (j = i; j < 200; ++j) mystatement[j] = '\0';
	}
	return index;
}

int checkmul(int value) {
	// check to see if value can be optimized to save cycles

	if (!(value % 2)) return 1;

	if (value < 11) return 1;		// always optimize these

	while (value != 1) {
		if      (!(value % 9)) value /= 9;
		else if (!(value % 7)) value /= 7;
		else if (!(value % 5)) value /= 5;
		else if (!(value % 3)) value /= 3;
		else if (!(value % 2)) value /= 2;
		else break;
		if (!(value % 2) && (optimization & 1) != 1) break; // don't optimize multplication
	}
	return (value == 1) ? 1 : 0;
}

int checkdiv(int value) {
	// check to see if value is a power of two - if not, run standard div routine
	while (value != 1) {
		if (value & 1) break;
		value >>= 1;
	}
	return (value == 1) ? 1 : 0;
}


void mul(char **statement, int bits) {
	// this will attempt to output optimized code depending on the multiplicand
	int multiplicand = atoi(statement[6]);
	int tempstorage = 0;
	// we will optimize specifically for 2,3,5,7,9
	if (bits == 16) {
		ap("LDX #0");
		ap("STX temp1");
	}
	while (multiplicand != 1) {
		if (!(multiplicand % 9)) {
			if (tempstorage) {
				strcpy(statement[4], "temp2");
				ap("STA temp2");
			}
			multiplicand /= 9;
			ap("ASL");
			if (bits == 16) ap("ROL temp1");
			ap("ASL");
			if (bits == 16) ap("ROL temp1");
			ap("ASL");
			if (bits == 16) ap("ROL temp1");
			ap("CLC");
			ap("ADC %s%s", immedtok(statement[4]), statement[4]);
			if (bits == 16) {
				ap("TAX");
				ap("LDA temp1");
				ap("ADC #0");
				ap("STA temp1");
				ap("TXA");
			}
			tempstorage = 1;
		}
		else if (!(multiplicand % 7)) {
			if (tempstorage) {
				strcpy(statement[4], "temp2");
				ap("STA temp2");
			}
			multiplicand /= 7;
			ap("ASL");
			if (bits == 16) printf("ROL temp1");
			ap("ASL");
			if (bits == 16) printf("ROL temp1");
			ap("ASL");
			if (bits == 16) printf("ROL temp1");
			ap("SEC");
			ap("SBC %s%s", immedtok(statement[4]), statement[4]);
			if (bits == 16) {
				ap("TAX");
				ap("LDA temp1");
				ap("SBC #0");
				ap("STA temp1");
				ap("TXA");
			}
			tempstorage = 1;
		}
		else if (!(multiplicand % 5)) {
			if (tempstorage) {
				strcpy(statement[4], "temp2");
				ap("STA temp2");
			}
			multiplicand /= 5;
			ap("ASL");
			if (bits == 16) ap("ROL temp1");
			ap("ASL");
			if (bits == 16) ap("ROL temp1");
			ap("CLC");
			ap("ADC %s%s", immedtok(statement[4]), statement[4]);
			if (bits == 16) {
				ap("TAX");
				ap("LDA temp1");
				ap("ADC #0");
				ap("STA temp1");
				ap("TXA");
			}
			tempstorage = 1;
		}
		else if (!(multiplicand % 3)) {
			if (tempstorage) {
				strcpy(statement[4], "temp2");
				ap("STA temp2");
			}
			multiplicand /= 3;
			ap("ASL");
			if (bits == 16) ap("ROL temp1");
			ap("CLC");
			ap("ADC %s%s", immedtok(statement[4]), statement[4]);
			if (bits == 16) {
				ap("TAX");
				ap("LDA temp1");
				ap("ADC #0");
				ap("STA temp1");
				ap("TXA");
			}
			tempstorage = 1;
		}
		else if (!(multiplicand % 2)) {
			multiplicand /= 2;
			ap("ASL");
			if (bits == 16) ap("ROL temp1");
		}
		else {
			ap("LDY #%d", multiplicand);
			ap("JSR mul%d", bits);
			fprintf(stderr, "Warning - there seems to be a problem.  Your code may not run properly.\n");
			fprintf(stderr, "If you are seeing this message, please report it - it could be a bug.\n");
			// WARNING: not fixed up for bankswitching
		}
	}
}

void divd(char **statement, int bits) {
	int divisor = atoi(statement[6]);
	if (bits == 16) {
		ap("LDX #0");
		ap("STX temp1");
	}
	while (divisor != 1) {
		if (!(divisor % 2)) {		// div by power of two is the only easy thing
			divisor /= 2;
			ap("LSR\n");
			if (bits == 16)
				ap("ROL temp1\n");        // I am not sure if this is actually correct
		}
		else {
			ap("LDY #%d", divisor);
			ap("JSR div%d", bits);
			fprintf(stderr, "Warning - there seems to be a problem.  Your code may not run properly.\n");
			fprintf(stderr, "If you are seeing this message, please report it - it could be a bug.\n");
			// WARNING: Not fixed up for bankswitching
		}
	}
}

void endfunction() {
	if (!doingfunction) prerror("extraneous end keyword encountered\n");
	doingfunction = 0;
}

void function(char **statement) {
	// declares a function - only needed if function is in bB.  For asm functions, see
	// the help.html file.
	// determine number of args, then run until we get an end.
	doingfunction = 1;
	printf("%s\n", statement[2]);
	ap("STA temp1");
	ap("STY temp2");
}

void callfunction(char **statement) {
	// called by assignment to a variable
	// does not work as an argument in another function or an if-then... yet.
	int i, index = 0;
	char getindex0[200];
	int arguments = 0;
	int argnum[10];
	for (i = 6; statement[i][0] != ')'; ++i) {
		if (statement[i][0] != ',')
			argnum[arguments++] = i;
		if (i > 195)
			prerror("missing \")\" at end of function call\n");
	}
	if (!arguments)
		fprintf(stderr, "(%d) Warning: function call with no arguments\n", line);
	while (arguments) {
		// get [index]
		index = getindex(statement[argnum[--arguments]], &getindex0[0]);
		if (index) loadindex(&getindex0[0]);
		ap("LD%c %s", arguments == 1 ? 'Y' : 'A', indexpart(statement[argnum[arguments]], index));
		if (arguments > 1) ap("STA temp%d", arguments + 1);
		//arguments--;
	}
	//jsr(statement[4]);
	// need to fix above for proper function support
	ap("JSR %s", statement[4]);
	strcpy(Areg, "invalid");
}

void incline() { line++; }

int bbgetline() { return line; }

void invalidate_Areg() { strcpy(Areg, "invalid"); }

// Determine if the item after a "then" is a label or a statement
BOOL islabel(char **statement) {
	// return true=label, false=statement
	int i;
	// find the "then" or a "goto"
	for (i = 0; i < 198;) if (SMATCH(i++, "then")) break;
	return findlabel(statement, i);
}

// Determine if the item after an "else" is a label or a statement
BOOL islabelelse(char **statement) {
	// return of true=label, false=statement
	int i;
	// find the "else"
	for (i = 0; i < 198;) if (SMATCH(i++, "else")) break;
	return findlabel(statement, i);
}

BOOL findlabel(char **statement, int i) {
	char statementcache[100];
	// true if label, false if not
	if (statement[i][0] >= '0' && statement[i][0] <= ':') return true;
	if (statement[i + 1][0] == ':') return SMATCH(i + 2, "rem");
	if (SMATCH(i + 1, "else")) return true;
	//if (SMATCH(i + 1, "bank")) return 0;
	// uncomment to allow then label bankx (needs work)
	if (statement[i + 1][0] != '\0') return false;
	// only possibilities left are: drawscreen, player0:, player1:, asm, next, return, maybe others added later?

	strcpy(statementcache, statement[i]);
	removeCR(statementcache);
	if (MATCH(statementcache, "drawscreen"))		return false;
	if (MATCH(statementcache, "lives:"))			return false;
	if (MATCH(statementcache, "player0color:"))		return false;
	if (MATCH(statementcache, "player1color:"))		return false;
	if (MATCH(statementcache, "player2color:"))		return false;
	if (MATCH(statementcache, "player3color:"))		return false;
	if (MATCH(statementcache, "player4color:"))		return false;
	if (MATCH(statementcache, "player5color:"))		return false;
	if (MATCH(statementcache, "player6color:"))		return false;
	if (MATCH(statementcache, "player7color:"))		return false;
	if (MATCH(statementcache, "player8color:"))		return false;
	if (MATCH(statementcache, "player9color:"))		return false;
	if (MATCH(statementcache, "player0:"))			return false;
	if (MATCH(statementcache, "player1:"))			return false;
	if (MATCH(statementcache, "player2:"))			return false;
	if (MATCH(statementcache, "player3:"))			return false;
	if (MATCH(statementcache, "player4:"))			return false;
	if (MATCH(statementcache, "player5:"))			return false;
	if (MATCH(statementcache, "player6:"))			return false;
	if (MATCH(statementcache, "player7:"))			return false;
	if (MATCH(statementcache, "player8:"))			return false;
	if (MATCH(statementcache, "player9:"))			return false;
	if (MATCH(statementcache, "player1-"))			return false;
	if (MATCH(statementcache, "player2-"))			return false;
	if (MATCH(statementcache, "player3-"))			return false;
	if (MATCH(statementcache, "player4-"))			return false;
	if (MATCH(statementcache, "player5-"))			return false;
	if (MATCH(statementcache, "player6-"))			return false;
	if (MATCH(statementcache, "player7-"))			return false;
	if (MATCH(statementcache, "player8-"))			return false;
	if (MATCH(statementcache, "playfield:"))		return false;
	if (MATCH(statementcache, "pfcolors:"))			return false;
	if (MATCH(statementcache, "scorecolors:"))		return false;
	if (MATCH(statementcache, "pfheights:"))		return false;
	if (MATCH(statementcache, "asm"))				return false;
	if (MATCH(statementcache, "pop"))				return false;
	if (MATCH(statementcache, "stack"))				return false;
	if (MATCH(statementcache, "push"))				return false;
	if (MATCH(statementcache, "pull"))				return false;
	if (MATCH(statementcache, "rem"))				return false;
	if (MATCH(statementcache, "next"))				return false;
	if (MATCH(statementcache, "reboot"))			return false;
	if (MATCH(statementcache, "return"))			return false;
	if (MATCH(statementcache, "callmacro"))			return false;
	if (statement[i + 1][0] == '=')					return false; // It's a variable assignment
	return true; // I really hope we've got a label !!!!
}

void sread(char **statement) {
	// read sequential data
	ap("LDX #%s", statement[6]);
	ap("LDA (0,x)");
	ap("INC 0,x");
	ap("BNE *+4");
	ap("INC 1,x");
	strcpy(Areg, "invalid");
}

void sdata(char **statement) {
	// sequential data, works like regular basics and doesn't have the 256 byte restriction
	char data[200];
	int i;
	removeCR(statement[4]);
	sprintf(redefined_variables[numredefvars++], "%s = %s", statement[2], statement[4]);
	ap("LDA #<%s_begin", statement[2]);
	ap("STA %s", statement[4]);
	ap("LDA #>%s_begin", statement[2]);
	ap("STA %s+1", statement[4]);

	ap("JMP .skip%s", statement[0]);
	// not affected by noinlinedata

	printf("%s_begin\n", statement[2]);
	while (1) {
		if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
			prerror("Error: Missing \"end\" keyword at end of data\n");
			exit(1);
		}
		line++;
		if (MATCH(data, "end")) break;
		remove_trailing_commas(data);
		for (i = 0; i < 200; ++i) {
			if ((int) data[i] > 32) break;
			if (((int) data[i] < 14) && ((int) data[i] != 9)) i = 200;
		}
		if (i < 200) ap(".byte %s", data);
	}
	printf(".skip%s\n", statement[0]);
}

void data(char **statement) {
	char data[200];
	char **data_length;
	char **deallocdata_length;
	int i, j;
	data_length = (char **) malloc(sizeof(char *) * 200);
	for (i = 0; i < 200; ++i) {
		data_length[i] = (char *) malloc(sizeof(char) * 200);
		for (j = 0; j < 200; ++j) data_length[i][j] = '\0';
	}
	deallocdata_length = data_length;
	removeCR(statement[2]);

	if (!(optimization & 4))
		ap("JMP .skip%s", statement[0]);

	// if optimization level >=4 then data cannot be placed inline with code!

	printf("%s\n", statement[2]);
	while (1) {
		if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
			prerror("Error: Missing \"end\" keyword at end of data\n");
			exit(1);
		}
		line++;
		if (MATCH(data, "end")) break;
		remove_trailing_commas(data);
		for (i = 0; i < 200; ++i) {
			if ((int) data[i] > 32) break;
			if (((int) data[i] < 14) && ((int) data[i] != 9)) i = 200;
		}
		if (i < 200) ap(".byte %s", data);
	}
	printf(".skip%s\n", statement[0]);
	strcpy(data_length[0], " ");
	strcpy(data_length[1], "const");
	sprintf(data_length[2], "%s_length", statement[2]);
	strcpy(data_length[3], "=");
	sprintf(data_length[4], ".skip%s-%s", statement[0], statement[2]);
	strcpy(data_length[5], "\n");
	data_length[6][0] = '\0';
	keywords(data_length);
	freemem(deallocdata_length);
}

void shiftdata(char **statement, int num) {
	int i, j;
	for (i = 199; i > num; i--)
		for (j = 0; j < 200; ++j)
			statement[i][j] = statement[i - 1][j];
}

void compressdata(char **statement, int num1, int num2) {
	int i, j;
	for (i = num1; i < 200 - num2; i++)
		for (j = 0; j < 200; ++j)
			statement[i][j] = statement[i + num2][j];
}

void ongoto(char **statement) {
	// warning!!! bankswitching not yet supported
	int k, i = 4;

	if (SMATCH(3, "gosub")) {
		ap("LDA #>(ongosub%d-1)", ongosub);
		ap("PHA");
		ap("LDA #<(ongosub%d-1)", ongosub);
		ap("PHA");
	}
	if (strcmp(statement[2], Areg))
		ap("LDX %s", statement[2]);
	//ap("ASL");
	//ap("TAX");
	ap("LDA .%sjumptablehi,x", statement[0]);
	ap("PHA");
	//ap("INX");
	ap("LDA .%sjumptablelo,x", statement[0]);
	ap("PHA");
	ap("RTS");
	printf(".%sjumptablehi\n", statement[0]);
	while (statement[i][0] != ':' && statement[i][0] != '\0') {
		for (k = 0; k < 200; ++k)
			if (statement[i][k] == '\n' || statement[i][k] == '\r')
				statement[i][k] = '\0';
		ap(".byte >(.%s-1)", statement[i++]);
	}
	printf(".%sjumptablelo\n", statement[0]);
	i = 4;
	while (statement[i][0] != ':' && statement[i][0] != '\0') {
		for (k = 0; k < 200; ++k)
			if (statement[i][k] == '\n' || statement[i][k] == '\r')
				statement[i][k] = '\0';
		ap(".byte <(.%s-1)", statement[i++]);
	}
	if (SMATCH(3, "gosub"))
		printf("ongosub%d\n", ongosub++);
}

void dofor(char **statement) {
	if (strcmp(statement[4], Areg)) {
		ap("LDA %s%s", immedtok(statement[4]), statement[4]);
	}

	ap("STA %s", statement[2]);

	forlabel[numfors][0] = '\0';
	sprintf(forlabel[numfors], "%sfor%s", statement[0], statement[2]);
	printf(".%s\n", forlabel[numfors]);

	forend[numfors][0] = '\0';
	strcpy(forend[numfors], statement[6]);

	forvar[numfors][0] = '\0';
	strcpy(forvar[numfors], statement[2]);

	forstep[numfors][0] = '\0';

	if (IMATCH(7, "step"))
		strcpy(forstep[numfors], statement[8]);
	else
		strcpy(forstep[numfors], "1");

	numfors++;
}

void next(char **statement) {
	int immed = 0;
	int immedend = 0;
	int failsafe = 0;
	char failsafelabel[200];

	invalidate_Areg();

	if (!numfors) {
		fprintf(stderr, "(%d) next without for\n", line);
		exit(1);
	}
	numfors--;
	if (!strncmp(forstep[numfors], "1\0", 2)) { // step 1
		ap("LDA %s", forvar[numfors]);
		ap("CMP %s%s", immedtok(forend[numfors]), forend[numfors]);
		ap("INC %s", forvar[numfors]);
		bcc(forlabel[numfors]);
	}
	else if (!strncmp(forstep[numfors], "-1\0", 3) || !strncmp(forstep[numfors], "255\0", 4)) { // step -1
		ap("DEC %s", forvar[numfors]);
		if (!MATCH(forend[numfors], "1")) {
			ap("LDA %s", forvar[numfors]);
			if (MATCH(forend[numfors], "0")) {
				// the special case of 0 as end, since we can't check to see if it was smaller than 0
				ap("CMP #255");
				bne(forlabel[numfors]);
			}
			else { // general case
				ap("CMP %s%s", immedtok(forend[numfors]), forend[numfors]);
				bcs(forlabel[numfors]);
			}
		}
		else
			bne(forlabel[numfors]);
	}
	else {		// step other than 1 or -1
		// normally, the generated code adds to or subtracts from the for variable, and checks
		// to see if it's less than the ending value.
		// however, if the step would make the variable less than zero or more than 255
		// then this check will not work.  The compiler will attempt to detect this situation
		// if the step and end are known.  If the step and end are not known (that is,
		// either is a variable) then much more complex code must be generated.

		ap("LDA %s", forvar[numfors]);
		ap("CLC");

		immed = isimmed(forstep[numfors]);
		ap("ADC %s%s", immedtok(forstep[numfors]), forstep[numfors]);

		if (immed && isimmed(forend[numfors])) {	// the step and end are immediate
			if (atoi(forstep[numfors]) & 128) {		// step is negative
				if ((256 - (atoi(forstep[numfors]) & 255)) >= atoi(forend[numfors])) {
					// if in danger of going < 0... have carry clear after ADC
					failsafe = 1;
					sprintf(failsafelabel, "%s_failsafe", forlabel[numfors]);
					bcc(failsafelabel);
				}
			}
			else {	// step is positive
				if ((atoi(forstep[numfors]) + atoi(forend[numfors])) > 255) {
					// if in danger of going > 255...have carry set after ADC
					failsafe = 1;
					sprintf(failsafelabel, "%s_failsafe", forlabel[numfors]);
					bcs(failsafelabel);
				}
			}

		}
		ap("STA %s", forvar[numfors]);

		immedend = isimmed(forend[numfors]);
		printf("\tCMP ");
		// add 1 to immediate compare for increasing loops
		if (immedend && !(atoi(forstep[numfors]) & 128))
			strcat(forend[numfors], "+1");
		printf("%s\n", forend[numfors]);

		// if step number is 1 to 127 then add 1 and use bcc, otherwise bcs
		// if step is a variable, we'll need to check for every loop iteration
		//
		// Warning! no failsafe checks with variables as step or end - it's the
		// programmer's job to make sure the end value doesn't overflow

		if (!immed) {
			ap("LDX %s", forstep[numfors]);
			ap("BMI .%sbcs", statement[0]);
			bcc(forlabel[numfors]);
			ap("CLC");
			printf(".%sbcs\n", statement[0]);
			bcs(forlabel[numfors]);
		}
		else if (atoi(forstep[numfors]) & 128)
			bcs(forlabel[numfors]);
		else {
			bcc(forlabel[numfors]);
			if (!immedend)
				beq(forlabel[numfors]);
		}
	}
	if (failsafe) printf(".%s\n", failsafelabel);
}

void dim(char **statement) {
	// just take the statement and pass it right to a header file
	int i;
	char *fixpointvar1;
	char fixpointvar2[50];
	// check for fixedpoint variables
	i = findpoint(statement[4]);
	if (i < 50) {
		removeCR(statement[4]);
		strcpy(fixpointvar2, statement[4]);
		fixpointvar1 = fixpointvar2 + i + 1;
		fixpointvar2[i] = '\0';
		if (!strcmp(fixpointvar1, fixpointvar2)) {	// 4.4 fixedpoint
			strcpy(fixpoint44[1][numfixpoint44], fixpointvar1);
			strcpy(fixpoint44[0][numfixpoint44++], statement[2]);
		}
		else {										// 8.8 fixedpoint
			strcpy(fixpoint88[1][numfixpoint88], fixpointvar1);
			strcpy(fixpoint88[0][numfixpoint88++], statement[2]);
		}
		statement[4][i] = '\0'; // terminate string at '.'
	}
	i = 2;
	redefined_variables[numredefvars][0] = '\0';
	while ((statement[i][0] != '\0') && (statement[i][0] != ':')) {
		strcat(redefined_variables[numredefvars], statement[i++]);
		strcat(redefined_variables[numredefvars], " ");
	}
	numredefvars++;
}

void doconst(char **statement) {
	// basically the same as dim, except we keep a queue of variable names that are constant
	int i = 2;
	redefined_variables[numredefvars][0] = '\0';
	while ((statement[i][0] != '\0') && (statement[i][0] != ':')) {
		strcat(redefined_variables[numredefvars], statement[i++]);
		strcat(redefined_variables[numredefvars], " ");
	}
	numredefvars++;
	strcpy(constants[numconstants++], statement[2]);    // record to queue
}


void doreturn(char **statement) {
	int index = 0;
	char getindex0[200];
	int bankedreturn = 0;
	// 0=no special action
	// 1=return thisbank
	// 2=return otherbank

	if (SMATCH(2, "thisbank") || SMATCH(3, "thisbank"))
		bankedreturn = 1;
	else if (SMATCH(2, "otherbank") || SMATCH(3, "otherbank"))
		bankedreturn = 2;

	// several types of returns:
	// return by itself (or with a value) can return to any calling bank
	// this one has the most overhead in terms of cycles and ROM space
	// use sparingly if cycles or space are an issue

	// return [value] thisbank will only return within the same bank
	// this one is the fastest

	// return [value] otherbank will slow down returns to the same bank
	// but speed up returns to other banks - use if you are primarily returning
	// across banks

	if (   statement[2][0]
		&& statement[2][0] != ' '
		&& !SMATCH(2, "thisbank")
		&& !SMATCH(2, "otherbank")
	) {
		index |= getindex(statement[2], &getindex0[0]);
		if (index & 1) loadindex(&getindex0[0]);
		char reg = (!bankedreturn && bs != 64) ? 'Y' : 'A';
		ap("LD%c %s", reg, indexpart(statement[2], index & 1));
	}

	if (bankedreturn == 1) { ap("RTS"); return; }
	if (bankedreturn == 2) { ap("JMP BS_return"); return; }

	if (bs) {		// check if sub was called from the same bank
		if (bs == 64) {
			// for 64kb carts, the onus is on the user to use "return otherbank" from bankswitch gosubs.
			// if we're here, we assume that it was from a non-bankswitched gosub.
			ap("RTS");
			return;
		}
		else {
			ap("TSX");
			ap("LDA 2,x ; check return address");
			ap("EOR #(>*) ; vs. current PCH");
			ap("AND #$E0 ;  mask off all but top 3 bits");
		}

		// if zero, then banks are the same
		if (statement[2][0] && (statement[2][0] != ' ')) {
			ap("BEQ *+6 ; if equal, do normal return");
			ap("TYA");
		}
		else
			ap("BEQ *+5 ; if equal, do normal return");
		ap("JMP BS_return");
	}

	if (statement[2][0] && (statement[2][0] != ' '))
		ap("TYA");
	ap("RTS");
}

void pfread(char **statement) {
	char getindex0[200];
	char getindex1[200];

	invalidate_Areg();

	int index = getindex(statement[3], &getindex0[0]) | getindex(statement[4], &getindex1[0]) << 1;

	if (bs == 28) {
		ap("LDA #<C_function");
		ap("STA DF0LOW");
		ap("LDA #(>C_function) & $0F");
		ap("STA DF0HI");
		ap("LDA #24");
		ap("STA DF0WRITE");
	}

	if (index & 1) loadindex(&getindex0[0]);

	ap("LDA %s", indexpart(statement[4], index & 1));
	if (bs == 28) ap("STA DF0WRITE");

	if (index & 2) loadindex(&getindex1[0]);

	ap("LDY %s", indexpart(statement[6], index & 2));
	if (bs != 28)
		jsr("pfread");
	else {
		ap("STY DF0WRITE");
		ap("LDA #255");
		ap("STA CALLFUNCTION");
		ap("LDA DF0DATA");
	}
}

void pfpixel(char **statement) {
	char getindex0[200];
	char getindex1[200];
	int on_off_flip = 0;
	int index = 0;
	if (multisprite == 1) {
		prerror("Error: pfpixel not supported in multisprite kernel\n");
		exit(1);
	}
	invalidate_Areg();

	index |= getindex(statement[2], &getindex0[0]);
	index |= getindex(statement[3], &getindex1[0]) << 1;

	if (bs == 28) {		// DPC+
		ap("LDA #<C_function");
		ap("STA DF0LOW");
		ap("LDA #(>C_function) & $0F");
		ap("STA DF0HI");
	}

	if      (!strncmp(statement[4], "flip", 2))	on_off_flip = 2; // Allow 'fl'
	else if (!strncmp(statement[4], "off", 2))	on_off_flip = 1; // Allow 'of'
	ap("LDX #%d", on_off_flip | (bs == 28 ? 12 : 0));
	if (bs == 28) {
		ap("STX DF0WRITE");
		ap("STX DF0WRITE");
	}

	if (index & 2) loadindex(&getindex1[0]);
	ap("LDY %s", indexpart(statement[3], index & 2));
	if (bs == 28) ap("STY DF0WRITE");

	if (index & 1) loadindex(&getindex0[0]);
	ap("LDA %s", indexpart(statement[2], index & 1));
	if (bs == 28) ap("STA DF0WRITE");

	if (bs == 28) {
		ap("LDA #255");
		ap("STA CALLFUNCTION");
	}
	else
		jsr("pfpixel");
}

void pfhline(char **statement) {
	char getindex0[200];
	char getindex1[200];
	char getindex2[200];
	int on_off_flip = 0;
	int index = 0;
	if (multisprite == 1) {
		prerror("Error: pfhline not supported in multisprite kernel\n");
		exit(1);
	}

	invalidate_Areg();

	if (bs == 28) { // DPC+
		ap("LDA #<C_function");
		ap("STA DF0LOW");
		ap("LDA #(>C_function) & $0F");
		ap("STA DF0HI");
	}

	index |= getindex(statement[2], &getindex0[0]);
	index |= getindex(statement[3], &getindex1[0]) << 1;
	index |= getindex(statement[4], &getindex2[0]) << 2;

	if      (!strncmp(statement[4], "flip", 2))	on_off_flip = 2; // Allow 'fl'
	else if (!strncmp(statement[4], "off", 2))	on_off_flip = 1; // Allow 'of'
	ap("LDX #%d", on_off_flip | (bs == 28 ? 8 : 0));
	if (bs == 28) ap("STX DF0WRITE");

	if (index & 4) loadindex(&getindex2[0]);
	ap("LDA %s", indexpart(statement[4], index & 4));
	ap("STA %s", bs == 28 ? "DF0WRITE" : "temp3");

	if (index & 2) loadindex(&getindex1[0]);
	ap("LDY %s", indexpart(statement[3], index & 2));
	if (bs == 28) ap("STY DF0WRITE");

	if (index & 1) loadindex(&getindex0[0]);
	ap("LDA %s", indexpart(statement[2], index & 1));
	if (bs == 28) ap("STA DF0WRITE");

	if (bs == 28) {
		ap("STA DF0WRITE");
		ap("LDA #255");
		ap("STA CALLFUNCTION");
	}
	else
		jsr("pfhline");
}

void pfvline(char **statement) {
	char getindex0[200];
	char getindex1[200];
	char getindex2[200];
	int index = 0;
	int on_off_flip = 0;
	if (multisprite == 1) {
		prerror("Error: pfvline not supported in multisprite kernel\n");
		exit(1);
	}

	invalidate_Areg();

	if (bs == 28) {		// DPC+
		ap("LDA #<C_function");
		ap("STA DF0LOW");
		ap("LDA #(>C_function) & $0F");
		ap("STA DF0HI");
	}

	index |= getindex(statement[2], &getindex0[0]);
	index |= getindex(statement[3], &getindex1[0]) << 1;
	index |= getindex(statement[4], &getindex2[0]) << 2;

	if      (!strncmp(statement[4], "flip", 2))	on_off_flip = 2; // Allow 'fl'
	else if (!strncmp(statement[4], "off", 2))	on_off_flip = 1; // Allow 'of'
	ap("LDX #%d", on_off_flip | (bs == 28 ? 4 : 0));
	if (bs == 28) ap("STX DF0WRITE");

	if (index & 4) loadindex(&getindex2[0]);
	ap("LDA %s", indexpart(statement[4], index & 4));
	ap("STA %s", bs == 28 ? "DF0WRITE" : "temp3");

	if (index & 2) loadindex(&getindex1[0]);
	ap("LDY %s", indexpart(statement[3], index & 2));
	if (bs == 28) ap("STY DF0WRITE");

	if (index & 1) loadindex(&getindex0[0]);
	ap("LDA %s", indexpart(statement[2], index & 1));
	if (bs == 28) ap("STA DF0WRITE");

	if (bs == 28) {
		ap("LDA #255");
		ap("STA CALLFUNCTION");
	}
	else
		jsr("pfvline");
}

void pfscroll(char **statement) {
	invalidate_Areg();
	if (bs == 28) {
		//DPC+ version of function uses the syntax: pfscroll #LINES [start queue#] [end queue#]
		if (SMATCH(2, "up") || SMATCH(2, "down") || SMATCH(2, "right") || SMATCH(2, "left")) {
			fprintf(stderr, "(%d) pfscroll for DPC+ doesn't use up/down/left/right. try a value or variable instead.\n", line);
			exit(1);
		}
		ap("LDA #<C_function");
		ap("STA DF0LOW");
		ap("LDA #(>C_function) & $0F");
		ap("STA DF0HI");

		ap("LDA #32");
		ap("STA DF0WRITE");

		if (ISNUM(statement[2][0]))
			ap("LDA #%s", statement[2]);
		else
			ap("LDA %s", statement[2]);
		ap("STA DF0WRITE");

		if ((statement[3][0] >= '0') && (statement[3][0] <= '6')) {
			if ((statement[4][0] >= '0') && (statement[4][0] <= '6')) {
				ap("LDA #%d", statement[3][0] - '0');
				ap("STA DF0WRITE");
				ap("LDA #%d", statement[4][0] - '0' + 1);
				ap("STA DF0WRITE");
			}
			else {
				fprintf(stderr, "(%d) initial queue provided for DPC+ pfscroll, but invalid end queue was provided.\n", line);
				exit(1);
			}
		}
		else {
			// The default is to scroll all playfield columns, without color scrolling
			ap("LDA #0");
			ap("STA DF0WRITE");
			ap("LDA #4");
			ap("STA DF0WRITE");
		}

		ap("LDA #255");
		ap("STA CALLFUNCTION");
		return;
	}
	if (multisprite == 1) {
		int acc = 0;
		if      (SMATCH(2, "up")) acc = 0;
		else if (!strncmp(statement[2], "down", 2)) acc = 1; // Allow 'do'
		else {
			fprintf(stderr, "(%d) pfscroll direction unknown in multisprite kernel\n", line);
			exit(1);
		}
		ap("LDA #%d", acc);
	}
	else {
		int acc = 0;
		if      (!strncmp(statement[2], "left", 2))		acc = 0; // Allow 'le'
		else if (!strncmp(statement[2], "right", 2))	acc = 1; // Allow 'ri'
		else if (SMATCH(2, "upup"))						acc = 6;
		else if (!strncmp(statement[2], "downdown", 6))	acc = 8; // Allow 'downdo'
		else if (SMATCH(2, "up"))						acc = 2;
		else if (!strncmp(statement[2], "down", 2))		acc = 4; // Allow 'do'
		else {
			fprintf(stderr, "(%d) pfscroll direction unknown\n", line);
			exit(1);
		}
		ap("LDA #%d", acc);
	}
	jsr("pfscroll");
}

void doasm() {
	char data[200];
	while (1) {
		if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
			prerror("Error: Missing \"end\" keyword at end of inline asm\n");
			exit(1);
		}
		line++;
		if (MATCH(data, "end")) break;
		printf("%s\n", data);
	}
}

void domacro(char **statement) {
	int k, j = 1, i = 3;
	macroactive = 1;
	printf(" MAC %s\n", statement[2]);

	while (statement[i][0] != ':' && statement[i][0] != '\0') {
		for (k = 0; k < 200; ++k)
			if (statement[i][k] == '\n' || statement[i][k] == '\r')
				statement[i][k] = '\0';
		if (SMATCH(i, "const"))
			strcpy(constants[numconstants++], statement[i + 1]);        // record to const queue
		else
			printf("%s SET {%d}\n", statement[i], j++);
		i++;
	}
}

void callmacro(char **statement) {
	int k, i = 3;
	macroactive = 1;
	printf(" %s", statement[2]);

	while (statement[i][0] != ':' && statement[i][0] != '\0') {
		for (k = 0; k < 200; ++k)
			if (statement[i][k] == '\n' || statement[i][k] == '\r')
				statement[i][k] = '\0';
		printf(" %s%s,", immedtok(statement[i]), statement[i]); // Assume the assembler doesn't mind extra commas
		i++;
	}
	printf("\n");
}

void doextra(char *extrano) {
	extraactive = 1;
	printf("extra set %d\n", ++extra);
	//printf(".extra%c",extrano[5]);
	//if (extrano[6]!=':') printf("%c",extrano[6]);
	//printf("\n");
	printf(" MAC extra%c", extrano[5]);
	if (extrano[6] != ':') printf("%c", extrano[6]);
	printf("\n");
}

void doend() {
	if (extraactive) {
		printf(" ENDM\n");
		extraactive = 0;
	}
	else if (macroactive) {
		printf(" ENDM\n");
		macroactive = 0;
	}
	else
		prerror("extraneous end statement found");
}

void player(char **statement) {
	int height = 0, i = 0;      // calculating sprite height
	int doingcolor = 0;         // doing player colors?
	char label[200];
	char j;
	char data[200];
	char pl = statement[1][6];
	int heightrecord;
	if (statement[1][7] == 'c') doingcolor = 1;
	if ((statement[1][7] == '-') && (statement[1][9] == 'c')) doingcolor = 1;
	if (!doingcolor)
		sprintf(label, "player%s_%c\n", statement[0], pl);
	else
		sprintf(label, "playercolor%s_%c\n", statement[0], pl);
	removeCR(label);
	if ((multisprite == 2) && (pl != '0')) {
		ap("LDA #<(playerpointers+%d)", (pl - 49) * 2 + 18 * doingcolor);
		ap("STA DF0LOW");
		ap("LDA #(>(playerpointers+%d)) & $0F", (pl - 49) * 2 + 18 * doingcolor);
		ap("STA DF0HI");
	}
	ap("LDX #<%s", label);
	if ((multisprite == 2) && (pl != '0'))
		ap("STX DF0WRITE");
	else {
		if (doingcolor)
			ap("STX player%ccolor", pl);
		else
			ap("STX player%cpointerlo", pl);
	}
	if (multisprite == 2)
		ap("LDA #((>%s) & $0f) | (((>%s) / 2) & $70)", label, label);     // DPC+
	else
		ap("LDA #>%s", label);
	if ((multisprite == 2) && (pl != '0'))
		ap("STA DF0WRITE");
	else {
		if (doingcolor)
			ap("STA player%ccolor+1", pl);
		else
			ap("STA player%cpointerhi", pl);
	}
	if ((statement[1][7] == '-') && (multisprite == 2) && (pl != '0')) {	// multiple players
		for (j = statement[1][6] + 1; j <= statement[1][8]; j++) {
			ap("STX DF0WRITE");
			ap("STA DF0WRITE");	// creates multiple "copies" of single sprite
		}
	}

	//ap("JMP .%sjump%c",statement[0],pl);

	// insert DASM stuff to prevent page-wrapping of player data
	// stick this in a data file instead of displaying

	if (multisprite != 2) { // DPC+ has no pages to wrap
		heightrecord = sprite_index++;
		sprite_index += 2;
		// record index for creation of the line below
	}
	if (multisprite == 1) {
		sprintf(sprite_data[sprite_index++], " if (<*) < 90\n");        // is 90 enough? could this be the cause of page wrapping issues at the bottom of the screen?
		// This is potentially wasteful, therefore the user now has an option to use this space for data or code
		// (Not an ideal way, but a way nonetheless)
		if (optimization & 2) {
			sprintf(sprite_data[sprite_index++], "extralabel%d\n", extralabel);
			sprintf(sprite_data[sprite_index++], " ifconst extra\n");
			for (i = 4; i >= 0; i--) {
				if (i == 4)
					sprintf(sprite_data[sprite_index++], " if (extra > %d)\n", i);
				else
					sprintf(sprite_data[sprite_index++], " else\n if (extra > %d)\n", i);
				sprintf(sprite_data[sprite_index++], "extra set extra-1\n");
				sprintf(sprite_data[sprite_index++], " extra%d\n", i);
			}
			sprintf(sprite_data[sprite_index++], " endif\n endif\n endif\n endif\n endif\n endif\n");

			sprintf(sprite_data[sprite_index++], " echo [90-(<*)]d,\"bytes found in extra%d", extralabel);
			sprintf(sprite_data[sprite_index++], " (\",[(*-extralabel%d)]d,\"used)\"\n", extralabel++);
			sprintf(sprite_data[sprite_index++], " if (<*) < 90\n");    // do it again
		}
		sprintf(sprite_data[sprite_index++], "  repeat (90-<*)\n\t.byte 0\n");
		sprintf(sprite_data[sprite_index++], "  repend\n        endif\n");
		if (optimization & 2)
			sprintf(sprite_data[sprite_index++], "      endif\n");
	}                           // potential bug: should this go after the below page wrapping stuff to prevent possible issues?

	sprintf(sprite_data[sprite_index++], "%s\n", label);
	if (multisprite == 1 && pl == '0')
		sprintf(sprite_data[sprite_index++], "\t.byte 0\n");

	while (1) {
		if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
			prerror("Error: Missing \"end\" keyword at end of player declaration\n");
			exit(1);
		}
		line++;
		if (MATCH(data, "end")) break;
		height++;
		sprintf(sprite_data[sprite_index++], "\t.byte %s", data);
	}

	if (multisprite == 1 && pl == '0')
		height++;

	// record height and add page-wrap prevention
	if (multisprite != 2) { // DPC+ has no pages to wrap
		sprintf(sprite_data[heightrecord], " if (<*) > (<(*+%d))\n", height - 1);       //+1);
		sprintf(sprite_data[heightrecord + 1], "        repeat ($100-<*)\n\t.byte 0\n");
		sprintf(sprite_data[heightrecord + 2], "        repend\n        endif\n");
	}
	if (multisprite == 1 && pl == '0') height--;

	//printf(".%sjump%c\n",statement[0],pl);
	if (multisprite == 1)
		ap("LDA #%d", height + 1);        // 2);
	else if ((multisprite == 2) && (!doingcolor))
		ap("LDA #%d", height);
	else if (!doingcolor)
		ap("LDA #%d", height - 1);        // added - 1);

	if (!doingcolor)
		ap("STA player%cheight", pl);

	if ((statement[1][7] == '-') && (multisprite == 2) && (pl != '0')) { // multiple players
		for (j = statement[1][6] + 1; j <= statement[1][8]; j++) {
			if (!doingcolor)
				ap("STA player%cheight", j);
		}
	}
}

void lives(char **statement) {
	int i = 0;
	char label[200];
	char data[200];
	if (!lifekernel) {
		lifekernel = 1;
		//strcpy(redefined_variables[numredefvars++],"lifekernel = 1");
	}

	sprintf(label, "lives__%s\n", statement[0]);
	removeCR(label);

	ap("LDA #<%s", label);
	ap("STA lifepointer");
	ap("LDA lifepointer+1");
	ap("AND #$E0");
	ap("ORA #(>%s)&($1F)", label);
	ap("STA lifepointer+1");

	sprintf(sprite_data[sprite_index++], " if (<*) > (<(*+8))\n");
	sprintf(sprite_data[sprite_index++], "      repeat ($100-<*)\n\t.byte 0\n");
	sprintf(sprite_data[sprite_index++], "      repend\n        endif\n");

	sprintf(sprite_data[sprite_index++], "%s\n", label);

	for (i = 0; i < 9; ++i) {
		if ((!fgets(data, sizeof(data), stdin) || ISNUM(data[0])) && data[0] != 'e') {
			prerror("Error: Not enough data or missing \"end\" keyword at end of lives declaration\n");
			exit(1);
		}
		line++;
		if (MATCH(data, "end")) break;
		sprintf(sprite_data[sprite_index++], "\t.byte %s", data);
	}
}

int check_colls(char *statement) {
	int bit;
	if      (MATCH(statement, "collision(missile0,player1)"))	{ bit = 7; printf("CXM0P"); }
	else if (MATCH(statement, "collision(missile0,player0)"))	{ bit = 6; printf("CXM0P"); }
	else if (MATCH(statement, "collision(missile1,player0)"))	{ bit = 7; printf("CXM1P"); }
	else if (MATCH(statement, "collision(missile1,player1)"))	{ bit = 6; printf("CXM1P"); }
	else if (MATCH(statement, "collision(player0,playfield)"))	{ bit = 7; printf("CXP0FB"); }
	else if (MATCH(statement, "collision(player0,ball)"))		{ bit = 6; printf("CXP0FB"); }
	else if (MATCH(statement, "collision(player1,playfield)"))	{ bit = 7; printf("CXP1FB"); }
	else if (MATCH(statement, "collision(player1,ball)"))		{ bit = 6; printf("CXP1FB"); }
	else if (MATCH(statement, "collision(missile0,playfield)"))	{ bit = 7; printf("CXM0FB"); }
	else if (MATCH(statement, "collision(missile0,ball)"))		{ bit = 6; printf("CXM0FB"); }
	else if (MATCH(statement, "collision(missile1,playfield)"))	{ bit = 7; printf("CXM1FB"); }
	else if (MATCH(statement, "collision(missile1,ball)"))		{ bit = 6; printf("CXM1FB"); }
	else if (MATCH(statement, "collision(ball,playfield)"))		{ bit = 7; printf("CXBLPF"); }
	else if (MATCH(statement, "collision(player0,player1)"))	{ bit = 7; printf("CXPPMM"); }
	else if (MATCH(statement, "collision(missile0,missile1)"))	{ bit = 6; printf("CXPPMM"); }

	// now repeat everything in reverse...

	else if (MATCH(statement, "collision(player1,missile0)"))	{ bit = 7; printf("CXM0P"); }
	else if (MATCH(statement, "collision(player0,missile0)"))	{ bit = 6; printf("CXM0P"); }
	else if (MATCH(statement, "collision(player0,missile1)"))	{ bit = 7; printf("CXM1P"); }
	else if (MATCH(statement, "collision(player1,missile1)"))	{ bit = 6; printf("CXM1P"); }
	else if (MATCH(statement, "collision(playfield,player0)"))	{ bit = 7; printf("CXP0FB"); }
	else if (MATCH(statement, "collision(ball,player0)"))		{ bit = 6; printf("CXP0FB"); }
	else if (MATCH(statement, "collision(playfield,player1)"))	{ bit = 7; printf("CXP1FB"); }
	else if (MATCH(statement, "collision(ball,player1)"))		{ bit = 6; printf("CXP1FB"); }
	else if (MATCH(statement, "collision(playfield,missile0)"))	{ bit = 7; printf("CXM0FB"); }
	else if (MATCH(statement, "collision(ball,missile0)"))		{ bit = 6; printf("CXM0FB"); }
	else if (MATCH(statement, "collision(playfield,missile1)"))	{ bit = 7; printf("CXM1FB"); }
	else if (MATCH(statement, "collision(ball,missile1)"))		{ bit = 6; printf("CXM1FB"); }
	else if (MATCH(statement, "collision(playfield,ball)"))		{ bit = 7; printf("CXBLPF"); }
	else if (MATCH(statement, "collision(player1,player0)"))	{ bit = 7; printf("CXPPMM"); }
	else if (MATCH(statement, "collision(missile1,missile0)"))	{ bit = 6; printf("CXPPMM"); }
	return bit;
}

void scorecolors(char **statement) {
	int i = 0;  //height can change
	char data[200];
	ap("LDA #<scoredata");
	ap("STA DF0LOW");

	ap("LDA #((>scoredata) & $0f)");
	ap("STA DF0HI");
	for (i = 0; i < 9; ++i) {
		if (!fgets(data, sizeof(data), stdin)) {
			prerror("Error: Not enough data for scorecolor declaration\n");
			exit(1);
		}
		line++;
		if (MATCH(data, "end")) break;
		if (i == 8) {
			prerror("Error: Missing \"end\" keyword at end of scorecolor declaration\n");
			exit(1);
		}
		ap("LDA %s%s", immedtok(data), data);
		ap("STA DF0WRITE");
	}
}

void doif(char **statement) {
	int index = 0;
	int situation = 0;
	char getindex0[200];
	char getindex1[200];
	int not = 0;
	int complex_boolean = 0;
	int i, j, k, h;
	int push1 = 0;
	int push2 = 0;
	int bit = 0;
	int Aregmatch = 0;
	char Aregcopy[200];
	char **cstatement;          //conditional statement
	char **dealloccstatement;   //for deallocation

	strcpy(Aregcopy, "index-invalid");

	cstatement = (char **) malloc(sizeof(char *) * 200);
	for (k = 0; k < 200; ++k)
		cstatement[k] = (char *) malloc(sizeof(char) * 200);
	dealloccstatement = cstatement;
	for (k = 0; k < 200; ++k)
		for (j = 0; j < 200; ++j)
			cstatement[j][k] = '\0';
	if (statement[2][0] == '!' && statement[2][1] != '\0') {
		not = 1;
		for (i = 0; i < 199; ++i)
			statement[2][i] = statement[2][i + 1];
	}
	else if (!strncmp(statement[2], "!\0", 2)) {
		not = 1;
		compressdata(statement, 2, 1);
	}

	if (statement[2][0] == '(') {
		j = 0;
		k = 0;
		for (i = 2; i < 199; ++i) {
			if (statement[i][0] == '(') j++;
			if (statement[i][0] == ')') j--;
			if (statement[i][0] == '<') break;
			if (statement[i][0] == '>') break;
			if (statement[i][0] == '=') break;
			if (statement[i][0] == '&' && statement[i][1] == '\0')
				k = j;
			if (SMATCH(i, "then")) {
				complex_boolean = 1;
				break;
			}                   //prerror("Complex boolean not yet supported\n");exit(1);}
		}
		if (i == 199 && k) j = k;
		if (j) {
			compressdata(statement, 2, 1);      //remove first parenthesis
			for (i = 2; i < 199; ++i)
				if (SMATCH(i, "then") || SMATCH(i, "&&") || SMATCH(i, "||"))
					break;
			if (i != 199) {
				if (statement[i - 1][0] != ')') {
					prerror("Unbalanced parentheses in if-then\n");
					exit(1);
				}
				compressdata(statement, i - 1, 1);
			}
		}
	}

	if (SMATCH(2, "joy") || SMATCH(2, "switch")) {
		i = switchjoy(statement[2]);
		if (islabel(statement)) {
			switch (i) {
				case 0: if (not) bne(statement[4]); else beq(statement[4]); break;
				case 1: if (not) bvs(statement[4]); else bvc(statement[4]); break;
				case 2: if (not) bmi(statement[4]); else bpl(statement[4]); break;
			}
			freemem(dealloccstatement);
			return;
		}
		else {					// then statement
			char *op = NULL;
			switch (i) {
				case 0: op = not ? "BEQ" : "BNE"; break;
				case 1: op = not ? "BVC" : "BVS"; break;
				case 2: op = not ? "BPL" : "BMI"; break;
			}
			ap("%s .skip%s", op, statement[0]);
			// separate statement
			for (i = 3; i < 200; ++i) {
				for (k = 0; k < 200; ++k) {
					cstatement[i - 3][k] = statement[i][k];
				}
			}
			printf(".condpart%d\n", condpart++);
			keywords(cstatement);
			printf(".skip%s\n", statement[0]);
			freemem(dealloccstatement);
			return;
		}
	}

	if (SMATCH(2, "pfread")) {
		pfread(statement);
		if (islabel(statement)) {
			if (not)
				bne(statement[9]);
			else
				beq(statement[9]);
			freemem(dealloccstatement);
			return;
		}
		else {		// then statement
			ap("%s .skip%s", not ? "BEQ" : "BNE", statement[0]);
			// separate statement
			for (i = 8; i < 200; ++i) {
				for (k = 0; k < 200; ++k) {
					cstatement[i - 8][k] = statement[i][k];
				}
			}
			printf(".condpart%d\n", condpart++);
			keywords(cstatement);
			printf(".skip%s\n", statement[0]);
			freemem(dealloccstatement);
			return;
		}
	}

	if (SMATCH(2, "collision(")) {
		if (   SMATCH(2, "collision(player")
			&& (MATCH(statement[2] + 17, ",player") || MATCH(statement[2] + 17, ",_player"))
			&& bs == 28
		) {
			// DPC+ custom collision
			if (statement[2][16] + statement[2][24] != '0' + '1') {
				ap("LDA #<C_function");
				ap("STA DF0LOW");
				ap("LDA #(>C_function) & $0F");
				ap("STA DF0HI");
				ap("LDA #20");
				ap("STA DF0WRITE");
				ap("LDA #%c", statement[2][16]);
				ap("STA DF0WRITE");
				ap("LDA #%c", statement[2][statement[2][24] == 'r' ? 25 : 24]);
				ap("STA DF0WRITE");
				ap("LDA #255");
				ap("STA CALLFUNCTION");
				ap("BIT DF0DATA");
				bit = 7;
			}
		}

		if (!bit) {
			printf("\tBIT ");
			bit = check_colls(statement[2]);
			printf("\n");
		}
		if (!bit) {		// Error
			fprintf(stderr, "(%d) Error: Unknown collision type: %s\n", line, statement[2] + 9);
			exit(1);
		}

		if (islabel(statement)) {
			if (!not) { if (bit == 7) bmi(statement[4]); else bvs(statement[4]); }
			else      { if (bit == 7) bpl(statement[4]); else bvc(statement[4]); }
			//{if (bit==7) printf("\tBMI "); else printf("\tBVS ");}
			//      else {if (bit==7) printf("\tBPL "); else printf("\tBVC ");}
			//      printf(".%s\n",statement[4]);
			freemem(dealloccstatement);
			return;
		}
		else {		// then statement
			char *op;
			if (not) op = (bit == 7) ? "BMI" : "BVS";
			else     op = (bit == 7) ? "BPL" : "BVC";
			ap("%s .skip%s", op, statement[0]);

			// separate statement
			for (i = 3; i < 200; ++i) {
				for (k = 0; k < 200; ++k) {
					cstatement[i - 3][k] = statement[i][k];
				}
			}
			printf(".condpart%d\n", condpart++);
			keywords(cstatement);
			printf(".skip%s\n", statement[0]);

			freemem(dealloccstatement);
			return;
		}
	}

	// check for array, e.g. x{1} to get bit 1 of x
	for (i = 3; i < 200; ++i) {
		if (statement[2][i] == '\0') { i = 200; break; }
		if (statement[2][i] == '}') break;
	}
	if (i < 200) {		// found array
		// extract expression in parantheses - for now just whole numbers allowed
		bit = (int) statement[2][i - 1] - '0';
		if ((bit > 9) || (bit < 0)) {
			fprintf(stderr, "(%d) Error: variables in bit access not supported\n", line);
			exit(1);
		}
		if ((bit == 7) || (bit == 6)) { // if bit 6 or 7, we can use BIT and save 2 bytes
			printf("\tBIT ");
			for (i = 0; i < 200; ++i) {
				if (statement[2][i] == '{') break;
				printf("%c", statement[2][i]);
			}
			printf("\n");
			if (islabel(statement)) {
				if (!not) {
					if (bit == 7) bmi(statement[4]); else bvs(statement[4]);
				}
				else {
					if (bit == 7) bpl(statement[4]); else bvc(statement[4]);
				}
				freemem(dealloccstatement);
				return;
			}
			else {	// then statement
				char *op;
				if (not) op = (bit == 7) ? "BMI" : "BVS";
				else     op = (bit == 7) ? "BPL" : "BVC";
				ap("%s .skip%s", op, statement[0]);

				// separate statement
				for (i = 3; i < 200; ++i) {
					for (k = 0; k < 200; ++k) {
						cstatement[i - 3][k] = statement[i][k];
					}
				}
				printf(".condpart%d\n", condpart++);
				keywords(cstatement);
				printf(".skip%s\n", statement[0]);

				freemem(dealloccstatement);
				return;
			}
		}
		else {
			Aregmatch = 0;
			printf("\tLDA ");
			for (i = 0; i < 200; ++i) {
				if (statement[2][i] == '{') break;
				printf("%c", statement[2][i]);
			}
			printf("\n");
			if (!bit)           // if bit 0, we can use LSR and save a byte
				ap("LSR");
			else
				ap("AND #%d", 1 << bit);  //(int)pow(2,bit));

			if (islabel(statement)) {
				if (not) {
					if (!bit) bcc(statement[4]); else beq(statement[4]);
				}
				else {
					if (!bit) bcs(statement[4]); else bne(statement[4]);
				}
			}
			else {		// then statement
				char *op;
				if (not) op = bit ? "BNE" : "BCS";
				else     op = bit ? "BEQ" : "BCC";
				ap("%s .skip%s", op, statement[0]);

				// separate statement
				for (i = 3; i < 200; ++i) {
					for (k = 0; k < 200; ++k) {
						cstatement[i - 3][k] = statement[i][k];
					}
				}
				printf(".condpart%d\n", condpart++);
				keywords(cstatement);
				printf(".skip%s\n", statement[0]);

			}
			freemem(dealloccstatement);
			return;
		}
	}

	// generic if-then (no special considerations)
	//check for [indexing]
	strcpy(Aregcopy, statement[2]);
	if (!strcmp(statement[2], Areg)) Aregmatch = 1; // Already have the correct value in A?

	for (i = 3; i < 200; ++i)
		if (SMATCH(i, "then") || SMATCH(i, "&&") || SMATCH(i, "||"))
			break;

	j = 0;
	for (k = 3; k < i; ++k) {
		if (statement[k][0] == '&' && statement[k][1] == '\0')
			j = k;
		if ((statement[k][0] == '<') || (statement[k][0] == '>') || (statement[k][0] == '='))
			break;
	}
	if ((k == i) && j) k = j; // special case of & for efficient code

	if (complex_boolean || (k == i && i > 4)) {
		// complex boolean found
		// assign value to contents, reissue statement as boolean
		strcpy(cstatement[2], "Areg");
		strcpy(cstatement[3], "=");
		for (j = 2; j < i; ++j)
			strcpy(cstatement[j + 2], statement[j]);

		dolet(cstatement);

		if (islabel(statement)) {	// then linenumber
			if (not)
				beq(statement[i + 1]);
			else
				bne(statement[i + 1]);
		}
		else {						// then statement
			// first, take negative of condition and branch around statement
			j = i;
			ap("%s .skip%s\n", not ? "BNE" : "BEQ", statement[0]);

			// separate statement
			for (i = j; i < 200; ++i) {
				for (k = 0; k < 200; ++k) {
					cstatement[i - j][k] = statement[i][k];
				}
			}
			printf(".condpart%d\n", condpart++);
			keywords(cstatement);
			printf(".skip%s\n", statement[0]);
		}

		Aregmatch = 0;
		freemem(dealloccstatement);
		return;
	}
	else if (((k < i) && (i - k != 2)) || ((k < i) && (k > 3))) {
		printf("; complex condition detected\n");
		// complex statements will be changed to assignments and reissued as assignments followed by a simple compare
		// i=location of then
		// k=location of conditional operator
		// if is at 2
		if (not) {
			// handle =, <, <=, >, >=, <>
			// (& handled later)
			if (CMATCH(k, '=')) {
				statement[3][0] = '<';  // force beq/bne below
				statement[3][1] = '>';
				statement[3][2] = '\0';
			}
			else if (SMATCH(k, "<>")) {
				statement[3][0] = '=';  // force beq/bne below
				statement[3][1] = '\0';
			}
			else if (SMATCH(k, "<=")) {
				statement[3][0] = '>';  // force beq/bne below
				statement[3][1] = '\0';
			}
			else if (SMATCH(k, ">=")) {
				statement[3][0] = '<';  // force beq/bne below
				statement[3][1] = '\0';
			}
			else if (CMATCH(k, '<')) {
				statement[3][0] = '>';  // force beq/bne below
				statement[3][1] = '=';
				statement[3][2] = '\0';
			}
			else if (CMATCH(k, '<')) {
				statement[3][0] = '>';  // force beq/bne below
				statement[3][1] = '=';
				statement[3][2] = '\0';
			}
		}
		if (k > 4)      push1 = 1;	// first statement is complex
		if (i - k != 2) push2 = 1;	// second statement is complex

		// <, >=, &, = do not swap
		// > or <= swap

		if (push1 == 1 && push2 == 1 && strncmp(statement[k], ">\0", 2) && !SMATCH(k, "<=")) {
			// Assign to Areg and push
			strcpy(cstatement[2], "Areg");
			strcpy(cstatement[3], "=");
			for (j = 2; j < k; ++j) {
				for (h = 0; h < 200; ++h) {
					cstatement[j + 2][h] = statement[j][h];
				}
			}
			dolet(cstatement);
			ap("PHA");
			// second statement:
			strcpy(cstatement[2], "Areg");
			strcpy(cstatement[3], "=");
			for (j = k + 1; j < i; ++j) {
				for (h = 0; h < 200; ++h) {
					cstatement[j - k + 3][h] = statement[j][h];
				}
			}
			dolet(cstatement);
			ap("PHA");
			situation = 1;
		}
		else if (push1 == 1 && push2 == 1) {	// two pushes plus swaps
			// second statement first:
			strcpy(cstatement[2], "Areg");
			strcpy(cstatement[3], "=");
			for (j = k + 1; j < i; ++j) {
				for (h = 0; h < 200; ++h) {
					cstatement[j - k + 3][h] = statement[j][h];
				}
			}
			dolet(cstatement);
			ap("PHA");

			// first statement second
			strcpy(cstatement[2], "Areg");
			strcpy(cstatement[3], "=");
			for (j = 2; j < k; ++j) {
				for (h = 0; h < 200; ++h) {
					cstatement[j + 2][h] = statement[j][h];
				}
			}
			dolet(cstatement);
			ap("PHA");

			// now change operator
			// > or <= swap
			if (CMATCH(k, '>')) statement[k][0] = '<';
			if (SMATCH(k, "<=")) statement[k][0] = '>';
			situation = 2;
		}
		else if (push1 == 1 && !CMATCH(k, '>') && !SMATCH(k, "<=")) {
			// first statement only, no swap
			strcpy(cstatement[2], "Areg");
			strcpy(cstatement[3], "=");
			for (j = 2; j < k; ++j) {
				for (h = 0; h < 200; ++h) {
					cstatement[j + 2][h] = statement[j][h];
				}
			}
			dolet(cstatement);
			//ap("PHA");
			situation = 3;

		}
		else if (push1 == 1) {
			// first statement only, swap
			strcpy(cstatement[2], "Areg");
			strcpy(cstatement[3], "=");
			for (j = 2; j < k; ++j) {
				for (h = 0; h < 200; ++h) {
					cstatement[j + 2][h] = statement[j][h];
				}
			}
			dolet(cstatement);
			ap("PHA");

			// now change operator
			// > or <= swap
			if (CMATCH(k, '>'))  strcpy(statement[k], "<");
			if (SMATCH(k, "<=")) strcpy(statement[k], ">=");

			// swap pushes and vars:
			push1 = 0;
			push2 = 1;
			strcpy(statement[2], statement[k + 1]);
			situation = 4;

		}
		else if (push2 == 1 && strncmp(statement[k], ">\0", 2) && !SMATCH(k, "<=")) {
			// second statement only, no swap:
			strcpy(cstatement[2], "Areg");
			strcpy(cstatement[3], "=");
			for (j = k + 1; j < i; ++j) {
				for (h = 0; h < 200; ++h) {
					cstatement[j - k + 3][h] = statement[j][h];
				}
			}
			dolet(cstatement);
			ap("PHA");
			situation = 5;
		}
		else if (push2 == 1) {
			// second statement only, swap:
			strcpy(cstatement[2], "Areg");
			strcpy(cstatement[3], "=");
			for (j = k + 1; j < i; ++j) {
				for (h = 0; h < 200; ++h) {
					cstatement[j - k + 3][h] = statement[j][h];
				}
			}
			dolet(cstatement);
			//ap("PHA");
			// now change operator
			// > or <= swap
			if (CMATCH(k, '>'))  statement[k][0] = '<';
			if (SMATCH(k, "<=")) statement[k][0] = '>';

			// swap pushes and vars:
			push1 = 1;
			push2 = 0;
			strcpy(statement[k + 1], statement[2]);
			situation = 6;
		}
		else {		// should never get here
			prerror("Parse error in complex if-then statement\n");
			exit(1);
		}
		if (situation != 6 && situation != 3) {
			ap("TSX");  //index to stack
			if (push1) ap("PLA");
			if (push2) ap("PLA");
		}
		if (push1 && push2)
			strcpy(cstatement[2], " 2[TSX]");
		else if (push1)
			strcpy(cstatement[2], " 1[TSX]");
		else
			strcpy(cstatement[2], statement[2]);
		strcpy(cstatement[3], statement[k]);
		if (push2)
			strcpy(cstatement[4], " 1[TSX]");
		else
			strcpy(cstatement[4], statement[k + 1]);
		for (j = 5; j < 40; ++j)
			strcpy(cstatement[j], statement[j - 5 + i]);
		strcpy(cstatement[0], statement[0]);    // copy label
		if (situation != 4 && situation != 5)
			strcpy(Areg, cstatement[2]);        // attempt to suppress superfluous LDA

		if (not && statement[k][0] == '&') {
			shiftdata(cstatement, 5);
			cstatement[5][0] = ')';
			cstatement[5][1] = '\0';
			shiftdata(cstatement, 2);
			shiftdata(cstatement, 2);
			cstatement[2][0] = '!';
			cstatement[2][1] = '\0';
			cstatement[3][0] = '(';
			cstatement[3][1] = '\0';
		}
		strcpy(cstatement[1], "if");
		if (statement[i][0] == 't')
			doif(cstatement);   // okay to recurse
		else if (statement[i][0] == '&') {
			if (situation != 4 && situation != 5)
				printf("; todo: this LDA is spurious and should be prevented ->");
			keywords(cstatement);       // statement still has booleans - attempt to reanalyze
		}
		else {
			prerror("if-then too complex for logical OR\n");
			exit(1);
		}
		Aregmatch = 0;
		freemem(dealloccstatement);
		return;
	}
	index |= getindex(statement[2], &getindex0[0]);
	if (!SMATCH(3, "then"))
		index |= getindex(statement[4], &getindex1[0]) << 1;

	if (!Aregmatch) {		// do we already have the correct value in A?
		if (index & 1) loadindex(&getindex0[0]);
		ap("LDA %s", indexpart(statement[2], index & 1));
		strcpy(Areg, Aregcopy);
	}
	if (index & 2) loadindex(&getindex1[0]);
	//todo:check for cmp #0--useless except for <, > to clear carry
	if (!SMATCH(3, "then")) {
		char *ipart = indexpart(statement[4], index & 2);
		if (statement[3][0] == '&') {
			ap("AND %s", ipart);
			if (not) {
				statement[3][0] = '=';  // force beq/bne below
				statement[3][1] = '\0';
			}
			else {
				statement[3][0] = '<';  // force beq/bne below
				statement[3][1] = '>';
				statement[3][2] = '\0';
			}
		}
		else
			ap("CMP %s", ipart);
	}

	if (islabel(statement)) {			// then linenumber
		if (statement[3][0] == '=')			beq(statement[6]);
		else if (SMATCH(3, "<>"))			bne(statement[6]);
		else if (statement[3][0] == '<')	bcc(statement[6]);
		else if (statement[3][0] == '>')	bcs(statement[6]);
		if (SMATCH(3, "then")) {
			if (not) beq(statement[4]);
			else     bne(statement[4]);
		}
	}
	else {						// then statement
		char *op = NULL;
		// first, take negative of condition and branch around statement
		j = 5;
		if (SMATCH(3, "then")) {
			j = 3;
			op = not ? "BNE" : "BEQ";
		}
		else if (!strcmp(statement[3], "<>"))	op = "BEQ";
		else if (statement[3][0] == '=')		op = "BNE";
		else if (statement[3][0] == '<')		op = "BCS";
		else if (statement[3][0] == '>')		op = "BCC";

		ap("%s .skip%s", op, statement[0]);
		// separate statement

		// separate statement
		for (i = j; i < 200; ++i) {
			for (k = 0; k < 200; ++k) {
				cstatement[i - j][k] = statement[i][k];
			}
		}
		printf(".condpart%d\n", condpart++);
		keywords(cstatement);
		printf(".skip%s\n", statement[0]);

		freemem(dealloccstatement);
		return;

		//i=4;
		//while (statement[i][0]!='\0')
		//{
		//  cstatement[i-4]=statement[i++];
		//}
		//keywords(cstatement);
		//printf(".skip%s\n",statement[0]);
	}
	freemem(dealloccstatement);
}

int getcondpart() { return condpart; }

int orderofoperations(char op1, char op2) {
	// specify order of operations for complex equations
	// i.e.: parens, divmul (*/), +-, logical (^&|)
	if (op1 == '(') return 0;
	if (op2 == '(') return 0;
	if (op2 == ')') return 1;
	if (   (op1 == '^' || op1 == '|' || op1 == '&')
		&& (op2 == '^' || op2 == '|' || op2 == '&')) return 0;
	//if (op1 == '^') return 1;
	//if (op1 == '&') return 1;
	//if (op1 == '|') return 1;
	//if (op2 == '^') return 0;
	//if (op2 == '&') return 0;
	//if (op2 == '|') return 0;
	if (op1 == '*' || op1 == '/') return 1;
	if (op2 == '*' || op2 == '/') return 0;
	if (op1 == '+' || op1 == '-') return 1;
	if (op2 == '+' || op2 == '-') return 0;
	return 1;
}

int isoperator(char op) {
	return (strchr("+-/*&|^()", op) != NULL) ? 1 : 0;
}

void displayoperation(char *opcode, char *operand, int index) {
	if (MATCH(operand, "stackpull")) {
		if (opcode[0] == '-') {
			// operands swapped
			ap("TAY");
			ap("PLA");
			ap("TSX");
			ap("STY $00,x");
			ap("SEC");
			ap("SBC $00,x");
		}
		else if (opcode[0] == '/') {
			// operands swapped
			ap("TAY");
			ap("PLA");
		}
		else {
			ap("TSX");
			ap("INX");
			ap("TXS");
			ap("%s $00,x\n", opcode + 1);
		}
	}
	else {
		ap("%s %s ", opcode + 1, indexpart(operand, index));
	}
}

void dec(char **cstatement) {
	decimal = 1;
	ap("SED");
	dolet(cstatement);
	ap("CLD");
	decimal = 0;
}

void dolet(char **cstatement) {
	int i, j = 0, bit = 0, k;
	int index = 0;
	char getindex0[200];
	char getindex1[200];
	char getindex2[200];
	int score[6] = { 0, 0, 0, 0, 0, 0 };
	char **statement;
	char *getbitvar;
	int Aregmatch = 0;
	char Aregcopy[200];
	char operandcopy[200];
	int fixpoint1;
	int fixpoint2;
	int fixpoint3 = 0;
	char **deallocstatement;
	char **rpn_statement;       // expression in rpn
	char rpn_stack[200][200];   // prolly doesn't need to be this big
	int sp = 0;                 // stack pointer for converting to rpn
	int numrpn = 0;
	char **atomic_statement;    // singular statements to recurse back to here
	char tempstatement1[200], tempstatement2[200];

	strcpy(Aregcopy, "index-invalid");

	statement = (char **) malloc(sizeof(char *) * 200);
	deallocstatement = statement;
	if (cstatement[2][0] == '=') {
		for (i = 198; i > 0; --i)
			statement[i + 1] = cstatement[i];
	}
	else
		statement = cstatement;

	// check for unary minus (e.g. a=-a) and insert zero before it
	if (statement[4][0] == '-' && statement[5][0] > (unsigned char)0x3F) {
		shiftdata(statement, 4);
		statement[4][0] = '0';
	}


	fixpoint1 = isfixpoint(statement[2]);
	fixpoint2 = isfixpoint(statement[4]);
	removeCR(statement[4]);

	// check for complex statement
	if ((!((statement[4][0] == '-') && (statement[6][0] == ':'))) &&
		(statement[5][0] != ':') && (statement[7][0] != ':')
		&& (!((statement[5][0] == '(') && (statement[4][0] != '(')))
		&& ((unsigned char) statement[5][0] > ' ')
		&& ((unsigned char) statement[7][0] > ' ')
	) {
		printf("; complex statement detected\n");
		// complex statement here, hopefully.
		// convert equation to reverse-polish notation so we can express it in terms of
		// atomic equations and stack pushes/pulls
		rpn_statement = (char **) malloc(sizeof(char *) * 200);
		for (i = 0; i < 200; ++i) {
			rpn_statement[i] = (char *) malloc(sizeof(char) * 200);
			for (k = 0; k < 200; ++k)
				rpn_statement[i][k] = '\0';
		}

		atomic_statement = (char **) malloc(sizeof(char *) * 10);
		for (i = 0; i < 10; ++i) {
			atomic_statement[i] = (char *) malloc(sizeof(char) * 200);
			for (k = 0; k < 200; ++k)
				atomic_statement[i][k] = '\0';
		}

		// Convert expression to RPN
		for (k = 4; (statement[k][0] != '\0') && (statement[k][0] != ':'); k++) {
			// ignore CR/LF
			if (statement[k][0] == '\n') continue;
			if (statement[k][0] == '\r') continue;

			strcpy(tempstatement1, statement[k]);
			if (!isoperator(tempstatement1[0])) {
				strcpy(rpn_statement[numrpn++], tempstatement1);
			}
			else {
				while ((sp) && (orderofoperations(rpn_stack[sp - 1][0], tempstatement1[0]))) {
					strcpy(tempstatement2, rpn_stack[sp - 1]);
					sp--;
					strcpy(rpn_statement[numrpn++], tempstatement2);
				}
				if ((sp) && (tempstatement1[0] == ')'))
					sp--;
				else
					strcpy(rpn_stack[sp++], tempstatement1);
			}
		}

		// get stuff off of our rpn stack
		while (sp) {
			strcpy(tempstatement2, rpn_stack[sp - 1]);
			sp--;
			strcpy(rpn_statement[numrpn++], tempstatement2);
		}

		//for(i=0;i<20;++i)fprintf(stderr,"%s ",rpn_statement[i]);i=0;

		// now parse rpn statement

		//strcpy(atomic_statement[2],"Areg");
		//strcpy(atomic_statement[3],"=");
		//strcpy(atomic_statement[4],rpn_statement[0]);
		//strcpy(atomic_statement[5],rpn_statement[2]);
		//strcpy(atomic_statement[6],rpn_statement[1]);
		//dolet(atomic_statement);

		sp = 0;                 // now use as pointer into rpn_statement
		while (sp < numrpn) {
			// clear atomic statement cache
			for (i = 0; i < 10; ++i)
				for (k = 0; k < 200; ++k)
					atomic_statement[i][k] = '\0';
			if (isoperator(rpn_statement[sp][0])) {
				// operator: need stack pull as 2nd arg
				// Areg=Areg (op) stackpull
				strcpy(atomic_statement[2], "Areg");
				strcpy(atomic_statement[3], "=");
				strcpy(atomic_statement[4], "Areg");
				strcpy(atomic_statement[5], rpn_statement[sp++]);
				strcpy(atomic_statement[6], "stackpull");
				dolet(atomic_statement);
			}
			else if (isoperator(rpn_statement[sp + 1][0])) {
				// val,operator: Areg=Areg (op) val
				strcpy(atomic_statement[2], "Areg");
				strcpy(atomic_statement[3], "=");
				strcpy(atomic_statement[4], "Areg");
				strcpy(atomic_statement[6], rpn_statement[sp++]);
				strcpy(atomic_statement[5], rpn_statement[sp++]);
				dolet(atomic_statement);
			}
			else if (isoperator(rpn_statement[sp + 2][0])) {
				// val,val,operator: stackpush, then Areg=val1 (op) val2
				if (sp) ap("PHA");
				strcpy(atomic_statement[2], "Areg");
				strcpy(atomic_statement[3], "=");
				strcpy(atomic_statement[4], rpn_statement[sp++]);
				strcpy(atomic_statement[6], rpn_statement[sp++]);
				strcpy(atomic_statement[5], rpn_statement[sp++]);
				dolet(atomic_statement);
			}
			else {
				if ((rpn_statement[sp] == 0) || (rpn_statement[sp + 1] == 0) || (rpn_statement[sp + 2] == 0)) {
					// incomplete or unrecognized expression
					prerror("Cannot evaluate expression\n");
					exit(1);
				}
				// val,val,val: stackpush, then load of next value
				if (sp) ap("PHA");
				strcpy(atomic_statement[2], "Areg");
				strcpy(atomic_statement[3], "=");
				strcpy(atomic_statement[4], rpn_statement[sp++]);
				dolet(atomic_statement);
			}
		}
		// done, now assign A-reg to original value
		for (i = 0; i < 10; ++i)
			for (k = 0; k < 200; ++k)
				atomic_statement[i][k] = '\0';
		strcpy(atomic_statement[2], statement[2]);
		strcpy(atomic_statement[3], "=");
		strcpy(atomic_statement[4], "Areg");
		dolet(atomic_statement);
		return;                 // bye-bye!
	}

	//check for [indexing]
	strcpy(Aregcopy, statement[4]);
	if (!strcmp(statement[4], Areg)) Aregmatch = 1; // Already have the correct value in A?

	index |= getindex(statement[2], &getindex0[0]);
	index |= getindex(statement[4], &getindex1[0]) << 1;
	if (statement[5][0] != ':')
		index |= getindex(statement[6], &getindex2[0]) << 2;

	// check for array, e.g. x(1) to access bit 1 of x
	for (i = 3; i < 200; ++i) {
		if (statement[2][i] == '\0') { i = 200; break; }
		if (statement[2][i] == '}') break;
	}
	if (i < 200) {		// found bit
		strcpy(Areg, "invalid");
		// extract expression in parantheses - for now just whole numbers allowed
		bit = (int) statement[2][i - 1] - '0';
		if ((bit > 9) || (bit < 0)) {
			fprintf(stderr, "(%d) Error: variables in bit access not supported\n", line);
			exit(1);
		}
		if (bit > 7) {
			fprintf(stderr, "(%d) Error: invalid bit access\n", line);
			exit(1);
		}

		if (statement[4][0] == '0') {
			printf("\tLDA ");
			for (i = 0; i < 200; ++i) {
				if (statement[2][i] == '{') break;
				printf("%c", statement[2][i]);
			}
			printf("\n");
			ap("AND #%d", 255 ^ (1 << bit));	//(int)pow(2,bit));
		}
		else if (statement[4][0] == '1') {
			printf("\tLDA ");
			for (i = 0; i < 200; ++i) {
				if (statement[2][i] == '{') break;
				printf("%c", statement[2][i]);
			}
			printf("\n");
			ap("ORA #%d", 1 << bit);	//(int)pow(2,bit));
		}
		else if ((getbitvar = strtok(statement[4], "{"))) {
			// assign one bit to another
			// removed NOP Abs to eventully support 0840 bankswitching
			ap("LDA %s", getbitvar + (getbitvar[0] == '!'));
			ap("AND #%d", (1 << ((int) statement[4][strlen(getbitvar) + 1] - '0')));
			ap("PHP");
			printf("\tLDA ");
			for (i = 0; i < 200; ++i) {
				if (statement[2][i] == '{') break;
				printf("%c", statement[2][i]);
			}
			printf("\n");
			ap("AND #%d", 255 ^ (1 << bit));	//(int)pow(2,bit));
			ap("PLP");
			if (getbitvar[0] == '!')
				ap(".byte $D0, $02");	// bad, bad way to do BEQ addr+5
			else
				ap(".byte $F0, $02");	// bad, bad way to do BNE addr+5

			ap("ORA #%d", 1 << bit);	//(int)pow(2,bit));
		}
		else {
			fprintf(stderr, "(%d) Error: can only assign 0, 1 or another bit to a bit\n", line);
			exit(1);
		}
		printf("\tSTA ");
		for (i = 0; i < 200; ++i) {
			if (statement[2][i] == '{') break;
			printf("%c", statement[2][i]);
		}
		printf("\n");
		free(deallocstatement);
		return;
	}

	if (statement[4][0] == '-') { // assignment to negative
		strcpy(Areg, "invalid");
		if ((!fixpoint1) && (isfixpoint(statement[5]) != 12)) {
			if (statement[5][0] > '9') { // perhaps include constants too?
				ap("LDA #0");
				ap("SEC");
				ap("SBC %s", statement[5]);
			}
			else
				ap("LDA #%d", 256 - atoi(statement[5]));
		}
		else {
			if (fixpoint1 == 4) {
				if (statement[5][0] > '9') {	// perhaps include constants too?
					printf("LDA #0");
					printf("SEC");
					printf("SBC %s", statement[5]);
				}
				else
					ap("LDA #%d", (int) ((16 - atof(statement[5])) * 16));
				ap("STA %s", statement[2]);
				free(deallocstatement);
				return;
			}
			if (fixpoint1 == 8) {
				sprintf(statement[4], "%f", 256.0 - atof(statement[5]));
				ap("LDX %s", fracpart(statement[4]));
				ap("STX %s", fracpart(statement[2]));
				ap("LDA #%s", statement[4]);
				ap("STA %s", statement[2]);
				free(deallocstatement);
				return;
			}
		}
	}
	else if (SMATCH(4, "rand")) {
		strcpy(Areg, "invalid");
		if (optimization & 8) {
			ap("LDA rand");
			ap("LSR");
			printf(" ifconst rand16\n");
			ap("ROL rand16");
			printf(" endif\n");
			ap("BCC *+4");
			ap("EOR #$B4");
			ap("STA rand");
			printf(" ifconst rand16\n");
			ap("EOR rand16");
			printf(" endif\n");
		}
		else if (bs == 28)
			ap("LDA rand");
		else
			jsr("randomize");
	}
	else if (SMATCH(2, "score") && !SMATCH(2, "scorec")) {
		// break up into three parts
		strcpy(Areg, "invalid");
		if (CMATCH(5, '+')) {
			ap("SED");
			ap("CLC");
			for (i = 5; i >= 0; i--) {
				if (statement[6][i] != '\0') score[j] = number(statement[6][i]);
				score[j] = number(statement[6][i]);
				if ((score[j] < 10) && (score[j] >= 0)) j++;
			}
			if (score[0] | score[1]) {
				ap("LDA score+2");
				if (statement[6][0] > (unsigned char) 0x3F)
					ap("ADC %s", statement[6]);
				else
					ap("ADC #$%d%d", score[1], score[0]);
				ap("STA score+2");
			}
			if (score[0] | score[1] | score[2] | score[3]) {
				ap("LDA score+1");
				if (score[0] > 9)
					ap("ADC #0");
				else
					ap("ADC #$%d%d", score[3], score[2]);
				ap("STA score+1");
			}
			ap("LDA score");
			if (score[0] > 9)
				ap("ADC #0");
			else
				ap("ADC #$%d%d", score[5], score[4]);
			ap("STA score");
			ap("CLD");
		}
		else if (statement[5][0] == '-') {
			ap("SED");
			ap("SEC");
			for (i = 5; i >= 0; i--) {
				if (statement[6][i] != '\0') score[j] = number(statement[6][i]);
				score[j] = number(statement[6][i]);
				if ((score[j] < 10) && (score[j] >= 0)) j++;
			}
			ap("LDA score+2");
			if (score[0] > 9)
				ap("SBC %s", statement[6]);
			else
				ap("SBC #$%d%d", score[1], score[0]);
			ap("STA score+2");
			ap("LDA score+1");
			if (score[0] > 9)
				ap("SBC #0");
			else
				ap("SBC #$%d%d", score[3], score[2]);
			ap("STA score+1");
			ap("LDA score");
			if (score[0] > 9)
				ap("SBC #0");
			else
				ap("SBC #$%d%d", score[5], score[4]);
			ap("STA score");
			ap("CLD");
		}
		else {
			for (i = 5; i >= 0; i--) {
				if (statement[4][i] != '\0') score[j] = number(statement[4][i]);
				score[j] = number(statement[4][i]);
				if ((score[j] < 10) && (score[j] >= 0)) j++;
			}
			ap("LDA #$%d%d", score[1], score[0]);
			ap("STA score+2");
			ap("LDA #$%d%d", score[3], score[2]);
			ap("STA score+1");
			ap("LDA #$%d%d", score[5], score[4]);
			ap("STA score");
		}
		free(deallocstatement);
		return;
	}
	else if ((statement[6][0] == '1')
		&& !ISNUM(statement[6][1])
		&& ((statement[5][0] == '+') || (statement[5][0] == '-'))
		&& SMATCH(2, statement[4])
		&& !SMATCH(2, "Areg")
		&& (statement[6][1] == '\0' || statement[6][1] == ' ' || statement[6][1] == '\n')
		&& decimal == 0
	) { // var=var +/- something
		strcpy(Areg, "invalid");
		if ((fixpoint1 == 4) && (fixpoint2 == 4)) {
			if (statement[5][0] == '+') {
				ap("LDA %s", statement[2]);
				ap("CLC");
				ap("ADC #16");
				ap("STA %s", statement[2]);
				free(deallocstatement);
				return;
			}
			if (statement[5][0] == '-') {
				ap("LDA %s", statement[2]);
				ap("SEC");
				ap("SBC #16");
				ap("STA %s", statement[2]);
				free(deallocstatement);
				return;
			}
		}

		if (index & 1) loadindex(&getindex0[0]);
		printf("        %s ", (statement[5][0] == '+') ? "INC" : "DEC");
		if (!(index & 1))
			printf("%s\n", statement[2]);
		else
			printf("%s,x\n", statement[4]);     // indexed with x!
		free(deallocstatement);

		return;
	}
	else {	// Generic x=num or var

		if (!Aregmatch) { // Already have the correct value in A?
			if (index & 2) loadindex(&getindex1[0]);

			// if 8.8 = 8.8 + 8.8: this LDA will be superfluous - fix this at some point

			//if (!fixpoint1 && !fixpoint2 && statement[5][0]!='(')
			if (((!fixpoint1 && !fixpoint2) || (!fixpoint1 && fixpoint2 == 8)) && statement[5][0] != '(') {
			//	printfrac(statement[4]);
			//} else {
				if (strncmp(statement[4], "Areg\n", 4))
					ap("LDA %s", indexpart(statement[4], index & 2));
			}
			strcpy(Areg, Aregcopy);
		}
	}
	if ((statement[5][0] != '\0') && (statement[5][0] != ':')) {
		// An operator was found
		fixpoint3 = isfixpoint(statement[6]);
		strcpy(Areg, "invalid");
		if (index & 4) loadindex(&getindex2[0]);
		if (statement[5][0] == '+') {
			//if ((fixpoint1 == 4) && (fixpoint2 == 4)) {
			//}
			//else {
			if ((fixpoint1 == 8) && ((fixpoint2 & 8) == 8) && ((fixpoint3 & 8) == 8)) {
				// 8.8 = 8.8 + 8.8
				ap("LDA %s", fracpart(statement[4]));
				ap("CLC");
				ap("ADC %s", fracpart(statement[6]));
				ap("STA %s", fracpart(statement[2]));
				ap("LDA %s%s", immedtok(statement[4]), statement[4]);
				ap("ADC %s%s", immedtok(statement[6]), statement[6]);
			}
			else if ((fixpoint1 == 8) && ((fixpoint2 & 8) == 8) && (fixpoint3 == 4))
			{
				ap("LDY %s", statement[6]);
				ap("LDX %s", fracpart(statement[4]));
				ap("LDA %s%s", immedtok(statement[4]), statement[4]);
				jsrbank1("Add44to88");
				ap("STX %s", fracpart(statement[2]));
			}
			else if ((fixpoint1 == 8) && ((fixpoint3 & 8) == 8) && (fixpoint2 == 4))
			{
				ap("LDY %s", statement[4]);
				ap("LDX %s", fracpart(statement[6]));
				ap("LDA %s%s", immedtok(statement[6]), statement[6]);
				jsrbank1("Add44to88");
				ap("STX %s", fracpart(statement[2]));
			}
			else if ((fixpoint1 == 4) && (fixpoint2 == 8) && ((fixpoint3 & 4) == 4))
			{
				if (fixpoint3 == 4)
					ap("LDY %s", statement[6]);
				else
					ap("LDY #%d", (int) (atof(statement[6]) * 16.0));
				ap("LDA %s", statement[4]);
				ap("LDX %s", fracpart(statement[4]));
				jsrbank1("Add88to44");
			}
			else if ((fixpoint1 == 4) && (fixpoint2 == 4) && (fixpoint3 == 12))
			{
				ap("CLC");
				ap("LDA %s", statement[4]);
				ap("ADC #%d", (int) (atof(statement[6]) * 16.0));
			}
			else if ((fixpoint1 == 4) && (fixpoint2 == 12) && (fixpoint3 == 4))
			{
				ap("CLC");
				ap("LDA %s", statement[6]);
				ap("ADC #%d", (int) (atof(statement[4]) * 16.0));
			}
			else                // this needs work - 44+8+44 and probably others are screwy
			{
				if (fixpoint2 == 4)
					ap("LDA %s", statement[4]);
				if ((fixpoint3 == 4) && (fixpoint2 == 0))
					ap("LDA %s%s", immedtok(statement[4]), statement[4]); // this LDA might be superfluous
				displayoperation("+CLC\n        ADC", statement[6], index & 4);
			}
			//}
		}
		else if (statement[5][0] == '-') {
			if ((fixpoint1 == 8) && ((fixpoint2 & 8) == 8) && ((fixpoint3 & 8) == 8)) {
				// 8.8 = 8.8 - 8.8
				ap("LDA %s", fracpart(statement[4]));
				ap("SEC ");
				ap("SBC %s", fracpart(statement[6]));
				ap("STA %s", fracpart(statement[2]));
				ap("LDA %s%s", immedtok(statement[4]), statement[4]);
				ap("SBC %s%s", immedtok(statement[6]), statement[6]);
			}
			else if ((fixpoint1 == 8) && ((fixpoint2 & 8) == 8) && (fixpoint3 == 4)) {
				ap("LDY %s", statement[6]);
				ap("LDX ", fracpart(statement[4]));
				ap("LDA %s%s", immedtok(statement[4]), statement[4]);
				jsrbank1("Sub44from88");
				ap("STX ", fracpart(statement[2]));
			}
			else if ((fixpoint1 == 4) && (fixpoint2 == 8) && ((fixpoint3 & 4) == 4)) {
				if (fixpoint3 == 4)
					ap("LDY %s", statement[6]);
				else
					ap("LDY #%d", (int) (atof(statement[6]) * 16.0));
				ap("LDA %s", statement[4]);
				ap("LDX ", fracpart(statement[4]));
				jsrbank1("Sub88from44");
			}
			else if ((fixpoint1 == 4) && (fixpoint2 == 4) && (fixpoint3 == 12)) {
				ap("SEC");
				ap("LDA %s", statement[4]);
				ap("SBC #%d", (int) (atof(statement[6]) * 16.0));
			}
			else if ((fixpoint1 == 4) && (fixpoint2 == 12) && (fixpoint3 == 4)) {
				ap("SEC");
				ap("LDA #%d", (int) (atof(statement[4]) * 16.0));
				ap("SBC %s", statement[6]);
			}
			else {
				if (fixpoint2 == 4)
					ap("LDA %s", statement[4]);
				if ((fixpoint3 == 4) && (fixpoint2 == 0))
					ap("LDA #%s", statement[4]);
				displayoperation("-SEC\n        SBC", statement[6], index & 4);
			}
		}
		else if (statement[5][0] == '&') {
			if (fixpoint2 == 4)
				ap("LDA %s", statement[4]);
			displayoperation("&AND", statement[6], index & 4);
		}
		else if (statement[5][0] == '^') {
			if (fixpoint2 == 4)
				ap("LDA %s", statement[4]);
			displayoperation("^EOR", statement[6], index & 4);
		}
		else if (statement[5][0] == '|') {
			if (fixpoint2 == 4)
				ap("LDA %s", statement[4]);
			displayoperation("|ORA", statement[6], index & 4);
		}
		else if (statement[5][0] == '*') {
			if (isimmed(statement[4]) && !isimmed(statement[6]) && checkmul(atoi(statement[4]))) {
				// swap operands to avoid mul routine
				strcpy(operandcopy, statement[4]);	// place here temporarily
				strcpy(statement[4], statement[6]);
				strcpy(statement[6], operandcopy);
			}
			if (fixpoint2 == 4)
				ap("LDA %s", statement[4]);
			if ((!isimmed(statement[6])) || (!checkmul(atoi(statement[6])))) {
				displayoperation("*LDY", statement[6], index & 4);
				if (statement[5][1] == '*')
					jsrbank1("mul16");	// general mul routine
				else
					jsrbank1("mul8");
			}
			else if (statement[5][1] == '*')
				mul(statement, 16);
			else
				mul(statement, 8);		// attempt to optimize - may need to call mul anyway

		}
		else if (statement[5][0] == '/') {
			if (fixpoint2 == 4)
				ap("LDA %s", statement[4]);
			if ((!isimmed(statement[6])) || (!checkdiv(atoi(statement[6])))) {
				displayoperation("/LDY", statement[6], index & 4);
				jsrbank1(statement[5][1] == '/' ? "div16" : "div8");  // general div routine
			}
			else if (statement[5][1] == '/')
				divd(statement, 16);
			else
				divd(statement, 8);		// attempt to optimize - may need to call divd anyway

		}
		else if (statement[5][0] == ':') {
			strcpy(Areg, Aregcopy);		// A reg is not invalid
		}
		else if (statement[5][0] == '(') {
			// we've called a function, hopefully
			strcpy(Areg, "invalid");
			if (SMATCH(4, "sread"))
				sread(statement);
			else
				callfunction(statement);
		}
		else if (statement[4][0] != '-') {	// if not unary -
			fprintf(stderr, "(%d) Error: invalid operator: %s\n", line, statement[5]);
			exit(1);
		}
	}
	else {	// simple assignment
		// check for fixed point stuff here
		// bugfix: forgot the LDA (?) did I do this correctly???
		if ((fixpoint1 == 4) && (fixpoint2 == 0)) {
			ap("LDA %s%s", immedtok(statement[4]), statement[4]);
			ap("ASL"); ap("ASL"); ap("ASL"); ap("ASL");
		}
		else if ((fixpoint1 == 0) && (fixpoint2 == 4)) {
			ap("LDA %s%s", immedtok(statement[4]), statement[4]);
			ap("LSR"); ap("LSR"); ap("LSR"); ap("LSR");
		}
		else if ((fixpoint1 == 4) && (fixpoint2 == 8)) {
			ap("LDA %s%s", immedtok(statement[4]), statement[4]);
			ap("LDX %s", fracpart(statement[4]));
			printf("\tJSR Assign88to44"); // note: this shouldn't be changed to jsr(); (why???)
			if (bs) printf("bs");
			printf("\n");
		}
		else if ((fixpoint1 == 8) && (fixpoint2 == 4)) {
			ap("LDA %s%s", immedtok(statement[4]), statement[4]);
			printf("\tJSR Assign44to88"); // note: this shouldn't be changed to jsr();
			if (bs) printf("bs");
			printf("\n");
			ap("STX %s", fracpart(statement[2]));
		}
		else if ((fixpoint1 == 8) && ((fixpoint2 & 8) == 8)) {
			ap("LDX %s", fracpart(statement[4]));
			ap("STX %s", fracpart(statement[2]));
			ap("LDA %s%s", immedtok(statement[4]), statement[4]);
		}
		else if ((fixpoint1 == 4) && ((fixpoint2 & 4) == 4)) {
			if (fixpoint2 == 4)
				ap("LDA %s", statement[4]);
			else
				ap("LDA #%d", (int) (atof(statement[4]) * 16));
		}
		else if ((fixpoint1 == 8) && (fixpoint2 == 0)) {
			// should handle 8.8 = number w/o point or int var
			ap("LDA #0");
			ap("STA %s", fracpart(statement[2]));
			ap("LDA %s%s", immedtok(statement[4]), statement[4]);
		}
	}
	if (index & 1) loadindex(&getindex0[0]);
	if (!SMATCH(2, "Areg"))
		ap("STA %s", indexpart(statement[2], index & 1));

	free(deallocstatement);
}

void dogoto(char **statement) {
	int anotherbank = 0;
	if (SMATCH(3, "bank")) {
		anotherbank = (int) (statement[3][4]) - '0';
		if (ISNUM(statement[3][5]))
			anotherbank = (int) (statement[3][5]) - 38;
	}
	else {
		ap("JMP .%s", statement[2]);
		return;
	}

	// if here, we're jmp'ing to another bank
	// we need to switch banks
	ap("STA temp7");
	// push the jsr address
	ap("LDA #>(.%s-1)", statement[2]);
	ap("PHA");
	ap("LDA #<(.%s-1)", statement[2]);
	ap("PHA");
	// store regs on stack
	ap("LDA temp7");
	ap("PHA");
	ap("TXA");
	ap("PHA");
	// select bank to switch to
	ap("LDX #%d", anotherbank);
	ap("JMP BS_jsr");    // also works for jmps
}

void gosub(char **statement) {
	int anotherbank = 0;
	invalidate_Areg();

	//if (numgosubs++>3) {
	// fprintf(stderr,"Max. nested gosubs exceeded in line %s\n",statement[0]);
	// exit(1);
	//}

	if (SMATCH(3, "bank")) {
		anotherbank = (int) (statement[3][4]) - '0';
		if (ISNUM(statement[3][5]))
			anotherbank = (int) (statement[3][5]) - 38;
	}
	else {
		ap("JSR .%s", statement[2]);
		return;
	}

	// if here, we're jsr'ing to another bank
	// we need to switch banks
	ap("STA temp7");
	// first create virtual return address

	// if it's 64k banks, store the bank directly in the high nibble
	if (bs == 64)
		ap("LDA #(((>(ret_point%d-1)) & $0F) | $%1x0) ", ++numjsrs, bank - 1);
	else
		ap("LDA #>(ret_point%d-1)", ++numjsrs);

	ap("PHA");

	ap("LDA #<(ret_point%d-1)", numjsrs);
	ap("PHA");

	// push the jsr address
	ap("LDA #>(.%s-1)", statement[2]);
	ap("PHA");

	ap("LDA #<(.%s-1)", statement[2]);
	ap("PHA");

	// store regs on stack
	ap("LDA temp7");
	ap("PHA");
	ap("TXA");
	ap("PHA");

	// select bank to switch to
	ap("LDX #%d", anotherbank);
	ap("JMP BS_jsr");
	printf("ret_point%d\n", numjsrs);
}

void set(char **statement) {
	int i;
	int v;
	int valid_kernel_combos[] = {       // C preprocessor should turn these into numbers!
		_player1colors,
		_no_blank_lines,
		_pfcolors,
		_pfheights,
		_pfcolors | _pfheights,
		_pfcolors | _pfheights | _background,
		_pfcolors | _no_blank_lines,
		_pfcolors | _no_blank_lines | _background,
		_player1colors | _no_blank_lines,
		_player1colors | _pfcolors,
		_player1colors | _pfheights,
		_player1colors | _pfcolors | _pfheights,
		_player1colors | _pfcolors | _background,
		_player1colors | _pfheights | _background,
		_player1colors | _pfcolors | _pfheights | _background,
		_player1colors | _no_blank_lines | _readpaddle,
		_player1colors | _no_blank_lines | _pfcolors,
		_player1colors | _no_blank_lines | _pfcolors | _background,
		_playercolors | _player1colors | _pfcolors,
		_playercolors | _player1colors | _pfheights,
		_playercolors | _player1colors | _pfcolors | _pfheights,
		_playercolors | _player1colors | _pfcolors | _background,
		_playercolors | _player1colors | _pfheights | _background,
		_playercolors | _player1colors | _pfcolors | _pfheights | _background,
		_no_blank_lines | _readpaddle,
		255
	};
	if (IMATCH(2, "tv")) {
		if (IMATCH(3, "ntsc")) {
			// pick constant timer values for now, later maybe add more lines
			strcpy(redefined_variables[numredefvars++], "overscan_time = 37");
			strcpy(redefined_variables[numredefvars++], "vblank_time = 43");
		}
		else if (IMATCH(3, "pal")) {
			// 36 and 48 scanlines, respectively
			strcpy(redefined_variables[numredefvars++], "overscan_time = 82");
			strcpy(redefined_variables[numredefvars++], "vblank_time = 58");
		}
		else
			prerror("set TV: invalid TV type\n");
	}
	else if (SMATCH(2, "smartbranching")) {
		smartbranching = SMATCH(3, "on") ? 1 : 0;
	}
	else if (SMATCH(2, "dpcspritemax")) {
		v = atoi(statement[3]);
		if ((v == 0) || (v > 9)) {
			prerror("set dpcspritemax: invalid value\n");
			exit(1);
		}
		sprintf(redefined_variables[numredefvars++], "dpcspritemax = %d", v);
	}
	else if (SMATCH(2, "romsize")) {
		set_romsize(statement[3]);
	}
	else if (!strncmp(statement[2], "optimization", 5)) { // Allow 'optim'
		if (SMATCH(3, "speed"))								optimization |= 1;
		if (SMATCH(3, "size"))								optimization |= 2;
		if (!strncmp(statement[3], "noinlinedata", 4))		optimization |= 4;
		if (!strncmp(statement[3], "inlinerand", 4))		optimization |= 8;
		if (SMATCH(3, "none"))								optimization = 0;
	}
	else if (SMATCH(2, "kernal")) {
		prerror("The proper spelling is \"kernel.\"  With an e.  Please make a note of this to save yourself from further embarassment.\n");
	}
	else if (SMATCH(2, "kernel_options")) {
		i = 3;
		kernel_options = 0;
		while (((unsigned char) statement[i][0] > (unsigned char) 64)
			   && ((unsigned char) statement[i][0] < (unsigned char) 123)) {
			if (SMATCH(i, "readpaddle")) {
				strcpy(redefined_variables[numredefvars++], "readpaddle = 1");
				if (bs == 28) {
					printf("DPC_kernel_options = INPT0+$40\n");
					return;
				}
				else
					kernel_options |= 1;
			}
			else if (SMATCH(i, "collision")) {
				if (bs == 28) {
					printf("DPC_kernel_options = ");
					if (check_colls(statement[i]) == 7) printf("+$40");
					printf("\n");
					return;
				}
			}
			else if (SMATCH(i, "player1colors")) {
				strcpy(redefined_variables[numredefvars++], "player1colors = 1");
				kernel_options |= 2;
			}
			else if (SMATCH(i, "playercolors")) {
				strcpy(redefined_variables[numredefvars++], "playercolors = 1");
				strcpy(redefined_variables[numredefvars++], "player1colors = 1");
				kernel_options |= 6;
			}
			else if (SMATCH(i, "no_blank_lines")) {
				strcpy(redefined_variables[numredefvars++], "no_blank_lines = 1");
				kernel_options |= 8;
			}
			else if (IMATCH(i, "pfcolors")) {
				kernel_options |= 16;
			}
			else if (IMATCH(i, "pfheights")) {
				kernel_options |= 32;
			}
			else if (IMATCH(i, "backgroundchange")) {
				strcpy(redefined_variables[numredefvars++], "backgroundchange = 1");
				kernel_options |= 64;
			}
			else {
				prerror("set kernel_options: Options unknown or invalid\n");
				exit(1);
			}
			i++;
		}
		if ((kernel_options & 48) == 32)
			strcpy(redefined_variables[numredefvars++], "PFheights = 1");
		else if ((kernel_options & 48) == 16)
			strcpy(redefined_variables[numredefvars++], "PFcolors = 1");
		else if ((kernel_options & 48) == 48)
			strcpy(redefined_variables[numredefvars++], "PFcolorandheight = 1");
		//fprintf(stderr,"%d\n",kernel_options);
		// check for valid combinations
		if (kernel_options == 1) {
			prerror("set kernel_options: readpaddle must be used with no_blank_lines\n");
			exit(1);
		}
		i = 0;
		while (1) {
			if (valid_kernel_combos[i] == 255) {
				prerror("set kernel_options: Invalid combination of options\n");
				exit(1);
			}
			if (kernel_options == valid_kernel_combos[i++])
				break;
		}
	}
	else if (SMATCH(2, "kernel")) {
		if (SMATCH(3, "multisprite")) {
			multisprite = 1;
			strcpy(redefined_variables[numredefvars++], "multisprite = 1");
			create_includes("multisprite.inc");
			ROMpf = 1;
		}
		else if (SMATCH(3, "DPC")) {
			multisprite = 2;
			strcpy(redefined_variables[numredefvars++], "multisprite = 2");
			create_includes("DPCplus.inc");
			bs = 28;
			last_bank = 7;
			strcpy(redefined_variables[numredefvars++], "bankswitch_hotspot = $1FF6");
			strcpy(redefined_variables[numredefvars++], "bankswitch = 28");
			strcpy(redefined_variables[numredefvars++], "bs_mask = 7");
		}
		else if (SMATCH(3, "multisprite_no_include")) {
			multisprite = 1;
			strcpy(redefined_variables[numredefvars++], "multisprite = 1");
			ROMpf = 1;
		}
		else
			prerror("set kernel: kernel name unknown or unspecified\n");
	}
	else if (SMATCH(2, "debug")) {
		if (SMATCH(3, "cyclescore")) {
			strcpy(redefined_variables[numredefvars++], "debugscore = 1");
		}
		else if (SMATCH(3, "cycles")) {
			strcpy(redefined_variables[numredefvars++], "debugcycles = 1");
		}
		else
			prerror("set debug: debugging mode unknown\n");
	}
	else if (SMATCH(2, "legacy")) {
		sprintf(redefined_variables[numredefvars++], "legacy = %d", (int) (100 * (atof(statement[3]))));
	}
	else
		prerror("set: unknown parameter\n");

}

void rem(char **statement) {
	if (SMATCH(2, "smartbranching"))
		smartbranching = SMATCH(3, "on") ? 1 : 0;
}

void dopop() {
	ap("PLA");
	ap("PLA");
}

void hotspotcheck(char *linenumber) {
	if (bs) {	//if bankswitching, check for reverse branches from $1fXX that trigger hotspots...
		printf(" if ( (((((#>*)&$1f)*256)|(#<.%s))>=bankswitch_hotspot) && (((((#>*)&$1f)*256)|(#<.%s))<=(bankswitch_hotspot+bs_mask)) )\n", linenumber, linenumber);
		printf("   echo \"WARNING: branch near the end of bank %d may accidentally trigger a bankswitch. Reposition code there if bad things happen.\"\n", bank);
		printf(" endif\n");
	}
}

void _branch(char *b1, char *b2, char *linenumber) {
	removeCR(linenumber);
	if (smartbranching) {
		printf(" if ((* - .%s) < 127) && ((* - .%s) > -128)\n", linenumber, linenumber);
		// branches might be allowed as below - check carefully to make sure!
		// printf(" if ((* - .%s) < 127) && ((* - .%s) > -129)\n\tBMI .%s\n",linenumber,linenumber,linenumber);
		ap("%s .%s", b1, linenumber);
		printf(" else\n");
		ap("%s .%dskip%s", b2, branchtargetnumber, linenumber);
		ap("JMP .%s", linenumber);
		printf(".%dskip%s\n", branchtargetnumber++, linenumber);
		printf(" endif\n");
	}
	else {
		ap("%s .%s", b1, linenumber);
		hotspotcheck(linenumber);
	}
}
void bmi(char *linenumber) { _branch("BMI", "BPL", linenumber); }
void bpl(char *linenumber) { _branch("BPL", "BMI", linenumber); }
void bne(char *linenumber) { _branch("BNE", "BEQ", linenumber); }
void beq(char *linenumber) { _branch("BEQ", "BNE", linenumber); }
void bcc(char *linenumber) { _branch("BCC", "BCS", linenumber); }
void bcs(char *linenumber) { _branch("BCS", "BCC", linenumber); }
void bvc(char *linenumber) { _branch("BVC", "BVS", linenumber); }
void bvs(char *linenumber) { _branch("BVS", "BVC", linenumber); }

void drawscreen() {
	invalidate_Areg();
	if (multisprite == 2)
		jsrbank1("drawscreen");
	else
		jsr("drawscreen");
}

void prerror(char *myerror) { fprintf(stderr, "(%d): %s\n", line, myerror); }

BOOL isimmed(char *value) {
	// search queue of constants
	// removeCR(value);
	int i;
	for (i = 0; i < numconstants; ++i) {
		if (!strcmp(value, constants[i])) {
			// a constant should be treated as an immediate
			return true;
		}
	}
	if (!strcmp(value + (strlen(value) > 7 ? strlen(value) - 7 : 0), "_length")) {
		// Warning about use of data_length before data statement
		fprintf(stderr,
				"(%d): Warning: Possible use of data statement length before data statement is defined\n"
				"      Workaround: forward declaration may be done by const %s=%s at beginning of code\n",
				line, value, value);
	}

	return value[0] == '$' || value[0] == '%' || ISNUM(value[0]);
}

int number(unsigned char value) { return ((int) value) - '0'; }

// Remove trailing CR from string
void removeCR(char *linenumber) {
	while (linenumber[strlen(linenumber) - 1] == '\n' || linenumber[strlen(linenumber) - 1] == '\r')
		linenumber[strlen(linenumber) - 1] = '\0';
}

void remove_trailing_commas(char *linenumber) {	// remove trailing commas from string
	int i;
	for (i = strlen(linenumber) - 1; i > 0; i--) {
		if (   linenumber[i] != ','
			&& linenumber[i] != ' '
			&& linenumber[i] != '\n'
			&& linenumber[i] != '\r'
		) break;
		if (linenumber[i] == ',') { linenumber[i] = ' '; break; }
	}
}

void header_open(FILE * header) {
}

void header_write(FILE * header, char *filename) {
	int i;
	if ((header = fopen(filename, "w")) == NULL) { // open file
		fprintf(stderr, "Cannot open %s for writing\n", filename);
		exit(1);
	}

	strcpy(redefined_variables[numredefvars],
		   "; This file contains variable mapping and other information for the current project.\n");

	for (i = numredefvars; i >= 0; i--)
		fprintf(header, "%s\n", redefined_variables[i]);

	fclose(header);
}
