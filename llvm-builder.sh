#!/bin/bash

if [ -z "$LIB" ]; then
	LIB=library.c
fi
if [ ! -f "$LIB" ]; then
	echo "Cannot find library '$LIB'" >&2
	exit 1
fi

DIR=.
if [ $# -gt 0 ]; then
	DIR=$1
fi

clang -g -nostdinc -emit-llvm -c "$LIB" -o library.o -O0 || exit 1

find "$DIR" -type f -name '*.i' -print0| xargs -t -P3 -0 -n1 -I{} \
	sh -c 'test ! -f {}.llvm -o {}.llvm -ot {} &&
		clang -g -nostdinc -emit-llvm -O0 -w -c {} -o {}.comp 2>/dev/null &&
		opt -load LLVMSlicer.so -prepare {}.comp -o {}.prep &&
		llvm-link -o {}.llvm {}.prep library.o &&
		rm -f {}.comp {}.prep 2>/dev/null;
		true'

#	     -exec opt -load LLVMSlicer.so -slice {}.llvm -simplifycfg -o {}.llvm.sliced \;
