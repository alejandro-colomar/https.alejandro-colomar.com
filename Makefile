#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################

DESTDIR		=
prefix		= /usr/local
sysconfdir	= $(prefix:/usr=)/etc
MANDIR_		= $(CURDIR)/src/man-pages/
htmlbuilddir	= $(CURDIR)/tmp/html
srvdir		= /srv
wwwdir		= $(srvdir)/www
htmlext		= .html

INSTALL		= install
INSTALL_DATA	= $(INSTALL) -m 644
INSTALL_DIR	= $(INSTALL) -m 755 -d

current_arch	= $(shell uname -m)
arch		= $(shell uname -m)

build		= $(CURDIR)/etc/docker/images/build-essential
build_reg	= $(shell <$(build) grep '^reg' | cut -f2)
build_user	= $(shell <$(build) grep '^user' | cut -f2)
build_repo	= $(shell <$(build) grep '^repo' | cut -f2)
build_lbl	= $(shell <$(build) grep '^lbl' | cut -f2)
build_digest	= $(shell <$(build) grep '^digest' | grep $(current_arch) | cut -f3)

nginx		= $(CURDIR)/etc/docker/images/nginx
nginx_reg	= $(shell <$(nginx) grep '^reg' | cut -f2)
nginx_user	= $(shell <$(nginx) grep '^user' | cut -f2)
nginx_repo	= $(shell <$(nginx) grep '^repo' | cut -f2)
nginx_lbl	= $(shell <$(nginx) grep '^lbl' | cut -f2)
nginx_digest	= $(shell <$(nginx) grep '^digest' | grep $(arch) | cut -f3)

www	= $(CURDIR)/etc/docker/images/www
reg	= $(shell <$(www) grep '^reg' | cut -f2)
user	= $(shell <$(www) grep '^user' | cut -f2)
repo	= $(shell <$(www) grep '^repo' | cut -f2)
repository = $(reg)/$(user)/$(repo)
lbl	= $(shell <$(www) grep '^lbl' | cut -f2)
lbl_	= $(shell git describe --tags | sed 's/^v//')_$(arch)
img	= $(repository):$(lbl)
img_	= $(repository):$(lbl_)
archs	= $(shell <$(CURDIR)/.config grep '^archs' | cut -f2 | tr ',' ' ')
imgs	= $(addprefix $(img)_,$(archs))
digest	= $(shell <$(www) grep '^digest' | grep $(arch) | cut -f3)
digest_	= $(shell echo '$(digest)' | sed 's/sha256:/@sha256:/')

orchestrator = $(shell cat $(CURDIR)/etc/docker/orchestrator)
stack	= $(shell <$(CURDIR)/.config grep '^stack' | cut -f2)
project	= $(shell <$(CURDIR)/.config grep '^project' | cut -f2)

.PHONY: all
all: man

.PHONY: config
config: submodules

.PHONY: Dockerfile
Dockerfile:
	@echo '	Update Dockerfile ARGs';
	@sed -i \
		-e '/^ARG	BUILD_REG=/s/=.*/="$(build_reg)"/' \
		-e '/^ARG	BUILD_USER=/s/=.*/="$(build_user)"/' \
		-e '/^ARG	BUILD_REPO=/s/=.*/="$(build_repo)"/' \
		-e '/^ARG	BUILD_LBL=/s/=.*/="$(build_lbl)"/' \
		-e '/^ARG	BUILD_DIGEST=/s/=.*/="$(build_digest)"/' \
		-e '/^ARG	NGINX_REG=/s/=.*/="$(nginx_reg)"/' \
		-e '/^ARG	NGINX_USER=/s/=.*/="$(nginx_user)"/' \
		-e '/^ARG	NGINX_REPO=/s/=.*/="$(nginx_repo)"/' \
		-e '/^ARG	NGINX_LBL=/s/=.*/="$(nginx_lbl)"/' \
		-e '/^ARG	NGINX_DIGEST=/s/=.*/="$(nginx_digest)"/' \
		$(CURDIR)/$@;

.PHONY: digest
digest:
	@echo '	Update digest';
	@sed -i '\#$(repository)#s#$(lbl).*"$$#$(lbl)$(digest_)"#' \
		$(CURDIR)/etc/kubernetes/manifests/030_deploy.yaml \
		$(CURDIR)/etc/swarm/manifests/compose.yaml;

.PHONY: submodules
submodules:
	git submodule init && git submodule update;

.PHONY: html
html: | builddirs-html
	cd $(MANDIR_)/ && \
	find man*/ -type f \
	|while read f; do \
		_d=$$(dirname $$f | sed -E 's/(man.).*/\1/'); \
		_f=$$(basename $$f); \
		man2html -r "$$f" \
		|sed -e '1,2d' \
		>"$(htmlbuilddir)/$$_d/$${_f}$(htmlext)" \
			|| exit $$?; \
	done;

.PHONY: builddirs-html
builddirs-html:
	cd $(MANDIR_)/ && \
	find man*/ -type d \
	|sed -E 's/(man.).*/\1/' \
	|while read d; do \
		$(INSTALL_DIR) "$(htmlbuilddir)/$$d" || exit $$?; \
	done;

.PHONY: man
man: man-pages man-pages-posix


.PHONY: man-pages
man-pages:
	$(MAKE) html MANDIR_='$(CURDIR)/src/$@';

.PHONY: man-pages-posix
man-pages-posix:
	$(MAKE) html MANDIR_='$(CURDIR)/src/$@/man-pages-posix-2017';

.PHONY: clean-man
clean-man:
	rm -rf "$(htmlbuilddir)/";

.PHONY: clean
clean: clean-man

.PHONY: install-srv
install-srv: install-man | installdirs-srv
	cd srv/ && \
	find ./ -type f \
	|while read f; do \
		$(INSTALL_DATA) -T "$$f" "$(DESTDIR)$(srvdir)/$$f" || exit $$?; \
	done;

.PHONY: installdirs-srv
installdirs-srv:
	cd srv/ && \
	find ./ -type d \
	|while read d; do \
		$(INSTALL_DIR) "$(DESTDIR)$(srvdir)/$$d" || exit $$?; \
	done;

.PHONY: install-man
install-man: | installdirs-man
	cd $(htmlbuilddir)/ && \
	find man?/ -type f \
	|while read f; do \
		$(INSTALL_DATA) -T "$$f" "$(DESTDIR)$(wwwdir)/share/man/$$f" \
			|| exit $$?; \
	done;

.PHONY: installdirs-man
installdirs-man:
	cd $(htmlbuilddir)/ && \
	find man?/ -type d \
	|while read d; do \
		$(INSTALL_DIR) "$(DESTDIR)$(wwwdir)/share/man/$$d" || exit $$?; \
	done;

.PHONY: image
image: Dockerfile submodules
	@echo '	DOCKER image build	$(img_)';
	@docker image build -t '$(img_)' $(CURDIR);

.PHONY: image-push
image-push:
	@echo '	DOCKER image push	$(img_)';
	@docker image push '$(img_)';

.PHONY: image-manifest
image-manifest:
	@echo '	DOCKER manifest create	$(img)';
	@docker manifest create '$(img)' $(imgs);

.PHONY: image-manifest-push
image-manifest-push:
	@echo '	DOCKER manifest push	$(img)';
	@docker manifest push '$(img)';

.PHONY: stack-deploy
stack-deploy: digest
	@echo '	STACK deploy	$(orchestrator) $(stack)';
	@alx_stack_deploy -o '$(orchestrator)' '$(stack)';

.PHONY: stack-rm-stable
.PHONY: stack-rm-test
stack-rm-stable stack-rm-test: stack-rm-%:
	@echo '	STACK rm	$(orchestrator) $(project)-$*';
	@alx_stack_delete -o '$(orchestrator)' '$(project)-$*';

.PHONY: clean
clean: clean-man
