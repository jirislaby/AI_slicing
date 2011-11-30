#!/bin/bash

DIR=.
if [ $# -gt 0 ]; then
	DIR=$1
fi

find "$DIR" -type f -name '*.i' -print0 | xargs -t -P3 -0 -n1 -I{} \
	sh -c 'test ! -f {}.llvm -o {}.llvm -ot {} && clang -g -emit-llvm -c {} -o {}.llvm -O0 -w; true'

#	     -exec opt -load LLVMSlicer.so -slice {}.llvm -simplifycfg -o {}.llvm.sliced \;
