#!/bin/sh

splited=/tmp/screen-splited.`who am i | awk '{print $1}'`
#sizef=/tmp/screen-split-size.$STY

title=$2
if [ -n $3 ] ; then
    size=$3
else
    size=8
fi

echo "title=[$title]"

case $1 in
    -t|--toggle)
    if [ -f $splited ]; then
	screen -X eval 'focus top' 'only' 'redisplay'
	rm $splited
    else
	screen -X eval 'split' \
	    'focus bottom' "resize $size" "select $title" \
	    'focus top' 'redisplay' 
	touch $splited
    fi
    ;;
    
    -o|--only)

    screen -X eval 'focus top' 'only' 'redisplay' 
    [ -f $splited ] && rm $splited
    ;;
esac

