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
                           --disable-nls \
                           --disable-logind \
                           --disable-man \
                           --enable-subordinate-ids"

post_makeinstall_target() {
  # Keep only the subordinate-id helpers and their library.
  find ${INSTALL}/usr/bin -type f ! -name newuidmap ! -name newgidmap -delete 2>/dev/null || true
  find ${INSTALL}/usr/sbin -type f -delete 2>/dev/null || true
  rm -rf ${INSTALL}/etc ${INSTALL}/usr/share ${INSTALL}/usr/lib/pkgconfig
}
