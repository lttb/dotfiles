#!/usr/bin/env bun

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title ya
// @raycast.mode compact

// Optional parameters:
// @raycast.icon 🤖
// @raycast.argument1 {"optional": true, "type": "dropdown", "placeholder": "app", "data": [{"title": "win", "value": "win"}, {"title": "app", "value": "app"}, {"title": "lock", "value": "lock"}, {"title": "unlock", "value": "unlock"}, {"title": "lock_all", "value": "lock_all"}, {"title": "unlock_all", "value": "unlock_all"}]}
// @raycast.argument2 {"optional": true, "type": "dropdown", "placeholder": "current", "data": [{"title": "current", "value": "current"}, {"title": "centre", "value": "centre"}, {"title": "small", "value": "small"}, {"title": "main", "value": "main"}, {"title": "left", "value": "left"}, {"title": "right", "value": "right"}]}

// Documentation:
// @raycast.author Artur Kenzhaev
// @raycast.authorURL https://github.com/lttb

import { run } from './utils';

const [type = 'win', command = 'centre'] = process.argv.slice(2);

await run(type, command);
