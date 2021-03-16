%option nounput noinput
%{
#include <string.h>

void get_comments(char* yytext);

int count_lines = 1, chars = 0;

%}

DIGIT        [0-9]
KEYWORD	     int|float|if-else|if|else|while|set|add|is_set|remove|in|exists|read|for|forall|write|writeln|return|elem|EMPTY
ID 	         [A-z_][A-z_0-9]*
STRING       ["].*["]
CHAR         ['].[']|[']\\n[']|[']\\r[']|[']\\t[']

%%

"//".*\n                       { count_lines++; chars=0;}
"/*"((\*+[^/*])|([^*]))*\**"*/" {get_comments(yytext);}
{DIGIT}+{ID}|{DIGIT}+{KEYWORD} { printf("LINHA %d,%d: Expressao mal formada\n", count_lines, chars); chars+=strlen(yytext);}
{KEYWORD}                      { printf("KEYWORD: %s\n", yytext);chars+=strlen(yytext);}
{STRING}			           { printf("STRING: %s\n", yytext);chars+=strlen(yytext);}
{CHAR}			               { printf("CHARACTER: %s\n", yytext);chars+=strlen(yytext);}
{ID}                           { printf("ID: %s\n", yytext);chars+=strlen(yytext);}
{DIGIT}*                       { printf("INTEGER: %s\n", yytext);chars+=strlen(yytext);}
{DIGIT}*"."{DIGIT}*			   { printf("FLOAT: %s\n", yytext);chars+=strlen(yytext);}	 
","                            { printf("COMMA\n");chars+=strlen(yytext);}
";"                            { printf("SEMICOLON\n");chars+=strlen(yytext);}
"\("                           { printf("OPEN_PAREN\n");chars+=strlen(yytext);}
"\)"                           { printf("CLOSE_PAREN\n");chars+=strlen(yytext);}
"\{"                           { printf("OPEN_CURL_BRACKETS\n");chars+=strlen(yytext);}
"\}"                           { printf("CLOSE_CURL_BRACKETS\n");chars+=strlen(yytext);}
"+"       					   { printf("PLUS\n");chars+=strlen(yytext);}
"="       					   { printf("ATRIBUICAO\n");chars+=strlen(yytext);}
"-"       					   { printf("MINUS\n");chars+=strlen(yytext);}
"*"       					   { printf("TIMES\n");chars+=strlen(yytext);}
"/"       					   { printf("DIVIDE\n");chars+=strlen(yytext);}
"<="      					   { printf("LESS_EQUAL\n");chars+=strlen(yytext);}
"<"       					   { printf("LESS\n");chars+=strlen(yytext);}
">="      					   { printf("GREATER_EQUAL\n");chars+=strlen(yytext);}
">"       					   { printf("GREATER\n");chars+=strlen(yytext);}
"&&"      					   { printf("CONJUNCTION\n");chars+=strlen(yytext);}
"||"      					   { printf("DISJUNCTION\n");chars+=strlen(yytext);}
"=="      					   { printf("EQUALS\n");chars+=strlen(yytext);}
"!="      					   { printf("DIFFERENT\n");chars+=strlen(yytext);}
"!"      					   { printf("NEGATION\n");chars+=strlen(yytext);}
[\n]        				   { printf("NEWLINE\n");count_lines++; chars=0;}
[ \t]    					   { /* ignorar linhas em branco */ }
.         					   { printf("Mystery character %s in Line %d,%d:\n", yytext, count_lines, chars);chars+=strlen(yytext);}

%%

void get_comments(char* yytext){
    int i; 
    for(i=0; i < strlen(yytext); i++){
        if (yytext[i]=='\n') {
			count_lines++;
		}
    }
}

int main(void)
{
    yylex();
	yylex_destroy();
    return 0;
}

int yywrap(void)
{
    return 1;
}