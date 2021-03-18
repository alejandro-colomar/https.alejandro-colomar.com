#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################
SHELL	= /bin/bash


www	= $(CURDIR)/etc/docker/images/www
reg	= $(shell <$(www) grep '^reg' | cut -f2)
user	= $(shell <$(www) grep '^user' | cut -f2)
repo	= $(shell <$(www) grep '^repo' | cut -f2)
repository = $(reg)/$(user)/$(repo)
lbl	= $(shell git describe --tags | sed 's/^v//')
arch	= $(shell uname -m)
lbl_	= $(lbl)_$(arch)
img	= $(repository):$(lbl)
img_	= $(repository):$(lbl_)
archs	= aarch64 x86_64
imgs	= $(addprefix $(img)_,$(archs))
digest	= $(shell <$(www) grep '^digest' | grep $(arch) | cut -f3)

orchestrator = $(shell cat $(CURDIR)/etc/docker/orchestrator)
stack	= $(shell <$(CURDIR)/.config grep '^stack' | cut -f2)
project	= $(shell <$(CURDIR)/.config grep '^project' | cut -f2)


.PHONY: Dockerfile
Dockerfile: $(CURDIR)/etc/docker/images/nginx
Dockerfile: $(CURDIR)/libexec/update_dockerfile
	@echo '	Update Dockerfile ARGs';
	@$<;

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

.PHONY: digest
digest:
	@echo '	Update digest';
	@sed -i '/$(repository)/s/"$$/@$(digest)"/' \
		$(CURDIR)/etc/kubernetes/manifests/030_deploy.yaml \
		$(CURDIR)/etc/swarm/manifests/compose.yaml;

.PHONY: stack-deploy
stack-deploy: digest
	@echo '	STACK deploy	$(orchestrator) $(stack)';
	@alx_stack_deploy -o '$(orchestrator)' '$(stack)';

.PHONY: stack-rm-stable
.PHONY: stack-rm-test
stack-rm-stable stack-rm-test: stack-rm-%:
	@echo '	STACK rm	$(orchestrator) $(project)-$*';
	@alx_stack_delete -o '$(orchestrator)' '$(project)-$*';
