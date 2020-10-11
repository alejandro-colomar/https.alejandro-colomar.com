################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Generate the configmaps and secrets
## ===================================
##
################################################################################


################################################################################
##	source								      ##
################################################################################


################################################################################
##	definitions							      ##
################################################################################


################################################################################
##	functions							      ##
################################################################################
## sudo
function alx_kube_create_configmaps()
{
	local	project="$1";
	local	stack="$2";

	for file in $(find /run/configs -type f); do
		cm="${file#/run/configs/}";
		cm="${cm//\//_}";
		cm="${cm//./_}";
		cm="${cm}.${project}.cm";
		kubectl create configmap "${cm}" --from-file "${file}"	\
				-n "${stack}";
	done
}

## sudo
function alx_kube_create_secrets()
{
	local	project="$1";
	local	stack="$2";

	for file in $(find /run/secrets -type f); do
		secret="${file#/run/secrets/}";
		secret="${secret//\//_}";
		secret="${secret//./_}";
		secret="${secret}.${project}.secret";
		kubectl create secret generic "${secret}"		\
				--from-file "${file}" -n "${stack}";
	done
}


################################################################################
##	end of file							      ##
################################################################################
