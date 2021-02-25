#!/bin/bash
set -Eeuo pipefail;
########################################################################
#	Copyright (C) 2020        Alejandro Colomar Andres
#	SPDX-License-Identifier:  GPL-2.0-only
########################################################################

_h=$(eval echo ~${SUDO_USER:-});
. ${_h}/.bash_aliases;

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

alx_stack_deploy "${WWW_DK_ORCHESTRATOR}" "${WWW_STACK}";
