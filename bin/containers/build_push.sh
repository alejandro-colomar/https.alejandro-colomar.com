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

img="${WWW_DK_REG}/${WWW_DK_USER}/${WWW_DK_REPO}:${WWW_DK_LBL}";

docker build -t "${img}" ${_D}/;
docker push "${img}";

exit ${EX_OK};
