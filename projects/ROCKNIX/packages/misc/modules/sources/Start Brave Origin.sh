#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

. /etc/profile
set_kill set "brave-origin"

# Brave Origin may be installed to persistent storage.
BRAVE_DIR="/storage/.config/brave/brave-origin"
BRAVE_BIN="${BRAVE_DIR}/brave"

if [ ! -x "${BRAVE_BIN}" ]; then
  echo "Brave Origin not found." >&2
  echo "Please install Brave Origin to ${BRAVE_DIR}." >&2
  sleep 3
  exit 1
fi

export XDG_RUNTIME_DIR=/var/run/0-runtime-dir
export WAYLAND_DISPLAY=wayland-1
export SWAYSOCK=/var/run/0-runtime-dir/sway-ipc.0.sock

# Make Brave a borderless floating window that fills the display without
# entering browser fullscreen, so tabs and the address bar stay visible.
position_brave() {
  local count=0
  while [ ${count} -lt 10 ]; do
    if swaymsg -t get_tree 2>/dev/null | grep -q '"app_id": "brave-origin"'; then
      swaymsg '[app_id="brave-origin"] floating enable'
      swaymsg '[app_id="brave-origin"] border none'
      swaymsg '[app_id="brave-origin"] move position 0 0'
      swaymsg '[app_id="brave-origin"] focus'
      break
    fi
    count=$((count + 1))
    sleep 1
  done
}

position_brave &
"${BRAVE_BIN}" --no-sandbox --ozone-platform=wayland --enable-features=UseOzonePlatform --window-size=1312,762
