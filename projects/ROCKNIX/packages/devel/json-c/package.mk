# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

. ${ROOT}/packages/devel/json-c/package.mk

# 0.19 wraps the final free() in assert(), so NDEBUG builds never release
# non-empty containers (and their serialization printbuf); sway then leaks one
# whole IPC reply per request. Pin a master commit until the fix is released.
PKG_VERSION="d9b375ff1b4ea0305566527e377ecf6545771e80"
PKG_SHA256=""
PKG_URL="https://github.com/json-c/json-c/archive/${PKG_VERSION}.tar.gz"
