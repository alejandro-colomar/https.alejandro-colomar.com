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
WWW_VERSION="0.35.0";	## tag name or branch name.
WWW_DK_REG='docker.io';
WWW_DK_USER='alejandrocolomar';
WWW_DK_REPO="${WWW_PROJECT}";
WWW_DK_LBL="${WWW_VERSION}";
WWW_DK_DIGEST_aarch64='a70106790923049e88ec5c0d8166270781d5403bf26a2110788af14584242b77';
WWW_DK_DIGEST_x86_64='34c652cbc41b0c09daab213282ab0af88d4a55dd532a98458e221035bdfa6d0d';
WWW_DK_ORCHESTRATOR='swarm';
