#!/bin/bash
set -Eeuo pipefail;
########################################################################
#      Copyright (C) 2020        Alejandro Colomar Andres
#      SPDX-License-Identifier:  GPL-2.0-only
########################################################################


EX_OK=0;
EX_USAGE=64;
EX_CANTCREAT=73;

if [ $# -ne 1 ]; then
	>&2 echo "Usage: ${BASH_SOURCE[0]} <version>";
	exit ${EX_USAGE};
fi;
version="$1";

_d="$(dirname "${BASH_SOURCE[0]}")";
_D="${_d}/../..";
. ${_D}/lib/www/version/digest.sh;

update_digest;

if git rev-parse "refs/tags/${version}" >/dev/null 2>&1; then
	>&2 echo "Version already exists!";
	exit ${EX_CANTCREAT};
fi;

git tag -a ${version} -m "";

exit ${EX_OK};
