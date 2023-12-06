all: language

language.tab.c language.tab.h: language.y
	bison -t -v -d language.y

lex.yy.c: language.l language.tab.h
	flex language.l

language: lex.yy.c language.tab.c language.tab.h
	cc -Wall -o compiler language.tab.c lex.yy.c

clean:
	rm -f compiler language.tab.c lex.yy.c language.tab.h language.output
