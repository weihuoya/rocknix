# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

. ${ROOT}/packages/network/nftables/package.mk

# hotspot NAT needs the nft CLI; the global package builds libnftables only (--without-cli)
PKG_CONFIGURE_OPTS_TARGET="--with-cli=readline --with-mini-gmp"

pre_configure_target() {
  export LIBS="-lncurses -ltinfo"
  # nftables configure.ac has a bash-only `for ((...))` in AC_CONFIG_COMMANDS(nftversion.h);
  # config/options forces CONFIG_SHELL=/bin/dash, so config.status must run under bash
  export CONFIG_SHELL="/bin/bash"
}
