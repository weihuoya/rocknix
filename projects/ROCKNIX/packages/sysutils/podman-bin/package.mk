# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2024-present Team ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="podman-bin"
PKG_VERSION="6.2.0"
PKG_SHA256="cb182273c5c5e3ea079f8f88a9a30a574d247f80e0b9dd9c02df1d2e6f6f3705"
PKG_LICENSE="Apache-2.0"
PKG_SITE="https://podman.io/"
PKG_URL="https://github.com/containers/podman/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain go:host gpgme libassuan libseccomp systemd"
PKG_DEPENDS_CONFIG="gpgme libassuan libseccomp"
PKG_LONGDESC="Podman: A tool for managing OCI containers and pods."
PKG_TOOLCHAIN="manual"

export PKG_GIT_COMMIT="055de046937d29450f310fce0fe3071485d8bed9"

configure_target() {
  go_configure
  export GIT_COMMIT=${PKG_GIT_COMMIT}
}

make_target() {
  make BUILDTAGS="exclude_graphdriver_devicemapper \
                  exclude_graphdriver_btrfs \
                  seccomp \
                  systemd" \
       CGO_CPPFLAGS="-I$(get_install_dir gpgme)/usr/include" \
       GO="${GOLANG}" \
       PREFIX=/usr \
       HELPER_BINARIES_DIR=/usr/libexec/podman \
       EXTRA_LDFLAGS="-X github.com/containers/image/v5/sysregistries.systemRegistriesConfPath=/etc/containers/registries.conf \
                      -X github.com/containers/image/v5/sysregistries.systemRegistriesConfDirectoryPath=/etc/containers/registries.conf.d \
                      -X github.com/containers/image/v5/signature.systemDefaultPolicyPath=/etc/containers/policy.json \
                      -extldflags=-L$(get_install_dir gpgme)/usr/lib" \
       binaries
}

makeinstall_target() {
  :
}
