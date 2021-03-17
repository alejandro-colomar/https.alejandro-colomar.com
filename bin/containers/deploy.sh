#!/bin/bash
set -Eeuo pipefail;
########################################################################
#	Copyright (C) 2020        Alejandro Colomar Andres
#	SPDX-License-Identifier:  GPL-2.0-only
########################################################################


EX_OK=0;
EX_USAGE=64;

usage="Usage: sudo ${BASH_SOURCE[0]}";
if [ $# -ne 0 ]; then
	>&2 echo "${usage}";
	exit ${EX_USAGE};
fi;
if [ $(id -u) -ne 0 ]; then
	>&2 echo "${usage}";
	exit ${EX_NOPERM};
fi;

. etc/www/config.sh;

alx_stack_deploy -o "${WWW_DK_ORCHESTRATOR}" "${WWW_STACK}";

exit ${EX_OK};
