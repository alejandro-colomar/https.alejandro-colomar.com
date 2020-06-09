###############################################################################
#        Copyright (C) 2020        Sebastian Francisco Colomar Bauza          #
#        Copyright (C) 2020        Alejandro Colomar Andrés                   #
#        SPDX-License-Identifier:  GPL-2.0-only                               #
###############################################################################

FROM	alpine:3.12.0@sha256:3b3f647d2d99cac772ed64c4791e5d9b750dd5fe0b25db653ec4976f7b72837c \
			AS git

RUN	apk add	--no-cache --upgrade git

RUN	git clone							\
		--single-branch						\
		--branch "master"					\
		https://github.com/alejandro-colomar/www.git		\
		/repo

###############################################################################

FROM	nginx:alpine@sha256:fa24815c8e52981d8ef01249e17d46dc5367765814d6feed154f1043aa255b8e \
			AS nginx

## Remove any nginx module but 'nginx' itself.
RUN	for package in $(						\
		for x in 0 1 2 3 4 5 6 7 8 9;				\
		do							\
			apk list					\
			| awk /nginx/'{ print $1 }'			\
			| awk -F-$x  '{ print $1 }'			\
			| grep -v '\-[0-9]';				\
		done							\
		| sort							\
		| uniq							\
		| grep -v ^nginx$					\
	);								\
	do								\
		apk del $package;					\
	done

## configure nginx server
COPY	--from=git	/repo/etc/nginx/nginx.conf	/etc/nginx/nginx.conf
COPY	--from=git	/repo/etc/nginx/conf.d/		/etc/nginx/conf.d

## copy web files
COPY	--from=git	/repo/share/nginx/downloads/	/usr/share/nginx/downloads
COPY	--from=git	/repo/share/nginx/html/		/usr/share/nginx/html
COPY	--from=git	/repo/share/nginx/pictures/	/usr/share/nginx/pictures

###############################################################################
