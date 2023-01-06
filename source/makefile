# The bB generic-Unix makefile. Should work with most unixy OSes.
ARCH=
DEST=./build/
CC=cc
CFLAGS=-O2
#CFLAGS=-O0 -g
LEX=lex
LEXFLAGS=-t
CP=cp
MKDIR=mkdir -p
RM=rm

_2600basic=${DEST}2600basic${ARCH}
_postprocess=${DEST}postprocess${ARCH}
_bbfilter=${DEST}bbfilter${ARCH}
_preprocess=${DEST}preprocess${ARCH}
_optimize=${DEST}optimize${ARCH}

all: 2600basic preprocess postprocess optimize bbfilter

2600basic: 2600bas.c statements.c keywords.c statements.h keywords.h
	@${MKDIR} ${DEST}
	${CC} ${CFLAGS} -o ${_2600basic} 2600bas.c statements.c keywords.c

postprocess: postprocess.c
	@${MKDIR} ${DEST}
	${CC} ${CFLAGS} -o ${_postprocess} postprocess.c

bbfilter: bbfilter.c
	@${MKDIR} ${DEST}
	${CC} ${CFLAGS} -o ${_bbfilter} bbfilter.c

preprocess: preprocess.lex
	@${MKDIR} ${DEST}
	${LEX} ${LEXFLAGS}<preprocess.lex>lex.yy.c
	${CC} ${CFLAGS} -o ${_preprocess} lex.yy.c
	${RM} -f lex.yy.c

optimize: optimize.lex
	@${MKDIR} ${DEST}
	${LEX} ${LEXFLAGS} -i<optimize.lex>lex.yy.c
	${CC} ${CFLAGS} -o ${_optimize} lex.yy.c
	${RM} -f lex.yy.c

distclean:
	make -f makefile.xcmp.win-x86 clean
	make -f makefile.xcmp.win-x64 clean
	make -f makefile.linux-x86 clean
	make -f makefile.linux-x64 clean
	make -f makefile.xcmp.osx-x86 clean
	make -f makefile.xcmp.osx-x64 clean
	make -f makefile.xcmp.osx-arm64 clean

dist:
	make clean
	make distclean
	make -f makefile.xcmp.win-x86
	make -f makefile.xcmp.win-x64
	make -f makefile.linux-x86
	make -f makefile.linux-x64
	make -f makefile.xcmp.osx-x86
	make -f makefile.xcmp.osx-x64
	make -f makefile.xcmp.osx-arm64
	#unix2dos *.txt *.c *.h

install: all
ifneq ($(bB),)
	@ echo
	@ echo "Installing to ${bB}..."
	@ ${MKDIR} "${bB}"
	@ ${CP} build/* "${bB}"
	@ ${CP} ../2600basic.sh "${bB}"
	@ ${CP} -r ../includes "${bB}"
endif

mac:
	make -f makefile.xcmp.osx-x86
	make -f makefile.xcmp.osx-x64
	make -f makefile.xcmp.osx-arm64

windows:
	make -f makefile.xcmp.win-x86
	make -f makefile.xcmp.win-x64

linux:
	make -f makefile.linux-x86
	make -f makefile.linux-x64

clean:
	${RM} -f a.out core ${_2600basic} ${_preprocess} ${_postprocess} ${_bbfilter} ${_optimize}
