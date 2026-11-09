# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="gawk"
PKG_VERSION="5.4.1"
PKG_SHA256="07f6f7342b7febe4313fc2c2542ad93d64fe20ad8717200109f105a826f5fd37"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://www.gnu.org/software/gawk/"
PKG_URL="https://ftp.gnu.org/gnu/gawk/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="GNU awk, a full AWK implementation (gensub/match() array/switch/asort/regex RS), replacing the BusyBox awk applet."
PKG_TOOLCHAIN="configure"

# 开动态扩展只为 inplace(awk -i inplace 就地改文件),其余 12 个 .so 在
# post_makeinstall_target 里裁掉。--disable-extensions 不是"少编一个 .so":
# configure 会跳过 dlfcn.h 检测、不定义 DYNAMIC,主程序从此完全没有加载扩展的
# 能力(@load 报 "dynamic loading of libraries is not supported"),必须开这个开关。
PKG_CONFIGURE_OPTS_TARGET="--disable-nls \
                           --disable-mpfr"

# configure 用 AC_RUN_IFELSE 探测 printf 的 %F / %a,交叉编译时一律判为不支持,
# 导致 %F 被降级成 %f(inf/nan 大小写丢失)、%a 直接失效。目标 glibc 两者都支持,
# 这里补回定义(实测 aarch64 glibc 2.44 均正确)。
post_configure_target() {
  sed -i -e 's|/\* #undef PRINTF_HAS_F_FORMAT \*/|#define PRINTF_HAS_F_FORMAT 1|' \
         -e 's|/\* #undef PRINTF_HAS_A_FORMAT \*/|#define PRINTF_HAS_A_FORMAT 1|' \
         ${PKG_BUILD}/.${TARGET_NAME}/config.h
}

post_makeinstall_target() {
  # 手册/信息页/头文件/发信脚本/示例库在设备上没有用途
  rm -rf ${INSTALL}/usr/share/info
  rm -rf ${INSTALL}/usr/share/man
  rm -rf ${INSTALL}/usr/share/doc
  rm -rf ${INSTALL}/usr/include
  rm -rf ${INSTALL}/usr/lib/awk
  rm -rf ${INSTALL}/etc/profile.d
  rm -f ${INSTALL}/usr/bin/gawkbug

  # 只留 inplace,其余扩展(约 806KB)设备上用不到
  find ${INSTALL}/usr/lib/gawk -type f ! -name 'inplace.so' -delete

  debug_strip ${INSTALL}/usr
}
