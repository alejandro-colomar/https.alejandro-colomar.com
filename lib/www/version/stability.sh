################################################################################
#	Copyright (C) 2020        Alejandro Colomar Andrés
#	SPDX-License-Identifier:  GPL-2.0-only
################################################################################


function update_stability()
{
	local	stability="$1";

	sed "/WWW_STABILITY=/s/\".*\"\;/\"${stability}\"\;/" \
		-i ./etc/www/config.sh;
}
