#!/bin/sh -x
##	./bin/prepare_release.sh
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
	local	branch="$2"

	sed "/branch_app=${branch}/s/${branch}/v${version}/"		\
		-i ./bin/deploy_aws.sh
	sed "/--branch ${branch}/s/${branch}/v${version}/"		\
		-i ./etc/docker/http/arm64v8.Dockerfile			\
		-i ./etc/docker/http/Dockerfile
	sed "/www.alejandro-colomar:/s/${branch}/${version}/"		\
		-i ./etc/docker/swarm/docker-compose_arm64v8.yaml	\
		-i ./etc/docker/swarm/docker-compose.yaml
}


################################################################################
##	main								      ##
################################################################################
main()
{
	local	version="0.8"
	local	branch="$(git branch --show-current)"

	update_version	"${version}" "${branch}"
}


################################################################################
##	run								      ##
################################################################################
params=0

if [ "$#" -ne ${params} ]; then
	echo	"Illegal number of parameters (Requires ${params})"
	exit	64	## EX_USAGE /* command line usage error */
fi

main


################################################################################
##	end of file							      ##
################################################################################
