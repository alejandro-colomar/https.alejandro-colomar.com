################################################################################
#	Copyright (C) 2020        Alejandro Colomar Andrés
#	SPDX-License-Identifier:  GPL-2.0-only
################################################################################


function update_version()
{
	local version="$1";

	local _d="$(dirname "${BASH_SOURCE[0]}")";
	local _D="${_d}/../../..";
	. ${_D}/etc/www/config.sh;

	local dk_repo="${WWW_DK_REG}/${WWW_DK_USER}/${WWW_DK_REPO}";

	sed "\%${dk_repo}:%s%${WWW_DK_REPO}:.*\"%${WWW_DK_REPO}:${version}\"%" \
		-i ./etc/kubernetes/manifests/030_deploy.yaml;
	sed "\%${dk_repo}:%s%${WWW_DK_REPO}:.*\"%${WWW_DK_REPO}:${version}\"%" \
		-i ./etc/swarm/manifests/compose.yaml;
	sed "\%WWW_VERSION=%s%\".*\";%\"${version}\";%" \
		-i ./etc/www/config.sh;
	sed "\%Version:%s%\(<.*>\)\(.*\)\(</.*>\)%\1${version}\3%" \
		-i ./srv/www/index.html;
}
