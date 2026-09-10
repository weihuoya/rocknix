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
run_or_sudo apt-get update
# The builder image already provides gcc-12/g++-12. Do not install the default
# gcc metapackage here because it conflicts with the image's alternatives.
DEBIAN_FRONTEND=noninteractive run_or_sudo apt-get install -y --no-install-recommends \
  git ca-certificates cmake make \
  libelf-dev libdw-dev zlib1g-dev

# Ensure cmake finds the image's compiler.
export CC=/usr/bin/gcc-12
export CXX=/usr/bin/g++-12

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

# Update the dynamic linker cache so the freshly installed libraries are
# visible to all users (including the non-root docker build user).
run_or_sudo ldconfig

# Also expose pahole in /usr/bin so it is found regardless of the exact
# PATH the kernel build user ends up with.
run_or_sudo ln -sf "${PAHOLE_PREFIX}/bin/pahole" /usr/bin/pahole

echo "Installed pahole version:"
"${PAHOLE_PREFIX}/bin/pahole" --version
# Verify it is also found via plain PATH and works for non-root users.
run_or_sudo sh -c 'PATH="/usr/local/bin:/usr/bin:$PATH" command -v pahole && pahole --version'
