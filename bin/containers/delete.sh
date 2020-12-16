#!/bin/bash
set -Eeo pipefail;
##	./bin/containers/delete.sh <mode> <stability>;
################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Delete stack
## ============
##
################################################################################


ARGC=2;
argc=$#;
mode="$1";
stability="$2";
EX_USAGE=64;
if [ ${argc} -ne ${ARGC} ]; then
	echo >&2							\
'Usage: ./bin/containers/delete mode stack_stability
Mode:
	kubernetes
	openshift
	swarm
Stack stability:
	A suffix string that will be appended
	to the project name to create the stack name.
	Usually, it should be one of the following:
	"exp", "rc", or "stable".';
	exit	${EX_USAGE};
fi


. etc/www/config.sh;

project="${WWW_PROJECT}";
stack="${project}-${stability}";

/usr/local/libexec/libalx/stack_delete.sh	"${mode}" "${stack}";


################################################################################
##	end of file							      ##
################################################################################
