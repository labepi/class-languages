%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE char *

extern char *yytext;
extern int yylex(void);
extern int yyerror(char* s);

unsigned int count = 0;
char buffer[256];
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

expression: factor              {  }
 | expression TK_OP_ADD factor  {
                                    printf("sum %s %s\n", $1, $3);
                                    sprintf(buffer, "vr%u", count++);
                                    printf("store %s\n", buffer);
                                    $$ = strdup(buffer);
                                }
 | expression TK_OP_SUB factor  {
                                    printf("subtract %s %s\n", $1, $3);
                                    sprintf(buffer, "vr%u", count++);
                                    printf("store %s\n", buffer);
                                    $$ = strdup(buffer);
                                }
 ;

factor: term                    { $$ = $1; }
 | factor TK_OP_MUL term        {
                                    printf("muliply %s %s\n", $1, $3);
                                    sprintf(buffer, "vr%u", count++);
                                    printf("store %s\n", buffer);
                                    $$ = strdup(buffer);
                                }
 | factor TK_OP_DIV term        {
                                    printf("divide %s %s\n", $1, $3);
                                    sprintf(buffer, "vr%u", count++);
                                    printf("store %s\n", buffer);
                                    $$ = strdup(buffer);
                                }
 ;

term: TK_NUM_INT                { $$ = strdup(yytext); }
 | TK_NAME                      { $$ = strdup(yytext); }
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
