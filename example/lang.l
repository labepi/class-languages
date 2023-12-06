%{ 
#include <stdio.h> 
#include <string.h> 

#include "lang.tab.h"

#define TK_RETURN(TK_TYPE) return TK_TYPE

%} 
  
%% 
"+"                 { printf("ADD"); TK_RETURN(TK_OP_ADD); }

"-"                 { printf("SUB"); TK_RETURN(TK_OP_SUB); }

"*"                 { printf("MUL"); TK_RETURN(TK_OP_MUL); }

"/"                 { printf("DIV"); TK_RETURN(TK_OP_DIV); }

[0-9]+              { printf("NUM"); TK_RETURN(TK_NUM_INT); }

[a-z]([a-z0-9])*    { printf("NAME"); TK_RETURN(TK_NAME); }

\n                  { printf("\n"); TK_RETURN(TK_EOL); }

[ \t]               { printf(" "); }

.                   { printf("unknown character %c\n", *yytext); }
%% 
  
int yywrap(void)
{
    return 0;
} 

/*
int main(int argc, char **argv)
{
    extern FILE *yyin;

    yyin = fopen(argv[1], "r");
    yylex(); 

    return 0; 
}
*/
