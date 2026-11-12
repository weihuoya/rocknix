# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2024-present Team ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="fuse-overlayfs"
PKG_VERSION="1.18"
PKG_SHA256="fdd1896c8de35a15eb14444d7880be81d635fcbbc4ad162d8bc3ccf5627aa8c7"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/containers/fuse-overlayfs"
PKG_URL="https://github.com/containers/fuse-overlayfs/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse3"
PKG_LONGDESC="FUSE implementation of overlayfs, used as rootless storage driver."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-selinux"
