%{
#include <stdlib.h>  
#include <string.h>
char mystring[100];
char mystring2[100];
char *mychar;

//void yyerror(char *);  
%}    
%x rlda
%%    
[ \t]+ putchar(' ');
[ \t\r]+$

"cmp #0"$
"cmp #$0"$
"cmp #$00"$

"sta "+[A-Za-z0-9]+ {printf("%s",yytext);mychar=strtok(yytext," ");strcpy(mystring,mychar+strlen(mychar)+1);BEGIN(rlda);}
<rlda>"," {printf("%s",yytext);BEGIN(INITIAL);}
<rlda>"+" {printf("%s",yytext);BEGIN(INITIAL);}
<rlda>"#" {printf("%s",yytext);BEGIN(INITIAL);}
<rlda>"(" {printf("%s",yytext);BEGIN(INITIAL);}
<rlda>[ \t\r\n]+ {printf("%s",yytext);}
<rlda>[A-Za-z0-9]+ {if (strcmp(yytext,"lda")) printf("%s",yytext);BEGIN(INITIAL);}
<rlda>"lda"+[ \t]+[A-Za-z0-9]+"+" {printf(" %s",yytext);BEGIN(INITIAL);}
<rlda>"lda"+[ \t]+[A-Za-z0-9]+ {
 mychar=strtok(yytext," ");
 strcpy(mystring2,mychar+strlen(mychar)+1); 
 
 if (strcmp(mystring,mystring2)) {printf(" lda %s",mystring2);BEGIN(INITIAL);}
 else {printf(" ; lda %s",mystring2);BEGIN(INITIAL);}
 }
<rlda>"ldx"+[ \t]+[A-Za-z0-9]+ {// experimental conversion of sta val/ldx val to sta/tax
 mychar=strtok(yytext," ");
 strcpy(mystring2,mychar+strlen(mychar)+1); 
 
 if (strcmp(mystring,mystring2)) {printf(" ldx %s",mystring2);BEGIN(INITIAL);}
 else {printf(" tax\n");BEGIN(INITIAL);}
 }
<rlda>"lda"+[ \t]+[^A-Za-z0-9] {printf(" %s",yytext);BEGIN(INITIAL);}
<rlda>"lda.w" {printf(" %s",yytext);BEGIN(INITIAL);}

[A-Za-z]+ printf("%s",yytext);
[0-9]+      {       printf("%s", yytext);}
[\n] {printf("\n");}
.      {       printf("%s", yytext);}
%%
  int yywrap(void) {      return 1;  } 
int main(){yylex();}
