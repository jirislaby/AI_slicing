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

if [ library.o -ot "$LIB" ]; then
	clang -g -nostdinc -emit-llvm -c "$LIB" -o library.o -O0 || exit 1
fi

find "$DIR" -type f -name '*.i' -print0| xargs -t -P4 -0 -n1 -I{} \
	sh -c 'test ! -f {}.llvm -o {}.llvm -ot {} -o {}.llvm -ot library.o &&
		clang -g -nostdinc -emit-llvm -O0 -w -c {} -o {}.comp &&
		opt -load LLVMSlicer.so -prepare {}.comp -o {}.prep &&
		llvm-link -o {}.llvm {}.prep library.o &&
		opt -load LLVMSlicer.so -kleerer -disable-output {}.llvm &&
		rm -f {}.comp {}.prep 2>/dev/null;
		true'

#		opt -load LLVMSlicer.so -simplifycfg -create-hammock-cfg -slice-inter -simplifycfg {}.llvm -o {}.llvm.sliced &&
