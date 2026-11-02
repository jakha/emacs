#!/bin/bash
# Install pinned yaml-language-server for the Emacs YAML IDE:
# a private Node into ~/.local/share/yaml-ide/node (not put on PATH),
# the server from languages/yaml/package-lock.json via `npm ci`,
# and a ~/.local/bin/yaml-language-server wrapper that runs it with that Node.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/versions.env"

PREFIX="${PREFIX:-$HOME/.local}"
BIN="$PREFIX/bin"
HOME_DIR="$PREFIX/share/yaml-ide"
NODE_DIR="$HOME_DIR/node"
mkdir -p "$BIN" "$HOME_DIR"

case "$(uname -m)" in
    x86_64)  ARCH=x64;   NODE_SHA256="$NODE_SHA256_X64" ;;
    aarch64) ARCH=arm64; NODE_SHA256="$NODE_SHA256_ARM64" ;;
    *) echo "unsupported arch $(uname -m)"; exit 1 ;;
esac

if [ -x "$NODE_DIR/bin/node" ] && [ "$("$NODE_DIR/bin/node" --version)" = "v$NODE_VERSION" ]; then
    echo "ok: node $NODE_VERSION"
else
    CACHE="$HOME/.cache/yaml-ide"
    mkdir -p "$CACHE"
    TARBALL="$CACHE/node-v$NODE_VERSION-linux-$ARCH.tar.xz"
    [ -f "$TARBALL" ] || curl -fL -o "$TARBALL" \
        "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz"
    echo "$NODE_SHA256  $TARBALL" | sha256sum -c -
    rm -rf "$NODE_DIR"
    mkdir -p "$NODE_DIR"
    tar -xJf "$TARBALL" -C "$NODE_DIR" --strip-components=1
fi

# npm ci checks every package against the integrity hashes in the lock file
if cmp -s "$ROOT/languages/yaml/package-lock.json" "$HOME_DIR/package-lock.json" \
        && [ -d "$HOME_DIR/node_modules/yaml-language-server" ]; then
    echo "ok: yaml-language-server $YAML_LS_VERSION"
else
    cp "$ROOT/languages/yaml/package.json" "$ROOT/languages/yaml/package-lock.json" "$HOME_DIR/"
    (cd "$HOME_DIR" && PATH="$NODE_DIR/bin:$PATH" \
         npm ci --omit=dev --ignore-scripts --no-audit --no-fund)
fi

cat > "$BIN/yaml-language-server" <<WRAPPER
#!/bin/sh
exec "$NODE_DIR/bin/node" "$HOME_DIR/node_modules/yaml-language-server/bin/yaml-language-server" "\$@"
WRAPPER
chmod +x "$BIN/yaml-language-server"
