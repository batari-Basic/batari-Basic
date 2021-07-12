# The bB generic-Unix makefile. Should work with most unixy OSes.
SHELL=/bin/sh
CHMOD=chmod
CP=cp
RM=rm
MKDIR=mkdir -p
CFLAGS=-O2
#CFLAGS=-O0 -g
CC=cc
LEX=lex
LEXFLAGS=-t

all: 2600basic preprocess postprocess optimize bbfilter

2600basic: 2600bas.c statements.c keywords.c statements.h keywords.h
	@${MKDIR} build
	${CC} ${CFLAGS} -o build/2600basic 2600bas.c statements.c keywords.c

postprocess: postprocess.c
	@${MKDIR} build
	${CC} ${CFLAGS} -o build/postprocess postprocess.c

preprocess: preprocess.lex
	@${MKDIR} build
	${LEX} ${LEXFLAGS}<preprocess.lex>lex.yy.c
	${CC} ${CFLAGS} -o build/preprocess lex.yy.c
	${RM} -f lex.yy.c

optimize: optimize.lex
	@${MKDIR} build
	${LEX} ${LEXFLAGS} -i<optimize.lex>lex.yy.c
	${CC} ${CFLAGS} -o build/optimize lex.yy.c
	${RM} -f lex.yy.c

bbfilter: bbfilter.c
	@${MKDIR} build
	${CC} ${CFLAGS} -o build/bbfilter bbfilter.c

distclean:
	make -f makefile.xcmp.win-x86 clean
	make -f makefile.xcmp.win-x64 clean
	make -f makefile.linux-x86 clean
	make -f makefile.linux-x64 clean
	make -f makefile.xcmp.osx-x86 clean
	make -f makefile.xcmp.osx-x64 clean

dist:
	make distclean
	make clean
	make -f makefile.xcmp.win-x86
	make -f makefile.xcmp.win-x64
	make -f makefile.linux-x86
	make -f makefile.linux-x64
	make -f makefile.xcmp.osx-x86
	make -f makefile.xcmp.osx-x64
	unix2dos *.txt *.c *.h

install: all
ifneq ($(bB),)
	@${MKDIR} "${bB}"
	${CP} build/* "${bB}"
	${CP} ../2600basic.sh "${bB}"
	${CP} -r ../includes "${bB}"
endif

clean:
	${RM} -f build/a.out build/core build/2600basic build/preprocess build/postprocess build/optimize build/bbfilter
	${RM} -rf build

love:
	@echo "not war"
peace:
	@echo "not war"
hay:
	@echo "while the sun shines"
believe:
	@echo "ok... the floor is lava"
