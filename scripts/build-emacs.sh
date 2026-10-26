#!/bin/bash
# Build pinned Emacs from the GNU release tarball into ~/.local.
# Skips the build when `emacs` on PATH already has the pinned version.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/versions.env"

PREFIX="${PREFIX:-$HOME/.local}"
BUILD_DIR="${BUILD_DIR:-$HOME/.cache/emacs-build}"

if command -v emacs >/dev/null &&
       emacs --version | head -1 | grep -q "GNU Emacs $EMACS_VERSION\$"; then
    echo "emacs $EMACS_VERSION already installed: $(command -v emacs)"
    exit 0
fi

sudo apt-get update
sudo apt-get install -y \
     build-essential pkg-config texinfo curl xz-utils \
     libgccjit-13-dev libtree-sitter-dev libgnutls28-dev libxml2-dev \
     libgtk-3-dev libcairo2-dev libharfbuzz-dev libxpm-dev libjpeg-dev \
     libpng-dev libgif-dev libtiff-dev librsvg2-dev libwebp-dev \
     libsqlite3-dev libncurses-dev libacl1-dev libgmp-dev libsystemd-dev

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

TARBALL="emacs-$EMACS_VERSION.tar.xz"
[ -f "$TARBALL" ] || curl -fL -o "$TARBALL" "https://ftp.gnu.org/gnu/emacs/$TARBALL"
echo "$EMACS_SHA256  $TARBALL" | sha256sum -c -

rm -rf "emacs-$EMACS_VERSION"
tar -xf "$TARBALL"
cd "emacs-$EMACS_VERSION"

./configure --prefix="$PREFIX" \
            --with-native-compilation=aot \
            --with-tree-sitter \
            --with-x-toolkit=gtk3 \
            --with-cairo \
            --with-modules
make -j"$(nproc)"
make install

echo "installed $("$PREFIX/bin/emacs" --version | head -1) to $PREFIX"
