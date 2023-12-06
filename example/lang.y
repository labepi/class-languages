%{
#include <stdio.h>

extern yytext;
%}

%token TK_NUM_INT
%token TK_OP_ADD TK_OP_SUB TK_OP_MUL TK_OP_DIV
%token TK_OP_NOT TK_OP_AND TK_OP_OR
%token TK_NAME
%token TK_EOL TK_WS

%%
program:
 | expression TK_EOL            { printf("done\n"); }
 ;

expression: factor              { $$ = $1; }
 | expression TK_OP_ADD factor  { printf("add %s %s\n", $1, $3); $$ = $1 + $3; }
 | expression TK_OP_SUB factor  { $$ = $1 - $3; }
 ;

factor: term                    { $$ = $1; }
 | factor TK_OP_MUL term        { $$ = $1 * $3; }
 | factor TK_OP_DIV term        { $$ = $1 / $3; }
 ;

term: TK_NUM_INT                { $$ = strdup(yytext); }
 | TK_NAME
 ;
%%

main(int argc, char **argv)
{
    extern FILE *yyin;

    yyin = fopen(argv[1], "r");
    yyparse();
}

yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
