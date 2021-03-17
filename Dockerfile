########################################################################
# Copyright (C) 2020		Sebastian Francisco Colomar Bauza
# Copyright (C) 2020, 2021	Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################


########################################################################
ARG	NGINX_REG=docker.io
ARG	NGINX_USER=alejandrocolomar
ARG	NGINX_REPO=nginx
ARG	NGINX_LBL=1.16.0
ARG	NGINX_DIGEST=sha256:34c652cbc41b0c09daab213282ab0af88d4a55dd532a98458e221035bdfa6d0d
########################################################################
FROM	"${NGINX_REG}/${NGINX_USER}/${NGINX_REPO}:${NGINX_LBL}@${NGINX_DIGEST}" \
	AS nginx
########################################################################
COPY	srv/	/srv/
########################################################################
