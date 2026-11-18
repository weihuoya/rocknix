# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2024-present Team ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="catatonit"
PKG_VERSION="0.2.1"
PKG_SHA256="771385049516fdd561fbb9164eddf376075c4c7de3900a8b18654660172748f1"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://github.com/containers/catatonit"
PKG_URL="https://mirrors.aliyun.com/debian/pool/main/c/catatonit/catatonit_0.2.1.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A small container init program used by conmon/podman."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"
