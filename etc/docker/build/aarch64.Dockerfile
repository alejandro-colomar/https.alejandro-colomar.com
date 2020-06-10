################################################################################
##      Copyright (C) 2020        Sebastian Francisco Colomar Bauza           ##
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################


################################################################################
################################################################################
ARG	tag_git="3.12.0"
ARG	digest_git="sha256:3b3f647d2d99cac772ed64c4791e5d9b750dd5fe0b25db653ec4976f7b72837c"
ARG	tag_nginx="1.2_aarch64"
ARG	digest_nginx="sha256:FIXME"

################################################################################
################################################################################
FROM	"alpine:${tag_git}@${digest_git}"	AS git
################################################################################

RUN	apk add	--no-cache --upgrade git

RUN	git clone							\
		--single-branch						\
		--branch "master"					\
		https://github.com/alejandro-colomar/www.git		\
		/usr/local/src/www

################################################################################
################################################################################
FROM	"alejandrocolomar/nginx:${tag_nginx}@${digest_nginx}"	AS nginx
################################################################################

## copy web files
COPY	--from=git /usr/local/src/www/share/nginx/downloads/	/usr/share/nginx/downloads
COPY	--from=git /usr/local/src/www/share/nginx/html/		/usr/share/nginx/html
COPY	--from=git /usr/local/src/www/share/nginx/pictures/	/usr/share/nginx/pictures

################################################################################
