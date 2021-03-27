# The bB generic-Unix makefile. Should work with most unixy OSes.
SHELL=/bin/sh
CHMOD=chmod
CP=cp
RM=rm
CFLAGS=-O2
#CFLAGS=-O0 -g
CC=cc
LEX=lex
LEXFLAGS=-t

all: 2600basic preprocess postprocess optimize bbfilter

2600basic: 2600bas.c statements.c keywords.c statements.h keywords.h
	${CC} ${CFLAGS} -o 2600basic 2600bas.c statements.c keywords.c

postprocess: postprocess.c
	${CC} ${CFLAGS} -o postprocess postprocess.c

preprocess: preprocess.lex
	${LEX} ${LEXFLAGS}<preprocess.lex>lex.yy.c
	${CC} ${CFLAGS} -o preprocess lex.yy.c
	${RM} -f lex.yy.c

optimize: optimize.lex
	${LEX} ${LEXFLAGS} -i<optimize.lex>lex.yy.c
	${CC} ${CFLAGS} -o optimize lex.yy.c
	${RM} -f lex.yy.c

bbfilter: bbfilter.c
	${CC} ${CFLAGS} -o bbfilter bbfilter.c

distclean:
	make -f makefile.xcmp.win-x86 clean
	make -f makefile.xcmp.win-x64 clean
	make -f makefile.linux-x86 clean
	make -f makefile.linux-x64 clean
	make -f makefile.xcmp.osx-x86 clean
	make -f makefile.xcmp.osx-x64 clean

dist:
	make clean
	make distclean
	make -f makefile.xcmp.win-x86
	make -f makefile.xcmp.win-x64
	make -f makefile.linux-x86
	make -f makefile.linux-x64
	make -f makefile.xcmp.osx-x86
	make -f makefile.xcmp.osx-x64
	unix2dos *.txt *.c *.h

install: all

clean:
	${RM} -f a.out core 2600basic preprocess postprocess optimize bbfilter

love:
	@echo "not war"
peace:
	@echo "not war"
hay:
	@echo "while the sun shines"
believe:
	@echo "ok... the floor is lava"
