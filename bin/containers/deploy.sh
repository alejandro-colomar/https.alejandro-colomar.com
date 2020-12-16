#!/bin/bash
set -Eeo pipefail;
##	sudo ./bin/containers/deploy.sh <mode>;
################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Deploy stack
## ============
##
################################################################################


ARGC=1;
argc=$#;
mode="$1";
EX_USAGE=64;
if [ ${argc} -ne ${ARGC} ]; then
	echo >&2							\
'Usage: ./bin/containers/deploy mode
Mode:
	kubernetes
	openshift
	swarm';
	exit	${EX_USAGE};
fi


. etc/www/config.sh;

project="${WWW_PROJECT}";
stack="${WWW_STACK}";

/usr/local/libexec/libalx/stack_deploy.sh "${mode}" "${project}" "${stack}";


################################################################################
##	end of file							      ##
################################################################################
