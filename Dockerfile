###############################################################################
#        Copyright (C) 2020        Sebastian Francisco Colomar Bauza          #
#        Copyright (C) 2020        Alejandro Colomar Andrés                   #
#        SPDX-License-Identifier:  GPL-2.0-only                               #
###############################################################################

FROM									\
	alpine/git@sha256:3640856b23fc294757fd1d0d8b6aaecd689e8f234df8513e7b789f04c99ac600 \
			AS git

RUN									\
	git clone							\
	    --single-branch						\
	    --branch master						\
	    https://github.com/alejandro-colomar/www.alejandro-colomar.com.git \
	    /repo

###############################################################################

FROM									\
	nginx@sha256:676b8117782d9e8c20af8e1b19356f64acc76c981f3a65c66e33a9874877892a \
			AS nginx

## Remove any nginx module but 'nginx' itself.
RUN									\
	for package in $(						\
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

## copy web files
COPY	--from=git	/repo/share/html/	/usr/share/nginx/html
COPY	--from=git	/repo/share/pictures/	/usr/share/nginx/pictures

###############################################################################
