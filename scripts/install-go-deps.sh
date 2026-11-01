#!/bin/bash
# Install Go toolchain for the Emacs Go IDE:
# pinned Go into ~/.local/go (go, gofmt linked into ~/.local/bin),
# pinned gopls built with that Go into ~/.local/bin.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/versions.env"

PREFIX="${PREFIX:-$HOME/.local}"
BIN="$PREFIX/bin"
GOROOT_DIR="$PREFIX/go"
mkdir -p "$BIN"

case "$(uname -m)" in
    x86_64)  ARCH=amd64; GO_SHA256="$GO_SHA256_AMD64" ;;
    aarch64) ARCH=arm64; GO_SHA256="$GO_SHA256_ARM64" ;;
    *) echo "unsupported arch $(uname -m)"; exit 1 ;;
esac

if [ -x "$GOROOT_DIR/bin/go" ] && [ "$("$GOROOT_DIR/bin/go" env GOVERSION)" = "go$GO_VERSION" ]; then
    echo "ok: go $GO_VERSION"
else
    CACHE="$HOME/.cache/go-ide"
    mkdir -p "$CACHE"
    TARBALL="$CACHE/go$GO_VERSION.linux-$ARCH.tar.gz"
    [ -f "$TARBALL" ] || curl -fL -o "$TARBALL" "https://go.dev/dl/go$GO_VERSION.linux-$ARCH.tar.gz"
    echo "$GO_SHA256  $TARBALL" | sha256sum -c -
    rm -rf "$GOROOT_DIR"
    tar -xzf "$TARBALL" -C "$PREFIX"
fi
ln -sf "$GOROOT_DIR/bin/go" "$BIN/go"
ln -sf "$GOROOT_DIR/bin/gofmt" "$BIN/gofmt"

# gopls: module checksums are verified by the Go checksum database
if [ -x "$BIN/gopls" ] && "$BIN/gopls" version | grep -q "v$GOPLS_VERSION\$"; then
    echo "ok: gopls $GOPLS_VERSION"
else
    GOTOOLCHAIN=local GOBIN="$BIN" "$GOROOT_DIR/bin/go" install "golang.org/x/tools/gopls@v$GOPLS_VERSION"
fi

case ":$PATH:" in
    *":$BIN:"*) ;;
    *) echo "WARNING: $BIN is not on PATH, add it in ~/.profile" ;;
esac
