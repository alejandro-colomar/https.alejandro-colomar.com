################################################################################
#	Copyright (C) 2020        Alejandro Colomar Andrés
#	SPDX-License-Identifier:  GPL-2.0-only
################################################################################


function update_port()
{
	local	port="$1";

	sed "/nodePort:/s/:.*/: ${port}/" \
		-i ./etc/kubernetes/manifests/020_svc.yaml;
	sed "/ports/{n;s/\".*:/\"${port}:/}" \
		-i ./etc/swarm/manifests/compose.yaml;
}
