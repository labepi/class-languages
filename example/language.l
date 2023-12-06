%{ 
#include <stdio.h>
#include <string.h>

#include "language.tab.h"
%} 

%option nounput
%option noinput
  
%% 
"+"                 { return TK_OP_ADD; }

"-"                 { return TK_OP_SUB; }

"*"                 { return TK_OP_MUL; }

"/"                 { return TK_OP_DIV; }

[0-9]+              { return TK_NUM_INT; }

[a-z]([a-z0-9])*    { return TK_NAME; }

\n                  { return TK_EOL; }

[ \t]               {  }

.                   { printf("unknown character %c\n", *yytext); }
%% 
  
int yywrap(void)
{
    return 0;
} 
