#!/bin/bash

SCRIPTS_PATH=`dirname $0`
LINUX_SOURCES=/l/latest/tmp/linux1

set -xx

while read ST_FILE ST_LINE ST_FUN END_FILE END_LINE END_FUN; do
	I_FILE="${ST_FILE%%.c}.i"
	LLVM_FILE="$I_FILE.llvm"
	DEMANDED_FILE="$LLVM_FILE.main.$ST_FUN.$END_LINE.o"
	echo "$I_FILE"
	touch "$I_FILE"
#	sed 's@\<inline\>@@g' "$I_FILE" > "$I_FILE-new.i"
	export SLICE_INITIAL_FUNCTION="$ST_FUN"
	export SLICE_ASSERT_FILE="$LINUX_SOURCES/$END_FILE"
	export SLICE_ASSERT_LINE="$END_LINE"
	$SCRIPTS_PATH/llvm-builder.sh 2>/dev/null
	((opt -load LLVMSlicer.so -slice-inter "$LLVM_FILE" -simplifycfg \
	 -kleerer -disable-output && \
	 mv "$LLVM_FILE.main.$ST_FUN.o" "$DEMANDED_FILE") || \
	touch "$DEMANDED_FILE") #2>&1 | grep -w MATCH
done
