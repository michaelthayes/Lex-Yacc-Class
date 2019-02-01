%{
#include "y.tab.h"
%}
Pickbeeper     pickbeeper|PickBeeper|pick_beeper
Move           move|Move
PutBeeper      putbeeper|PutBeeper|put_beeper
Turnleft       turnleft|TurnLeft|turn_left
Turnoff        turnoff|TurnOff|turn_off
If             if|If
Else           else|Else
While          while|While
Remove         remove|Remove
%%
execute        { return(EXECUTE); }
tell           { return(TELL); }
Tell           { return(TELL); }
New            { return(NEW); }
new            { return(NEW); }
times          { printf("Bearing Word\n"); return(WORD); }
{Pickbeeper}   { return(PICKBEEPER); }
{Move}         { return(MOVE); }
{Turnleft}     { return(TURNLEFT); }
{Turnoff}      { return(TURNOFF); }
{If}           { return(IF); }
{Else}         { return(ELSE); }
iterate        { return(ITERATE); }
Remove         { return(REMOVE); }
{While}        { return(WHILE); }
[a-zA-Z_]+     { return(IDENTIFIER); }
[0-9A-Za-z]+   { printf("Expression\n"); return(EXPRESSION); }
[;:,{}()=]     { printf("Punctuation\n"); return(PUNC); }
