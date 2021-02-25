#!/bin/bash
set -Eeuo pipefail;
########################################################################
#      Copyright (C) 2020        Alejandro Colomar Andres
#      SPDX-License-Identifier:  GPL-2.0-only
########################################################################

. ~/.bash_aliases;

if [ $# -ne 0 ]; then
	>&2 echo "Usage:  ${BASH_SOURCE[0]}";
	exit ${EX_USAGE};
fi;

. etc/www/config.sh;

docker build -t "${WWW_DK_REPO}/${WWW_DK_IMG}:${WWW_DK_TAG}" .;
docker push "${WWW_DK_REPO}/${WWW_DK_IMG}:${WWW_DK_TAG}";
