# The bB generic-Unix makefile. Should work with most unixy OSes.


all: 64kbb  64kbranchbug  64kSC  dpcpfread  msdpc  zombie_chase bbstarfield

test:
	./make_test.sh

64kbb: 64kbb.bas
	2600basic.sh 64kbb.bas
64kbranchbug: 64kbranchbug.bas
	2600basic.sh 64kbranchbug.bas
64kSC: 64kSC.bas
	2600basic.sh 64kSC.bas
dpcpfread: dpcpfread.bas
	2600basic.sh dpcpfread.bas
msdpc: msdpc.bas
	2600basic.sh msdpc.bas
zombie_chase: zombie_chase.bas
	2600basic.sh zombie_chase.bas
bbstarfield: bbstarfield.bas
	2600basic.sh bbstarfield.bas

clean:
	rm -f *.bin *.sym *.lst *.asm 2600basic_variable_redefs.h includes.bB

