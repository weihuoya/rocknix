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
    PKG_SHA256="b6fdb37bc08e320bd92381e13d7311837f04a98423b8a5b678a5eb5e87c978ca"
    PKG_URL="https://static.rust-lang.org/dist/rustc-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnu.tar.gz"
    ;;
  "arm")
    PKG_SHA256="0aa09d8717c3e22c89a9ebdc367f8c29896b8a2f0d21f52ea2fcf4930ed3bc8f"
    PKG_URL="https://static.rust-lang.org/dist/rustc-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnueabihf.tar.gz"
    ;;
  "x86_64")
    PKG_SHA256="18ed6559de1b8ea6b77474ea86992b9a507d3a3d134d9ee017d30cf3f406e3ee"
    PKG_URL="https://static.rust-lang.org/dist/rustc-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnu.tar.gz"
    ;;
esac
PKG_SOURCE_NAME="rustc-snapshot_${PKG_VERSION}_${ARCH}.tar.gz"
