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
	local	old_version=0.4
	local	version=$1

	sed "/--branch master/s/master/v${version}/"			\
			-i ./Dockerfile
	sed "/www.alejandro-colomar.es:v${old_version}/s/v${old_version}/v${version}/" \
			-i ./Swarm/release/web.yaml
	sed "/www.alejandro-colomar.es:v${old_version}/s/v${old_version}/v${version}/" \
			-i ./Swarm/release/web-BLUE.yaml
	sed "/old_version=${old_version}/s/${old_version}/${version}/"	\
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
main	$1


################################################################################
##	end of file							      ##
################################################################################
