###############################################################################
#        Copyright (C) 2020        Sebastian Francisco Colomar Bauza          #
#        Copyright (C) 2020        Alejandro Colomar Andrés                   #
#        SPDX-License-Identifier:  GPL-2.0-only                               #
###############################################################################

##	alpine:latest
FROM	alpine@sha256:a15790640a6690aa1730c38cf0a440e2aa44aaca9b0e8931a9f2b0d7cc90fd65 \
			AS dns

RUN	apk add	--no-cache --upgrade bind

RUN	ln -sv /run/secrets/var/bind/master /var/bind

CMD	["named", "-c", "/etc/bind/named.conf", "-g"]

###############################################################################
