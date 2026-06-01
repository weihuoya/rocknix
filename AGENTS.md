# ROCKNIX Distribution — Agent Guide

## Project Overview

ROCKNIX is an immutable Linux distribution for handheld gaming devices. It is a fork of [JELOS](https://github.com/JustEnoughLinuxOS/distribution) and inherits the LibreELEC build system architecture. The project produces bootable OS images for ARM and AArch64 handhelds.

Key characteristics:
- **Build-system type**: Custom shell-based cross-compilation framework (LibreELEC lineage).
- **Languages**: Shell/Bash (build system), Python (helper scripts), C/C++ (target software).
- **License**: Original software and scripts are GPL-2.0; bundled works retain their respective licenses. Distribution branding and documentation are CC BY-NC-SA.
- **Default distro**: `ROCKNIX` (set in `config/options`).
- **Default project**: `ROCKNIX`.
- **Default device**: `SM8550` (when `DEVICE` is unset and `PROJECT=ROCKNIX`).
- **Default arch**: `aarch64`.

## Repository Layout

```
.
├── config/              # Build-system core: functions, arch configs, options, graphic flags
├── distributions/       # Distro branding, version, and per-distribution options
│   ├── LEIoT/
│   ├── LibreELEC/
│   └── ROCKNIX/        # <--- active distro
├── packages/            # ~960 package definitions (package.mk files)
│   ├── emulation/       # Libretro cores and standalone emulators
│   ├── linux/           # Linux kernel package
│   ├── mediacenter/     # Kodi and related packages
│   ├── sysutils/        # System utilities
│   ├── virtual/         # Metapackages that group dependencies (image, toolchain, debug, ...)
│   └── ...
├── projects/            # Per-project/device configuration
│   ├── Allwinner/       # Devices: A64, H2-plus, H3, H5, H6, R40
│   ├── Amlogic/         # Devices: AMLGX
│   ├── ARM/             # Devices: ARMv7, ARMv8
│   ├── Generic/         # Devices: gbm, Generic, Generic-gl, Generic-legacy, wayland, x11
│   ├── NXP/             # Devices: iMX6, iMX8
│   ├── Qualcomm/        # Devices: Dragonboard
│   ├── ROCKNIX/         # <--- active project
│   │   ├── devices/
│   │   │   └── SM8550/  # Currently the only device under the ROCKNIX project
│   │   └── options      # Project-wide defaults
│   ├── Rockchip/        # Devices: RK3288, RK3328, RK3399
│   ├── RPi/             # Devices: RPi, RPi2, RPi4, RPi5
│   └── Samsung/         # Devices: Exynos
├── scripts/             # Build and image creation scripts
│   ├── build            # Build a single package
│   ├── build_distro     # Top-level distro build entry point
│   ├── image            # Create bootable image
│   ├── clean            # Clean package build artifacts
│   ├── unpack           # Extract sources and apply patches
│   └── ...
├── tools/               # Developer utilities (pkgcheck, distro-tool, refresh-patches, ...)
└── Dockerfile           # Ubuntu Jammy builder image for Docker builds
```

## Build System

### How It Works

The build system is a collection of Bash scripts that:
1. Source cascading option files (`config/options` → `projects/${PROJECT}/options` → `projects/${PROJECT}/devices/${DEVICE}/options`).
2. Download, unpack, patch, build, and install packages into a cross-compilation sysroot.
3. Assemble the root filesystem and kernel into a bootable image.

Build outputs go into `build.${DISTRO}-${DEVICE}.${ARCH}/`.

### Key Environment Variables

| Variable | Description |
|----------|-------------|
| `PROJECT` | Top-level project name (e.g., `ROCKNIX`). |
| `DEVICE`  | Target device (e.g., `SM8550`, `RK3399`, `AMLGX`). |
| `ARCH`    | Target architecture (`arm` or `aarch64`). |
| `DEVICE_ROOT` | Some devices share a build root. Build `DEVICE_ROOT` first, then `DEVICE` links to it. |
| `DIRTY`   | If set, skip cleaning packages that would otherwise be cleaned to update version stamps. |
| `VERBOSE` | `yes` (default) enables verbose build output. |

### Common Build Commands

Build everything for the default device (SM8550):
```bash
make
# Equivalent to:
# PROJECT=ROCKNIX DEVICE=SM8550 ARCH=arm ./scripts/build_distro
# PROJECT=ROCKNIX DEVICE=SM8550 ARCH=aarch64 ./scripts/build_distro
```

Build for a specific device:
```bash
make SM8550
```

Build a specific package:
```bash
./scripts/build <package_name>
# Or via Makefile:
make package PACKAGE=<package_name>
```

Clean a package:
```bash
./scripts/clean <package_name>
# Or:
make package-clean PACKAGE=<package_name>
```

Create a release image:
```bash
make release
```

Build inside Docker (recommended for reproducibility):
```bash
make docker-SM8550
```

Pull or build the Docker builder image:
```bash
make docker-image-pull
make docker-image-build
```

Enter an interactive Docker shell:
```bash
make docker-shell
```

### Build Dependencies

Run `scripts/checkdeps` to verify the host has required tools. Typical Ubuntu/Debian packages needed:
- `bash`, `bc`, `bzip2`, `curl`, `diffutils`, `gawk`, `gcc`, `g++`, `gperf`, `gzip`, `file`, `lzop`, `make`, `patch`, `perl`, `rsync`, `sed`, `tar`, `unzip`, `xmlstarlet`, `xz-utils`, `zip`, `zstd`, `python3`, `git`, `openssh-client`, `wget`, `automake`, `parted`, `xxd`, `rdfind`, `patchutils`, `golang`, `default-jre-headless`, `xsltproc`, `upx-ucl`, `libc6-dev`, `libncurses5-dev`, `libjson-perl`, `libxml-parser-perl`, `libparse-yapp-perl`

**Do not build as root.** The build system exits if `EUID == 0`.
**Do not use paths containing spaces.**

## Package System

### Structure

Each package lives in its own directory under `packages/<category>/<name>/` and contains at minimum a `package.mk` file.

Example:
```
packages/emulation/libretro-2048/
└── package.mk
```

Patches are placed in a `patches/` subdirectory and are auto-applied after unpacking.

### Standard Variables in `package.mk`

| Variable | Required | Description |
|----------|----------|-------------|
| `PKG_NAME` | yes | Lowercase package name. |
| `PKG_VERSION` | yes | Version string or full git hash. |
| `PKG_SHA256` | yes | Hash of the downloaded source archive. |
| `PKG_LICENSE` | yes | License identifier. |
| `PKG_SITE` | yes | Upstream project URL. |
| `PKG_URL` | yes | Source download URL. |
| `PKG_ARCH` | no | `any` (default) or space-separated list of target architectures. Prefix with `!` to exclude. |
| `PKG_DEPENDS_TARGET` | no | Space-separated dependencies for target build. |
| `PKG_DEPENDS_HOST` | no | Space-separated dependencies for host build. |
| `PKG_DEPENDS_INIT` | no | Space-separated dependencies for init build. |
| `PKG_DEPENDS_BOOTSTRAP` | no | Space-separated dependencies for bootstrap build. |
| `PKG_TOOLCHAIN` | no | `auto` (default), `meson`, `cmake`, `cmake-make`, `configure`, `make`, `ninja`, `autotools`, `manual`, `python`, `python-flit`. |
| `PKG_BUILD_FLAGS` | no | Fine-tune build behavior (`+pic`, `-gold`, `+speed`, `-parallel`, `+lto`, `+mold`, `+size`, `-strip`, etc.). |
| `PKG_SECTION` | no | Set to `virtual` for metapackages that only declare dependencies. |
| `PKG_NEED_UNPACK` | no | Files or folders to include in stamp calculation for incremental rebuilds. |

### Build Lifecycle Hooks

The build script calls these functions (stage suffixes: `_bootstrap`, `_host`, `_init`, `_target`):

- `pre_build_<stage>`
- `pre_configure_<stage>` / `configure_<stage>` / `post_configure_<stage>`
- `pre_make_<stage>` / `make_<stage>` / `post_make_<stage>`
- `pre_makeinstall_<stage>` / `makeinstall_<stage>` / `post_makeinstall_<stage>`

For packages that need custom logic, set `PKG_TOOLCHAIN="manual"` and implement the needed hooks.

### Late Binding Rule

Variables such as `PKG_BUILD`, `PKG_SOURCE_NAME`, and toolchain variables (`CC`, `CFLAGS`, `CMAKE_CONF`, `TARGET_CMAKE_OPTS`, etc.) are only available after the build system has initialized them. **Do not reference them at the top level of `package.mk`**. Use `configure_package()` or other hook functions instead. Run `tools/pkgcheck <package>` to detect violations.

### Virtual Packages

The root of the dependency tree is `packages/virtual/image/package.mk`, which pulls in:
- `libc`, `gcc`, `linux`, `linux-drivers`, `linux-firmware`
- `busybox`, `util-linux`, `corefonts`, `network`, `misc-packages`
- Display server, window manager, mediacenter, audio stack
- `BOOTLOADER`

## Device Configuration

Devices are defined under `projects/${PROJECT}/devices/${DEVICE}/`.

Key device-level option files:
- `options` — CPU flags, kernel target, bootloader, GPU drivers, firmware, additional packages, cmdline.
- `linux/` — Device-specific kernel configurations or patches.
- `packages/` — Device-specific packages or package overrides.

Some devices share a build root via `DEVICE_ROOT`. For example, if `DEVICE_ROOT` is set to another device name, that base device must be built first and the current device will symlink to its build directory.

## Code Style Guidelines

- **License headers**: Every source file should begin with an SPDX identifier and copyright notice.
  ```bash
  # SPDX-License-Identifier: GPL-2.0-or-later
  # Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)
  ```
  Use `GPL-2.0` for files that do not explicitly state "or later."
- **Indentation**: 2 spaces in shell scripts and `package.mk` files.
- **Function definitions**: Opening brace `{` must be on the same line as the function name:
  ```bash
  post_makeinstall_target() {
    ...
  }
  ```
- **Variable assignments**: Keep all variable assignments at the top of `package.mk`, before any functions. Do not interleave variables and functions.
- **Lowercase package names**: `PKG_NAME` should be lowercase.
- **Git versions**: Use the full git hash, not an abbreviated one.

## Testing and Validation

- There is no traditional unit-test suite; correctness is validated by **building the distribution**.
- Use `tools/pkgcheck <path/to/package.mk>` to lint packages for:
  - Late-binding violations
  - Duplicate function definitions
  - Missing braces on function definitions
  - Unknown functions (possible typos)
  - Ignored dependency assignments
  - Intertwined variables and functions
- Use `scripts/checkdeps` to validate the host build environment.
- Incremental builds are supported via stamp files in `build.*/.stamps/`. If a package or its dependencies change, it is automatically rebuilt.

## CI / Deployment

GitHub Actions workflows live in `.github/workflows/`:
- `build-device.yml` — Orchestrates the full multi-stage build for a device (arm, aarch64-toolchain, aarch64, emulators, image).
- `build-aarch64.yml` — Main AArch64 system build.
- `build-arm.yml` — ARM (32-bit) compatibility builds.
- `build-aarch64-toolchain.yml` — Builds the cross-compilation toolchain.
- `build-aarch64-mame-lr.yml` — MAME libretro core build.
- `build-aarch64-qt6.yml` — Qt6 package build.
- `build-aarch64-emu-libretro.yml` / `build-aarch64-emu-standalone.yml` — Emulator package builds.
- `build-aarch64-image.yml` — Assembles final images per device.
- `build-nightly.yml` — Nightly and official release pipeline.
- `build-docker-image.yml` — Publishes the builder Docker image.
- `update-mirror-sources.yml` — Updates source mirror caches.
- `update-kernel-configs-docs.yml` — Updates kernel configuration documentation.
- `ai-usage.yml` — Labels PRs that disclose AI assistance.
- `feature-freeze.yml` — Feature freeze automation.

Official builds use `ghcr.io/rocknix/rocknix-build:latest` as the builder image.

## Security Considerations

- The distribution is immutable; the root filesystem is typically a SquashFS image.
- Default root password is `rocknix` (see `distributions/ROCKNIX/options`).
- `HARDENING_SUPPORT` is set to `no` in distribution options.
- Do not commit secrets or API keys; the CI uses GitHub Secrets for scraping/achievement services (`CHEEVOS_DEV_LOGIN`, `GAMESDB_APIKEY`, `SCREENSCRAPER_DEV_LOGIN`).
- When updating packages, verify `PKG_SHA256` against upstream sources to prevent supply-chain issues.

## Useful Developer Tools

| Tool | Purpose |
|------|---------|
| `tools/pkgcheck <package>` | Lint a `package.mk` for common errors. |
| `tools/distro-tool` | Manage distribution packages and dependencies. |
| `tools/refresh-patches` | Refresh quilt-style patches for a package. |
| `tools/check_kernel_config` | Validate kernel configuration. |
| `tools/adjust_kernel_config` | Run `menuconfig`/`olddefconfig` for a device kernel. |
| `scripts/get_env` | Generate `.env` for Docker builds. |
| `scripts/mkimage` | Low-level image creation helper. |

## Quick Reference

Build the default device image:
```bash
make
```

Build a specific device image:
```bash
make <DEVICE>
```

Build one package:
```bash
./scripts/build <package>
```

Clean one package:
```bash
./scripts/clean <package>
```

Lint a package:
```bash
./tools/pkgcheck packages/<category>/<package>
```

Enter Docker shell:
```bash
make docker-shell
```
