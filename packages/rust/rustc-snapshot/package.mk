# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rustc-snapshot"
PKG_VERSION="$(get_pkg_version rust)"
PKG_LICENSE="MIT"
PKG_SITE="https://www.rust-lang.org"
PKG_LONGDESC="rustc bootstrap compiler"
PKG_TOOLCHAIN="manual"

case "${MACHINE_HARDWARE_NAME}" in
  "aarch64")
    PKG_SHA256="f91c23ade7e7b4ac173f12593eb1dcf1a37189d4e545ca2f64e3c14090ff6c0c"
    PKG_URL="https://static.rust-lang.org/dist/rustc-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnu.tar.gz"
    ;;
  "arm")
    PKG_SHA256="1f67c31c3bc7abaa0212adb019e7e09a3963184ce1311479b9046b80745c5e1d"
    PKG_URL="https://static.rust-lang.org/dist/rustc-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnueabihf.tar.gz"
    ;;
  "x86_64")
    PKG_SHA256="ca0439140d02e91420f4755cc4681a6444a2dbe8e9a6f685f403946ed3efd995"
    PKG_URL="https://static.rust-lang.org/dist/rustc-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnu.tar.gz"
    ;;
esac
PKG_SOURCE_NAME="rustc-snapshot_${PKG_VERSION}_${ARCH}.tar.gz"
