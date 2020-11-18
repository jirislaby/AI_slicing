#!/usr/bin/bash

while read FILE FUN; do
	test -f "$FILE" || continue
	echo "A $FILE $FUN"
	if [ -f "$FILE.main.$FUN.o" ]; then
		echo B $FILE.main.$FUN.o
		continue
	fi
	for fun in `grep '^CALLREL .* => '"$FUN"'$' $FILE.callrel | \
			sed 's/^CALLREL \(.*\) => .*$/\1/'`; do
		if [ -f $FILE.main.$fun.o ]; then
			echo B $FILE.main.$fun.o
		else
#			echo $FILE.main.$fun.o not found >&2
:
		fi
	done
done
