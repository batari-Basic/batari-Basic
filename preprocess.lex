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
%x data
%x sdata
%x player
%x lives
%x playercolor
%x scorecolors
%x pffirstline
%x playfield
%x pfcolors
%x bkcolors
%x pfheights
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
<asm>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<asm>"\n" {linenumber++;printf("\n");}

"_sdata"            printf("%s", yytext);
"sdata" {printf("%s",yytext);BEGIN(sdata);}
<sdata>"=" printf(" %s ", yytext);  
<sdata>[ \t]+ putchar(' ');
<sdata>^"\nend" printf("%s",yytext);
<sdata>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<sdata>"\n" {linenumber++;printf("\n");}

"_data"            printf("%s", yytext);
"data" {printf("%s",yytext);BEGIN(data);}
<data>^"\nend" printf("%s",yytext);
<data>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<data>"\n" {linenumber++;printf("\n");}

"_include"            printf("%s", yytext);
"include" {printf("%s",yytext);BEGIN(includes);}
<includes>^\n* printf("%s",yytext);
<includes>\n {linenumber++;printf("\n");BEGIN(INITIAL);}

"player"[0123456789-]+: {printf("%s",yytext);BEGIN(player);}
<player>^"\nend" printf("%s",yytext);
<player>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<player>"\n" {linenumber++;printf("\n");}

"lives:" {printf("%s",yytext);BEGIN(lives);}
<lives>^"\nend" printf("%s",yytext);
<lives>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<lives>"\n" {linenumber++;printf("\n");}

"scorecolors:" {printf("%s",yytext);BEGIN(scorecolors);}
<scorecolors>[ \t]+ ;
<scorecolors>^"\nend" printf("%s",yytext);
<scorecolors>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<scorecolors>"\n" {linenumber++;printf("\n");}

"player"[0123456789-]+"color:" {printf("%s",yytext);BEGIN(playercolor);}
<playercolor>^"\nend" printf("%s",yytext);
<playercolor>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<playercolor>"\n" {linenumber++;printf("\n");}

"playfield:" {printf("%s",yytext);BEGIN(pffirstline);}

<pffirstline>[ \t]+ printf(" ");
<pffirstline>"\n" {linenumber++;printf("\n");BEGIN(playfield);}

"_playfield"            printf("%s", yytext);
<playfield>[ \t]+ ;
<playfield>^"\nend" printf(" %s",yytext);
<playfield>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<playfield>"\n" {linenumber++;printf("\n");}

[pP][fF]"colors:" {printf("%s",yytext);BEGIN(pfcolors);}
<pfcolors>[ \t]+ printf(" ");
<pfcolors>^"\nend" printf(" %s",yytext);
<pfcolors>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<pfcolors>"\n" {linenumber++;printf("\n");}

[bB][kK]"colors:" {printf("%s",yytext);BEGIN(bkcolors);}
<bkcolors>[ \t]+ printf(" ");
<bkcolors>^"\nend" printf(" %s",yytext);
<bkcolors>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<bkcolors>"\n" {linenumber++;printf("\n");}

[pP][fF]"heights:" {printf("%s",yytext);BEGIN(pfheights);}
<pfheights>[ \t]+ printf(" ");
<pfheights>^"\nend" printf(" %s",yytext);
<pfheights>"\nend" {linenumber++;printf("\nend");BEGIN(INITIAL);}
<pfheights>"\n" {linenumber++;printf("\n");}

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
