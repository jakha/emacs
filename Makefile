# Reproducible language IDE builds. Versions are pinned in versions.env and
# languages/ide/ide-lock.el.
#
#   make php-ide     build the PHP IDE (idempotent)
#   make go-ide      build the Go IDE (idempotent)
#   make ide         build all IDEs
#   make php-check / go-check   verify an installation

include versions.env

export PATH := $(HOME)/.local/bin:$(PATH)

EMACS_BATCH = emacs --batch --init-directory=$(CURDIR) -l languages/ide/install.el

.PHONY: ide php-ide go-ide emacs php-deps go-deps php-elisp go-elisp ide-elisp \
        emacs-check php-check go-check

ide: php-ide go-ide

php-ide: emacs php-deps php-elisp php-check

go-ide: emacs go-deps go-elisp go-check

emacs:
	./scripts/build-emacs.sh

php-deps:
	./scripts/install-php-deps.sh

go-deps:
	./scripts/install-go-deps.sh

php-elisp:
	$(EMACS_BATCH) -f ide-install php

go-elisp:
	$(EMACS_BATCH) -f ide-install go

ide-elisp:
	$(EMACS_BATCH) -f ide-install

emacs-check:
	emacs --version | head -1 | grep -q 'GNU Emacs $(EMACS_VERSION)$$'

php-check: emacs-check
	phpantom_lsp --version | grep -q '$(PHPANTOM_VERSION)'
	php -v | head -1
	composer -V
	phpstan --version
	phpcs --version
	$(EMACS_BATCH) -f ide-verify php

go-check: emacs-check
	go env GOVERSION | grep -qx 'go$(GO_VERSION)'
	gopls version | grep -q 'v$(GOPLS_VERSION)$$'
	$(EMACS_BATCH) -f ide-verify go
