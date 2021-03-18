################################################################################
#	Copyright (C) 2020        Alejandro Colomar Andrés
#	SPDX-License-Identifier:  GPL-2.0-only
################################################################################


function update_version()
{
	local version="$1";

	local _d="$(dirname "${BASH_SOURCE[0]}")";
	local _D="${_d}/../../..";

	local www="${_D}/etc/docker/images/www";

	local dk_reg="$(<${www} grep '^reg' | cut -f2)";
	local dk_user="$(<${www} grep '^user' | cut -f2)";
	local dk_repo="$(<${www} grep '^repo' | cut -f2)";
	local dk_repository="${dk_reg}/${dk_user}/${dk_repo}";

	sed "\%^lbl	%s%	.*%	${version}%" \
		-i ${_D}/etc/docker/images/www;
	sed "\%${dk_repository}:%s%${dk_repo}:.*\"%${dk_repo}:${version}\"%" \
		-i ${_D}/etc/kubernetes/manifests/030_deploy.yaml;
	sed "\%${dk_repository}:%s%${dk_repo}:.*\"%${dk_repo}:${version}\"%" \
		-i ${_D}/etc/swarm/manifests/compose.yaml;
	sed "\%Version:%s%\(<.*>\)\(.*\)\(</.*>\)%\1${version}\3%" \
		-i ${_D}/srv/www/index.html;
	sed "\%^version	%s%	.*%	${version}%" \
		-i ${_D}/.config;
}
