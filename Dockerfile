########################################################################
# Copyright (C) 2020		Sebastian Francisco Colomar Bauza
# Copyright (C) 2020, 2021	Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################


########################################################################
ARG	MAKE_REG="docker.io"
ARG	MAKE_USER="alejandrocolomar"
ARG	MAKE_REPO="make"
ARG	MAKE_REPOSITORY="${MAKE_REG}/${MAKE_USER}/${MAKE_REPO}"
ARG	MAKE_LBL="1.0.0"
ARG	MAKE_DIGEST="sha256:e147f9d190a31cfebbb60beb134869d39554d5938c1f3d8fe5282bc53d81530d"
########################################################################
FROM	"${MAKE_REPOSITORY}:${MAKE_LBL}@${MAKE_DIGEST}" AS make
########################################################################
COPY	./	/usr/local/src/www/
########################################################################
# busybox doesn't understand 'install -T'
RUN	sed -i '/INSTALL/s/-T//' Makefile;
########################################################################
RUN	make -C /usr/local/src/www/ install-srv;
########################################################################


########################################################################
ARG	NGINX_REG="docker.io"
ARG	NGINX_USER="alejandrocolomar"
ARG	NGINX_REPO="nginx"
ARG	NGINX_REPOSITORY="${NGINX_REG}/${NGINX_USER}/${NGINX_REPO}"
ARG	NGINX_LBL="1.16.0"
ARG	NGINX_DIGEST="sha256:34c652cbc41b0c09daab213282ab0af88d4a55dd532a98458e221035bdfa6d0d"
########################################################################
FROM	"${NGINX_REPOSITORY}:${NGINX_LBL}@${NGINX_DIGEST}" AS nginx
########################################################################
COPY	--from=make	/srv/	/srv/
########################################################################
