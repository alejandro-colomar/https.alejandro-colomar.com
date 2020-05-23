###############################################################################
#        Copyright (C) 2020        Sebastian Francisco Colomar Bauza          #
#        Copyright (C) 2020        Alejandro Colomar Andrés                   #
#        SPDX-License-Identifier:  GPL-2.0-only                               #
###############################################################################

##	alpine/git:latest
FROM	alpine/git@sha256:8d2aedf3898243892d170f033603b40a55e0b0a8ab68ba9762f9c0dae40b5c8d \
			AS git

RUN	git clone							\
	    --single-branch						\
	    --branch master						\
	    https://github.com/alejandro-colomar/www.alejandro-colomar.bit.git \
	    /repo

###############################################################################

FROM	nginx@sha256:676b8117782d9e8c20af8e1b19356f64acc76c981f3a65c66e33a9874877892a \
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
