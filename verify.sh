#!/bin/sh
# Rebuild UID 164's compiled kernels from the sources in this folder and compare them with the files in the committed
# image (layers 15 and 16 hold every kernel file; layer 15's copies equal layer 16's).
# usage: ./verify.sh <nvcc 13.4>      needs: crane, tar, sha256sum, docker (for ftokc.so: ubuntu:24.04 gcc 13.3)
set -e
NVCC134=${1:?path to nvcc 13.4}
HERE=$(cd "$(dirname "$0")" && pwd)
IMG=ghcr.io/johnkell9801-hub/s1eng
REF=$IMG@sha256:944fa7aee414607c4b620de5600224fb7b844f0f9d844031b07f591b8b7455f7
W=$(mktemp -d)
layer() {  # layer <n> <digest>: unpack one layer's /opt/s1eng/s1eng into $W/L<n>
  mkdir -p "$W/L$1"; crane blob "$IMG@$2" | tar -xz -C "$W/L$1" opt/s1eng/s1eng 2>/dev/null || true
}
layer 15 sha256:82de8a5ae5b0754e737278d2c1cd7b215355d18146680a425e006dd4a518ae40
layer 16 sha256:e93f8ea1c2f81414479e9cfe0a7f0c17c15ab25cdff72fdb8964b7dca183847a
mkdir -p "$W/b" && cd "$W/b" && cp "$HERE"/*.cu "$HERE"/*.c "$HERE"/*.h .
build() {  # build <nvcc> <log> <args...>
  nv=$1; log=$2; shift 2
  if ! "$nv" "$@" > "$log" 2>&1; then echo "build failed: $nv $*"; tail -20 "$log"; exit 1; fi
}
build_onorm() {  # onorm.cubin: byte-identical only from /opt/s1eng/s1eng/onorm.cu (path CRC in an internal symbol)
  if mkdir -p /opt/s1eng/s1eng 2>/dev/null && [ -w /opt/s1eng/s1eng ] && [ ! -e /opt/s1eng/s1eng/onorm.cu ]; then
    cp "$HERE"/*.cu "$HERE"/*.h /opt/s1eng/s1eng/ && (cd /opt/s1eng/s1eng && "$1" $2 > /dev/null 2>&1) &&
      cp /opt/s1eng/s1eng/onorm.cubin "$W/b/onorm.cubin" && rm -f /opt/s1eng/s1eng/*.cu /opt/s1eng/s1eng/*.h /opt/s1eng/s1eng/onorm.cubin
  else
    echo "(onorm.cubin: /opt/s1eng/s1eng not usable here; built in place, only .strtab / symbol tables may differ)"
    "$1" $2 > onorm.log 2>&1
  fi
}
build_gcc() {  # ftokc.so with Ubuntu 24.04's gcc 13.3
  docker run --rm -v "$W/b:/w" -w /w ubuntu:24.04 sh -c "apt-get update -qq >/dev/null && apt-get install -y -qq gcc >/dev/null 2>&1 && $1"
}
check() {  # check <name>: the rebuilt file against layer 16 (and layer 15 where it exists)
  a=$(sha256sum "$1" | cut -d' ' -f1)
  for n in 16 15; do
    f="$W/L$n/opt/s1eng/s1eng/$1"; [ -f "$f" ] || continue
    b=$(sha256sum "$f" | cut -d' ' -f1)
    if [ "$a" = "$b" ]; then echo "layer $n $1: byte-identical ($a)"; else echo "layer $n $1: DIFFERS (rebuilt $a, image $b)"; fi
  done
}
build "$NVCC134" ngemm5.cubin.log -arch=sm_120a -O3 -cubin -o ngemm5.cubin ngemm5.cu
build "$NVCC134" ngemm9b.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -o ngemm9b.cubin ngemm9b.cu
build "$NVCC134" ngemm9t.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -o ngemm9t.cubin ngemm9t.cu
build "$NVCC134" ngemm9l.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -o ngemm9l.cubin ngemm9l.cu
build "$NVCC134" ngr.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -o ngr.cubin ngr.cu
build "$NVCC134" xa.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -o xa.cubin xa.cu
build "$NVCC134" kkt2n.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -o kkt2n.cubin kkt2n.cu
build "$NVCC134" ffs.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -o ffs.cubin ffs.cu
build "$NVCC134" pron.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -DPRON_SHIP -o pron.cubin pron.cu
build_onorm "$NVCC134" '-O3 -arch=sm_120a -cubin -std=c++17 -Xptxas -v -DFFS_SHIP -DONORM_V=5 -DONORM_PF2 -DONORM_SILU_FIN -DONORM_FINROLL -o onorm.cubin onorm.cu'
build "$NVCC134" kf.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -o kf.cubin kf.cu
build "$NVCC134" skx6.cubin.log -arch=sm_120a -O3 -cubin -Xptxas -v -o skx6.cubin skx6.cu
build "$NVCC134" skx6t.cubin.log -arch=sm_120a -O3 -cubin -Xptxas -v -o skx6t.cubin skx6t.cu
build "$NVCC134" rn.cubin.log -cubin -arch=sm_120a -O3 -fmad=false -Xptxas -v -o rn.cubin rn.cu
build "$NVCC134" ngemm7.cubin.log -cubin -O3 -std=c++17 -arch=sm_120a -o ngemm7.cubin ngemm7.cu
build "$NVCC134" kfx.cubin.log -arch=sm_120a -O3 -cubin -Xptxas -v -o kfx.cubin kfx.cu
build "$NVCC134" zcin.cubin.log -cubin -arch=sm_120a -O3 -Xptxas -v -o zcin.cubin zcin.cu
build "$NVCC134" xa3.cubin.log -O3 -arch=sm_120a -cubin -Xptxas -v -o xa3.cubin xa3.cu
build_gcc 'gcc -O2 -fPIC -shared -nostdlib -ffreestanding -fno-builtin -o ftokc.so ftokc.c'
check ngemm5.cubin
check ngemm9b.cubin
check ngemm9t.cubin
check ngemm9l.cubin
check ngr.cubin
check xa.cubin
check kkt2n.cubin
check ffs.cubin
check pron.cubin
check onorm.cubin
check kf.cubin
check skx6.cubin
check skx6t.cubin
check rn.cubin
check ngemm7.cubin
check kfx.cubin
check zcin.cubin
check xa3.cubin
check ftokc.so
echo "image: $REF"
rm -rf "$W"
