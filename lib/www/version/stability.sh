################################################################################
#	Copyright (C) 2020        Alejandro Colomar Andrés
#	SPDX-License-Identifier:  GPL-2.0-only
################################################################################


function update_stability()
{
	local stability="$1";
	local _d="$(dirname "${BASH_SOURCE[0]}")";
	local _D="${_d}/../../..";

	sed -i "/stability	/s/	.*/	${stability}/" ${_D}/.config;
}
