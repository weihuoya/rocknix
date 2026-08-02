# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="gcc-native"
PKG_VERSION="15.2.0"
PKG_SHA256="438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
PKG_LICENSE="GRL-2.0-or-later"
PKG_SITE="https://gcc.gnu.org/"
PKG_URL="https://ftpmirror.gnu.org/gcc/gcc-${PKG_VERSION}/gcc-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain gmp mpfr mpc zlib"
PKG_LONGDESC="GNU Compiler Collection for native compilation on target device."

PKG_CONFIGURE_OPTS_TARGET="--build=${HOST_NAME} \
                           --host=${TARGET_NAME} \
                           --target=${TARGET_NAME} \
                           --with-sysroot=${SYSROOT_PREFIX} \
                           --with-gmp=${SYSROOT_PREFIX}/usr \
                           --with-mpfr=${SYSROOT_PREFIX}/usr \
                           --with-mpc=${SYSROOT_PREFIX}/usr \
                           --with-zstd=${SYSROOT_PREFIX}/usr \
                           --with-gnu-as \
                           --with-gnu-ld \
                           --enable-languages=c,c++ \
                           --enable-checking=release \
                           --enable-threads=posix \
                           --enable-libstdcxx-time \
                           --enable-clocale=gnu \
                           --enable-shared \
                           --disable-static \
                           --disable-multilib \
                           --disable-nls \
                           --disable-libada \
                           --disable-libmudflap \
                           -,disable-libitm \
                           --disable-libquadmath \
                           --disable-libgomp \
                           --disable-libmpx \
                           --disable-libssp \
                           --disable-bootstrap"

unpack() {
  mkdir -p ${PKG_BUILD}
  tar --strip-components=1 -xf ${SOURCES}/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.tar.xz -C ${PKG_BUILD}
}

pre_configure_target() {
  unset CPP
  unset CPPFLAGS
  export CFLAGS="${CFLAGS} -O2"
  export CXXFLAGS="${CXXFLAGS} -O2"
  # Prevent target flags from being used for build tools
  export CFLAGS_FOR_BUILD=""
  export CXXFLAGS_FOR_BUILD=""
  export LDFLAGS_FOR_BUILD=""
}

make_target() {
  make -j${CONCURRENCY_MAKE_LEVEL}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr
  cp -a ${PKG_BUILD}/.${HOST_NAME}/${TARGET_NAME}/gcc/cc1 ${INSTALL}/usr/ 2>/dev/null || true
  cp -a ${PKG_BUILD}/.${HOST_NAME}/${TARGET_NAME}/gcc/cc1plus ${INSTALL}/usr/ 2>/dev/null || true
  make install DESTDIR=${INSTALL}
  rm -rf ${INSTALL}/usr/share/man
  rm -rf ${INSTALL}/usr/share/info
  rm -rf ${INSTALL}/usr/include
}
