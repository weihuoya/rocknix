# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

. ${ROOT}/packages/network/nftables/package.mk

# 1.1.6 + libnftnl 1.3.1 的 JSON 输入路径有 bug（netavark 应用 ruleset 时
# nft 报 "No such file or directory ... family ip"），升到 1.1.7 配套 libnftnl 1.3.x
PKG_VERSION="1.1.7"
PKG_SHA256="a6fbf060d8d4fff001517a2b94f356bb4366bfbf0ba366366f9d27cc38caa58f"

# hotspot NAT needs the nft CLI; the global package builds libnftables only (--without-cli)
# --with-json is required by netavark (podman's network backend) to read the ruleset
PKG_DEPENDS_TARGET="autotools:host gcc:host libnftnl readline jansson"
PKG_CONFIGURE_OPTS_TARGET="--with-cli=readline --with-mini-gmp --with-json"

pre_configure_target() {
  export LIBS="-lncurses -ltinfo"
  # nftables configure.ac has a bash-only `for ((...))` in AC_CONFIG_COMMANDS(nftversion.h);
  # config/options forces CONFIG_SHELL=/bin/dash, so config.status must run under bash
  export CONFIG_SHELL="/bin/bash"
}
