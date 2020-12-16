#!/bin/bash
set -Eeo pipefail;
##	./bin/version/branch.sh;
################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Prepare a branch
## ================
##
##  - Update version number
##  - Update exposed port
##  - Update stack name
##
################################################################################


ARGC=0;
argc=$#;
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

branch=$(git branch --show-current);

update_date;
update_port		"${WWW_PORT_EXP}";
update_stability	"exp";
update_version		"${branch}";

git commit -a -m "Branch: ${branch}";


################################################################################
##	end of file							      ##
################################################################################
