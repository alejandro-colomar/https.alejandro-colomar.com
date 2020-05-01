###############################################################################
#        Copyright (C) 2020        Sebastian Francisco Colomar Bauza          #
#        Copyright (C) 2020        Alejandro Colomar Andrés                   #
#        SPDX-License-Identifier:  GPL-2.0-only                               #
###############################################################################

FROM									\
	alpine/git:1.0.12 AS git

RUN									\
	git clone							\
	    --single-branch						\
	    --branch master						\
	    https://github.com/alejandro-colomar/https.alejandro-colomar.com.git \
	    /repo

###############################################################################

FROM									\
	nginx:1.18.0-alpine AS nginx

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

COPY									\
	--from=git /repo/Web/ /usr/share/nginx/html

###############################################################################
