# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2024-present Team ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="shadow"
PKG_VERSION="4.20.3"
PKG_SHA256="623be9429f64fa2165bfc5957c6a642ec309c5cf23c0d53855c99f7591922297"
PKG_LICENSE="BSD-3-Clause AND GPL-2.0-or-later"
PKG_SITE="https://github.com/shadow-maint/shadow"
PKG_URL="https://github.com/shadow-maint/shadow/releases/download/${PKG_VERSION}/shadow-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Shadow password suite (only newuidmap/newgidmap are installed)."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--without-libpam \
                           --without-selinux \
                           --without-audit \
                           --without-libbsd \
                           --disable-nls \
                           --disable-logind \
                           --disable-man \
                           --enable-subordinate-ids"

# Only the uid-mapping helpers are needed; readpassphrase is only used by the
# user management tools we do not build.
make_target() {
  ${MAKE} -C ${PKG_BUILD}/.${TARGET_NAME}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/.${TARGET_NAME}/src/newuidmap \
     ${PKG_BUILD}/.${TARGET_NAME}/src/newgidmap ${INSTALL}/usr/bin/
}

post_makeinstall_target() {
  rm -rf ${INSTALL}/etc ${INSTALL}/usr/share ${INSTALL}/usr/lib/pkgconfig
}
