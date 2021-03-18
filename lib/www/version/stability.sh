################################################################################
#	Copyright (C) 2020        Alejandro Colomar Andrés
#	SPDX-License-Identifier:  GPL-2.0-only
################################################################################


function update_stability()
{
	local stability="$1";
	local _d="$(dirname "${BASH_SOURCE[0]}")";
	local _D="${_d}/../../..";

	local prj="$(<${_D}/.config grep '^project' | cut -f2)";

	sed -i \
		-e "/^stable	/s/	.*/	${stability}/" \
		-e "/^stack	/s/	${prj}-.*/	${prj}-${stability}/" \
		${_D}/.config;
}
