################################################################################
##      Copyright (C) 2020        Sebastian Francisco Colomar Bauza           ##
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################


################################################################################
ARG	git_digest=sha256:8d2aedf3898243892d170f033603b40a55e0b0a8ab68ba9762f9c0dae40b5c8d

FROM	alpine/git:1.0.14@${git_digest}		AS git

RUN	git clone							\
		--single-branch						\
		--branch "master"					\
		https://github.com/alejandro-colomar/www.git		\
		/usr/local/src/www

###############################################################################
ARG	nginx_digest=sha256:8d2aedf3898243892d170f033603b40a55e0b0a8ab68ba9762f9c0dae40b5c8d

FROM	alejandrocolomar/nginx:1.19.0-alpine-alx.2_amd64@${nginx_digest} AS nginx

## copy web files
COPY	--from=git /usr/local/src/www/share/nginx/downloads/	/usr/share/nginx/downloads
COPY	--from=git /usr/local/src/www/share/nginx/html/		/usr/share/nginx/html
COPY	--from=git /usr/local/src/www/share/nginx/pictures/	/usr/share/nginx/pictures

###############################################################################
