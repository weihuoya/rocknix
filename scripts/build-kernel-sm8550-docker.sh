#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)
#
# Run inside the ROCKNIX build container to build the SM8550 kernel.
# This script is invoked by .github/workflows/build-kernel-sm8550.yml.

set -e

HOST_UID="${HOST_UID:-1000}"
HOST_GID="${HOST_GID:-1000}"

trap 'chown -R "${HOST_UID}:${HOST_GID}" /work/rocknix' EXIT

# Ensure the docker user can write into the workspace.
chown -R docker:docker /work/rocknix

# Make sure the image's /usr/local/bin pahole is findable, and fall back to
# building it from source if the builder image is missing it.
export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/bin

if ! command -v pahole >/dev/null 2>&1 && [ ! -x /usr/local/bin/pahole ]; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils
  /work/rocknix/scripts/install-pahole.sh
fi

# Make the pahole version visible to the kernel Kconfig even if the host pahole
# binary is not on the default PATH for the build user. The kernel's Kconfig
# falls back to this when auto-detection fails during cross-compilation.
export PAHOLE_VERSION=124

# Run the actual kernel build as the non-root docker user.
su -s /bin/bash docker -c \
  'cd /work/rocknix && set -a && . ./.env && set +a && unset DEVICE_ROOT && export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/bin && export PAHOLE_VERSION=124 && PROJECT=ROCKNIX DEVICE=SM8550 ARCH=aarch64 ./scripts/build linux'
