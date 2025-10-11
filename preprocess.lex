%{
#include <stdlib.h>
int linenumber=1;
//void yyerror(char *);
%}
%x mcomment
%x scomment
%x endmcomment
%x comment
%x asm
%x asm_mcomment
%x data
%x data_mcomment
%x sdata
%x sdata_mcomment
%x player
%x player_mcomment
%x lives
%x lives_mcomment
%x playercolor
%x playercolor_mcomment
%x scorecolors
%x scorecolors_mcomment
%x pffirstline
%x playfield
%x playfield_mcomment
%x pfcolors
%x pfcolors_mcomment
%x bkcolors
%x bkcolors_mcomment
%x pfheights
%x pfheights_mcomment
%x includes
%x collision
%%
[ \t]+ putchar(' ');
[ \t\r]+$

[ \t\r]+";" {BEGIN(scomment);}
";" {BEGIN(scomment);}
<scomment>. ;
<scomment>\n {linenumber++;printf("\n");BEGIN(INITIAL);}

"rem" {printf("rem");BEGIN(comment);}
<comment>^\n* printf("%s",yytext);
<comment>\n {linenumber++;printf("\n");BEGIN(INITIAL);}

[ \t\r]+"/*" {BEGIN(mcomment);}
"/*" {BEGIN(mcomment);}
<mcomment>"*/" {BEGIN(INITIAL);}
<mcomment>. ;
<mcomment>\n {linenumber++; printf("\n");}

<endmcomment>. ;
<endmcomment>\n {linenumber++;BEGIN(INITIAL);}

"_asm"            printf("%s", yytext);
"asm" {printf("%s",yytext);BEGIN(asm);}
<asm>";".* ;
<asm>"/*" {BEGIN(asm_mcomment);}
<asm>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<asm_mcomment>"*/" {BEGIN(asm);}
<asm_mcomment>. ;

"_sdata"            printf("%s", yytext);
"sdata" {printf("%s",yytext);BEGIN(sdata);}
<sdata>"=" printf(" %s ", yytext);
<sdata>[ \t]+ putchar(' ');
<sdata>";".* ;
<sdata>"/*" {BEGIN(sdata_mcomment);}
<sdata>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<sdata_mcomment>"*/" {BEGIN(sdata);}
<sdata_mcomment>. ;

"_data"            printf("%s", yytext);
"data" {printf("%s",yytext);BEGIN(data);}
<data>";".* ;
<data>"/*" {BEGIN(data_mcomment);}
<data>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<data_mcomment>"*/" {BEGIN(data);}
<data_mcomment>. ;

"_include"            printf("%s", yytext);
"include" {printf("%s",yytext);BEGIN(includes);}
<includes>^\n* printf("%s",yytext);
<includes>\n {linenumber++;printf("\n");BEGIN(INITIAL);}

"player"[0123456789-]+: {printf("%s",yytext);BEGIN(player);}
<player>";".* ;
<player>"/*" {BEGIN(player_mcomment);}
<player>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<player_mcomment>"*/" {BEGIN(player);}
<player_mcomment>. ;

"lives:" {printf("%s",yytext);BEGIN(lives);}
<lives>";".* ;
<lives>"/*" {BEGIN(lives_mcomment);}
<lives>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<lives_mcomment>"*/" {BEGIN(lives);}
<lives_mcomment>. ;

"scorecolors:" {printf("%s",yytext);BEGIN(scorecolors);}
<scorecolors>[ \t]+ ;
<scorecolors>";".* ;
<scorecolors>"/*" {BEGIN(scorecolors_mcomment);}
<scorecolors>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<scorecolors_mcomment>"*/" {BEGIN(scorecolors);}
<scorecolors_mcomment>. ;

"player"[0123456789-]+"color:" {printf("%s",yytext);BEGIN(playercolor);}
<playercolor>";".* ;
<playercolor>"/*" {BEGIN(playercolor_mcomment);}
<playercolor>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<playercolor_mcomment>"*/" {BEGIN(playercolor);}
<playercolor_mcomment>. ;

"playfield:" {printf("%s",yytext);BEGIN(pffirstline);}

<pffirstline>[ \t]+ printf(" ");
<pffirstline>"\n" {linenumber++;printf("\n");BEGIN(playfield);}

"_playfield"            printf("%s", yytext);
<playfield>[ \t]+ ;
<playfield>";".* ;
<playfield>"/*" {BEGIN(playfield_mcomment);}
<playfield>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<playfield_mcomment>"*/" {BEGIN(playfield);}
<playfield_mcomment>. ;

[pP][fF]"colors:" {printf("%s",yytext);BEGIN(pfcolors);}
<pfcolors>[ \t]+ printf(" ");
<pfcolors>";".* ;
<pfcolors>"/*" {BEGIN(pfcolors_mcomment);}
<pfcolors>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<pfcolors_mcomment>"*/" {BEGIN(pfcolors);}
<pfcolors_mcomment>. ;

[bB][kK]"colors:" {printf("%s",yytext);BEGIN(bkcolors);}
<bkcolors>[ \t]+ printf(" ");
<bkcolors>";".* ;
<bkcolors>"/*" {BEGIN(bkcolors_mcomment);}
<bkcolors>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<bkcolors_mcomment>"*/" {BEGIN(bkcolors);}
<bkcolors_mcomment>. ;

[pP][fF]"heights:" {printf("%s",yytext);BEGIN(pfheights);}
<pfheights>[ \t]+ printf(" ");
<pfheights>";".* ;
<pfheights>"/*" {BEGIN(pfheights_mcomment);}
<pfheights>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<pfheights_mcomment>"*/" {BEGIN(pfheights);}
<pfheights_mcomment>. ;

"_collision"            printf("%s", yytext);
"collision(" {printf("%s",yytext);BEGIN(collision);}
<collision>" "+
<collision>":\t\n"+ {fprintf(stderr,"%d: Missing )\n",linenumber);exit(1);}
<collision>^")" printf("%s",yytext);
<collision>")" {printf("%s",yytext);BEGIN(INITIAL);}

".asm" printf("%s",yytext);
"extra"[0-9]+: printf("%s",yytext);
"step"[ ]+"-" printf("step -");
"#"            printf("%s", yytext);
"$"            printf("%s", yytext);
"%"            printf("%s", yytext);
"["            printf("%s", yytext);
"]"            printf("%s", yytext);
"!"            printf("%s", yytext);
"."            printf("%s", yytext);
"_"            printf("%s", yytext);
"{"          printf("%s", yytext);
"}"          printf("%s", yytext);


","              printf(" %s ", yytext);
"("              printf(" %s ", yytext);
")"              printf(" %s ", yytext);
">="             printf(" %s ", yytext);
"<="             printf(" %s ", yytext);
[ \t]*"="[ \t]*  printf(" = ");
"<>"             printf(" %s ", yytext);
"<"              printf(" %s ", yytext);
"+"              printf(" %s ", yytext);
"-"              printf(" %s ", yytext);
"/"+             printf(" %s ", yytext);
"*"+             printf(" %s ", yytext);
">"              printf(" %s ", yytext);
":"              printf(" %s ", yytext);
"&"+             printf(" %s ", yytext);
"|"+             printf(" %s ", yytext);
"^"              printf(" %s ", yytext);

[A-Z]+ printf("%s",yytext);
[a-z]+       {       printf("%s", yytext);}
[0-9]+      {       printf("%s", yytext);}
[\n] {printf("\n"); linenumber++;}
.               {fprintf(stderr,"(%d) Parse error: unrecognized character \"%s\"\n",linenumber,yytext);  exit(1);}
%%
  int yywrap(void) {      return 1;  }
int main(){yylex();}
