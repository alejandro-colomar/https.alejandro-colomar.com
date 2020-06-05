#!/bin/sh
################################################################################
##	Copyright (C) 2020	  Alejandro Colomar Andrés		      ##
##	SPDX-License-Identifier:  GPL-2.0-only				      ##
################################################################################
##
## Prepare the repo for release
## ============================
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
	local	old_version="0.7"
	local	version=$1

	sed "/branch_app=master/s/master/v${version}/"			\
		-i ./bin/deploy_aws.sh
	sed "/--branch master/s/master/v${version}/"			\
		-i ./etc/docker/http/arm64v8.Dockerfile			\
		-i ./etc/docker/http/Dockerfile
	sed "/www.alejandro-colomar:dns_${old_version}/s/${old_version}/${version}/" \
		-i ./etc/docker/swarm/docker-compose.arm64v8.yaml	\
		-i ./etc/docker/swarm/docker-compose.yaml
	sed "/www.alejandro-colomar:http_${old_version}/s/${old_version}/${version}/" \
		-i ./etc/docker/swarm/docker-compose.arm64v8.yaml	\
		-i ./etc/docker/swarm/docker-compose.yaml
	sed "/old_version=\"${old_version}\"/s/${old_version}/${version}/" \
		-i ./bin/prepare_release.sh
}


################################################################################
##	main								      ##
################################################################################
main()
{
	local	version=$1

	update_version	${version}
}


################################################################################
##	run								      ##
################################################################################
params=1

if [ "$#" -ne ${params} ]; then
	echo	"Illegal number of parameters (Requires ${params})"
	exit	64	## EX_USAGE /* command line usage error */
fi

main	$1


################################################################################
##	end of file							      ##
################################################################################
