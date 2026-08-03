<!-- SPDX-License-Identifier: CC-BY-NC-SA-4.0 -->
<!-- Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX) -->

# wayvnc 部署与 H.264 验证记录

## 1. 文件说明

| 文件 | 说明 |
|---|---|
| `wayvnc-deps-aarch64-SM8550.tar.zst` | wayvnc 构建依赖（包含 `libaml`、`libneatvnc`、`libjansson`、`libgnutls`、`libnettle`、`libhogweed` 等 sysroot） |
| `wayvnc-v0.10.1-rocknix-sm8550.tar.gz` | wayvnc 0.10.1 安装树（包含 `wayvnc`、`wayvncctl` 以及 glibc/wayland 等基础库） |

> **版本匹配要求**：`wayvnc` 二进制和 `libneatvnc.so` 必须来自同一次构建。如果只用新的 `wayvnc-deps` 搭配旧的 `wayvnc` 二进制，启动时会出现 `Symbol 'nvnc_version' has different size in shared object, consider re-linking` 警告，并可能导致运行不稳定或崩溃。

## 2. 部署方法

已把 wayvnc 部署到设备 `/storage/.config/wayvnc/`，目录结构：

```text
/storage/.config/wayvnc/
├── start-wayvnc.sh      # 启动脚本
└── usr/
    ├── bin/
    │   ├── wayvnc       # VNC 服务器
    │   └── wayvncctl    # 控制客户端
    └── lib/
        ├── libaml.so*         # 事件循环库
        ├── libneatvnc.so*   # VNC 核心库（含 Open H.264 编码封装）
        ├── libjansson.so*   # JSON 库
        ├── libgnutls.so*    # TLS 库（wayvnc/neatvnc 依赖）
        ├── libnettle.so*    # gnutls 依赖
        └── libhogweed.so*   # gnutls 依赖
```

### 2.1 准备部署目录

在 PC 端创建 `wayvnc_deploy` 目录，把 `wayvnc` 二进制和所需库放到一起。

```bash
rm -rf wayvnc_deploy
mkdir -p wayvnc_deploy/usr/bin wayvnc_deploy/usr/lib

# 提取 wayvnc 二进制
tar -xzf wayvnc-v0.10.1-rocknix-sm8550.tar.gz -C wayvnc_deploy ./usr/bin/wayvnc ./usr/bin/wayvncctl

# 提取 wayvnc 依赖库
# 注意：wayvnc-deps-aarch64-SM8550.tar.zst 里的符号链接是绝对路径
#（指向 /work/rocknix/...），需要把它们转换为相对链接后再上传。
mkdir -p /tmp/wayvnc_deps_extract
tar --zstd -xf wayvnc-deps-aarch64-SM8550.tar.zst -C /tmp/wayvnc_deps_extract \
  './build.ROCKNIX-SM8550.aarch64/toolchain/aarch64-rocknix-linux-gnu/sysroot/usr/lib/'

SYSROOT=/tmp/wayvnc_deps_extract/build.ROCKNIX-SM8550.aarch64/toolchain/aarch64-rocknix-linux-gnu/sysroot/usr/lib

cp -a "${SYSROOT}/libaml.so."*         wayvnc_deploy/usr/lib/
cp -a "${SYSROOT}/libneatvnc.so."*     wayvnc_deploy/usr/lib/
cp -a "${SYSROOT}/libjansson.so."*     wayvnc_deploy/usr/lib/
cp -a "${SYSROOT}/libgnutls.so."*      wayvnc_deploy/usr/lib/
cp -a "${SYSROOT}/libnettle.so."*      wayvnc_deploy/usr/lib/
cp -a "${SYSROOT}/libhogweed.so."*     wayvnc_deploy/usr/lib/

# 修复符号链接为相对链接
cd wayvnc_deploy/usr/lib
ln -sf libaml.so.1.0.0          libaml.so.1
ln -sf libaml.so.1               libaml.so
ln -sf libjansson.so.4.15.1      libjansson.so.4
ln -sf libjansson.so.4            libjansson.so
ln -sf libneatvnc.so.1.1         libneatvnc.so.1
ln -sf libneatvnc.so.1            libneatvnc.so
ln -sf libgnutls.so.30.42.0       libgnutls.so.30
ln -sf libgnutls.so.30.42.0       libgnutls.so
ln -sf libnettle.so.9.0           libnettle.so.9
ln -sf libnettle.so.9.0           libnettle.so
ln -sf libhogweed.so.7.0          libhogweed.so.7
ln -sf libhogweed.so.7.0          libhogweed.so

rm -rf /tmp/wayvnc_deps_extract
```

> 如果 `wayvnc-deps` 中的库版本号不同，请把上面 `ln -sf` 命令里的目标文件名替换为实际文件名。

### 2.2 启动脚本

创建 `wayvnc_deploy/start-wayvnc.sh`：

```bash
#!/bin/bash
export WAYLAND_DISPLAY=wayland-1
export XDG_RUNTIME_DIR=/var/run/0-runtime-dir
export LD_LIBRARY_PATH=/storage/.config/wayvnc/usr/lib

cd /storage/.config/wayvnc
exec ./usr/bin/wayvnc --gpu 0.0.0.0 5900
```

```bash
chmod +x wayvnc_deploy/start-wayvnc.sh
```

### 2.3 上传到掌机

示例设备 IP 为 `192.168.31.54`，请根据实际情况替换：

```bash
ssh root@192.168.31.54 'pkill -9 wayvnc 2>/dev/null; rm -rf /storage/.config/wayvnc/*'
scp -r wayvnc_deploy/* root@192.168.31.54:/storage/.config/wayvnc/
```

### 2.4 启动

```bash
ssh root@192.168.31.54
cd /storage/.config/wayvnc
nohup ./start-wayvnc.sh > /storage/.config/wayvnc/wayvnc.log 2>&1 </dev/null &
```

### 2.5 停止

```bash
pkill -9 wayvnc
```

### 2.6 查看日志

```bash
tail -f /storage/.config/wayvnc/wayvnc.log
```

### 2.7 连接 VNC

使用任意 VNC 客户端连接：

```text
192.168.31.54:5900
```

无认证（`security-type: none`）。

## 3. 验证结果

### 3.1 wayvnc 基本连接 ✅

- 设备 IP：`192.168.31.54`
- 监听端口：`5900`
- VNC 协议版本：`RFB 003.008`
- 安全类型：`none`
- 捕获输出：`DSI-1 1280x720`

使用 VNC 客户端可以正常看到掌机画面。

### 3.2 版本匹配警告 ⚠️

当使用 **旧 `wayvnc` 二进制 + 新 `wayvnc-deps`** 时，启动日志会出现：

```text
./usr/bin/wayvnc: Symbol 'nvnc_version' has different size in shared object, consider re-linking
```

进程虽然能启动并监听端口，但符号大小不匹配可能导致运行时崩溃或功能异常。正确做法是重新构建 `wayvnc-v0.10.1-rocknix-sm8550.tar.gz`，使其与新的 `wayvnc-deps` 中的 `libneatvnc` 版本一致。

### 3.3 Open H.264 编码 ❌ 当前不可用

通过自定义 VNC 客户端测试，客户端优先请求 Open H.264 编码（RFB encoding 50），但 wayvnc/neatvnc 仍回退到 `Tight` 编码。

wayvnc 日志显示：

```text
Client ... set encodings: open-h264,tight,zrle,raw,copyrect
Info: Choosing tight encoding for client ...
```

## 4. 掌机的 H.264 / 视频编解码支持情况

### 4.1 内核配置

```text
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_QCOM_CAMSS=m
CONFIG_VIDEO_QCOM_IRIS=y      # 内置 Qualcomm Iris 编解码器
CONFIG_VIDEO_QCOM_VENUS=y     # 内置 Qualcomm Venus 编解码器（但未加载/无固件）
```

### 4.2 V4L2 设备

```text
/dev/video0  qcom-iris-decoder   # H.264/HEVC 解码器
/dev/video1  qcom-iris-encoder   # H.264/HEVC 编码器
```

其他 `/sys/devices/platform/soc@0/*.codec` 设备均为音频 codec（lpass-wsa/rx/tx/va-macro），不是视频编码器。

### 4.3 固件

- `/lib/firmware/qcom/a740_sqe.fw` ✅ 已加载
- `/lib/firmware/qcom/gmu_gen70200.bin` ✅ 已加载
- `*venus*` 固件 ❌ 未找到

### 4.4 GPU / DRM 状态

```text
/dev/dri/card0       # DPU/显示
/dev/dri/renderD128  # Adreno GPU render node
```

dmesg 显示 Adreno 和 GMU 已绑定，但存在以下问题：

```text
[drm] Initialized msm 1.13.0 for ae01000.display-controller on minor 0
adreno 3d00000.gpu: Direct firmware load for qcom/a740_sqe.fw failed with error -2
adreno 3d00000.gpu: [drm:adreno_request_fw] *ERROR* failed to load a740_sqe.fw
...
loaded qcom/a740_sqe.fw from new location
loaded qcom/gmu_gen70200.bin from new location
[drm] Loaded GMU firmware v4.1.9
...
platform 3d6a000.gmu: delay in fenced register write (0x8a1)
```

Sway 日志中也有：

```text
[ERROR] [wlr] [backend/drm/atomic.c:81] connector DSI-1: Atomic commit failed: Device or resource busy
[ERROR] [sway/desktop/output.c:300] Page-flip failed on output DSI-1
```

说明 GPU 驱动虽然绑定，但运行状态并不完全稳定。

### 4.5 FFmpeg / libavcodec 支持

系统自带的 `libavcodec.so.60` 包含：

- `h264_v4l2m2m_decoder` ✅
- `h264_v4l2m2m` ✅（v4l2m2m 通用封装，可能同时支持 encode/decode）
- `libx264` ✅（软件编码器）
- `h264_vaapi` ❌ 未找到
- `h264_mediacodec` ❌ 未找到

结论：**掌机硬件上存在 H.264 编码能力**（`qcom-iris-encoder` + `libavcodec` 的 v4l2m2m 封装 + libx264 软件回退），但 **neatvnc 当前无法直接调用这些路径**。

## 5. wayvnc 的 H.264 支持机制

wayvnc 0.10.1 搭配的 neatvnc 1.0.0 支持 **Open H.264** 编码（RFB encoding 50）。它本身不直接提供 `--h264` 命令行开关；H.264 是否启用由客户端在 `SetEncodings` 阶段请求，服务器根据条件决定是否使用。

### 5.1 启用 Open H.264 的条件

neatvnc 的 `choose_frame_encoding()` 要求同时满足：

1. 客户端请求 encoding `50`（Open H.264）
2. 所有帧缓冲区类型必须是 `NVNC_BUFFER_GBM_BO`（dma-buf / GBM buffer object）
3. `have_working_h264_encoder()` 探针必须成功

### 5.2 H.264 编码器后端

`h264_encoder_create()` 按顺序尝试：

1. **v4l2m2m 后端**：扫描 `/dev/video*`，找到支持 H.264 memory-to-memory 编码的设备，设置输入/输出格式并启动 streaming。
2. **ffmpeg 后端**：使用 `h264_vaapi` 编码器，依赖 VAAPI + DRM PRIME / GBM BO。

**注意**：neatvnc 的 Open H.264 封装名为 `open-h264`，但底层并不使用 OpenH264 库，而是使用 v4l2m2m 或 VAAPI。

### 5.3 为什么当前不工作

在 SM8550 上：

- **v4l2m2m 后端**：`qcom-iris-encoder` 只接受 YUV/NV12 等格式作为输入，而 neatvnc 的 v4l2m2m 实现只尝试 RGB32 格式（`V4L2_PIX_FMT_XRGB32`、`RGBX32`、`XBGR32`、`BGRX32` 等），格式不匹配导致初始化失败。
- **ffmpeg 后端**：需要 `h264_vaapi` 编码器，但 SM8550 的 Adreno GPU（freedreno/turnip）没有完整的 VAAPI 编码支持，`libavcodec` 中也没有 `h264_vaapi`。
- **GBM_BO 要求**：即使格式问题通过，GPU 驱动目前也不稳定，dma-buf/GBM 捕获路径可能无法正常工作。

因此 neatvnc 的 `have_working_h264_encoder()` 探针失败，回退到 `Tight` 编码。

## 6. 结论

| 项目 | 状态 | 说明 |
|---|---|---|
| wayvnc 部署 | ✅ 成功 | 已部署到 `/storage/.config/wayvnc/`，可正常启动 |
| 普通 VNC 连接 | ✅ 可用 | 连接 `192.168.31.54:5900` 即可远程控制 |
| 版本匹配 | ⚠️ 需注意 | `wayvnc` 二进制与 `libneatvnc` 必须来自同一次构建 |
| GPU 加速捕获 | ⚠️ 部分可用 | `--gpu` 已启用，但 GPU 驱动有 `gmu fenced register` 和 `Atomic commit` 错误 |
| H.264 硬件编码 | ❌ 不可用 | neatvnc 的 v4l2m2m/VA-API 后端与 `qcom-iris-encoder` 不兼容 |
| H.264 软件编码 | ⚠️ 系统支持 libx264 | 但 neatvnc 不会使用软件 x264，需要修改 neatvnc 才能利用 |

## 7. 常见问题

### 7.1 启动时报 `libnettle.so.9: cannot open shared object file`

设备 `/usr/lib` 只有 `libnettle.so.8`，而 `wayvnc` 依赖的 `libgnutls.so.30` 需要 `libnettle.so.9`。解决方法是把 `wayvnc-deps` 中的 `libnettle.so.9`、`libhogweed.so.7`、`libgnutls.so.30` 一起放到 `/storage/.config/wayvnc/usr/lib/`，并通过 `LD_LIBRARY_PATH` 优先加载。

### 7.2 启动时报 `Symbol 'nvnc_version' has different size`

`wayvnc` 二进制与 `libneatvnc.so` 版本不匹配。必须重新构建 `wayvnc-v0.10.1-rocknix-sm8550.tar.gz`，使其与新的 `wayvnc-deps` 一起编译。

## 8. 要让 H.264 工作可能的方案

1. **修改 neatvnc 支持 qcom-iris-encoder**
   - 在 `src/enc/h264/v4l2m2m-impl.c` 中增加 YUV/NV12 输入格式支持。
   - 或者在帧送入 v4l2m2m 之前进行 RGB→YUV 颜色空间转换。

2. **让 neatvnc 使用 FFmpeg 的 `h264_v4l2m2m` 编码器**
   - 当前 neatvnc 的 ffmpeg 后端硬编码使用 `h264_vaapi`。
   - 修改 neatvnc 使其在 ffmpeg 后端中尝试 `h264_v4l2m2m`。

3. **启用 Venus 编码路径**
   - 当前内核配置了 `CONFIG_VIDEO_QCOM_VENUS=y`，但没有固件、没有创建 `/dev/video*` 节点。
   - 需要 Venus 固件（如 `venus.mbn`、`venus.*.mbn`）和正确的设备树/remoteproc 配置。

4. **纯软件 x264**
   - 系统 `libavcodec` 已链接 libx264。
   - 可修改 neatvnc 增加软件 H.264 编码后端，或改用其他支持 libx264 的 VNC 服务器。
   - 缺点是功耗高、CPU 占用大、延迟高，不适合掌机实时串流。

## 10. 迭代记录

### 2026-07-30 修复 neatvnc 构建错误并增加调试日志

#### 10.1 构建错误

在 `neatvnc` 的 `next` 迭代中，把 `h264_encoder_v4l2m2m_probe` 在 `include/enc/h264-encoder.h` 中声明为全局函数，但在 `src/enc/h264/v4l2m2m-impl.c` 中定义成了 `static`，导致交叉编译报错：

```text
../src/enc/h264/v4l2m2m-impl.c:1006:13: error: static declaration of 'h264_encoder_v4l2m2m_probe' follows non-static declaration
```

修复：

- 从 `include/enc/h264-encoder.h` 删除该声明；
- 在 `src/server.c` 的 `#ifdef HAVE_V4L2` 块内加 `extern bool h264_encoder_v4l2m2m_probe(...);`。

同时在 `src/enc/h264/v4l2m2m-impl.c` 的 `try_set_dst_format()` 和 `find_capable_device()` 里增加 `VIDIOC_G_FMT` / `VIDIOC_S_FMT` 失败原因以及设备扫描路径的调试日志，方便后续排查 `qcom-iris-encoder` 的识别情况。

#### 10.2 更新源码与触发构建

- `neatvnc` 源码仓库：`/home/weiz/Projects/neatvnc`
  - 提交并推送到 `weihuoya/neatvnc:master`
  - 新提交：`6ff5ad1d31e1fe6a8de7f8b38538055806f28b6c`
- `rocknix` 源码仓库：`/home/weiz/Projects/rocknix-distribution-next`
  - 更新 `projects/ROCKNIX/packages/tools/neatvnc/package.mk` 中的 `PKG_VERSION` 为新提交 hash
  - 推送到 `weihuoya/rocknix:next`
- 在 GitHub Actions 触发 `build-aarch64-wayvnc-deps` workflow：

  ```bash
  gh workflow run build-aarch64-wayvnc-deps.yml -R weihuoya/rocknix --ref next
  ```

  构建产物：`wayvnc-deps-aarch64-SM8550.tar.zst`，上传到 `weihuoya/rocknix` 的 `wayvnc-aarch64-SM8550` release。

#### 10.3 部署到 192.168.31.210

1. 下载新构建的 `wayvnc-deps-aarch64-SM8550.tar.zst`。
2. 按第 2.1 节重新准备 `wayvnc_deploy` 目录（注意 `wayvnc` 二进制最好也重新构建，确保与新的 `libneatvnc.so` 版本一致）。
3. 上传并重启：

   ```bash
   DEVICE_IP=192.168.31.210
   ssh root@${DEVICE_IP} 'pkill -9 wayvnc 2>/dev/null; rm -rf /storage/.config/wayvnc/*'
   scp -r wayvnc_deploy/* root@${DEVICE_IP}:/storage/.config/wayvnc/
   ssh root@${DEVICE_IP} 'chmod +x /storage/.config/wayvnc/start-wayvnc.sh && cd /storage/.config/wayvnc && nohup ./start-wayvnc.sh > /storage/.config/wayvnc/wayvnc.log 2>&1 </dev/null &'
   ```

4. 查看日志：

   ```bash
   ssh root@192.168.31.210 'tail -f /storage/.config/wayvnc/wayvnc.log'
   ```

   重点搜索：

   - `v4l2m2m: probing H.264 encoder` — 是否开始扫描编码器
   - `v4l2m2m: H.264 probe OK` / `v4l2m2m: H.264 probe failed` — 探针结果
   - `open-h264: frame 0 buffer type ...` — 捕获缓冲区类型
   - `open-h264: selecting H.264 encoding` / `open-h264: no working H.264 encoder` — 编码选择结果

#### 10.4 已知限制

根据此前在 `192.168.31.210` 上的排查，SM8550 掌机即使 `qcom-iris-encoder` 可用，H.264 仍可能无法启用，因为 Sway 合成器回退到 Pixman 软件渲染，只能提供 SHM 缓冲区，不满足 `NVNC_BUFFER_GBM_BO` 要求。根本原因是 Adreno 740 GMU 设备 `3d6a000.gmu` 未绑定驱动，需要在内核/设备树层面修复 GPU 驱动后，Sway 才能提供 dma-buf 捕获缓冲区。

### 2026-08-01 修复 qcom-iris packed NV12 单平面描述符

#### 11.1 问题现象

在 `192.168.31.210` 上启用 Open H.264 后，wayvnc 运行一段时间后崩溃，eu-stack 指向 `open_h264_handle_packet()` → `vec_append()` → `realloc()`，报错 `corrupted size vs. prev_size`，说明堆在更早阶段被破坏。

关键排查结论：

- 已排除 DMABUF 分支 `src_memory` 未传递导致的 NULL 解引用（已修复）。
- `sws_scale` 返回 `rc=720`，说明软件颜色空间转换本身成功。
- `qcom-iris-encoder` 在 `VIDIOC_REQBUFS` / `VIDIOC_QUERYBUF` 阶段把 NV12 源缓冲区作为一个连续 plane 返回，但 neatvnc 在 `VIDIOC_QBUF` 阶段只设置 `buffer.length = 1`，用单平面长度去描述双平面格式，导致内核写越界、堆损坏。

#### 11.2 修改内容

文件：`/home/weiz/Projects/neatvnc/src/enc/h264/v4l2m2m-impl.c`，函数 `encode_buffer_mmap()`。

当检测到 `packed_yuv`（NV12/NV21 只有一个 mmap plane）时：

- 不再把 `srcbuf->buffer.length` 设为 `1` 并合并 Y/UV size。
- 改为设置 `buffer.length = 2`，填充两个 V4L2 plane descriptor：
  - `planes[0]`：Y 平面，`bytesused = y_size`，`data_offset = 0`。
  - `planes[1]`：UV 平面，`bytesused = uv_size`，`data_offset = y_size`。
  - 两个 plane 共享同一个 `m.mem_offset`（来自 QUERYBUF 的连续缓冲区偏移），`length` 均为整个缓冲区大小。
- `sws_scale` 的 `dst_data[0]/dst_data[1]` 与 `dst_stride` 保持原有逻辑不变。
- `free_src_buffers()` 只 `munmap` 一次 `mmap_payload[0]`，不受影响。

新增调试日志：当 packed yuv 以双平面描述符 queue 时，打印 `total`、`y_size`、`uv_size`、`mem_offset`。

#### 11.3 源码与构建更新

- `neatvnc` 源码仓库：`/home/weiz/Projects/neatvnc`
  - 提交并推送到 `weihuoya/neatvnc:master`
  - 新提交：`c7d5bb7f77f4447f27777952929623a975739a6e`
- `rocknix` 源码仓库：`/home/weiz/Projects/rocknix-distribution-next`
  - 更新 `projects/ROCKNIX/packages/tools/neatvnc/package.mk` 的 `PKG_VERSION` 为 `c7d5bb7f77f4447f27777952929623a975739a6e`
  - 推送到 `weihuoya/rocknix:next`
- 触发 GitHub Actions workflow：

  ```bash
  gh workflow run build-aarch64-wayvnc-deps.yml -R weihuoya/rocknix --ref next
  ```

  Run URL: <https://github.com/weihuoya/rocknix/actions/runs/30647232770>

  构建产物：`wayvnc-deps-aarch64-SM8550.tar.zst`，上传到 `weihuoya/rocknix` 的 `wayvnc-aarch64-SM8550` release。

#### 11.4 验证日志与后续发现

在 `192.168.10.155` 上重新部署并连接 VNC 客户端后，日志显示：

- 编码器成功 probe：`v4l2m2m: H.264 probe OK on iris_driver`。
- H.264 编码被选中：`Choosing open-h264 encoding for client ...`。
- 第一次编码帧成功产出：`v4l2m2m: encoded frame (index 0) ... size 80875`。
- 崩溃仍发生在 `open_h264_handle_packet()` 中 `vec_append` 触发 `realloc` 时：

  ```text
  open-h264: handle_packet start size=80875 pts=18446744073709551615
  open-h264: handle_packet context=0x23e5cb10 self=0x23e5c8c0
  open-h264: handle_packet pending data=0x23e5cb60 len=0 cap=4096
  open-h264: handle_packet about to vec_append
  corrupted size vs. prev_size
  ```

- `context=0x23e5cb10` 与 `pending.data=0x23e5cb60` 只相隔 0x50 = 80 字节。`struct open_h264_context` 实际大小为 64 字节，其后的 16 字节正是 `pending.data` 堆块的 malloc 元数据。`corrupted size vs. prev_size` 说明 `context` 结构体末尾或该 malloc 元数据被越界写破坏。

- 同时发现 `uv_size` 计算有误：在 packed 单平面分支里调用了 `get_plane_size(..., self->height / 2, 1)`，而该函数内部对 plane 1 又会再 halve 一次 height，导致 UV `bytesused` 只有实际一半（2560×1440 下 `uv=921600` 而非正确的 1843200）。这会让 qcom-iris 拿到的 UV 长度不完整，可能触发驱动越界读写。

#### 11.5 第二次修改

- 修正 `uv_size` 计算：对 packed 单平面 NV12，把 `self->height / 2` 改为 `self->height`（因为 `get_plane_size` 内部已 halve）。
- 在 `process_dst_bufs()` 调用 `on_packet_ready` 前加 `malloc(16)/free` 堆健康检查日志，确认堆损坏是否发生在 V4L2 出队之后、回调之前。
- 在 `open_h264_handle_packet()` 中保留 `context` / `pending` 指针与字段日志。

提交 hash：`3c1e0c6ce4aa49f99c0e706b0e4a7141d0202f62`

- `neatvnc`：`weihuoya/neatvnc:master`
- `rocknix`：`weihuoya/rocknix:next`（commit `340a806427`）
- Workflow：<https://github.com/weihuoya/rocknix/actions/runs/30680671723>
- 产物：`wayvnc-deps-aarch64-SM8550.tar.zst`

#### 11.6 第三次部署后的新发现

下载 `3c1e0c6` 构建产物重新部署到 `192.168.10.155` 并连接 VNC 客户端后：

- `uv_size` 已修正：日志显示 `packed_yuv calc height=720 stride=1280 y_size=921600 uv_size=460800`（正确值）。
- 但崩溃点没有到达 `process_dst_bufs` 的堆健康检查，也没有到达 `open_h264_handle_packet`。
- 崩溃发生在第一次源缓冲区成功 queue 之后、屏幕捕获尝试分配 GBM buffer 时：

  ```text
  v4l2m2m: source buffer 0 queued
  DEBUG: ../src/ext-image-copy-capture.c: 355: Buffer dimensions: 512x512
  DEBUG: ../src/buffer.c: 639: Reconfiguring buffer pool
  ...
  DEBUG: ../src/buffer.c: 569: Using render node: /dev/dri/renderD128
  (wayvnc 进程消失，dmesg 显示 coredump 失败)
  ```

- 关键原因：当前部署的 `wayvnc` 二进制是 **7 月 30 日旧构建**，它基于旧版 `neatvnc` 编译，日志里的文件/行号（如 `../src/buffer.c:639`）与新版 `libneatvnc.so` 源码不匹配。旧二进制 + 新 `libneatvnc.so` 存在 ABI/结构体布局风险，导致 GBM buffer 捕获路径在 reconfiguration 阶段崩溃。
- 这与之前 `Symbol 'nvnc_version' has different size` 警告同源：必须同时重新构建 `wayvnc` 二进制。

#### 11.7 第三次修改：重建 wayvnc 二进制

触发 `build-aarch64-wayvnc.yml` workflow，使用当前 `weihuoya/wayvnc` 的 `master` 分支（commit `3423d09178721b4eab8ee38d760cc5a4f2fc7d58`）和最新的 `wayvnc-deps`：

```bash
gh workflow run build-aarch64-wayvnc.yml -R weihuoya/rocknix --ref next \
  -f wayvnc_repo=weihuoya/wayvnc \
  -f wayvnc_ref=3423d09178721b4eab8ee38d760cc5a4f2fc7d58
```

Workflow：<https://github.com/weihuoya/rocknix/actions/runs/30681232539>

产物：`wayvnc-v<version>-rocknix-sm8550.tar.gz`（上传到 `wayvnc-aarch64-SM8550` release）。

#### 11.8 待验证

下载新的 `wayvnc-deps-aarch64-SM8550.tar.zst` 和新的 `wayvnc-...-rocknix-sm8550.tar.gz` 后，一起重新部署到 `192.168.10.155`：

1. 按第 2.1 节重新准备 `wayvnc_deploy` 目录（这次要同时替换 `wayvnc`/`wayvncctl` 二进制和全部库）。
2. 上传并启动。
3. VNC 客户端连接，观察：
   - 是否不再在 `buffer.c: Reconfiguring buffer pool` 阶段崩溃。
   - 是否到达 `v4l2m2m: heap sanity ok before on_packet_ready`。
   - 如果到达堆健康检查且通过，再看 `open_h264_handle_packet` 是否还崩溃。
   - 如果 H.264 流能持续输出且 VNC 画面正常，则成功。

- 若仍崩溃，下一步需要检查 `context` 结构体相邻内存是否被 `h264_encoder_v4l2m2m` 内部数组或 GBM/捕获路径越界写，或者尝试把 `context->pending` 改在 `open_h264` 中分配而非与 `context` 相邻。

### 2026-08-01（b） 第四次修改：在 open_h264_handle_packet 开头释放并重置 pending vec

#### 11.9 问题现象

重建 `wayvnc` 二进制后，崩溃回到最初位置：

```text
open-h264: handle_packet start size=5474 pts=18446744073709551615
open-h264: handle_packet context=0xc46c7e0 self=0xc483780
open-h264: handle_packet pending data=0xc4931e0 len=0 cap=4096
open-h264: handle_packet about to vec_append
corrupted size vs. prev_size
```

关键发现：

- `v4l2m2m: heap sanity ok before on_packet_ready` 已经出现，说明在 V4L2 出队、调用回调之前，**通用堆是健康的**。
- `context`（0xc46c7e0）与 `pending.data`（0xc4931e0）相隔 154KB，不再相邻，因此之前的“`context` 越界写坏 `pending` 元数据”假设不成立。
- 崩溃精确发生在 `vec_append` 内部 `realloc(context->pending.data, 10948)` 时，说明 `pending.data` 指向的这块 malloc chunk 的元数据被破坏了。

#### 11.10 第四次修改

为定位是这块 chunk 本身被破坏，还是 `realloc` 机制有问题，在 `open_h264_handle_packet()` 调用 `vec_append` 之前主动：

1. 打印现有 `pending.data/len/cap`。
2. `free(context->pending.data)`。
3. 把 `pending.data` / `len` / `cap` 清零。

这样 `vec_append` 会走 `realloc(NULL, 10948)`，等价于一次全新 `malloc`。如果仍崩溃，说明是整个堆已被污染；如果通过，说明原先那块 chunk 在创建后、回调前被某个中间步骤写坏。

提交 hash：`fdbd6adf51a2efbe592fbad033ab028f9fc8efb6`

- `neatvnc`：`weihuoya/neatvnc:master`
- `rocknix`：`weihuoya/rocknix:next`（commit `f667cc7d9a`）
- Workflow：<https://github.com/weihuoya/rocknix/actions/runs/30681851364>
- 产物：`wayvnc-deps-aarch64-SM8550.tar.zst`

#### 11.11 待验证

下载新的 `wayvnc-deps-aarch64-SM8550.tar.zst` 并重新部署到 `192.168.10.155`（继续使用最新的 `wayvnc-3423d09-rocknix-sm8550.tar.gz` 二进制）：

1. 观察日志是否出现 `open-h264: handle_packet freeing pending data=...`。
2. 如果释放旧 chunk 成功且后续 `vec_append` 成功，则 H.264 编码流可能正常输出，说明原 chunk 被外部写坏（可能是 V4L2/GBM/捕获路径的越界写）。
3. 如果释放旧 chunk 就崩溃，说明元数据在 `free` 时已经损坏，需要进一步用 `MALLOC_CHECK_` 或其他工具定位。
4. 如果释放成功但 `malloc(10948)` 崩溃，说明整个堆空间被污染。
5. 若 H.264 流能持续输出，可视为临时绕过；长期仍需找出真正破坏 `pending` chunk 的代码。


### 2026-08-01（c） 第五次修改：用多尺寸堆检查 + 日志刷新定位破坏源

#### 11.12 问题现象

下载 `fdbd6ad` 构建产物并重新部署到 `192.168.10.155`（继续使用 `wayvnc-3423d09-rocknix-sm8550.tar.gz` 二进制，不带 `--gpu`）后：

- 第一次编码帧成功输出，H.264 数据大小约 5474 字节。
- 当 VNC 客户端触发屏幕尺寸从 1280×720 切换到 2560×1440 时，`open_h264_resize()` 需要重新创建 encoder。
- 崩溃出现在 `open_h264_resize before h264_encoder_create` 之后、`v4l2m2m_create` 的任何新日志之前：

  ```text
  DEBUG: ../src/enc/h264/open-h264.c: ...: heap-ok: open_h264_resize before h264_encoder_create
  corrupted double-linked list
  ```

关键发现：

- 此前的 `check_heap()` 只 `malloc(1048576)`。在 glibc 默认配置下，≥128KB 的分配很可能走 `mmap`，不会遍历主堆的 free list，因此无法检测主堆元数据损坏。
- 崩溃点在 `h264_encoder_v4l2m2m_create()` 早期（可能在 `calloc(sizeof(*self))` 时），说明主堆 free list 在进入该函数前已被破坏。
- 第一次编码帧完成后所有检查点都曾显示“ok”，但那只说明 mmap 路径没有异常，主堆可能在第一次编码期间或两次帧之间被破坏。
- 日志缓冲可能导致最后几条检查点没有 flush 到磁盘， crash 时丢失关键上下文。

#### 11.13 第五次修改

在 `/home/weiz/Projects/neatvnc` 中：

1. `src/enc/h264/open-h264.c` 与 `src/enc/h264/v4l2m2m-impl.c` 的 `check_heap()` 改为多尺寸分配：
   - 依次 `malloc(16)`、`malloc(256)`、`malloc(1024)`、`malloc(65536)`、`malloc(1048576)`。
   - 每个都 `memset` 后 `free`。
   - 任一尺寸失败都打印 `heap-broken: <where> size=<size>`，全部通过才打印 `heap-ok`。
   - 每次调用后 `fflush(stderr)`，确保崩溃前所有检查点都已落盘。
2. 在关键路径新增密集检查点：
   - `encode_buffer_mmap`：`sws_scale` 后、source frame unref 后、plane setup 后。
   - `encode_buffer`：encode 前后、`v4l2_qbuf` 前后。
   - `process_dst_bufs`：`on_packet_ready` 前后。
   - `v4l2m2m_feed`：entry、`process_src_bufs` 后、`encode_buffer` 后。
   - `open_h264_ctx_encode`：`h264_encoder_feed` 前后。
   - `open_h264_resize`：`h264_encoder_destroy` 前后。

> **构建修复**：第一次提交 `68608c8...` 因 `open-h264.c` 缺少 `<stdio.h>` 且引用了未定义的 `ARRAY_LENGTH` 宏而编译失败。已修正为 `#include <stdio.h>` 并使用 `sizeof(sizes)/sizeof(sizes[0])`。

这样下一次崩溃时，最后一条 `heap-ok` 与崩溃位置之间的区间就是堆破坏发生的精确范围。

提交 hash：`53b77d925ea22605f6942d92e854271e58082437`（修复 `ARRAY_LENGTH` 与 `<stdio.h>` 构建错误）

- `neatvnc`：`weihuoya/neatvnc:master`
- `rocknix`：`weihuoya/rocknix:next`（commit `2dfe3098fb`）
- Workflow：<https://github.com/weihuoya/rocknix/actions/runs/30687316264>
- 产物：`wayvnc-deps-aarch64-SM8550.tar.zst`

#### 11.14 待验证

下载新的 `wayvnc-deps-aarch64-SM8550.tar.zst` 并重新部署到 `192.168.10.155`（继续使用 `wayvnc-3423d09-rocknix-sm8550.tar.gz` 二进制，启动脚本不带 `--gpu`）：

1. 启动并连接 VNC 客户端，触发分辨率变化。
2. 观察日志中最后一条 `heap-ok:` 或 `v4l2m2m: heap-ok:` 出现在哪里。
3. 如果最后一条 `heap-ok` 出现在 `v4l2m2m_create after calloc` 之前，说明 `calloc` 本身检测到破坏，需继续向上追溯最后通过的检查点。
4. 如果最后一条 `heap-ok` 出现在 `encode_buffer after qbuf` 或 `process_dst_bufs after on_packet_ready` 之后，说明破坏发生在 V4L2 驱动写输出 buffer 或回调处理阶段。
5. 根据区间继续缩小范围，直到找到具体越界写或释放后使用的代码。


#### 11.15 第六次修改：扩展 check_heap 尺寸并添加 exact-size 探针

分析日志后发现：

- 第一次 H.264 帧（1280×720）完全成功，所有 `heap-ok` 检查点通过。
- 当屏幕捕获缓冲区分辨率从 1280×720 切到 1440×2560 后，VNC 客户端又请求 2560×1440 编码，触发 `open_h264_resize` → `h264_encoder_create`。
- 崩溃精确发生在 `v4l2m2m_create entry` 与 `v4l2m2m_create after calloc` 之间，即 `calloc(1, sizeof(struct h264_encoder_v4l2m2m))` 阶段，报 `corrupted double-linked list`。
- 设置 `MALLOC_CHECK_=3` 没有提供额外诊断，说明这是 glibc 自由链表元数据损坏，而非轻量检查能捕获的简单错误。
- 此前 `check_heap` 只测试了 16/256/1024/65536/1MB 几个离散尺寸，可能遗漏了 `struct h264_encoder_v4l2m2m` 所在的具体 size bin。

修改：

1. `open-h264.c` 和 `v4l2m2m-impl.c` 的 `check_heap()` 扩展为连续尺寸：16, 64, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576。
2. 在 `h264_encoder_v4l2m2m_create()` 的 `calloc` 之前增加 exact-size 探针：
   - `malloc(sizeof(struct h264_encoder_v4l2m2m))` → `memset` → `free`。
   - 打印 `v4l2m2m: heap-ok exact self_size=<N> before calloc` 或 `heap-broken`。
3. 部署脚本增加 `MALLOC_PERTURB_=0xA5` 与 `MALLOC_CHECK_=3`。

提交 hash：`03299f20a10e3e2a5afb33508c06c14c78b3af88`

- `neatvnc`：`weihuoya/neatvnc:master`
- `rocknix`：`weihuoya/rocknix:next`（commit `1fdba1dd21`）
- Workflow：<https://github.com/weihuoya/rocknix/actions/runs/30688267318>
- 产物：`wayvnc-deps-aarch64-SM8550.tar.zst`

#### 11.16 待验证

下载新的 `wayvnc-deps-aarch64-SM8550.tar.zst` 并重新部署到 `192.168.10.155`（继续使用 `wayvnc-3423d09-rocknix-sm8550.tar.gz` 二进制，启动脚本带 `MALLOC_CHECK_=3 MALLOC_PERTURB_=0xA5`）：

1. 观察 `v4l2m2m_create entry` 的 `check_heap` 是否报 `heap-broken size=<X>`。如果报，说明尺寸 `<X>` 的 size bin 在 resize 前已被破坏，需继续向上追溯是在 `process_dst_bufs after v4l2_qbuf` 之后还是 `open_h264_encode start` 之后被破坏。
2. 观察 `v4l2m2m: heap-ok exact self_size=<N> before calloc` 是否出现。如果出现，说明 `calloc` 本身对同一尺寸敏感，而 `malloc/free` 不敏感；如果未出现，则该尺寸 bin 已损坏。
3. 根据新日志进一步缩小堆破坏源：可能方向是 `wayvnc` 的 buffer pool 重配置（`ext-image-copy-capture.c` / `buffer.c`）在 1440×2560 重配置时释放/分配出错，或 `nvnc_frame` 生命周期管理有 bug。


#### 11.17 第七次修改：用 malloc+memset 替换 calloc 定位 alloc 行为差异

新日志关键发现：

```text
v4l2m2m: heap-ok exact self_size=1824 before calloc
corrupted double-linked list
```

- `v4l2m2m_create entry` 的 `check_heap()` 全部 15 个尺寸通过，说明离散 size bin 暂时健康。
- 在 `calloc(1, sizeof(struct h264_encoder_v4l2m2m))` 之前增加 exact-size `malloc(1824) + memset + free` 探针，结果通过。
- 但紧接着 `calloc(1, 1824)` 立刻崩溃，报 `corrupted double-linked list`。
- 这意味着：**同尺寸 `malloc`/`free` 路径不触发检测，而 `calloc` 在访问 1824 字节 free list 时检测到元数据损坏**。两者可能走了不同的 glibc 路径，或 `calloc` 额外做了合并/检查。

修改：

1. 在 `h264_encoder_v4l2m2m_create()` 中把 `calloc(1, sizeof(*self))` 临时替换为 `malloc(sizeof(*self))` + `memset(self, 0, sizeof(*self))`。
2. 在替换前执行 3 轮 `malloc(self_size) + memset + free` 探针，确认 `malloc/free` 路径稳定。

提交 hash：`4a1720a849aaaeba3555c7f95996cf2cace1726f`

- `neatvnc`：`weihuoya/neatvnc:master`
- `rocknix`：`weihuoya/rocknix:next`（commit `4eefd8be54`）
- Workflow：<https://github.com/weihuoya/rocknix/actions/runs/30688826100>
- 产物：`wayvnc-deps-aarch64-SM8550.tar.zst`

#### 11.18 待验证

下载新的 `wayvnc-deps-aarch64-SM8550.tar.zst` 并重新部署到 `192.168.10.155`：

1. 观察 `v4l2m2m_create entry` 的 3x `malloc/free` 探针是否全部通过。
2. 观察 `malloc+memset` 替换后是否能成功创建第二个 encoder（2560×1440）。
3. 如果成功创建第二个 encoder，继续观察 H.264 流是否能持续输出，或是否在新的位置崩溃。
4. 如果 `malloc+memset` 也崩溃，说明 1824 字节 free list 本身已被污染，需要检查 `wayvnc` 的 buffer pool 重配置或 `nvnc_frame` 生命周期。
5. 如果 `malloc+memset` 通过且 H.264 工作，说明 `calloc` 在 1824 字节路径上有特殊行为触发该损坏；长期仍需找到堆破坏源，避免后续出现静默错误。


#### 11.19 第八次修改：用 mmap 分配 encoder self 绕过堆损坏

最新日志发现：

```text
v4l2m2m: heap-ok exact self_size=1824 3x malloc/free before calloc
corrupted double-linked list
```

- 3 轮 `malloc(1824) + memset + free` 探针全部通过。
- 但紧随其后的 `malloc(1824)`（用于实际创建第二个 encoder）仍崩溃，报 `corrupted double-linked list`。
- 这说明 1824 字节 free list 确实存在元数据损坏，且 `malloc`/`free` 循环本身可能一步步把损坏放大，直到实际分配时触发检测；也可能第 4 次分配正好取到损坏节点。

修改：

1. 在 `h264_encoder_v4l2m2m_create()` 中，把 `struct h264_encoder_v4l2m2m* self` 的分配从堆分配改为 `mmap(..., sizeof(*self), PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0)`，然后 `memset` 清零。
2. 在创建失败的 `failure` 路径中，如果 `self` 已 mmap 成功，用 `munmap(self, sizeof(*self))` 释放。
3. 在 `h264_encoder_v4l2m2m_destroy()` 中，用 `munmap(self, sizeof(*self))` 替代 `free(self)`。

这样 encoder 的核心结构体不再占用 glibc 堆，而是独立匿名页，彻底避开 1824 字节 free list 损坏导致的崩溃。

提交 hash：`94b9c96d48a26c00db77267ce5f269e46083b0c5`

- `neatvnc`：`weihuoya/neatvnc:master`
- `rocknix`：`weihuoya/rocknix:next`（commit `6b4bd8971b`）
- Workflow：<https://github.com/weihuoya/rocknix/actions/runs/30690616407>
- 产物：`wayvnc-deps-aarch64-SM8550.tar.zst`

#### 11.20 待验证

下载新的 `wayvnc-deps-aarch64-SM8550.tar.zst` 并重新部署到 `192.168.10.155`：

1. 确认第二个 encoder（2560×1440）能成功创建，`v4l2m2m_create after mmap+memset` 检查点通过。
2. 继续观察 H.264 流是否能持续输出，VNC 画面是否正常。
3. 如果 H.264 工作，说明用 `mmap` 成功绕过堆损坏。但堆损坏的根本原因仍未定位；建议后续使用 `valgrind`、`ASAN` 或 `mprotect` 守卫页进一步追查 `wayvnc` buffer pool / `nvnc_frame` 生命周期中谁污染了 1824 字节 free list。
4. 如果在新的 `malloc` 位置（例如 `open_h264_context_new` 的 `calloc` 或 `vec_append` 的 `realloc`）再次崩溃，则堆损坏仍在影响其它结构体，需要继续扩大 `mmap` 隔离或追查破坏源。

## 12. qcom-iris 编码器控制与 H.264 画质（2026-08-03）

### 12.1 发现

在 `192.168.31.210` 上启用 H.264 后，VNC 可以连接，但画面明显模糊。日志显示编码帧很小：

```text
open-h264: creating encoder 2560x1440 format XB24 quality 18
...
open-h264: handle_packet start size=12477 pts=18446744073709551615
```

2560×1440 的 H.264 帧只有 ~12KB，说明编码器走的是低码率/高压缩路径。

### 12.2 控制接口

`qcom-iris` 驱动在 `VIDIOC_S_FMT` 之前**不暴露任何 V4L2 控制**。在设置输出格式（NV12）和捕获格式（H264）之后，驱动会枚举出标准 Codec 控制，包括：

| 控制项 | 默认值 | 说明 |
|---|---|---|
| `Video Bitrate Mode` | 0 (VBR) | 码率模式 |
| `Video Bitrate` | 20000000 (20 Mbps) | 目标码率 |
| `Video Peak Bitrate` | 20000000 (20 Mbps) | 峰值码率 |
| `Frame Level Rate Control Enable` | 1 | 帧级码率控制 |
| `Video GOP Size` | 59 | GOP 长度 |
| `H264 I-Frame QP Value` | 20 | I 帧 QP |
| `H264 P-Frame QP Value` | 20 | P 帧 QP |
| `H264 B-Frame QP Value` | 20 | B 帧 QP |
| `H264 Minimum QP Value` | 1 | 最小 QP |
| `H264 Maximum QP Value` | 51 | 最大 QP |
| `H264 Profile` | 4 (High) | H.264 profile |
| `H264 Level` | 14 | H.264 level |
| `H264 Entropy Mode` | 1 (CABAC) | 熵编码模式 |

### 12.3 关键问题

neatvnc 上游的 `v4l2m2m-impl.c` 只设置：

- `V4L2_CID_MPEG_VIDEO_H264_PROFILE`
- `V4L2_CID_MPEG_VIDEO_H264_I_PERIOD`
- `V4L2_CID_MPEG_VIDEO_BITRATE_MODE` = `CQ`
- `V4L2_CID_MPEG_VIDEO_CONSTANT_QUALITY` = quality

在 `qcom-iris` 上：

- `V4L2_CID_MPEG_VIDEO_CONSTANT_QUALITY` **不存在**，`VIDIOC_S_CTRL` 返回 `EINVAL`。
- `BITRATE_MODE` 只支持 `0=VBR` 和 `1=CBR`，不支持 `2=CQ`。

因此 neatvnc 的设置被驱动忽略，实际走的是默认 VBR 20Mbps + QP20，导致 H.264 画质差。

### 12.4 修改

在 `v4l2m2m-impl.c` 的 `h264_encoder_v4l2m2m_configure()` 中显式设置：

1. `BITRATE_MODE` = `CBR`
2. `BITRATE` = 50 Mbps
3. `FRAME_RC_ENABLE` = 1
4. `H264_MIN_QP` = 1
5. `H264_MAX_QP` = `quality`（由 open-h264 映射后的 QP）
6. `H264_I/P/B_FRAME_QP` = `quality`
7. 保留 `CONSTANT_QUALITY` 作为 fallback

提交：

- `neatvnc`：`weihuoya/neatvnc:master` 的 `087cfc7ec60402803fc13b222bf290d948be8ead`
- `rocknix`：`weihuoya/rocknix:next`（`projects/ROCKNIX/packages/tools/neatvnc/package.mk`）

### 12.5 验证与清理

#### 12.5.1 第一次构建（含调试代码）

触发 `build-aarch64-wayvnc-deps` 重新构建 `wayvnc-deps-aarch64-SM8550.tar.zst`：
<https://github.com/weihuoya/rocknix/actions/runs/30824553739>

构建成功，产物包含 `neatvnc` 的 `087cfc7ec60402803fc13b222bf290d948be8ead`（含画质修复，但保留了排查阶段加入的大量 `check_heap`、guard-page 和调试日志）。

#### 12.5.2 清理临时调试代码

在 `/home/weiz/Projects/neatvnc` 中清理：

- 删除 `open-h264.c` 和 `v4l2m2m-impl.c` 中的 `check_heap()` 及所有调用。
- 删除 `open-h264.c` 中为 `pending` 缓冲区分配的 guard-page（`posix_memalign` + `mprotect`）。
- 删除 `open_h264_handle_packet()` 中主动释放并重置 `pending` 的临时代码。
- 删除 `v4l2m2m-impl.c` 中 3 轮 exact-size `malloc/free` 探针。
- 把 `v4l2m2m` encoder `self` 的分配从 `mmap` 改回 `calloc`（`free` 释放）。
- 删除大量生命周期调试日志（保留设备扫描、probe 失败/成功、编码帧大小、S_CTRL 结果等关键日志）。

保留的功能性修复：

- NV12 CPU 回退（`libswscale`）。
- qcom-iris 控制设置：CBR 50 Mbps、Frame RC、H264 MIN/MAX/I/P/B QP。
- V4L2 缓冲区释放、多平面 DMABUF/MMAP 处理、packed NV12/NV21 双平面描述符。
- `server.c` 中的 `h264_encoder_v4l2m2m_probe` 和 `NVNC_BUFFER_SIMPLE` 支持。
- `meson.build` 中的 `libswscale` 依赖。

新提交：

- `neatvnc`：`weihuoya/neatvnc:master` 的 `0cc262e9b6571447bbc12639a23e2f9bf8d9c982`
- `rocknix`：`weihuoya/rocknix:next` 的 `b39f63db5f`（更新 `projects/ROCKNIX/packages/tools/neatvnc/package.mk`）

#### 12.5.3 第二次构建（干净版本）

触发新的 `build-aarch64-wayvnc-deps`：
<https://github.com/weihuoya/rocknix/actions/runs/30826138004>

待构建完成后，再触发 `build-aarch64-wayvnc.yml` 重新构建 `wayvnc-3423d09-rocknix-sm8550.tar.gz`（或更新的 wayvnc 提交），确保二进制与 `libneatvnc.so` 来自同一次构建，避免 ABI/符号大小不匹配。

#### 12.5.4 部署检查点

一起部署到 `192.168.31.210` 后，观察日志：

- `v4l2m2m: S_CTRL id=... value=... OK`
- `open-h264: creating encoder ... quality ...`
- `v4l2m2m: encoded frame (index ...) size ...`（2560×1440 应达到数十 KB 或更高，而不是 ~12KB）
- VNC 画面是否不再模糊。

如果新构建的二进制仍出现 `Symbol 'nvnc_version' has different size` 警告或崩溃，需要确认 `wayvnc` 二进制和 `wayvnc-deps` 是否来自同一 workflow/同一 `neatvnc` 提交。
