// Provided under the GPL v2 license. See the included LICENSE.txt for details.

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
void rerand();
void function(char **);
void add_inline(char *);
void add_includes(char *);
void create_includes(char *);
void endfunction();
void invalidate_Areg();
int getcondpart();
int linenum();
int islabel(char **);
int islabelelse(char **);
void compressdata(char **, int, int);
void shiftdata(char **, int);
int findpoint(char *);
int getindex(char *, char *);
int bbgetline();
void doend();
int bbank();
int bbs();
void barf_sprite_data();
void printindex(char *, int);
void loadindex(char *);
void jsr(char *);
int islabel(char **);
int islabelelse(char **);
int findlabel(char **, int i);
void add_includes(char *);
void create_includes(char *);
void incline();
void init_includes();
void invalidate_Areg();
void shiftdata(char **, int);
void compressdata(char **, int, int);
void function(char **);
void endfunction();
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
void doif(char **);
void dolet(char **);
void dec(char **);
void rem(char **);
void set(char **);
void dogoto(char **);
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
