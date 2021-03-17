#!/bin/bash
set -Eeuo pipefail;
########################################################################
#	Copyright (C) 2020        Alejandro Colomar Andres
#	SPDX-License-Identifier:  GPL-2.0-only
########################################################################
#
# Prepare a branch
# ================
#
#  - Update version number
#  - Update exposed port
#  - Update stack name
#
########################################################################


EX_OK=0;
EX_USAGE=64;

if [ $# -ne 0 ]; then
	>&2 echo "Usage: ${BASH_SOURCE[0]}";
	exit ${EX_USAGE};
fi;

. etc/www/config.sh;
. lib/www/version/date.sh;
. lib/www/version/port.sh;
. lib/www/version/stability.sh;
. lib/www/version/version.sh;

branch=$(git branch --show-current);

update_date;
update_port		"${WWW_PORT_EXP}";
update_stability	"exp";
update_version		"${branch}";

git commit -a -m "Branch: ${branch}";

exit ${EX_OK};
