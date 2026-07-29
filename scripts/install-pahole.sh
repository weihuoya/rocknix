#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Build and install a recent pahole from source for BTF kernel support.
# Run as root inside the ROCKNIX build container.

set -e

PAHOLE_VERSION="${PAHOLE_VERSION:-v1.28}"
PAHOLE_PREFIX="${PAHOLE_PREFIX:-/usr/local}"
PAHOLE_JOBS="${PAHOLE_JOBS:-$(nproc)}"

if [ "$EUID" -ne 0 ] && ! sudo -n true >/dev/null 2>&1; then
  echo "This script must be run as root (or with passwordless sudo)."
  exit 1
fi

run_or_sudo() {
  if [ "$EUID" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

echo "Installing pahole build dependencies..."
run_or_sudo apt-get update >/dev/null
DEBIAN_FRONTEND=noninteractive run_or_sudo apt-get install -y --no-install-recommends \
  git ca-certificates cmake make gcc \
  libelf-dev libdw-dev zlib1g-dev >/dev/null

PAHOLE_DIR="$(mktemp -d)"
trap 'rm -rf "${PAHOLE_DIR}"' EXIT

echo "Cloning pahole ${PAHOLE_VERSION}..."
git clone --depth 1 --branch "${PAHOLE_VERSION}" \
  https://git.kernel.org/pub/scm/devel/pahole/pahole.git "${PAHOLE_DIR}/pahole"

cd "${PAHOLE_DIR}/pahole"

echo "Initializing libbpf submodule..."
git submodule update --init

echo "Building pahole..."
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX="${PAHOLE_PREFIX}" ..
make -j"${PAHOLE_JOBS}"

echo "Installing pahole to ${PAHOLE_PREFIX}..."
run_or_sudo make install

echo "Installed pahole version:"
"${PAHOLE_PREFIX}/bin/pahole" --version
