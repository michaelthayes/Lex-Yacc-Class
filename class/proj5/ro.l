%{
#include "y.tab.h"
char ident[80];
char control[80];
char term[80];
char addop;
char mulop[10];
int ans;
%}
Pickbeeper     pickbeeper|PickBeeper|pick_beeper
Move           move|Move
New            new|New
PutBeeper      putbeeper|PutBeeper|put_beeper
Turnleft       turnleft|TurnLeft|turn_left
Turnoff        turnoff|TurnOff|turn_off
Tell           Tell|tell
If             if|If
Else           else|Else
While          while|While
Remove         remove|Remove
Identifier     [a-zA-Z_]
term           [0-9]
%%
execute        { return(EXECUTE); }
{Tell}         { strcpy(control, yytext); return(TELL); }
{New}          { strcpy(control, yytext); return(NEW); }
times          { return(TIMES); }
{Pickbeeper}   { strcpy(ident, yytext); return(PICKBEEPER); }
{Move}         { strcpy(ident, yytext); return(MOVE); }
{Turnleft}     { strcpy(ident, yytext); return(TURNLEFT); }
{Turnoff}      { strcpy(ident, yytext); return(TURNOFF); }
{If}           { return(IF); }
{Else}         { return(ELSE); }
iterate        { return(ITERATE); }
{Remove}       { return(REMOVE); }
{While}        { strcpy(control, yytext); return(WHILE); }
{term}+        { strcpy(term, yytext); return(TERM); }
{Identifier}+  { strcpy(ident, yytext); return(IDENTIFIER); }
[*/]           { strcpy(mulop, yytext); return(MULOP); }
[-+]           { addop=yytext[0]; return(ADDOP); }
[ \t\n]        { printf(""); }
[;:,(){}]      { printf("Punctuation \"%c\"\n", yytext[0]); return(yytext[0]); }
%%

