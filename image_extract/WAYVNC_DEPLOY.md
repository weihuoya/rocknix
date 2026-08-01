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
