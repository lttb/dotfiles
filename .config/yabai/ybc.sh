#!/bin/sh

yabai -m query --windows |
    jq ".[] | select(.app | test($(yabai -m query --windows --window | jq '.app'))).id" |
    xargs -L1 sh -c "
            yabai -m window \$0 --toggle float &&
            yabai -m window \$0 $1
    "
