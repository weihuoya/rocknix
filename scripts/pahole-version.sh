#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
#
# Usage: $ ./pahole-version.sh pahole
#
# Prints pahole's version in a 3-digit form, such as 119 for v1.19.

# Allow the caller to short-circuit pahole auto-detection. This is useful
# when cross-compiling and the target-prefixed tool lookup would otherwise
# fail to find the host pahole binary.
if [ -n "${PAHOLE_VERSION}" ]; then
	# Accept v1.28, 1.28, or 128 form.
	echo "${PAHOLE_VERSION}" | sed -E 's/^v?([0-9]+)\.([0-9]+)$/\1\2/; t; /^[0-9]+$/!s/.*/0/'
	exit 0
fi

if [ ! -x "$(command -v "$@")" ]; then
	echo 0
	exit 1
fi

"$@" --version | sed -E 's/^v?([0-9]+)\.([0-9]+)$/\1\2/; t; /^[0-9]+$/!s/.*/0/'
