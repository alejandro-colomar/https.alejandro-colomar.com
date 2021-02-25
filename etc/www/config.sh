########################################################################
#      Copyright (C) 2020        Alejandro Colomar Andres
#      SPDX-License-Identifier:  BSD-2-Clause
########################################################################

[ -v WWW_CONFIG_SH ] \
	&&return;
WWW_CONFIG_SH="${BASH_SOURCE[0]}";


WWW_PORT_EXP=32001;
WWW_PORT_RC=31001;
WWW_PORT_STABLE=30001;
WWW_PROJECT="www";
WWW_STABILITY="stable";	## "stable", "rc", or "exp"
WWW_STACK="${WWW_PROJECT}-${WWW_STABILITY}";
WWW_VERSION="0.31.0";	## tag name or branch name.
WWW_DK_REPO='alejandrocolomar';
WWW_DK_IMG="${WWW_PROJECT}";
WWW_DK_TAG="${WWW_VERSION}";
WWW_DK_ORCHESTRATOR='swarm';
