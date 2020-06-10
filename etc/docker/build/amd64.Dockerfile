################################################################################
##      Copyright (C) 2020        Sebastian Francisco Colomar Bauza           ##
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################


################################################################################
################################################################################
ARG	tag_git="1.0.14"
ARG	digest_git="sha256:8d2aedf3898243892d170f033603b40a55e0b0a8ab68ba9762f9c0dae40b5c8d"
ARG	tag_nginx="1.2_amd64"
ARG	digest_nginx="sha256:10c53e711f1a57ba531c62dc68c30c7d14b24edc618b846b94443951a9c466df"

################################################################################
################################################################################
FROM	"alpine/git:${tag_git}@${digest_git}"	AS git
################################################################################

RUN	git clone							\
		--single-branch						\
		--branch "master"					\
		https://github.com/alejandro-colomar/www.git		\
		/usr/local/src/www

################################################################################
################################################################################
FROM	"alejandrocolomar/nginx:${tag_nginx}@${digest_nginx}" AS nginx
################################################################################

## copy web files
COPY	--from=git /usr/local/src/www/share/nginx/downloads/	/usr/share/nginx/downloads
COPY	--from=git /usr/local/src/www/share/nginx/html/		/usr/share/nginx/html
COPY	--from=git /usr/local/src/www/share/nginx/pictures/	/usr/share/nginx/pictures

################################################################################
