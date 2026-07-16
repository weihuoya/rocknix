# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="xwayland"
PKG_VERSION="24.1.9"
PKG_LICENSE="OSS"
PKG_SITE="https://gitlab.freedesktop.org/xorg/xserver"
PKG_URL="https://gitlab.freedesktop.org/xorg/xserver/-/archive/xwayland-24.1.9/xserver-xwayland-24.1.9.tar.bz2"
PKG_SHA256="cd03b324e3abb689d20ddc6ebecd72ff7dea5c565d56f3e50c415db130520e7f"
PKG_DEPENDS_TARGET="toolchain util-macros font-util xorgproto libpciaccess libX11 libXfont2 libXinerama libxcvt libxshmfence libxkbfile libdrm openssl freetype pixman systemd xorg-launch-helper wayland libglvnd"
PKG_NEED_UNPACK=""
PKG_LONGDESC="X.Org Server is the free and open-source implementation of the X Window System display server."

get_graphicdrivers

pre_configure_target() {
export TARGET_CFLAGS="${TARGET_CFLAGS} -Wno-error=incompatible-pointer-types"
}

PKG_MESON_OPTS_TARGET+=" -Dxvfb=false \
                       -Dbuilder_addr=${BUILDER_NAME} \
                       -Ddefault_font_path="/usr/share/fonts/misc,built-ins" \
                       -Dxdmcp=false \
                       -Dxdm-auth-1=false \
                       -Dsecure-rpc=false \
                       -Dipv6=false \
                       -Dinput_thread=true \
                       -Dxkb_dir=${XORG_PATH_XKB} \
                       -Dxkb_output_dir="/var/cache/xkb" \
                       -Dvendor_name="ROCKNIX" \
                       -Dvendor_name_short="ROCKNIX" \
                       -Dvendor_web="https://rocknix.org" \
                       -Dlisten_tcp=false \
                       -Dlisten_unix=true \
                       -Dlisten_local=false \
                       -Ddpms=true \
                       -Dxf86bigfont=false \
                       -Dscreensaver=false \
                       -Dxres=true \
                       -Dxace=true \
                       -Dxselinux=false \
                       -Dxinerama=true \
                       -Dxcsecurity=false \
                       -Dxv=true \
                       -Dmitshm=true \
                       -Dsha1="libcrypto" \
                       -Ddri3=true \
                       -Ddrm=true \
                       -Dlibunwind=false \
                       -Ddocs=false \
                       -Ddevel-docs=false"

if [ ! "${OPENGL}" = "no" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL} libepoxy"
  PKG_MESON_OPTS_TARGET+=" -Dglx=true \
                           -Dglamor=true"
else
  PKG_MESON_OPTS_TARGET+=" -Dglx=false \
                           -Dglamor=false"
fi

if [ "${COMPOSITE_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" libXcomposite"
fi

post_makeinstall_target() {
  rm -rf ${INSTALL}/var/cache/xkb

}
