#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################

DESTDIR		=
prefix		= /usr/local
sysconfdir	= $(prefix:/usr=)/etc
srvdir		= /srv
wwwdir		= $(srvdir)/www

INSTALL		= install
INSTALL_DATA	= $(INSTALL) -m 644
INSTALL_DIR	= $(INSTALL) -m 755 -d

arch	= $(shell uname -m)

make		= $(CURDIR)/etc/docker/images/make
make_reg	= $(shell <$(make) grep '^reg' | cut -f2)
make_user	= $(shell <$(make) grep '^user' | cut -f2)
make_repo	= $(shell <$(make) grep '^repo' | cut -f2)
make_lbl	= $(shell <$(make) grep '^lbl' | cut -f2)
make_digest	= $(shell <$(make) grep '^digest' | grep $(arch) | cut -f3)

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
config: Dockerfile digest submodules

.PHONY: Dockerfile
Dockerfile:
	@echo '	Update Dockerfile ARGs';
	@sed -i \
		-e '/^ARG	MAKE_REG=/s/=.*/="$(make_reg)"/' \
		-e '/^ARG	MAKE_USER=/s/=.*/="$(make_user)"/' \
		-e '/^ARG	MAKE_REPO=/s/=.*/="$(make_repo)"/' \
		-e '/^ARG	MAKE_LBL=/s/=.*/="$(make_lbl)"/' \
		-e '/^ARG	MAKE_DIGEST=/s/=.*/="$(make_digest)"/' \
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

.PHONY: man
man:
	make -C src/man-pages/ html HTOPTS='-r';

.PHONY: clean-man
clean-man:
	make -C src/man-pages/ clean;

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
install-man:
	make -C src/man-pages/ install-html htmldir='$(wwwdir)/share/';

.PHONY: image
image: Dockerfile
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
stack-deploy:
	@echo '	STACK deploy	$(orchestrator) $(stack)';
	@alx_stack_deploy -o '$(orchestrator)' '$(stack)';

.PHONY: stack-rm-stable
.PHONY: stack-rm-test
stack-rm-stable stack-rm-test: stack-rm-%:
	@echo '	STACK rm	$(orchestrator) $(project)-$*';
	@alx_stack_delete -o '$(orchestrator)' '$(project)-$*';

.PHONY: clean
clean: clean-man
