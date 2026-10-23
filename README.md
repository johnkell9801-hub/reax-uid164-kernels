# Kernel sources of the REAX s1-fast engine committed on SN92 UID 164

Entry: UID 164, hotkey `5G1b2xwMVqb6kUfk6xsniqtTfFZKzQwMAPU4oVsBxy4RxQj3`, competition element
`reax-eng/1:s1-fast:ghcr.io/johnkell9801-hub/s1eng@sha256:944fa7aee414607c4b620de5600224fb7b844f0f9d844031b07f591b8b7455f7`.

Every compiled part the image ships is in `/opt/s1eng/s1eng/` (19 files: 18 CUDA cubins and one host library). Each one
rebuilds **byte for byte** from the sources in this folder with the build line below, run in `/opt/s1eng/s1eng`. The image
also ships each source next to its binary, and `/opt/s1eng/s1eng/KERNELS.md` holds the same table.

Layers: the kernel files sit in two layers of the image, layer 15 (`82de8a5ae5b0…`) and layer 16 (`e93f8ea1c2f8…`). Every file
in layer 15 is byte-identical to its copy in layer 16; `xa3.cu` / `xa3.cubin` and `ftokc.c` / `ftokc.so` are only in
layer 16. There are no older shadowed binaries.

| binary (layers) | sha256 | source in this folder (sha256) | build line | toolkit | author |
|---|---|---|---|---|---|
| `ngemm5.cubin` (15, 16 (identical)) | `7e7775b0f52bf73c5848d5d0016070663ec1c0581389b48d06bb2a4d29585b94` | `ngemm5.cu` (`1d6410833144ece2…`) | `nvcc -arch=sm_120a -O3 -cubin -o ngemm5.cubin ngemm5.cu` | CUDA 13.4 (`V13.4.92`) | rgh |
| `ngemm9b.cubin` (15, 16 (identical)) | `f097e26cfa1064f3e784ce0bb6bf79263491761933f4cd9d9f1ec9ef67545937` | `ngemm9b.cu` (`fc4e85d600ed8cae…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -o ngemm9b.cubin ngemm9b.cu` | CUDA 13.4 (`V13.4.92`) | rgh |
| `ngemm9t.cubin` (15, 16 (identical)) | `111b70b04ac63f4c12f82145d45a1ae64bafb3c5f812fd3dae4b195b08e7f70d` | `ngemm9t.cu` (`a2f47b5a440b1f99…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -o ngemm9t.cubin ngemm9t.cu` | CUDA 13.4 (`V13.4.92`) | rgh |
| `ngemm9l.cubin` (15, 16 (identical)) | `f35d8d2a2d44d01a0de8154adeaac94651035aaf83aaf04e021f048d37b57e88` | `ngemm9l.cu` (`27a5d2f0eed18ec7…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -o ngemm9l.cubin ngemm9l.cu` | CUDA 13.4 (`V13.4.92`) | rgh |
| `ngr.cubin` (15, 16 (identical)) | `15dc8936691b884e1364a5c57f64470e354bc59c6c64c1244307fcf614f8e889` | `ngr.cu` (`fe6934567dcea3a7…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -o ngr.cubin ngr.cu` | CUDA 13.4 (`V13.4.92`) | rgh |
| `xa.cubin` (15, 16 (identical)) | `8d119f6b271de9ccf86d58b99b5a37299cc9460b1c247f4a74e70bd8154762aa` | `xa.cu` (`231ea2f7bfd427b1…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -o xa.cubin xa.cu` | CUDA 13.4 (`V13.4.92`) | rgh |
| `kkt2n.cubin` (15, 16 (identical)) | `fd5b50c85669d3f106d3415523b62651bf5e6ace69cb0531404059ba87000c3a` | `kkt2n.cu` (`05f7c62710f2e8ba…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -o kkt2n.cubin kkt2n.cu` | CUDA 13.4 (`V13.4.92`) | rgh |
| `ffs.cubin` (15, 16 (identical)) | `3c739cd2bfef61f8199601b4122dd4cda971c90015a4165284c696dea250c8f2` | `ffs.cu` (`724abb42dcca68d9…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -o ffs.cubin ffs.cu` | CUDA 13.4 (`V13.4.92`) | rgh |
| `pron.cubin` (15, 16 (identical)) | `f34ec4fb457a129b920928ea3355e689cd739a77d94b75e6236da5e053a34429` | `pron.cu` (`8bfa8dd5f059d4f9…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -DPRON_SHIP -o pron.cubin pron.cu` | CUDA 13.4 (`V13.4.92`) | rgh |
| `onorm.cubin` (15, 16 (identical)) | `e1188ab018788db45f5630f2c8fb7dee62c120a86f8aea072846efecedf86b8c` | `onorm.cu` (`ec42b12a08a1278d…`) | `nvcc -O3 -arch=sm_120a -cubin -std=c++17 -Xptxas -v -DFFS_SHIP -DONORM_V=5 -DONORM_PF2 -DONORM_SILU_FIN -DONORM_FINROLL -o onorm.cubin onorm.cu` | CUDA 13.4 (`V13.4.92`) | rgh (source onorm_v17.cu) |
| `kf.cubin` (15, 16 (identical)) | `63117c351394d8e3bf6635bde4fffbe9e5e6aff03d2aa682eeee05b102608a0c` | `kf.cu` (`57d67f979cc642c9…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -o kf.cubin kf.cu` | CUDA 13.4 (`V13.4.92`) | ruj (the `KF_NO_KERNELS` guard and the `late` hook in `kf.cu`: kai) |
| `skx6.cubin` (15, 16 (identical)) | `d5e3b11dbf53e0b5fa08bbd633d685f64e63738fdb00cd7777dd54176b83caf5` | `skx6.cu` (`4f0e74d32b6ebabf…`) | `nvcc -arch=sm_120a -O3 -cubin -Xptxas -v -o skx6.cubin skx6.cu` | CUDA 13.4 (`V13.4.92`) | ruj |
| `skx6t.cubin` (15, 16 (identical)) | `017ca4f7f600affcd2cfb3659c98ccb26ca04e3f65993f491e57dc9cd349ca75` | `skx6t.cu` (`d64594a7372f2c39…`) | `nvcc -arch=sm_120a -O3 -cubin -Xptxas -v -o skx6t.cubin skx6t.cu` | CUDA 13.4 (`V13.4.92`) | ruj |
| `rn.cubin` (15, 16 (identical)) | `88247357dccfa88bd1d7c10eac47e3eb7e079e10498b30daacc3c5987b467487` | `rn.cu` (`8c00eac6f0c4170d…`) | `nvcc -cubin -arch=sm_120a -O3 -fmad=false -Xptxas -v -o rn.cubin rn.cu` | CUDA 13.4 (`V13.4.92`) | ruj |
| `ngemm7.cubin` (15, 16 (identical)) | `8671e9a9bec1573a9c5ffe94d4ace7475f38509a77e9cec346ccee79246a827f` | `ngemm7.cu` (`7beab23127aed1c6…`) | `nvcc -cubin -O3 -std=c++17 -arch=sm_120a -o ngemm7.cubin ngemm7.cu` | CUDA 13.4 (`V13.4.92`) | pjs (nsw7l, ported by rgh) |
| `kfx.cubin` (15, 16 (identical)) | `8ed921f761f1632bf08a4637b4c018fe059964cf468e8303d1899dec41c992fb` | `kfx.cu` (`9e19d55a175d510f…`) | `nvcc -arch=sm_120a -O3 -cubin -Xptxas -v -o kfx.cubin kfx.cu` | CUDA 13.4 (`V13.4.92`) | kai (instantiates ruj's KF tile; includes `kf.cu` and `kfx_map.h`) |
| `zcin.cubin` (15, 16 (identical)) | `f2ea51229214c944e873777b2f34812b3a6ef343686674564927331a98793133` | `zcin.cu` (`3e94fa1acd1e5695…`) | `nvcc -cubin -arch=sm_120a -O3 -Xptxas -v -o zcin.cubin zcin.cu` | CUDA 13.4 (`V13.4.92`) | kai |
| `xa3.cubin` (16) | `31cd78d9e28dc0ced0ae3f8283fe3ad2d8604bd5b5af159f220b9e903c612032` | `xa3.cu` (`bf836985bd3af8c7…`) | `nvcc -O3 -arch=sm_120a -cubin -Xptxas -v -o xa3.cubin xa3.cu` | CUDA 13.4 (`V13.4.92`) | kai |
| `ftokc.so` (16) | `2b34d5b4b7b56dfbe38fa57be16ac1005da54b1b64ce886cdb02bc0ea0e224dc` | `ftokc.c` (`1fe352dc6cf51083…`) | `gcc -O2 -fPIC -shared -nostdlib -ffreestanding -fno-builtin -o ftokc.so ftokc.c` | gcc 13.3.0 (Ubuntu 24.04) | kai |

Every other engine file in the image is Python source. The lower layers are the official reference-runtime base layers.

## Notes

* `-Xptxas -v` matters where a build line has it: ptxas writes its own command line into the cubin's `.note.nv.tkinfo`.
* `onorm.cubin`: `onorm.cu` has a device function in an anonymous namespace, whose internal name includes the CRC32 of the
  source's absolute path, so it is byte-identical only when built from `/opt/s1eng/s1eng/onorm.cu`. Built elsewhere, only the
  string table (`.strtab`) and the two symbol tables that point into it differ; every code section is equal.
* `ftokc.so` is freestanding (no libc, no NEEDED entry) and built with Ubuntu 24.04's gcc 13.3.0.
* `kfx.cu` includes `kf.cu` and `kfx_map.h`, so those three files belong together.

## How to check

`verify.sh` unpacks the two kernel layers from the committed image (`crane`), rebuilds every binary from the sources here and
compares the sha256:

```
./verify.sh <path to nvcc 13.4>
```

It builds `onorm.cubin` at `/opt/s1eng/s1eng` when that directory can be created (otherwise it compares every section except
the path-dependent string and symbol tables), and `ftokc.so` inside `ubuntu:24.04` (docker) for gcc 13.3.

## Authors

The engine is the team's work: rgh, ruj, kai and pjs (per binary in the table above).

## Licence

See `LICENSE` (MIT).
