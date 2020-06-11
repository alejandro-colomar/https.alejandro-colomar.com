################################################################################
##      Copyright (C) 2020        Sebastian Francisco Colomar Bauza           ##
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################


################################################################################
FROM	"alpine:3.12.0"	AS git
################################################################################
RUN									\
	apk add	--no-cache --upgrade git

################################################################################
RUN									\
	git clone							\
		--single-branch						\
		--branch "0.12.1"					\
		https://github.com/alejandro-colomar/www.git		\
		/usr/local/src/www

################################################################################
FROM	"alejandrocolomar/nginx:1.3.0"	AS nginx
################################################################################
## Copy web files
COPY	--from=git	/usr/local/src/www/share/nginx/downloads/	\
			/usr/share/nginx/downloads
COPY	--from=git	/usr/local/src/www/share/nginx/html/		\
			/usr/share/nginx/html
COPY	--from=git	/usr/local/src/www/share/nginx/pictures/	\
			/usr/share/nginx/pictures

################################################################################
