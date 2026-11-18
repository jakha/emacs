#!/bin/bash
# Install pinned buf (Protobuf LSP, formatter, linter) into ~/.local/bin.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/versions.env"

BIN="${BIN:-$HOME/.local/bin}"
mkdir -p "$BIN"

case "$(uname -m)" in
    x86_64)  ARCH=x86_64;  SHA="$BUF_SHA256_X86_64" ;;
    aarch64) ARCH=aarch64; SHA="$BUF_SHA256_AARCH64" ;;
    *) echo "unsupported arch $(uname -m)"; exit 1 ;;
esac

DEST="$BIN/buf"
if [ -f "$DEST" ] && echo "$SHA  $DEST" | sha256sum -c --quiet - 2>/dev/null; then
    echo "ok: buf $BUF_VERSION"
else
    curl -fL -o "$DEST.tmp" \
         "https://github.com/bufbuild/buf/releases/download/v$BUF_VERSION/buf-Linux-$ARCH"
    echo "$SHA  $DEST.tmp" | sha256sum -c -
    chmod +x "$DEST.tmp"
    mv "$DEST.tmp" "$DEST"
fi
