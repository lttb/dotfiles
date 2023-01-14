#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Yabai
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "command", "optional": true }

# Documentation:
# @raycast.author Artur Kenzhaev
# @raycast.authorURL https://github.com/lttb

zx ~/.config/yabai/ybc.mjs "${1:-current}"


