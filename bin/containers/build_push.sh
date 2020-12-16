#!/bin/bash
set -Eeo pipefail;
##	./bin/containers/build_push.sh;
################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Build and push the docker image
## ===============================
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

docker build -t "${WWW_DK_REPO}/${WWW_DK_IMG}:${WWW_DK_TAG}" .;
docker push "${WWW_DK_REPO}/${WWW_DK_IMG}:${WWW_DK_TAG}";


################################################################################
##	end of file							      ##
################################################################################
