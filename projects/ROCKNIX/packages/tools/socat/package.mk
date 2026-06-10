# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

PKG_NAME="socat"
PKG_VERSION="1.8.1.1"
PKG_SHA256="5ebc636b7f427053f98806696521653a614c7e06464910353cbf54e2327adc1b"
PKG_LICENSE="GPLv2+"
PKG_SITE="http://www.dest-unreach.org/socat/download"
PKG_URL="${PKG_SITE}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A multipurpose relay (SOcket CAT)"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET+="	--disable-libwrap \
				--disable-readline \
				--enable-termios"

