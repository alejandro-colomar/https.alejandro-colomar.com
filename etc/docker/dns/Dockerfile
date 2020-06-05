###############################################################################
#        Copyright (C) 2020        Sebastian Francisco Colomar Bauza          #
#        Copyright (C) 2020        Alejandro Colomar Andrés                   #
#        SPDX-License-Identifier:  GPL-2.0-only                               #
###############################################################################

FROM	alpine:3.12.0@sha256:90baa0922fe90624b05cb5766fa5da4e337921656c2f8e2b13bd3c052a0baac1 \
			AS dns

RUN	apk add	--no-cache --upgrade bind

RUN	ln -sv /run/secrets/var/bind/master /var/bind

CMD	["named", "-c", "/etc/bind/named.conf", "-g"]

###############################################################################
