%{
#include<stdio.h>
#include<string.h>
#define MAX 80
struct node_list{
  char type[MAX];
  char info[MAX];
  int begin_line;
  int end_line;
  struct node_list *left;
  struct node_list *right;
};
typedef struct node_list NODE;
typedef NODE *NODEPTR;
char ident[MAX];
char control[MAX];
char expr[MAX];
int paren=0, i, line=1;
int temp=0;
NODEPTR create_node(char *);
void print_node();
%}
%union{
  struct node_list *nodeptr;
};
%type <nodeptr> executable_part
%type <nodeptr> statements
%type <nodeptr> statement
%type <nodeptr> new_statement
%type <nodeptr> tell_statement
%type <nodeptr> iterate_statement
%type <nodeptr> remove_statement
%type <nodeptr> instructions
%type <nodeptr> instruction
%type <nodeptr> control_instruction
%type <nodeptr> if_instruction
%type <nodeptr> iterate_instruction
%type <nodeptr> while_instruction
%type <nodeptr> assignment_instruction
%type <nodeptr> simple_instruction
%type <nodeptr> robot_name
%type <nodeptr> robot_type
%type <nodeptr> variable_name
%type <nodeptr> object_name
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
%token TIMES
%{
extern char yytext();
%}
%%
executable_part: EXECUTE statements                           
{
  printf("Executable-Part\n");
  $$=create_node("Program");
  $$->right=$2;
  strcpy($$->info, "execute");
  $$->begin_line=line;
  $$->end_line=$$->right->end_line;
  printf("\nHere is the list:\n");
  print_node($$);
  paren++;
  /*for(i=0; i<paren; i++) printf(")");*/
  printf("\n");
};


statements: '{' statement statements '}'                  
{
  printf("Statements\n");
  $$=create_node("Statements");
  $$->left=$2;
  $$->right=$3;
  $$->begin_line=$$->left->begin_line;
  $$->end_line=$$->right->end_line+$$->left->end_line;
}
            |  statement
{
  printf("Statements\n");
  $$=$1;
};


statement: new_statement
{
  printf("Statement\n");
  $$=$1;
}
           | tell_statement
{
  printf("Statement\n");
  $$=$1;
}
           | iterate_statement
{
  printf("Statement\n");
  $$=$1;
}
           | remove_statement
{
  printf("Statement\n");
  $$=$1;
};


new_statement: NEW robot_type object_name ';'                 
{
  printf("New-Statement\n");
  $$=create_node("New-Statement");
  strcpy($$->info, control);
  $$->left=$2;
  $$->right=$3;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->left->end_line+1;
};


tell_statement: TELL robot_name ':' instructions
{
  printf("Tell-Statement\n");
  $$=create_node("Tell-Statement");
  strcpy($$->info, control);
  $$->left=$2;
  $$->right=$4;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


iterate_statement: ITERATE EXPRESSION TIMES instructions
{
  printf("Iterate-Statement\n");
  $$=create_node("Iterate-Statement");
  strcpy($$->info, "iterate ");
  strcat($$->info, expr);
  strcat($$->info, " times");
  $$->right=$4;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


remove_statement: REMOVE robot_name ';'
{ 
  printf("Remove-Statement\n");
  $$=create_node("Statement");
  strcpy($$->info, "remove");
  $$->right=$2;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


instructions: '{' instruction instructions '}'
{
  printf("Instructions\n");
  $$=create_node("Instructions");
  $$->left=$2;
  $$->right=$3;
  $$->begin_line=$$->left->begin_line;
  $$->end_line=$$->right->end_line+$$->left->end_line;
}
              | instruction
{
  printf("Instructions\n");
  $$=$1;
};


instruction: simple_instruction ';'
{ 
  printf("Instruction\n");
  $$=$1;
}
             | control_instruction
{
  printf("Instruction\n");
  $$=$1;
}
             | assignment_instruction ';'
{
  printf("Instruction\n");
  $$=$1;
};


control_instruction: if_instruction                           
{ 
  printf("Control-Instruction\n");
  $$=$1;
}
                     | iterate_instruction
{
  printf("Control-Instruction\n");
  $$=$1;
}
                     | while_instruction
{
  printf("Control-Instruction\n");
  $$=$1;
};


if_instruction: IF '{' EXPRESSION '}' instructions ELSE instructions
{
  printf("If-Instruction\n");
  $$=create_node("If-Instruction");
  strcpy($$->info, "else");
  $$->right=$7;
  $$->left=create_node("If-Start-Stuff");
  strcpy($$->info, "If { ");
  strcat($$->info, expr);
  strcat($$->info, " }");
  $$->left=$5;
  $$->begin_line=1;
}
                | IF '{' EXPRESSION '}' instructions
{
  printf("If-Instruction\n");
  $$=create_node("If-Instruction");
  strcpy($$->info, "If { ");
  strcat($$->info, expr);
  strcat($$->info, " }");
  $$->right=$5;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


iterate_instruction: ITERATE EXPRESSION TIMES instructions
{
  printf("Iterate-Instruction\n");
  $$=create_node("Iterate-Instruction");
  strcpy($$->info, "iterate ");
  strcat($$->info, expr);
  strcat($$->info, " times");
  $$->right=$4;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


while_instruction: WHILE EXPRESSION instructions
{
  printf("While-Instruction\n");
  $$=create_node("While-Instruction");
  strcpy($$->info, control);
  strcat($$->info, " ");
  strcat($$->info, expr);
  $$->right=$3;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


assignment_instruction: variable_name '(' EXPRESSION ')'
{ 
  printf("Assignment-Instruction\n");
  $$=create_node("Assignment-Instruction");
  strcpy($$->info, "( ");
  strcat($$->info, expr);
  strcat($$->info, " )");
  $$->right=$1;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


simple_instruction: PICKBEEPER
{
  printf("Simple-Instruction\n");
  $$=create_node("Simple-Instruction");
  strcpy($$->info, ident);
  $$->begin_line=line;
  $$->end_line=line;
}

                    | MOVE EXPRESSION
{
  printf("Simple-Instruction\n");
  $$=create_node("Simple-Instruction");
  strcpy($$->info, ident);
  strcat($$->info, " ");
  strcat($$->info, expr);
  $$->begin_line=line;
  $$->end_line=line;
}
		    | TURNOFF
{
  printf("Simple-Instruction\n");
  $$=create_node("Simple-Instruction");
  strcpy($$->info, ident);
  $$->begin_line=line;
  $$->end_line=line;
}
                    | TURNLEFT
{ 
  printf("Simple-Instruction\n");
  $$=create_node("Simple-Instruction");
  strcpy($$->info, ident);
  $$->begin_line=line;
  $$->end_line=line;
};


robot_name: object_name
{
  printf("Robot-Name\n");
  $$=$1;
};


robot_type: variable_name
{
  printf("Robot-Type\n");
  $$=$1;
};


variable_name: object_name                                    
{
  printf("Variable-Name\n");
  $$=$1;
};


object_name: IDENTIFIER                                       
{
  printf("Object-Name\n");
  $$=create_node("Object-Name");
  strcpy($$->info, ident);
  $$->begin_line=line;
  $$->end_line=line;
};
%%
/* Create node of tree */
NODEPTR create_node(char *str){
  NODE *new_node;
  int len;
  
  /* Allocate new node struct */
  if((new_node=(NODE *)malloc(sizeof(NODE)))==NULL)
    return(NULL);
  
  /* Initialize fields to default values */
  new_node->type[0]='\0';
  new_node->info[0]='\0';
  
  strcpy(new_node->type, str);
  
  new_node->begin_line=0;
  new_node->end_line=0;
 
  new_node->left=NULL;
  new_node->right=NULL;

  return(new_node);
}


/* Prints the tree in a the preorder fashion */
void print_node(NODEPTR currentPtr){
  if(currentPtr != NULL){
    if(currentPtr->info[0]=='\0');
    else{
      if(temp<currentPtr->begin_line){
	temp=currentPtr->begin_line;
	printf("\n");
      }
      if(temp==currentPtr->begin_line){
	printf("(%d,%d) ", currentPtr->begin_line, currentPtr->end_line);
      }
      printf("%s ", currentPtr->info);
      
    }
    print_node(currentPtr->left);
    print_node(currentPtr->right);
  }
}

main(){
  /*  typedef struct node_list NODE;*/
  yyparse();
}
yyerror(char *s)
{
  fprintf(stderr, "%s\n", s);
}








