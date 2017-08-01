#!/bin/sh

if [ "$1" = "" ];then
	TARGET_DIR="."
else
	TARGET_DIR="$1"
fi

if [ "$2" = "" ];then
	OUT="file-tags"
else
	OUT="$2"
fi

cd "$TARGET_DIR"

find "$TARGET_DIR" \( \( ! -name . -name .\* \) -or -name bundle -or -name test -or -iname phpmyadmin -or -name bak \) -prune -or \( -type f -or -type l \) ! -name '*.bak' -print |
    sed -e 's@.*/\([^/]*\)@\1	&	1;"	F@' | sort > "$OUT"
