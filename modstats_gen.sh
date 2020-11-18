#!/usr/bin/bash

DIR=.
if [ $# -gt 0 ]; then
	DIR=$1
fi

find "$DIR" -type f -name '*.llvm' \
	     -exec test -f {}.sliced \; \
	     -exec opt -load LLVMSlicer.so -modstats {} -disable-output \; \
	     -exec opt -load LLVMSlicer.so -modstats {}.sliced -disable-output \;
