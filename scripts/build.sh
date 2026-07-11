#!/usr/bin/env bash
# Cross-compile Filltron for the Ableton Move (aarch64 Linux) via Docker,
# mirroring schwung's own toolchain (debian:bookworm + gcc-aarch64-linux-gnu)
# so the .so links against the same glibc as the rest of the ecosystem.
#
# Outputs:
#   build/modules/audio_fx/filltron/filltron.so + module.json  (chain + master FX)
#   build/filltron-module.tar.gz
set -euo pipefail
cd "$(dirname "$0")/.."

IMAGE=filltron-build
CFLAGS="-O3 -g -shared -fPIC -Wall -Wextra -Iinclude"

if ! docker image inspect "$IMAGE" &>/dev/null; then
    docker build -t "$IMAGE" - <<'EOF'
FROM debian:bookworm
RUN apt-get update && apt-get install -y gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu file && rm -rf /var/lib/apt/lists/*
EOF
fi

mkdir -p build/modules/audio_fx/filltron
cp modules/audio_fx/filltron/module.json src/ui_chain.js build/modules/audio_fx/filltron/
cp src/help.json build/modules/audio_fx/filltron/help.json

# Compile AND tar inside the container: macOS bsdtar embeds AppleDouble
# (._*) xattr entries that Linux tar extracts as real files — the schwung
# installer then reads entries[0] = "._filltron" and fails with "No
# module.json found in tarball". GNU tar in the container is clean.
docker run --rm -v "$PWD":/w -w /w "$IMAGE" bash -c "
    set -e
    aarch64-linux-gnu-gcc $CFLAGS src/smack_core.c src/smack_fx.c \
        -o build/modules/audio_fx/filltron/filltron.so -lm
    file build/modules/audio_fx/filltron/filltron.so
    tar --owner=0 --group=0 -czf build/filltron-module.tar.gz -C build/modules/audio_fx filltron
    echo 'tarball contents:'
    tar -tzf build/filltron-module.tar.gz
"

echo "Built: build/filltron-module.tar.gz"
