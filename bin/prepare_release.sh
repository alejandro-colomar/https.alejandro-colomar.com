#!/bin/sh -x
##	./bin/prepare_release.sh	<version>
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	Copyright (C) 2020	  Sebastian Francisco Colomar Bauza	      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Prepare the repo for imminent release
## =====================================
##
## This script should be run just before creating a release (tag).
##
##  - Remove the files that shouldn't go into the release
##  - Update version numbers
##
################################################################################


################################################################################
##	functions							      ##
################################################################################
update_version()
{
	local	version="$1"

	sed "/branch_app=/s/\".*\"/\"v${version}\"/"			\
		-i ./etc/docker-aws/config.sh
	sed "/--branch/s/\".*\"/\"v${version}\"/"			\
		-i ./etc/docker/http/aarch64.Dockerfile			\
		-i ./etc/docker/http/Dockerfile
	sed "/www.alejandro-colomar:/s/_.*\"/_${version}\"/"		\
		-i ./etc/docker/swarm/docker-compose.yaml
	sed "/www.alejandro-colomar:/s/_.*_/_${version}_/"		\
		-i ./etc/docker/swarm/docker-compose_aarch64.yaml
}


################################################################################
##	main								      ##
################################################################################
main()
{
	local	version="$1"

	update_version	"${version}"
}


################################################################################
##	run								      ##
################################################################################
params=1

if [ "$#" -ne ${params} ]; then
	echo	"Illegal number of parameters (Requires ${params})"
	exit	64	## EX_USAGE /* command line usage error */
fi

main	"$1"


################################################################################
##	end of file							      ##
################################################################################
