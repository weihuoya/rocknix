# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="dnsmasq"
PKG_VERSION="2.91"
PKG_SHA256="f622682848b33677adb2b6ad08264618a2ae0a01da486a93fd8cd91186b3d153"
PKG_LICENSE="GPL-2.0-only OR GPL-3.0-only"
PKG_SITE="https://thekelleys.org.uk/dnsmasq/"
PKG_URL="https://thekelleys.org.uk/dnsmasq/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Lightweight DNS forwarder and DHCP server"
PKG_TOOLCHAIN="make"

make_target() {
  make CC="${CC}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" COPTS="-DNO_TFTP -DNO_AUTH"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/sbin
    cp src/dnsmasq ${INSTALL}/usr/sbin/
}
