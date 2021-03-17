################################################################################
#	Copyright (C) 2020        Alejandro Colomar Andrés
#	SPDX-License-Identifier:  GPL-2.0-only
################################################################################


function update_digest()
{
	local _d="$(dirname "${BASH_SOURCE[0]}")";
	local _D="${_d}/../../../";
	. ${_D}/etc/www/config.sh;

	local dk_repo="${WWW_DK_REG}/${WWW_DK_USER}/${WWW_DK_REPO}";

	case "$(uname -m)" in
	x86_64)
		local digest="${WWW_DK_DIGEST_x86_64}";
		;;
	aarch64)
		local digest="${WWW_DK_DIGEST_aarch64}";
		;;
	esac;

	sed "\%${dk_repo}:%s%\"$%@${digest}\"%" \
		-i ./etc/kubernetes/manifests/030_deploy.yaml;
	sed "\%${dk_repo}:%s%\"$%@${digest}\"%" \
		-i ./etc/swarm/manifests/compose.yaml;
}
