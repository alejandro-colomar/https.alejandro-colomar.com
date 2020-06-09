#!/bin/bash -x
##	./bin/update_version.sh	[<version>]
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Update version numbers
## ======================
##
## This script should be run just after a new branch has been created, a
## release is imminent, or a release has been made.
## The default value for the version is the branch name.
##
##  - Update version numbers
##
################################################################################


################################################################################
##	source								      ##
################################################################################
source	lib/libalx/sh/sysexits.sh


################################################################################
##	definitions							      ##
################################################################################
MAX_ARGC=1


################################################################################
##	functions							      ##
################################################################################
update_version()
{
	local	version="$1"

	sed "/branch_app=/s/\".*\"/\"${version}\"/"			\
		-i ./etc/docker-aws/config.sh
	sed "/--branch/s/\".*\"/\"${version}\"/"			\
		-i ./etc/docker/www/aarch64.Dockerfile			\
		-i ./etc/docker/www/amd64.Dockerfile
	sed "/alejandrocolomar\/www:/s/www:.*_/www:${version}_/"	\
		-i ./etc/docker/swarm/docker-compose_aarch64.yaml	\
		-i ./etc/docker/swarm/docker-compose_amd64.yaml
}


################################################################################
##	main								      ##
################################################################################
main()
{
	local	version="$1"
	local	argc="$2"

	if [ ${argc} -eq 0 ]; then
		version="$(git branch --show-current)"
	fi

	update_version	"${version}"
}


################################################################################
##	run								      ##
################################################################################
argc=$#
if [ ${argc} -gt ${MAX_ARGC} ]; then
	echo	"Illegal number of parameters (Accepts ${MAX_ARGC} or less)"
	exit	${EX_USAGE}
fi

main	"$1" "${argc}"


################################################################################
##	end of file							      ##
################################################################################
