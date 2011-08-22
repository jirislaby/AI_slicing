#!/bin/bash

DIR=.
if [ $# -gt 0 ]; then
	DIR=$1
fi

find "$DIR" -type f -name '*.llvm' \
	     -exec opt -load LLVMSlicer.so -modstats {} -disable-output \; \
	     -exec opt -load LLVMSlicer.so -modstats {}.sliced -disable-output \;
