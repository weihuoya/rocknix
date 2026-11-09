# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

. ${ROOT}/packages/devel/mpfr/package.mk

# static libmpfr.a must be PIC so mpc:target can link it into libmpc.so
PKG_BUILD_FLAGS="+pic"
