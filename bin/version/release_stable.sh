#!/bin/bash
set -Eeo pipefail;
##	./bin/version/release_stable.sh	"<version>";
################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Release a stable version
## ========================
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
update_port		${WWW_PORT_STABLE};
update_stability	"stable";
update_version		"${version}";

git commit -a -m "Release ${version}";
git tag -a ${version} -m "";


################################################################################
##	end of file							      ##
################################################################################
