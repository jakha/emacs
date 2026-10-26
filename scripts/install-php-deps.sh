#!/bin/bash
# Install PHP toolchain for the Emacs PHP IDE:
# php-cli + composer from apt, pinned phpantom_lsp / phpstan / phpcs into ~/.local/bin,
# and the global phpantom config.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/versions.env"

BIN="${BIN:-$HOME/.local/bin}"
mkdir -p "$BIN"

sudo apt-get update
sudo apt-get install -y curl php-cli php-xml php-mbstring php-curl php-zip unzip composer

# fetch URL DEST SHA256 -- download and verify, skip when DEST already matches
fetch () {
    local url="$1" dest="$2" sha="$3"
    if [ -f "$dest" ] && echo "$sha  $dest" | sha256sum -c --quiet - 2>/dev/null; then
        echo "ok: $dest"
        return
    fi
    curl -fL -o "$dest.tmp" "$url"
    echo "$sha  $dest.tmp" | sha256sum -c -
    mv "$dest.tmp" "$dest"
}

# phpantom_lsp: verify the archive, keep it to make re-runs idempotent
case "$(uname -m)" in
    x86_64)  ARCH=x86_64;  PHPANTOM_SHA256="$PHPANTOM_SHA256_X86_64" ;;
    aarch64) ARCH=aarch64; PHPANTOM_SHA256="$PHPANTOM_SHA256_AARCH64" ;;
    *) echo "unsupported arch $(uname -m)"; exit 1 ;;
esac
CACHE="$HOME/.cache/php-ide"
mkdir -p "$CACHE"
ARCHIVE="$CACHE/phpantom_lsp-$PHPANTOM_VERSION-$ARCH.tar.gz"
fetch "https://github.com/PHPantom-dev/phpantom_lsp/releases/download/$PHPANTOM_VERSION/phpantom_lsp-$ARCH-unknown-linux-gnu.tar.gz" \
      "$ARCHIVE" "$PHPANTOM_SHA256"
tar -xzf "$ARCHIVE" -C "$BIN" phpantom_lsp
chmod +x "$BIN/phpantom_lsp"

fetch "https://github.com/phpstan/phpstan/releases/download/$PHPSTAN_VERSION/phpstan.phar" \
      "$BIN/phpstan" "$PHPSTAN_SHA256"
fetch "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/$PHPCS_VERSION/phpcs.phar" \
      "$BIN/phpcs" "$PHPCS_SHA256"
fetch "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/$PHPCS_VERSION/phpcbf.phar" \
      "$BIN/phpcbf" "$PHPCBF_SHA256"
chmod +x "$BIN/phpstan" "$BIN/phpcs" "$BIN/phpcbf"

CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/phpantom_lsp"
mkdir -p "$CONF_DIR"
cp "$ROOT/languages/php/phpantom.toml" "$CONF_DIR/.phpantom.toml"
echo "wrote $CONF_DIR/.phpantom.toml"

case ":$PATH:" in
    *":$BIN:"*) ;;
    *) echo "WARNING: $BIN is not on PATH, add it in ~/.profile" ;;
esac
