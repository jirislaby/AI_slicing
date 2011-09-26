#!/bin/bash

DIR=.
if [ $# -gt 0 ]; then
	DIR=$1
fi

find "$DIR" -type f -name '*.i' -print \
	     -exec clang -g -emit-llvm -c {} -o {}.llvm -O0 -w \; \
	     -exec opt -load LLVMSlicer.so -slice {}.llvm -o {}.llvm.sliced \;
