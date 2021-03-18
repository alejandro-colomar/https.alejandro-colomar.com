########################################################################
#      Copyright (C) 2020        Alejandro Colomar Andres
#      SPDX-License-Identifier:  BSD-2-Clause
########################################################################

[ -v WWW_CONFIG_SH ] \
	&&return;
WWW_CONFIG_SH="${BASH_SOURCE[0]}";


WWW_PORT_UNSTABLE=31001;
WWW_PORT_STABLE=30001;
WWW_PROJECT="www";
WWW_STABILITY="unstable";	## "stable" or "unstable"
WWW_STACK="${WWW_PROJECT}-${WWW_STABILITY}";
WWW_VERSION="0.40";
