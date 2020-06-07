#!/bin/sh -x
##	./bin/prepare_branch.sh	<future_version>
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
	local	v_old="0.8"
	local	v_future="$1"
	local	branch="$2"

	sed "/branch_app=\"v${v_old}\"/s/v${v_old}/${branch}/"		\
		-i ./bin/deploy_aws.sh
	sed "/version=\"${v_old}\"/s/${v_old}/${v_future}/"		\
		-i ./bin/prepare_release.sh
	sed "/--branch v${v_old}/s/v${v_old}/${branch}/"		\
		-i ./etc/docker/http/aarch64.Dockerfile			\
		-i ./etc/docker/http/Dockerfile
	sed "/www.alejandro-colomar:/s/${v_old}/${branch}/"		\
		-i ./etc/docker/swarm/docker-compose_aarch64.yaml	\
		-i ./etc/docker/swarm/docker-compose.yaml
	sed "/v_old=\"${v_old}\"/s/${v_old}/${v_future}/"		\
		-i ./bin/prepare_branch.sh
}


################################################################################
##	main								      ##
################################################################################
main()
{
	local	future_version="$1"
	local	branch_name="$(git branch --show-current)"

	update_version	"${future_version}" "${branch_name}"
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
