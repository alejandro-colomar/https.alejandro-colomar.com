################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Deploy/delete stack
## ===================
##
################################################################################


################################################################################
##	source								      ##
################################################################################
source	lib/libalx/sh/containers/common.sh;


################################################################################
##	definitions							      ##
################################################################################


################################################################################
##	functions							      ##
################################################################################
## sudo
function alx_oc_create_configmaps__()
{
	local	project="$1";
	local	stack="$2";

	alx_cp_configs	"${project}";

	local	cm_files=$(find -L "/run/configs/${project}/" -type f);
	for file in ${cm_files}; do
		cm="${file#/run/configs/${project}/}";
		cm="${cm//\//-}";
		cm="${cm//./-}";
		cm="${cm//_/-}";
		cm="${cm}-${project}-cm";
		oc create configmap "${cm}" --from-file "${file}"	\
				-n "${stack}";
	done

	alx_shred_configs	"${project}";
}

## sudo
function alx_oc_create_secrets__()
{
	local	project="$1";
	local	stack="$2";

	alx_cp_secrets	"${project}";

	local	secret_files=$(find -L "/run/secrets/${project}/" -type f);
	for file in ${secret_files}; do
		secret="${file#/run/secrets/${project}/}";
		secret="${secret//\//-}";
		secret="${secret//./-}";
		secret="${secret//_/-}";
		secret="${secret}-${project}-secret";
		oc create secret generic "${secret}"		\
				--from-file "${file}" -n "${stack}";
	done

	alx_shred_secrets	"${project}";
}

## sudo
function alx_oc_deploy()
{
	local	project="$1";
	local	stack="$2";

	oc new-project "${stack}";
	alx_oc_create_configmaps__	"${project}" "${stack}";
	alx_oc_create_secrets__		"${project}" "${stack}";

	local	yaml_files=$(find -L "etc/docker/openshift/" -type f |sort);
	for file in ${yaml_files}; do
		oc apply -f "${file}" -n "${stack}";
	done
}

function alx_oc_delete()
{
	local	stack="$1";

	oc delete project "${stack}";
}


################################################################################
##	end of file							      ##
################################################################################
