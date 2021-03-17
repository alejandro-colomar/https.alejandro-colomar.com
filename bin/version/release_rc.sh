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
. ${_D}/etc/www/config.sh;
. ${_D}/lib/www/version/date.sh;
. ${_D}/lib/www/version/port.sh;
. ${_D}/lib/www/version/stability.sh;
. ${_D}/lib/www/version/version.sh;

update_date;
update_port		${WWW_PORT_RC};
update_stability	"rc";
update_version		"${version}";

if git rev-parse "refs/tags/${version}" >/dev/null 2>&1; then
	>&2 echo "Version already exists!";
	exit ${EX_CANTCREAT};
fi;

git commit -a -m "Pre-release ${version}";
git tag -a ${version} -m "";

exit ${EX_OK};
