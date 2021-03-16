#!/bin/bash
set -Eeuo pipefail;
########################################################################
#      Copyright (C) 2020        Alejandro Colomar Andres
#      SPDX-License-Identifier:  GPL-2.0-only
########################################################################


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
update_port		${WWW_PORT_STABLE};
update_stability	"stable";
update_version		"${version}";

if git rev-parse "refs/tags/${version}" >/dev/null 2>&1; then
	>&2 echo "Version already exists!";
	exit ${EX_CANTCREAT};
fi;

git commit -a -m "Release ${version}";
git tag -a ${version} -m "";
