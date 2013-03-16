#!/bin/bash

if [ $# -eq 0 ]; then
	FILES=`find -type f -name *.log `
else
	FILES="$1"
fi

for file in $FILES; do
#	grep -q 'LastChar > FirstChar' $file && echo -n X
	grep -q 'query timed out (resolve)' $file && echo -n H
	grep -q 'HaltTimer invoked' $file && echo -n H
	grep -q 'failed external call' $file && echo -n E
	grep -q 'ERROR: unable to load symbol' $file && echo -n G
	grep -qE 'memory error|invalid function pointer' $file && echo -n M
	grep -q 'LLVM ERROR: Code generator does not support' $file && echo -n I
	grep -q 'klee: .*Assertion .* failed.' $file && echo -n C
	grep -q 'ASSERTION FAIL' $file && echo -n B
	echo " $file"
done
