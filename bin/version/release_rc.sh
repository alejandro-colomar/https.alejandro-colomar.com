#!/bin/bash
set -Eeuo pipefail;
########################################################################
#      Copyright (C) 2020        Alejandro Colomar Andres
#      SPDX-License-Identifier:  GPL-2.0-only
########################################################################


EX_OK=0;
EX_USAGE=64;

if [ $# -ne 1 ]; then
	>&2 echo "Usage: ${BASH_SOURCE[0]} <version>";
	exit ${EX_USAGE};
fi;
version="$1";

. etc/www/config.sh;
. lib/www/version/date.sh;
. lib/www/version/port.sh;
. lib/www/version/stability.sh;
. lib/www/version/version.sh;

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
