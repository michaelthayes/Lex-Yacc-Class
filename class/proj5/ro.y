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
char mulop[10];
char addop;
char term[MAX];
int paren=0, i, line=1;
int temp=0;
NODEPTR create_node(char *);
void Maze();
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
%type <nodeptr> expression
%type <nodeptr> factor
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
%token DISTANCE
%token TERM
%token MULOP
%token ADDOP
%{
extern char yytext();
%}
%%
executable_part: EXECUTE '{' statements '}'
{
  printf("Executable-Part\n");
  $$=create_node("Program");
  $$->right=$3;
  strcpy($$->info, "execute");
  $$->begin_line=line;
  $$->end_line=$$->right->end_line;
  printf("\nHere is the list:\n");
  print_node($$);
  printf("\n\n");
  Maze();
}
                | EXECUTE statement
{
  printf("Executable-Part\n");
  $$=create_node("Program");
  $$->right=$2;
  strcpy($$->info, "execute");
  $$->begin_line=line;
  $$->end_line=$$->right->end_line;
  printf("\nHere is the list:\n");
  print_node($$);
  printf("\n\n");
  Maze();
};


statements: statement statements
{
  printf("Statements\n");
  $$=create_node("Statements");
  $$->left=$1;
  $$->right=$2;
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


tell_statement: TELL robot_name ':' '{' instructions '}'
{
  printf("Tell-Statement\n");
  $$=create_node("Tell-Statement");
  strcpy($$->info, control);
  $$->left=$2;
  $$->right=$5;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
}
               | TELL robot_name ':' instruction
{
  printf("Tell-Statement\n");
  $$=create_node("Tell-Statement");
  strcpy($$->info, control);
  $$->left=$2;
  $$->right=$4;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


iterate_statement: ITERATE IDENTIFIER TIMES '{' instructions '}'
{
  printf("Iterate-Statement\n");
  $$=create_node("Iterate-Statement");
  strcpy($$->info, "iterate");
  $$->left=create_node("Iterate Expression");
  strcpy($$->left->info, ident);
  $$->left->left=create_node("Iterate times");
  strcpy($$->left->left->info, "times");
  $$->right=$5;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
}
                  | ITERATE IDENTIFIER TIMES instruction
{
  printf("Iterate-Statement\n");
  $$=create_node("Iterate-Statement");
  strcpy($$->info, "iterate");
  $$->left=create_node("Iterate Expression");
  strcpy($$->left->info, ident);
  $$->left->left=create_node("Iterate times");
  strcpy($$->left->left->info, "times");
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


instructions: instruction instructions
{
  printf("Instructions\n");
  $$=create_node("Instructions");
  $$->left=$1;
  $$->right=$2;
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


if_instruction: IF '{' IDENTIFIER '}' '{' instructions '}' ELSE '{' instructions '}'
{
  printf("If-Instruction\n");
  $$=create_node("If-Instruction");
  strcpy($$->info, "else");
  $$->right=$10;
  $$->left=create_node("If-Start-Stuff");
  strcpy($$->info, "If { ");
  strcat($$->info, ident);
  strcat($$->info, " }");
  $$->left=$6;
  $$->begin_line=1;
}
                | IF '{' IDENTIFIER '}' instruction ELSE '{' instructions '}'
{
  printf("If-Instruction\n");
  $$=create_node("If-Instruction");
  strcpy($$->info, "else");
  $$->right=$8;
  $$->left=create_node("If-Start-Stuff");
  strcpy($$->info, "If { ");
  strcat($$->info, ident);
  strcat($$->info, " }");
  $$->left=$5;
  $$->begin_line=1;
}
                | IF '{' IDENTIFIER '}'  '{' instructions '}' ELSE instruction
{
  printf("If-Instruction\n");
  $$=create_node("If-Instruction");
  strcpy($$->info, "else");
  $$->right=$9;
  $$->left=create_node("If-Start-Stuff");
  strcpy($$->info, "If { ");
  strcat($$->info, ident);
  strcat($$->info, " }");
  $$->left=$6;
  $$->begin_line=1;
}
                | IF '{' IDENTIFIER '}' instruction ELSE instruction
{
  printf("If-Instruction\n");
  $$=create_node("If-Instruction");
  strcpy($$->info, "else");
  $$->right=$7;
  $$->left=create_node("If-Start-Stuff");
  strcpy($$->info, "If { ");
  strcat($$->info, ident);
  strcat($$->info, " }");
  $$->left=$5;
  $$->begin_line=1;
}
                | IF '{' IDENTIFIER '}' instruction
{
  printf("If-Instruction\n");
  $$=create_node("If-Instruction");
  strcpy($$->info, "If");
  $$->left=create_node("If-Expression");
  strcpy($$->info, "{ ");
  strcat($$->info, ident);
  strcat($$->info, " }");
  $$->right=$5;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
}
                | IF '{' IDENTIFIER '}' '{' instructions '}'
{
  printf("If-Instruction\n");
  $$=create_node("If-Instruction");
  strcpy($$->info, "If");
  $$->left=create_node("If-Expression");
  strcpy($$->info, "{ ");
  strcat($$->info, ident);
  strcat($$->info, " }");
  $$->right=$6;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


iterate_instruction: ITERATE TERM TIMES '{' instructions '}'
{
  printf("Iterate-Instruction\n");
  $$=create_node("Iterate-Instruction");
  strcpy($$->info, "iterate");
  $$->left=create_node("Iterate Expression");
  strcpy($$->left->info, term);
  $$->left->left=create_node("Iterate times");
  strcpy($$->left->left->info, "times");
  $$->right=$5;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
}
                  | ITERATE TERM TIMES instruction
{
  printf("Iterate-Instruction\n");
  $$=create_node("Iterate-Instruction");
  strcpy($$->info, "iterate");
  $$->left=create_node("Iterate Expression");
  strcpy($$->left->info, term);
  $$->left->left=create_node("Iterate times");
  strcpy($$->left->left->info, "times");
  $$->right=$4;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


while_instruction: WHILE IDENTIFIER '{' instructions '}'
{
  printf("While-Instruction\n");
  $$=create_node("While-Instruction");
  strcpy($$->info, control);
  strcat($$->info, " ");
  strcat($$->info, ident);
  $$->right=$4;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
}
                  | WHILE IDENTIFIER instruction
{
  printf("While-Instruction\n");
  $$=create_node("While-Instruction");
  strcpy($$->info, control);
  strcat($$->info, " ");
  strcat($$->info, ident);
  $$->right=$3;
  $$->begin_line=$$->right->begin_line+1;
  $$->end_line=$$->right->end_line+1;
};


assignment_instruction: variable_name '(' IDENTIFIER ')'
{
  printf("Assignment-Instruction\n");
  $$=create_node("Assignment-Instruction");
  strcpy($$->info, "( ");
  strcat($$->info, ident);
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

                    | MOVE expression
{
  printf("Simple-Instruction\n");
  $$=create_node("Simple-Instruction");
  strcpy($$->info, ident);
  $$->left=$2;
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

expression: TERM ADDOP factor
{
  printf("Expression\n");
  $$=create_node("Expression");
  $$->info[0]=addop;
  $$->left=create_node("term");
  strcpy($$->left->info, term);
  $$->right=$3;
}
          | factor
{
  printf("Expression\n");
  $$=$1;
};
factor: TERM MULOP factor
{
  printf("Factor\n");
  $$=create_node("factor");
  strcpy($$->info, mulop);
  $$->left=create_node("term");
  strcpy($$->left->info, term);
  $$->right=$3;
}
          | expression
{
  printf("Factor\n");
  $$=$1;
}
          | factor
{
  printf("Factor\n");
  $$=$1;
}
          | TERM
{
  printf("Factor\n");
  $$=create_node("Factor");
  strcpy($$->info, term);
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
#define UP 2
#define DOWN 1
#define RIGHT -1
#define LEFT -2
char name[MAX];
int total=0;
int times;
int orient=0;
int x=1, y=1;
char robot='v';

/* Maze stuff */
char maze[20][20]={'X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','X',
		   'X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X','X',};

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

void Maze(){
  int i, j;

  for(i=0; i<20; i++){
    for(j=0; j<20; j++){
      if(j==x && i==y)
	printf("%c", robot);
      else
	printf("%c", maze[i][j]);

    }
    printf("\n");
  }
  printf("\n\n");
}

/* Prints the tree in a the preorder fashion */
void print_node(NODEPTR currentPtr){
  int i, distance;

  if(currentPtr != NULL && currentPtr->info!='\0'){
    if(strcmp(currentPtr->info, "turnleft")==0 || strcmp(currentPtr->info, "TurnLeft")==0
       || strcmp(currentPtr->info, "turn_left")==0){
      printf("Robot %s turns left\n", name);
      if(orient==RIGHT){
	orient=UP;
	robot='^';
      }
      else if(orient==UP){
	orient=LEFT;
	robot='<';
      }
      else if(orient==LEFT){
	orient=DOWN;
	robot='v';
      }
      else if(orient==DOWN){
	orient=RIGHT;
	robot='>';
      }
    }
    else if(strcmp(currentPtr->info, "pickbeeper")==0 || strcmp(currentPtr->info, "PickBeeper")==0
	    || strcmp(currentPtr->info, "pick_beeper")==0){
      printf("Robot %s picks up beeper\n", name);
    }
    else if(strcmp(currentPtr->info, "turnoff")==0 || strcmp(currentPtr->info, "TurnOff")==0
	    || strcmp(currentPtr->info, "turn_off")==0){
      printf("Robot %s turns off beeper\n", name);
    }
    else if(strcmp(currentPtr->info, "execute")==0);
    else if(strcmp(currentPtr->info, "new")==0 || strcmp(currentPtr->info, "New")==0){
      strcpy(name, currentPtr->right->info);
      printf("Robot %s is at 0,0\n", name);
      robot='v';
      orient=DOWN;
      currentPtr->left=NULL;
      currentPtr->right=NULL;
    }
    else if(strcmp(currentPtr->info, "tell")==0 || strcmp(currentPtr->info, "Tell")==0){
      currentPtr->left=NULL;
    }
    else if(strcmp(currentPtr->info, "move")==0 || strcmp(currentPtr->info, "Move")==0){
      total=0;
      if(isdigit(currentPtr->left->info[0])) total+=atoi(currentPtr->left->info);
      else print_node(currentPtr->left);
      printf("Robot %s moves %d\n", name, total);
      for(i=0; i<total; i++){
	if(orient==DOWN && maze[y+1][x]!='X' && y+1<20){
	  maze[y][x]=':';
	  y+=1;
	}
	else if(orient==UP && maze[y-1][x]!='X' && y-1>=0){
	  maze[y][x]=':';
	  y-=1;
	}
	else if(orient==RIGHT && maze[y][x+1]!='X' && x+1<=20){
	  maze[y][x]=':';
	  x=x+1;
	}
	else if(orient==LEFT && maze[y][x-1]!='X' && x-1>=0){
	  maze[y][x]=':';
	  x-=1;
	}
      }
    }
    else if(currentPtr->info[0]=='+'){
      total+=atoi(currentPtr->left->info);
      if(isdigit(currentPtr->right->info[0])){
	total+=atoi(currentPtr->right->info);
	currentPtr->right=NULL;
      }
    }
    else if(currentPtr->info[0]=='-'){
      total-=atoi(currentPtr->left->info);
      if(isdigit(currentPtr->right->info[0])){
	total-=atoi(currentPtr->right->info);
	currentPtr->right=NULL;
      }
    }
    else if(currentPtr->info[0]=='*'){
      total*=atoi(currentPtr->left->info);
      if(isdigit(currentPtr->right->info[0])){
	total*=atoi(currentPtr->right->info);
	currentPtr->right=NULL;
      }
    }
    else if(currentPtr->info[0]=='/'){
      total/=atoi(currentPtr->left->info);
      if(isdigit(currentPtr->right->info[0])){
	total/=atoi(currentPtr->right->info);
	currentPtr->right=NULL;
      }
    }
    else if(strcmp(currentPtr->info, "iterate")==0){
      times=atoi(currentPtr->left->info);
      printf("times=%d\n", times);
      currentPtr->left=NULL;
      for(i=1; i<times; i++){
	if(currentPtr!=NULL && currentPtr->info!='\0'){
	  print_node(currentPtr->left);
	  print_node(currentPtr->right);
	}
      }
    }
    else if(strcmp(currentPtr->info, "remove")==0 || strcmp(currentPtr->info, "Remove")==0){
      printf("Robot %s removed\n", currentPtr->right->info);
      currentPtr->right=NULL;
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








