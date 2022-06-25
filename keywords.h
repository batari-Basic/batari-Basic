// Provided under the GPL v2 license. See the included LICENSE.txt for details.

#ifndef KEYWORDS_H
#define KEYWORDS_H

#define MAXCONSTANTS 80000

char includespath[500];
int ongosub;
int condpart;
int ROMpf;
int smartbranching;
int sprites_barfed;
int superchip;
extern int bank;
int last_bank;
int bs;
int multisprite;
int lifekernel;
int numfors;
int extra;
int extralabel;
int extraactive;
int macroactive;
char user_includes[1000];
char sprite_data[5000][50];
int sprite_index;
int playfield_index[50];
int playfield_number;
int pfdata[50][256];
char forvar[50][50];
char forlabel[50][50];
char forstep[50][50];
char forend[50][50];
char fixpoint44[2][50][50];
char fixpoint88[2][50][50];
//int numgosubs;
void keywords(char **);
char redefined_variables[500][100];
char constants[MAXCONSTANTS][100];
int pfcolorindexsave;
int pfcolornumber;
int kernel_options;
int numfixpoint44;
int numfixpoint88;
int numredefvars;
int optimization;
int numconstants;
int numthens;
int ors;
int line;
int numjsrs;
int numelses;
int doingfunction;
char Areg[50];
int branchtargetnumber;

#endif
