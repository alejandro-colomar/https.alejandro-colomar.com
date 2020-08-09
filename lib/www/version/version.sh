################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
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


################################################################################
##	definitions							      ##
################################################################################


################################################################################
##	functions							      ##
################################################################################
function update_version()
{
	local	version="$1";

	sed "/alejandrocolomar\/www:/s/www:.*\"/www:${version}\"/"	\
		-i ./etc/docker/kubernetes/deployment.yaml;
	sed "/alejandrocolomar\/www:/s/www:.*\"/www:${version}\"/"	\
		-i ./etc/docker/swarm/docker-compose.yaml;
	sed "/WWW_VERSION=/s/\".*\"\;/\"${version}\"\;/"		\
		-i ./etc/www/config.sh;
}


################################################################################
##	end of file							      ##
################################################################################
