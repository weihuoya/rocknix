#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

. /etc/profile
set_kill set "ashell"

# ashell may be deployed to persistent storage or shipped in the rootfs.
ASHELL_BIN=""
for candidate in /storage/.config/ashell/ashell /usr/bin/ashell; do
  if [ -x "${candidate}" ]; then
    ASHELL_BIN="${candidate}"
    break
  fi
done

if [ -z "${ASHELL_BIN}" ]; then
  echo "ashell not found." >&2
  echo "Please install ashell to /storage/.config/ashell/ashell or /usr/bin/ashell." >&2
  sleep 3
  exit 1
fi

sway_fullscreen "ashell" &
"${ASHELL_BIN}"
