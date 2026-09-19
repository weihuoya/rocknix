# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="git"
PKG_VERSION="2.55.0"
PKG_SHA256="457fdb04dc8728e007d4688695e6912e6f680727920f2a40bf11eacc17505357"
PKG_LICENSE="GPL-2.0-only"
PKG_SITE="https://git-scm.com/"
PKG_URL="https://mirrors.edge.kernel.org/pub/software/scm/git/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl openssl zlib expat pcre2"
PKG_LONGDESC="Git is a fast, scalable, distributed revision control system."
PKG_TOOLCHAIN="manual"

PKG_MAKE_OPTS_TARGET="NO_PERL=1 NO_PYTHON=1 NO_TCLTK=1 NO_GETTEXT=1 NO_RUST=1"
PKG_MAKEINSTALL_OPTS_TARGET="${PKG_MAKE_OPTS_TARGET}"

configure_target() {
  cd ${PKG_BUILD}
  ./configure ${TARGET_CONFIGURE_OPTS} \
              ac_cv_fread_reads_directories=no \
              ac_cv_snprintf_returns_bogus=no \
              ac_cv_iconv_omits_bom=no \
              --with-curl \
              --with-expat \
              --with-openssl \
              --with-libpcre2 \
              --with-zlib \
              --without-tcltk \
              --libexecdir=/usr/lib
}

make_target() {
  cd ${PKG_BUILD}
  make ${PKG_MAKE_OPTS_TARGET}
}

makeinstall_target() {
  cd ${PKG_BUILD}
  make install DESTDIR=${INSTALL} ${PKG_MAKEINSTALL_OPTS_TARGET}
}

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin/git-cvsserver
  rm -rf ${INSTALL}/usr/bin/gitk
  debug_strip ${INSTALL}/usr
}
