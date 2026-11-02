#!/bin/bash
# Install pinned marksman (Markdown LSP) into ~/.local/bin.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/versions.env"

BIN="${BIN:-$HOME/.local/bin}"
mkdir -p "$BIN"

case "$(uname -m)" in
    x86_64)  ARCH=x64;   SHA="$MARKSMAN_SHA256_X64" ;;
    aarch64) ARCH=arm64; SHA="$MARKSMAN_SHA256_ARM64" ;;
    *) echo "unsupported arch $(uname -m)"; exit 1 ;;
esac

DEST="$BIN/marksman"
if [ -f "$DEST" ] && echo "$SHA  $DEST" | sha256sum -c --quiet - 2>/dev/null; then
    echo "ok: marksman $MARKSMAN_VERSION"
else
    curl -fL -o "$DEST.tmp" \
         "https://github.com/artempyanykh/marksman/releases/download/$MARKSMAN_VERSION/marksman-linux-$ARCH"
    echo "$SHA  $DEST.tmp" | sha256sum -c -
    chmod +x "$DEST.tmp"
    mv "$DEST.tmp" "$DEST"
fi
