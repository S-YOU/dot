#!/bin/sh

# settings
TRASH_DIR=${TRASH_DIR:-"$HOME/.trash"}


# main
set -e

export LANG=C

dir="$TRASH_DIR"/$(date +'%Y%m')
mkdir -p "$dir"
timestamp=$(date +'%Y%m%d_%H%M%S')
for i in "$@"; do
    case "$i" in
        -l|--list)
            echo "Recently deleted 30 files:"
            ls -lrtc "$TRASH_DIR/current/" | tail -n 30
            ;;
        -*) 
            # ignore options
            ;;  
        *)  
            path=$(basename "$i")
            mv -iv "$i" "${dir}/${path}_${timestamp}"
            command rm -f "$TRASH_DIR/current"
            ln -sf "$dir" "$TRASH_DIR/current"
            ;;  
    esac
done
