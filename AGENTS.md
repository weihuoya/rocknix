<!-- From: /home/weiz/Projects/rocknix/AGENTS.md -->
# ROCKNIX Distribution — Agent Guide

## Project Overview

[ROCKNIX](https://github.com/ROCKNIX/distribution) is an immutable Linux distribution for handheld gaming devices. It is a fork of [JELOS](https://github.com/JustEnoughLinuxOS/distribution) and inherits the LibreELEC build system architecture. The project produces bootable OS images for ARM and AArch64 handhelds.

Key characteristics:
- **Build-system type**: Custom shell-based cross-compilation framework (LibreELEC lineage).
- **Languages**: Shell/Bash (build system), Python (helper scripts), C/C++ (target software).
- **License**: Original software and scripts are GPL-2.0; bundled works retain their respective licenses. Distribution branding and documentation are CC BY-NC-SA.
- **Default distro**: `ROCKNIX` (set in `config/options`).
- **Default project**: `ROCKNIX`.
- **Default device**: `SM8550` (when `DEVICE` is unset and `PROJECT=ROCKNIX`).
- **Default arch**: `aarch64`.
- **Kernel version**: Device-dependent. `SM8550` uses `7.0.11`.

Supported devices under `projects/ROCKNIX/devices/`:
`SM8550` (this fork only maintains this device).

## Agent Working Principles

- **When in doubt, ask**: During any modification or implementation, if you encounter uncertainties, ambiguities, or multiple valid approaches, you must ask the user for clarification rather than making assumptions or guessing. This prevents unnecessary changes and avoids pursuing the wrong direction.
- **Always check both package directories**: Before modifying any package, you **must** check whether it exists in **both** `packages/<cat>/<pkg>/` and `projects/ROCKNIX/packages/<cat>/<pkg>/`. The project-level override directory takes precedence during builds. If you only modify the generic `packages/` version while a `projects/ROCKNIX/packages/` override exists, your changes will be silently ignored.

## Repository Layout

```
.
├── config/              # Build-system core: functions, arch configs, options, graphic flags
├── distributions/       # Distro branding, version, and per-distribution options
│   ├── LEIoT/
│   ├── LibreELEC/
│   └── ROCKNIX/        # <--- active distro
├── packages/            # ~960+ package definitions (package.mk files)
│   ├── emulation/       # Libretro cores and standalone emulators (~77 packages)
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
│   │   │   └── SM8550/  # Currently the primary device under the ROCKNIX project
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

> **Local builds are not performed** for this project. Use the CI pipeline (triggered by publishing a release) to produce images. When debugging or testing individual packages, you may still use `./scripts/build <package>` in a local environment, but do not run full `make` or `make SM8550` locally.

### How It Works

The build system is a collection of Bash scripts that:
1. Source cascading option files (`config/options` → `projects/${PROJECT}/options` → `projects/${PROJECT}/devices/${DEVICE}/options` → `config/arch.${TARGET_ARCH}`).
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
| `THREADCOUNT` | Number of parallel build threads (defaults to `nproc`). |

### Build Lifecycle

For each package, the build script (`scripts/build`) executes these stages:

1. **Download** (`scripts/get`) — fetches source archives using `PKG_URL` and verifies `PKG_SHA256`.
2. **Unpack** (`scripts/unpack`) — extracts the archive and writes a `.rocknix-unpack` marker.
3. **Patch** — auto-applies patches from `patches/` (generic) and `${PROJECT}/packages/<cat>/<pkg>/patches/` (project override).
4. **Configure** — runs `pre_configure_${TARGET}` → `configure_${TARGET}` (or default toolchain logic) → `post_configure_${TARGET}`.
5. **Make** — runs `pre_make_${TARGET}` → `make_${TARGET}` (or default) → `post_make_${TARGET}`.
6. **Install** — runs `pre_makeinstall_${TARGET}` → `makeinstall_${TARGET}` (or default) → `post_makeinstall_${TARGET}`.
7. **Sysroot merge** — copies the per-package install tree into the shared `SYSROOT_PREFIX` under an update lock to prevent race conditions during parallel builds.

Stages suffixes are `_bootstrap`, `_host`, `_init`, and `_target`.

### Stamp-Based Incremental Builds

The build system computes a `PKG_DEEPHASH` for each package. If the stamp file in `build.*/.stamps/${PKG_NAME}/build_${TARGET}` matches the current hash, the build is skipped. To force a rebuild, run `./scripts/clean <package>`.

### Parallel Builds

The top-level image build uses `scripts/pkgbuilder.py` (invoked via `start_multithread_build` in `config/multithread`) to build packages in dependency order across multiple threads. `scripts/genbuildplan.py` resolves the dependency graph and emits the build plan.

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

### Project-Level Package Overrides

The build system supports **per-project package overrides**. When `PROJECT=ROCKNIX`, files under `projects/ROCKNIX/packages/<category>/<name>/` take precedence over the generic `packages/<category>/<name>/`.

This means for any package you must check **both** locations:

| Location | Purpose |
|----------|---------|
| `packages/<cat>/<pkg>/` | Generic package definition, shared across all projects |
| `projects/ROCKNIX/packages/<cat>/<pkg>/` | **ROCKNIX-specific override** — can contain its own `package.mk`, `patches/`, `config/`, etc. |

**Critical rule:** If a package has a `projects/ROCKNIX/packages/<cat>/<pkg>/` directory, the build system will use files from **that directory**, not the generic one. This applies to:

- `package.mk` — completely overrides the generic package definition
- `patches/*.patch` — patches are applied from the project directory
- `config/`, `system.d/`, `scripts/` — all auxiliary files

**Practical impact:** When adding or updating patches for a package used by ROCKNIX, you must place them in `projects/ROCKNIX/packages/<cat>/<pkg>/patches/`, not just `packages/<cat>/<pkg>/patches/`. If both directories exist but the patch is only in the generic location, the ROCKNIX build will **not** apply it.

To verify which directory is active for a package, check whether `projects/ROCKNIX/packages/<cat>/<pkg>/` exists before modifying the generic one.

> **⚠️ Critical reminder for this fork:** Many packages in this fork have been removed from `projects/ROCKNIX/packages/` while still existing in the generic `packages/` tree (or vice versa). Always verify the actual state in **both** locations before making changes. Do not assume a package is gone just because it is missing in one directory.

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

### Options Cascade

Configuration is sourced in this exact order (later files override earlier ones):

1. `distributions/${DISTRO}/version`
2. `distributions/${DISTRO}/options`
3. `projects/${PROJECT}/options`
4. `projects/${PROJECT}/devices/${DEVICE}/options`
5. `config/arch.${TARGET_ARCH}`
6. `${ROOT}/.rocknix/options` (local persistent options)
7. `${HOME}/.rocknix/options` (global persistent options)

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
- **Variable referencing**: Use `${VAR}` style consistently.

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
- `build-device.yml` — Orchestrates the full multi-stage build for a device (aarch64-toolchain, aarch64, emulators, image). **Note:** ARM (32-bit) builds have been removed in this fork.
- `build-aarch64.yml` — Main AArch64 system build.
- `build-aarch64-toolchain.yml` — Builds the cross-compilation toolchain.
- `build-aarch64-mame-lr.yml` — MAME libretro core build.
- `build-aarch64-qt6.yml` — Qt6 package build.
- `build-aarch64-rust.yml` — Rust toolchain build.
- `build-aarch64-emu-libretro.yml` / `build-aarch64-emu-standalone.yml` — Emulator package builds.
- `build-aarch64-image.yml` — Assembles final images per device.
- `build-nightly.yml` — Nightly and official release pipeline.
- `build-docker-image.yml` — Publishes the builder Docker image.
- `retry-workflow.yml` — Retries failed workflow jobs.
- ~~`update-mirror-sources.yml`~~ — Removed in this fork.
- ~~`update-kernel-configs-docs.yml`~~ — Removed in this fork.
- ~~`build-arm.yml`~~ — Removed in this fork (32-bit builds no longer supported).

Official builds use `ghcr.io/rocknix/rocknix-build:latest` as the builder image.

The full CI pipeline is triggered on `release: [published]` events. Individual stages are reusable `workflow_call` workflows invoked by `build-device.yml`.

### Artifact Handling — Cross-Repo Shared Cache

Instead of storing large build artifacts in GitHub Actions cache, the workflow:

1. Computes a content hash key from relevant source files.
2. Checks GitHub Releases for a matching pre-built archive under the `weihuoya/rocknix` repo. If found, downloads and extracts it, skipping the build entirely.
3. If not found, builds, compresses with `tar --zstd`, splits into parts (`.aa`, `.ab`), uploads those parts to GitHub Releases, and uploads only a tiny `*-key.txt` as the GitHub Actions artifact.
4. Downstream jobs download the key file, then fetch and reassemble the actual archive from Releases.

This creates a shared, repo-external build cache that works across forks without duplicating storage.

### Release Process

When a release is published:
1. The full multi-stage pipeline runs.
2. The final `build-aarch64-image.yml` job uploads the resulting artifacts directly to that release:
   - `target/ROCKNIX-*.img.gz` + `.sha256` (bootable image)
   - `target/ROCKNIX-*.tar` + `.sha256` (OTA update package)

## Fork Modifications (vs Upstream ROCKNIX)

This repository is a fork of upstream `ROCKNIX/distribution` with the following significant deviations. When working on this codebase, be aware that many packages, devices, and workflows have been removed or altered compared to upstream.

### 1. Device Scope — SM8550 Only

- **Only `SM8550` is maintained.** All other devices have been removed from `Makefile`, `build-nightly.yml`, and the workflow matrix.
- Removed devices: `H700`, `RK3326`, `RK3399`, `RK3566`, `RK3576`, `RK3588`, `S922X`, `SM6115`, `SM8250`, `SM8650`, `SM8750`.
- `make world` and CI only target `SM8550`.

### 2. Removed 32-bit ARM Builds

- The `build-arm.yml` workflow and all ARM (`ARCH=arm`) build targets have been removed.
- `Makefile` no longer includes any `ARCH=arm` build steps for `SM8550`.
- All 32-bit compatibility packages (`box64`, `box86`, `lib32`, `wine`) have been deleted.

### 3. Removed Emulators

#### Libretro Cores Removed (~60 packages)
The following libretro cores have been deleted from `projects/ROCKNIX/packages/emulators/libretro/` and `packages/emulation/`:

`81-lr`, `a5200-lr`, `atari800-lr`, `b2-lr`, `beetle-gba-lr`, `beetle-pce-lr`, `bk-lr`, `boom3-lr`, `cap32-lr`, `crocods-lr`, `daphne-lr`, `desmume-lr`, `doublecherrygb-lr`, `ecwolf-lr`, `emuscv-lr`, `fbalpha2012-lr`, `fbalpha2019-lr`, `fceumm-lr`, `flycast2021-lr`, `freechaf-lr`, `freeintv-lr`, `fuse-lr`, `gearcoleco-lr`, `gpsp-lr`, `hatari-lr`, `idtech-lr`, `jaxe-lr`, `mame2003-lr`, `mame2010-lr`, `mame2015-lr`, `minivmac-lr`, `mojozork-lr`, `mu-lr`, `np2kai-lr`, `o2em-lr`, `panda3ds-lr`, `parallel-n64-lr`, `play-lr`, `pokemini-lr`, `potator-lr`, `prboom-lr`, `prosystem-lr`, `puae2021-lr`, `px68k-lr`, `quasi88-lr`, `quicknes-lr`, `sameduck-lr`, `scummvm-lr`, `snes9x2002-lr`, `snes9x2005_plus-lr`, `snes9x2010-lr`, `stella-lr`, `swanstation-lr`, `tgbdual-lr`, `theodore-lr`, `tic80-lr`, `tyrquake-lr`, `uae4arm`, `uzem-lr`, `vba-next-lr`, `vbam-lr`, `vecx-lr`, `vircon32-lr`, `virtualjaguar-lr`, `vitaquake2-lr` (plus expansions), `vitaquake3-lr`, `wasm4-lr`, `xmil-lr`.

Also removed from generic packages:
`libretro-scummvm`.

#### Standalone Emulators Removed
- `gzdoom-sa` (+ `zmusic` dependency)
- `hatarisa` (+ `portaudio` dependency)
- `hypseus-singe`
- `minivmacsa`
- `openbor`
- `scummvmsa`
- `xemu-sa`

### 4. Removed System / Graphics / Network Packages

- **Graphics/GPU drivers for desktop/PC**: `nvidia`, `xf86-video-nvidia`, `xf86-video-intel`, `xf86-video-amdgpu`, `xf86-video-vmware`, `intel-vaapi-driver`, `media-driver`, `gmmlib`, `nv-codec-headers`, `nvidia-vaapi-driver`.
- **Wayland compositor**: `weston` (both generic and ROCKNIX-specific).
- **Compatibility layer**: `box64`, `box86`, `lib32`, `wine`, `cabextract`.
- **Network tools**: `rclone`, `tailscale`, `zerotier-one`.
- **System utilities**: `open-vm-tools`, `ethmactool`, `flashrom`.
- **Rockchip-specific**: `libmali`, `libmali-vulkan`, `librga`, `rkmpp`, `rkbin`, `gcc-linaro-aarch64-elf`, `gcc-linaro-arm-eabi`.
- **Other removed**: `gtk2`, `libcroco`, `soundfont-generaluser`, `kmscube`, `xorg-intel-gpu-tools`.

### 5. Package Version Updates

Many core packages have been updated to newer versions compared to upstream. Notable updates include:
- `alsa-lib`, `alsa-utils`, `alsa-ucm-conf`
- `pipewire`, `wireplumber`
- `glib`, `glibc`
- `Python3`, `llvm`
- `rust` toolchain (`rust`, `cargo-snapshot`, `rustc-snapshot`, `rust-std-snapshot`)
- `zlib`, `libpng`, `libarchive`, `7-zip`
- `binutils`, `ccache`, `elfutils`
- `busybox`, `util-linux`, `squashfs-tools`
- `samba`, `iwd`
- `SDL3`, `qt6`

Patches for removed/updated packages have also been cleaned up or refreshed.

### 6. CI/CD Workflow Changes

#### Trigger & Scope
- Removed scheduled (`cron`) and `workflow_dispatch` with multi-device matrix triggers.
- Build is now triggered **only on `release: [published]` events**.
- Workflow concurrency group added to cancel in-progress builds on new releases.
- `OWNER_LC` is hardcoded to `rocknix` instead of deriving from repository owner.

#### Removed Workflows
- `build-arm.yml` — 32-bit ARM build no longer needed.
- `ai-usage.yml` — AI PR labeling removed.
- `validate-commit.yml` — Commit validation removed.
- `update-kernel-configs-docs.yml` — Kernel config doc update removed.
- `update-mirror-sources.yml` — Source mirror update removed.
- `trigger-fail-if-upstream-changed.yml` — Removed.

#### Modified Workflows
- `build-nightly.yml` — Simplified to only emit `SM8550` matrix; removed `NIGHTLY`/`OFFICIAL` logic.
- `build-device.yml` — Removed `build-arm` job dependency; simplified `if` conditions to `!failure() && !cancelled()`.
- All `build-aarch64-*.yml` — Added cross-repo shared cache (prebuilt retrieval from `weihuoya/rocknix` releases), ccache restore/save, Docker mount path changed to `/work/rocknix`.
- `build-aarch64-image.yml` — Uploads final images to the GitHub release that triggered the build.

### 7. `Makefile` Changes

- `world:` target now only builds `SM8550`.
- Removed all per-device targets except `SM8550`.
- `update` target uses `DEVICE=SM8550` instead of `RK3588`.

## Workflow Migration Notes

The GitHub Actions workflows in `.github/workflows/` are derived from the upstream `ROCKNIX/distribution` repository (`next` branch). They have been customized to support a **cross-repository shared build-cache** model.

## Security Considerations

- The distribution is immutable; the root filesystem is a SquashFS image.
- Default root password is `rocknix` (see `distributions/ROCKNIX/options`).
- `HARDENING_SUPPORT` is set to `no` in distribution options.
- Do not commit secrets or API keys; the CI uses GitHub Secrets for scraping/achievement services (`CHEEVOS_DEV_LOGIN`, `GAMESDB_APIKEY`, `SCREENSCRAPER_DEV_LOGIN`).
- When updating packages, verify `PKG_SHA256` against upstream sources to prevent supply-chain issues.

## Useful Developer Tools

| Tool | Purpose |
|------|---------|
| `tools/pkgcheck <package>` | Lint a `package.mk` for common errors. |
| `tools/distro-tool` | Manage distribution packages, downloads, mirrors, and upstream version checks. |
| `tools/refresh-patches` | Refresh quilt-style patches for a package. |
| `tools/check_kernel_config` | Validate kernel configuration. |
| `tools/adjust_kernel_config` | Run `menuconfig`/`olddefconfig` for a device kernel. |
| `scripts/get_env` | Generate `.env` for Docker builds. |
| `scripts/mkimage` | Low-level image creation helper. |
| `scripts/genbuildplan.py` | Python dependency resolver that emits ordered build plans. |

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
