##	source	/lib/libalx/sh/sysexits.sh
################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  BSD-2-Clause                                ##
################################################################################


################################################################################
##	include guard							      ##
################################################################################
if [ -n "${WWW_CONFIG_H}" ]; then
	return;
fi
WWW_CONFIG_H="/etc/www/config.sh included";


################################################################################
##	definitions							      ##
################################################################################
WWW_COMPOSE_FNAME="etc/docker/swarm/docker-compose.yaml";
WWW_PORT_EXP=32001;
WWW_PORT_RC=31001;
WWW_PORT_STABLE=30001;
WWW_STABILITY="exp";	## "stable", "rc", or "exp"
WWW_STACK_BASENAME="www";
WWW_VERSION="master";	## tag name or branch name.


################################################################################
##	end of file							      ##
################################################################################
