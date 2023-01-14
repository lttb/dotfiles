#!/usr/bin/env zx

const [dir] = [...process.argv].slice(3);

// $.verbose = false;

const w_curr = JSON.parse(await $`yabai -m query --windows --window`);
const display_curr = JSON.parse(await $`yabai -m query --displays --display`);

const width = display_curr.frame.w;

const locate = (options) => {
  $.quote = (x) => x;
  return $`yabai -m query --windows \
    | jq ".[] \
    | select(.app \
    | test(\\"${w_curr.app}\\")).id" \
    | xargs -L1 sh -c 'yabai -m window $0 --toggle float && yabai -m window $0 ${options}'`;
};

const eps = 100;

if (dir === "right") {
  if (w_curr.frame.x < width / 4 && w_curr.frame.w < (width * 3) / 4) {
    if (w_curr.frame.w < width / 2 - eps) {
      await locate(`--grid 1:2:0:0:1:1`);
    } else if (w_curr.frame.w < (width * 2) / 3 - eps) {
      await locate(`--grid 1:3:0:0:2:1`);
    } else {
      await locate(`--grid 1:1:0:0:1:1`);
    }
  } else {
    if (w_curr.frame.w > (width * 2) / 3 + eps) {
      await locate(`--grid 1:3:1:0:2:1`);
    } else if (w_curr.frame.w > width / 2 + eps) {
      await locate(`--grid 1:2:1:0:1:1`);
    } else if (w_curr.frame.w > width / 3) {
      await locate(`--grid 1:3:2:0:1:1`);
    }
  }
} else if (dir === "left") {
  if (w_curr.frame.x > width / 4 && w_curr.frame.w < (width * 3) / 4) {
    if (w_curr.frame.w < width / 2 - eps) {
      await locate(`--grid 1:2:1:0:1:1`);
    } else if (w_curr.frame.w < (width * 2) / 3 - eps) {
      await locate(`--grid 1:3:1:0:2:1`);
    } else {
      await locate(`--grid 1:1:0:0:1:1`);
    }
  } else {
    if (w_curr.frame.w > (width * 2) / 3 + eps) {
      await locate(`--grid 1:3:0:0:2:1`);
    } else if (w_curr.frame.w > width / 2 + eps) {
      await locate(`--grid 1:2:0:0:1:1`);
    } else if (w_curr.frame.w > width / 3) {
      await locate(`--grid 1:3:0:2:1:1`);
    }
  }
} else if (dir === "max") {
  await locate(`--grid 1:1:0:0:1:1`);
} else if (dir === "current") {
  await locate(`--resize abs:${w_curr.frame.w}:${w_curr.frame.h}`);
  await locate(`--move abs:${w_curr.frame.x}:${w_curr.frame.y}`);
}

$.verbose = true;

// $`echo ${w_curr.frame.x}`;
