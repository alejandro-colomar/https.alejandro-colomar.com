###############################################################################
#        Copyright (C) 2020        Sebastian Francisco Colomar Bauza          #
#        Copyright (C) 2020        Alejandro Colomar Andrés                   #
#        SPDX-License-Identifier:  GPL-2.0-only                               #
###############################################################################

FROM	alpine:3.12.0@sha256:3b3f647d2d99cac772ed64c4791e5d9b750dd5fe0b25db653ec4976f7b72837c \
			AS dns

RUN	apk add	--no-cache --upgrade bind

RUN	ln -sv /run/secrets/var/bind/master /var/bind

CMD	["named", "-c", "/etc/bind/named.conf", "-g"]

###############################################################################
