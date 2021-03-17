#!/bin/bash
set -Eeuo pipefail;
########################################################################
#      Copyright (C) 2020        Alejandro Colomar Andres
#      SPDX-License-Identifier:  GPL-2.0-only
########################################################################


EX_OK=0;
EX_USAGE=64;

if [ $# -ne 0 ]; then
	>&2 echo "Usage:  ${BASH_SOURCE[0]}";
	exit ${EX_USAGE};
fi;

_d="$(dirname "${BASH_SOURCE[0]}")";
_D="${_d}/../..";
. ${_D}/etc/www/config.sh;

docker build -t "${WWW_DK_REPO}/${WWW_DK_IMG}:${WWW_DK_TAG}" ${_D}/;
docker push "${WWW_DK_REPO}/${WWW_DK_IMG}:${WWW_DK_TAG}";

exit ${EX_OK};
