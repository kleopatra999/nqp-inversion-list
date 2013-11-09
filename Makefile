InversionList.pir: lib/InversionList.pm
	nqp-p --target=pir lib/InversionList.pm > InversionList.pir

InversionList.pbc: InversionList.pir
	parrot -o InversionList.pbc InversionList.pir

test: InversionList.pbc
	prove -v -e 'nqp-p' t/*.t
