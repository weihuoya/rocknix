# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2024-present Team ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="passt"
PKG_VERSION="2026_10_02"
PKG_SHA256="aa75616cc43925f0bd6c05bcfbbaecd77397c03d7bd23591b34ef535be5dfcdc"
PKG_LICENSE="GPL-2.0-or-later AND BSD-3-Clause"
PKG_SITE="https://passt.top/passt/about/"
PKG_URL="https://mirrors.aliyun.com/debian/pool/main/p/passt/passt_0.0~git20261002.cba3570.orig.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="User-mode networking for VMs and containers (pasta)."
PKG_TOOLCHAIN="manual"

make_target() {
  ${MAKE} -C ${PKG_BUILD} CC="${CC}" CFLAGS="${CFLAGS}" pasta passt
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/pasta ${PKG_BUILD}/passt ${INSTALL}/usr/bin/
}
