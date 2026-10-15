# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026-present ROCKNIX (https://rocknix.org)

PKG_NAME="aircrack-ng"
PKG_VERSION="master"
PKG_SHA256=""
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/aircrack-ng/aircrack-ng"
PKG_URL="https://github.com/aircrack-ng/aircrack-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libnl libpcap sqlite pcre2 zlib"
PKG_LONGDESC="Complete suite of tools to assess WiFi network security."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-experimental \
                           ETHTOOL=/usr/sbin/ethtool"
