#!/bin/bash
set -Eeo pipefail;
##	./bin/version/release_rc.sh	"<version>";
################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Release a release-critical version
## ==================================
##
##  - Update version number
##  - Update exposed port
##  - Update stack name
##
################################################################################


ARGC=1;
argc=$#;
version="$1";
EX_USAGE=64;
if [ ${argc} -ne ${ARGC} ]; then
	echo	"Illegal number of parameters (Requires ${ARGC})";
	exit	${EX_USAGE};
fi


. etc/www/config.sh;
. lib/www/version/date.sh;
. lib/www/version/port.sh;
. lib/www/version/stability.sh;
. lib/www/version/version.sh;

update_date;
update_port		${WWW_PORT_RC};
update_stability	"rc";
update_version		"${version}";

git commit -a -m "Pre-release ${version}";
git tag -a ${version} -m "";


################################################################################
##	end of file							      ##
################################################################################
