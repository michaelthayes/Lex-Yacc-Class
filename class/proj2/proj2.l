Booleans       FrontIsClear|front_is_clear|RightIsClear|rightisclear|LeftIsClear|left_is_clear|FacingNorth|facingNorth|facing_north
Instructions   execute|new|at|tell|iterate|times|remove|Move|TurnLeft|PickBeeper|PutBeeper|if|else|while|BeeperInBag|beepers_in_bag|BeepersOnFloor|beepers_on_floor|XPosition|x_position|YPosition|y_position
Digit          [0-9]+
Space          [ \t\n]
Operators      [;:,*+-]
Braces         ["("|")"|"{"|"}"]
Bool_char      ["<"|">"|"<="|">="|"/"|"=="|"&&"|"||"]
Bool_words     or|and|not
Identifier     [a-zA-Z_]+
%%
{Bool_char}+         { printf("Booleans               %s\n", yytext); }
{Bool_words}+        { printf("Booleans               %s\n", yytext); }
{Braces}             { printf("Braces                 %s\n", yytext); }
{Instructions}+      { printf("Instructions           %s\n", yytext); } 
{Space}              { printf(""); }
{Operators}          { printf("Operators              %s\n", yytext); }
{Identifier}         { printf("Identifier             %s\n", yytext); }
{Digit}              { printf("Digit                  %s\n", yytext); }





