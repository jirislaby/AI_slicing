#!/bin/bash

if [ $# -eq 0 ]; then
	FILES=`find -type f -name *.log `
else
	FILES="$1"
fi

for file in $FILES; do
#	grep -q 'LastChar > FirstChar' $file && echo -n X
	grep -q 'query timed out (resolve)' $file && echo -n 'ESTPTIMEOUT '
	grep -q 'HaltTimer invoked' $file && echo -n 'EKLEETIMEOUT '
	grep -q 'failed external call' $file && echo -n 'EEXTERNCALL '
	grep -q 'ERROR: unable to load symbol' $file && echo -n 'ELOADSYM '
	grep -qE 'memory error|invalid function pointer' $file && echo -n 'EINVALPTR '
	grep -q 'LLVM ERROR: Code generator does not support' $file && echo -n 'EINVALINST '
	grep -q 'klee: .*Assertion .* failed.' $file && echo -n 'EKLEEASSERT '
	grep -q 'ASSERTION FAIL' $file && echo -n 'ASSERTIONFAILED '

	echo "$file"
done
