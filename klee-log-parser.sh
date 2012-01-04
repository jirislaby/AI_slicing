#!/bin/bash

for file in `find -type f -name *.log `; do
	grep -q 'HaltTimer invoked' $file && echo -n H
	grep -q 'failed external call' $file && echo -n E
	grep -qE 'memory error|invalid function pointer' $file && echo -n M
	grep -q 'LLVM ERROR: Code generator does not support' $file && echo -n I
	grep -q 'klee: .*Assertion .* failed.' $file && echo -n C
	grep -q 'ASSERTION FAIL' $file && echo -n B; echo " $file"
done
