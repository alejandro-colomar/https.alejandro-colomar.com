########################################################################
# Copyright (C) 2020		Sebastian Francisco Colomar Bauza
# Copyright (C) 2020, 2021	Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################


########################################################################
ARG	BUILD_REG="docker.io"
ARG	BUILD_USER="alejandrocolomar"
ARG	BUILD_REPO="build-essential"
ARG	BUILD_REPOSITORY="${BUILD_REG}/${BUILD_USER}/${BUILD_REPO}"
ARG	BUILD_LBL="1.0.0"
ARG	BUILD_DIGEST="sha256:ccde260ba2881dd35e26a343fafab20e9b5e3e668a0e11d7063675f429937452"
########################################################################
ARG	NGINX_REG="docker.io"
ARG	NGINX_USER="alejandrocolomar"
ARG	NGINX_REPO="nginx"
ARG	NGINX_REPOSITORY="${NGINX_REG}/${NGINX_USER}/${NGINX_REPO}"
ARG	NGINX_LBL="1.16.0"
ARG	NGINX_DIGEST="sha256:a70106790923049e88ec5c0d8166270781d5403bf26a2110788af14584242b77"
########################################################################


########################################################################
FROM	"${BUILD_REPOSITORY}:${BUILD_LBL}@${BUILD_DIGEST}" AS build
########################################################################
COPY	./	/usr/local/src/www/
########################################################################
WORKDIR	/usr/local/src/www/
########################################################################
RUN	apt-get install -V --no-install-recommends man2html --yes;
RUN	make;
RUN	make install-srv;
########################################################################


########################################################################
FROM	"${NGINX_REPOSITORY}:${NGINX_LBL}@${NGINX_DIGEST}" AS nginx
########################################################################
COPY	--from=build	/srv/	/srv/
########################################################################
