################################################################################
#	Copyright (C) 2020        Alejandro Colomar Andrés
#	SPDX-License-Identifier:  GPL-2.0-only
################################################################################


function update_date()
{
	find srv/www/ -type f \
	|grep -v 'srv/www/share/' \
	|while read -r f; do
		local d="$(git log -1 --format='%ai' -- "${f}"
			|xargs date '+%b/%Y' -d)";

		sed -i -E "\%Last modified:%s%(<time>)(.*)(</time>)%\1${d}\3%" \
			"${f}";
	done;
}
