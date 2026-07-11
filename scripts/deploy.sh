#!/usr/bin/env bash
# Copy the built module onto the Move. Requires ssh access
# (ableton@move.local, same as schwung's installer). Run scripts/build.sh
# first. After deploying, rescan modules from the schwung UI (or restart
# Move) so the host picks it up.
set -euo pipefail
cd "$(dirname "$0")/.."

HOST="${MOVE_HOST:-ableton@move.local}"
DEST=/data/UserData/schwung/modules

[ -f build/modules/audio_fx/filltron/filltron.so ] || { echo "run scripts/build.sh first"; exit 1; }

ssh "$HOST" "mkdir -p $DEST/audio_fx"
scp -r build/modules/audio_fx/filltron "$HOST:$DEST/audio_fx/"
echo "Deployed to $HOST:$DEST — rescan modules or restart Move."
