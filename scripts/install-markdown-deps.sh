#!/bin/bash
# Install pinned marksman (Markdown LSP) and pandoc (preview) into ~/.local/bin.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/versions.env"

BIN="${BIN:-$HOME/.local/bin}"
mkdir -p "$BIN"

case "$(uname -m)" in
    x86_64)  ARCH=x64;   SHA="$MARKSMAN_SHA256_X64";   PANDOC_ARCH=amd64; PANDOC_SHA256="$PANDOC_SHA256_AMD64" ;;
    aarch64) ARCH=arm64; SHA="$MARKSMAN_SHA256_ARM64"; PANDOC_ARCH=arm64; PANDOC_SHA256="$PANDOC_SHA256_ARM64" ;;
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

if [ -x "$BIN/pandoc" ] && [ "$("$BIN/pandoc" --version | head -1)" = "pandoc $PANDOC_VERSION" ]; then
    echo "ok: pandoc $PANDOC_VERSION"
else
    CACHE="$HOME/.cache/markdown-ide"
    mkdir -p "$CACHE"
    TARBALL="$CACHE/pandoc-$PANDOC_VERSION-linux-$PANDOC_ARCH.tar.gz"
    [ -f "$TARBALL" ] || curl -fL -o "$TARBALL" \
        "https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux-$PANDOC_ARCH.tar.gz"
    echo "$PANDOC_SHA256  $TARBALL" | sha256sum -c -
    tar -xzf "$TARBALL" -C "$BIN" --strip-components=2 "pandoc-$PANDOC_VERSION/bin/pandoc"
fi
