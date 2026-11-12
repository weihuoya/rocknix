# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present Team ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="attr-bin"
PKG_VERSION="2.6.0"
PKG_SHA256="d42fa374513180bb48cb11a46696f488240e5124ff1e6ad88b0abff706985612"
PKG_LICENSE="GPL-2.0-or-later AND LGPL-2.1-or-later"
PKG_SITE="https://savannah.nongnu.org/projects/attr"
PKG_URL="http://download.savannah.nongnu.org/releases/attr/attr-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Extended attributes tools (setfattr/getfattr) for the target."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="OPTIMIZER= \
                           CONFIG_SHELL=/bin/bash \
                           INSTALL_USER=root INSTALL_GROUP=root \
                           --disable-shared --enable-static"

post_makeinstall_target() {
  rm -rf ${INSTALL}/etc
}
