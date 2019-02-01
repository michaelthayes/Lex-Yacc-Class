%{
#include<stdio.h>
%}
%start executable_part
%token EXECUTE
%token NEW
%token TELL
%token REMOVE
%token IDENTIFIER
%token PICKBEEPER
%token MOVE
%token EXPRESSION
%token IF
%token ELSE
%token ITERATE
%token WHILE
%token TURNOFF
%token TURNLEFT
%token PUNC
%token WORD
%%
executable_part: EXECUTE PUNC statements PUNC                 { printf("Executable-Part\n");};
statements: statement statements                              { printf("Statements\n");}
            | statement                                       { printf("Statements\n");};
statement: new_statement                                      { printf("Statement\n");}
           | tell_statement                                   { printf("Statement\n");}
           | iterate_statement                                { printf("Statement\n");}
           | remove_statement                                 { printf("Statement\n");};
new_statement: NEW robot_type object_name PUNC                { printf("New-Statement\n");};
tell_statement: TELL robot_name PUNC instructions             { printf("Tell-Statement\n");};
iterate_statement: ITERATE EXPRESSION WORD statements         { printf("Iterate-Statement\n");};
remove_statement: REMOVE robot_name PUNC                      { printf("Remove-Statement\n");};
instructions: PUNC instruction instructions PUNC              { printf("Instructions\n");}
              | instruction                                   { printf("Instructions\n");};
instruction: simple_instruction PUNC                          { printf("Instruction\n");}
             | control_instruction PUNC                       { printf("Instruction\n");}
             | assignment_instruction PUNC                    { printf("Instruction\n");};
control_instruction: if_instruction                           { printf("Control-Instruction\n");}
                     | iterate_instruction                    { printf("Control-Instruction\n");}
                     | while_instruction                      { printf("Control-Instruction\n");};
if_instruction: IF PUNC EXPRESSION PUNC instructions ELSE instructions  { printf("If-Instruction\n");}
                | IF PUNC EXPRESSION PUNC instructions        { printf("If-Instruction\n");};
iterate_instruction: ITERATE EXPRESSION WORD instructions     { printf("Iterate-Instruction\n");};
while_instruction: WHILE EXPRESSION instructions              { printf("While-Instruction\n");};
assignment_instruction: variable_name PUNC EXPRESSION PUNC    { printf("Assignment-Instruction\n");};
simple_instruction: PICKBEEPER                                { printf("Simple-Instruction\n");}
                    | MOVE EXPRESSION                         { printf("Simple-Instruction\n");}
		    | TURNOFF                                 { printf("Simple-Instruction\n");}
                    | TURNLEFT                                { printf("Simple-Instruction\n");};
robot_name: object_name                                       { printf("Robot_Name\n");};
robot_type: variable_name                                     { printf("Robot-Type\n");};
variable_name: object_name                                    { printf("Variable-Name\n");}; 
object_name: IDENTIFIER                                       { printf("Object-Name\n");};
%%
main()
{
  yyparse();
}
yyerror(char *s)
{
  fprintf(stderr, "%s\n", s);
}
