# Reproducible language IDE builds. Versions are pinned in versions.env and
# languages/ide/ide-lock.el.
#
#   make php-ide     build the PHP IDE (idempotent)
#   make go-ide      build the Go IDE (idempotent)
#   make markdown-ide / yaml-ide
#   make ide         build all IDEs
#   make <lang>-check   verify an installation

include versions.env

export PATH := $(HOME)/.local/bin:$(PATH)

EMACS_BATCH = emacs --batch --init-directory=$(CURDIR) -l languages/ide/install.el

LANGS = php go markdown yaml

.PHONY: ide emacs ide-elisp emacs-check $(foreach l,$(LANGS),$(l)-ide $(l)-deps $(l)-elisp $(l)-check)

ide: $(foreach l,$(LANGS),$(l)-ide)

php-ide: emacs php-deps php-elisp php-check

go-ide: emacs go-deps go-elisp go-check

markdown-ide: emacs markdown-deps markdown-elisp markdown-check

yaml-ide: emacs yaml-deps yaml-elisp yaml-check

emacs:
	./scripts/build-emacs.sh

php-deps:
	./scripts/install-php-deps.sh

go-deps:
	./scripts/install-go-deps.sh

markdown-deps:
	./scripts/install-markdown-deps.sh

yaml-deps:
	./scripts/install-yaml-deps.sh

php-elisp:
	$(EMACS_BATCH) -f ide-install php

go-elisp:
	$(EMACS_BATCH) -f ide-install go

markdown-elisp:
	$(EMACS_BATCH) -f ide-install markdown

yaml-elisp:
	$(EMACS_BATCH) -f ide-install yaml

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

markdown-check: emacs-check
	marksman --version | grep -qx '$(MARKSMAN_VERSION)'
	pandoc --version | head -1 | grep -qx 'pandoc $(PANDOC_VERSION)'
	$(EMACS_BATCH) -f ide-verify markdown

yaml-check: emacs-check
	grep -q '"version": "$(YAML_LS_VERSION)"' $(HOME)/.local/share/yaml-ide/node_modules/yaml-language-server/package.json
	grep -q '"yaml-language-server": "$(YAML_LS_VERSION)"' languages/yaml/package.json
	$(EMACS_BATCH) -f ide-verify yaml
