# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="shaderc"
PKG_VERSION="2025.3"
PKG_SHA256="a8e4a25e5c2686fd36981e527ed05e451fcfc226bddf350f4e76181371190937"
PKG_LICENSE="Apache-2.0"
PKG_SITE="https://github.com/google/shaderc"
PKG_URL="${PKG_SITE}/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_LONGDESC="A collection of tools, libraries, and tests for Vulkan shader compilation."
PKG_DEPENDS_HOST="toolchain:host Python3:host glslang:host spirv-tools:host"
PKG_DEPENDS_TARGET="toolchain glslang"
PKG_DEPENDS_UNPACK="spirv-headers"
PKG_TOOLCHAIN="cmake"

post_unpack() {
  # Use the ROCKNIX-packaged sources for shaderc's bundled dependencies so it
  # doesn't try to sync its own DEPS.
  mkdir -p ${PKG_BUILD}/third_party/glslang
  tar --strip-components=1 \
    -xf "${SOURCES}/glslang/glslang-$(get_pkg_version glslang).tar.gz" \
    -C "${PKG_BUILD}/third_party/glslang"

  mkdir -p ${PKG_BUILD}/third_party/spirv-tools
  tar --strip-components=1 \
    -xf "${SOURCES}/spirv-tools/spirv-tools-$(get_pkg_version spirv-tools).tar.gz" \
    -C "${PKG_BUILD}/third_party/spirv-tools"

  mkdir -p ${PKG_BUILD}/third_party/spirv-headers
  tar --strip-components=1 \
    -xf "${SOURCES}/spirv-headers/spirv-headers-$(get_pkg_version spirv-headers).tar.gz" \
    -C "${PKG_BUILD}/third_party/spirv-headers"

  # The target build also keeps the existing external/ extraction.
  mkdir -p ${PKG_BUILD}/external/spirv-headers
  tar --strip-components=1 \
    -xf "${SOURCES}/spirv-headers/spirv-headers-$(get_pkg_version spirv-headers).tar.gz" \
    -C "${PKG_BUILD}/external/spirv-headers"
}

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET+="-DSHADERC_SKIP_TESTS=ON \
                       -DSHADERC_SKIP_EXAMPLES=ON \
                       -DENABLE_OPT=OFF"

  mkdir -p ${PKG_BUILD}/glslc/src
  echo "\"${PKG_VERSION}\"" > ${PKG_BUILD}/glslc/src/build-version.inc
}

pre_configure_host() {
  PKG_CMAKE_OPTS_HOST+="-DSHADERC_SKIP_TESTS=ON \
                       -DSHADERC_SKIP_EXAMPLES=ON \
                       -DSHADERC_SKIP_INSTALL=ON \
                       -DENABLE_OPT=OFF"

  mkdir -p ${PKG_BUILD}/glslc/src
  echo "\"${PKG_VERSION}\"" > ${PKG_BUILD}/glslc/src/build-version.inc
}

makeinstall_host() {
  mkdir -p ${TOOLCHAIN}/bin
  cp -v ${PKG_BUILD}/.${HOST_NAME}/glslc/glslc ${TOOLCHAIN}/bin/glslc
}
