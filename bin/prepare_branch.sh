#!/bin/sh -x
##	./bin/prepare_branch.sh
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	Copyright (C) 2020	  Sebastian Francisco Colomar Bauza	      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Start working on a new version
## ==============================
##
## This script should be run just after a release has been made.
##
##  - Retake work in the current branch
##  - Update version numbers
##
################################################################################


################################################################################
##	functions							      ##
################################################################################
update_version()
{
	local	branch="$(git branch --show-current)"

	sed "/branch_app=/s/\".*\"/\"${branch}\"/"			\
		-i ./etc/docker-aws/config.sh
	sed "/--branch/s/\".*\"/\"${branch}\"/"				\
		-i ./etc/docker/http/aarch64.Dockerfile			\
		-i ./etc/docker/http/Dockerfile
	sed "/www.alejandro-colomar:/s/_.*\"/_${branch}\"/"		\
		-i ./etc/docker/swarm/docker-compose.yaml
	sed "/www.alejandro-colomar:/s/_.*_/_${branch}_/"		\
		-i ./etc/docker/swarm/docker-compose_aarch64.yaml
}


################################################################################
##	main								      ##
################################################################################
main()
{

	update_version
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
