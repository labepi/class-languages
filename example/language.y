%{
#include <stdio.h>
#include <stdlib.h>

extern char *yytext;
extern int yylex(void);
extern int yyerror(char* s);
%}

%token TK_NUM_INT
%token TK_OP_ADD TK_OP_SUB TK_OP_MUL TK_OP_DIV
%token TK_OP_NOT TK_OP_AND TK_OP_OR
%token TK_NAME
%token TK_EOL TK_WS

%%
program:
 | expression TK_EOL            { return 0; }
 ;

expression: factor              { $$ = $1; }
 | expression TK_OP_ADD factor  { printf("add %d %d\n", $1, $3); }
 | expression TK_OP_SUB factor  { printf("sub %d %d\n", $1, $3); }
 ;

factor: term                    { $$ = $1; }
 | factor TK_OP_MUL term        { printf("mul %d %d\n", $1, $3); }
 | factor TK_OP_DIV term        { printf("div %d %d\n", $1, $3); }
 ;

term: TK_NUM_INT                { $$ = atoi(yytext); }
 | TK_NAME
 ;
%%

int main(int argc, char **argv)
{
    extern FILE *yyin;

    yyin = fopen(argv[1], "r");
    yyparse();

    return 0;
}

int yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);

    return 0;
}
