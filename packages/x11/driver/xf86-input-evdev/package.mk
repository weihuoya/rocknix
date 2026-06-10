# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-input-evdev"
PKG_VERSION="2.11.0"
PKG_SHA256="45d64211580f1d83f27a413fac3f78bade3c9b014e823f5f0018c401736cf7f6"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/driver/xf86-input-evdev/-/archive/xf86-input-evdev-2.11.0/xf86-input-evdev-xf86-input-evdev-2.11.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain xorg-server util-macros libevdev mtdev systemd"
PKG_LONGDESC="Evdev is an Xorg input driver for Linux's generic event devices."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-silent-rules \
                           --with-xorg-module-dir=${XORG_PATH_MODULES} \
                           --with-gnu-ld"
