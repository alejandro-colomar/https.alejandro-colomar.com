#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################
SHELL	= /bin/bash


reg	= $(shell <$(CURDIR)/etc/docker/images/www grep '^reg' | cut -f2)
user	= $(shell <$(CURDIR)/etc/docker/images/www grep '^user' | cut -f2)
repo	= $(shell <$(CURDIR)/etc/docker/images/www grep '^repo' | cut -f2)
lbl	= $(shell git describe --tags | sed 's/^v//')
lbl_	= $(lbl)_$(shell uname -m)
img	= $(reg)/$(user)/$(repo):$(lbl)
img_	= $(reg)/$(user)/$(repo):$(lbl_)
orchestrator = $(shell cat $(CURDIR)/etc/docker/orchestrator)


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
	@docker manifest create '$(img)' '$(img)_x86_64' '$(img)_aarch64';

.PHONY: image-manifest-push
image-manifest-push:
	@echo '	DOCKER manifest push	$(img)';
	@docker manifest push '$(img)';
