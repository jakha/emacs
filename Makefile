# Reproducible PHP IDE build. Versions are pinned in versions.env and
# languages/php/php-ide-lock.el.
#
#   make php-ide     build everything (idempotent)
#   make php-check   verify the installation

include versions.env

export PATH := $(HOME)/.local/bin:$(PATH)

EMACS_BATCH = emacs --batch --init-directory=$(CURDIR) -l languages/php/install.el

.PHONY: php-ide emacs php-deps php-elisp php-check

php-ide: emacs php-deps php-elisp php-check

emacs:
	./scripts/build-emacs.sh

php-deps:
	./scripts/install-php-deps.sh

php-elisp:
	$(EMACS_BATCH) -f php-ide-install

php-check:
	emacs --version | head -1 | grep -q 'GNU Emacs $(EMACS_VERSION)$$'
	phpantom_lsp --version | grep -q '$(PHPANTOM_VERSION)'
	php -v | head -1
	composer -V
	phpstan --version
	phpcs --version
	$(EMACS_BATCH) -f php-ide-verify
