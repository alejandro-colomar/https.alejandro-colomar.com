################################################################################
#	Copyright (C) 2020        Alejandro Colomar Andrés
#	SPDX-License-Identifier:  GPL-2.0-only
################################################################################


function update_version()
{
	local	version="$1";

	sed "\%alejandrocolomar\/www:%s%www:.*\"%www:${version}\"%" \
		-i ./etc/kubernetes/manifests/030_deploy.yaml;
	sed "\%alejandrocolomar\/www:%s%www:.*\"%www:${version}\"%" \
		-i ./etc/swarm/manifests/compose.yaml;
	sed "\%WWW_VERSION=%s%\".*\";%\"${version}\";%" \
		-i ./etc/www/config.sh;
	sed "\%Version:%s%\(<.*>\)\(.*\)\(</.*>\)%\1${version}\3%" \
		-i ./srv/www/index.html;
}
