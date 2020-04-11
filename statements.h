// Provided under the GPL v2 license. See the included LICENSE.txt for details.

typedef unsigned char BOOL;
#define false 0
#define true  1

#define _BV(N)          (1 << (N))
#define MATCH(VAR,STR)  (!strncmp(VAR, STR, strlen(STR)))
#define SMATCH(IND,STR) MATCH(statement[IND], STR)
#define IMATCH(IND,STR) (!strncasecmp(statement[IND], STR, strlen(STR)))
#define CMATCH(IND,CHR) (statement[IND][0] == CHR)
#define WITHIN(N,A,B)   ((N)>=(A)&&(N)<=(A))
#define ISNUM(C)        WITHIN(C,'0','9')
#define COUNT(X)        (sizeof(X)/sizeof(*X))

#define _readpaddle 1
#define _player1colors 2
#define _playercolors 4
#define _no_blank_lines 8
#define _pfcolors 16
#define _pfheights 32
#define _background 64
#define MAX_EXTRAS 5

#include <stdio.h>

void doextra(char *);
void callmacro(char **);
void do_stack(char **);
void do_pull(char **);
void do_push(char **);
void domacro(char **);
void lives(char **);
void scorecolors(char **);
void playfield(char **);
void bkcolors(char **);
void playfieldcolorandheight(char **);
void vblank();
void doreboot();
void dopop();
void doasm();
void pfclear(char **);
void data(char **);
void sdata(char **);
void newbank(int);
void dogoto(char **);
void doif(char **);
void function(char **);
void add_inline(char *);
void add_includes(char *);
void create_includes(char *);
void endfunction();
void invalidate_Areg();
int getcondpart();
int linenum();
BOOL islabel(char **);
BOOL islabelelse(char **);
void compressdata(char **, int, int);
void shiftdata(char **, int);
int findpoint(char *);
int getindex(char *, char *);
int bbgetline();
void doend();
int bbank();
int bbs();
void barf_sprite_data();
void loadindex(char *);
void jsr(char *);
BOOL findlabel(char **, int i);
void incline();
void init_includes();
void callfunction(char **);
void ongoto(char **);
void doreturn(char **);
void doconst(char **);
void dim(char **);
void dofor(char **);
void mul(char **, int);
void divd(char **, int);
void next(char **);
void gosub(char **);
void dolet(char **);
void dec(char **);
void rem(char **);
void set(char **);
void pfpixel(char **);
void pfhline(char **);
void pfvline(char **);
void pfscroll(char **);
void player(char **);
void drawscreen(void);
void prerror(char *);
void remove_trailing_commas(char *);
void removeCR(char *);
void bmi(char *);
void bpl(char *);
void bne(char *);
void beq(char *);
void bcc(char *);
void bcs(char *);
void bvc(char *);
void bvs(char *);
int printimmed(char *);
int isimmed(char *);
int number(unsigned char);
void header_open(FILE *);
void header_write(FILE *, char *);
