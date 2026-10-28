# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="hostapd"
PKG_VERSION="2.11"
PKG_SHA256="2b3facb632fd4f65e32f4bf82a76b4b72c501f995a4f62e330219fe7aed1747a"
PKG_LICENSE="BSD-3-Clause"
PKG_SITE="https://w1.fi/hostapd/"
PKG_URL="https://w1.fi/releases/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libnl"
PKG_LONGDESC="IEEE 802.11 access point and authentication server"
PKG_TOOLCHAIN="make"

pre_make_target() {
  cp ${PKG_BUILD}/hostapd/defconfig ${PKG_BUILD}/hostapd/.config
  sed -i -e 's/^#CONFIG_IEEE80211AC=y/CONFIG_IEEE80211AC=y/' \
         -e 's/^#CONFIG_IEEE80211AX=y/CONFIG_IEEE80211AX=y/' \
         -e 's/^#CONFIG_SAE=y/CONFIG_SAE=y/' \
         ${PKG_BUILD}/hostapd/.config
}

make_target() {
  make -C ${PKG_BUILD}/hostapd CC="${CC}" PKG_CONFIG="${PKG_CONFIG}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/sbin
    cp ${PKG_BUILD}/hostapd/hostapd ${INSTALL}/usr/sbin/
    cp ${PKG_BUILD}/hostapd/hostapd_cli ${INSTALL}/usr/sbin/
}
