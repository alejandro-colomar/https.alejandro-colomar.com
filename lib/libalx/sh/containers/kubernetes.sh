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
function alx_kube_create_configmaps__()
{
	local	project="$1";
	local	stack="$2";
	local	cm_files=$(find -L "/run/configs/${project}/" -type f);

	alx_cp_configs	"${project}";

	for file in ${cm_files}; do
		cm="${file#/run/configs/${project}/}";
		cm="${cm//\//-}";
		cm="${cm//./-}";
		cm="${cm//_/-}";
		cm="${cm}-${project}-cm";
		kubectl create configmap "${cm}" --from-file "${file}"	\
				-n "${stack}";
	done

	alx_shred_configs	"${project}";
}

## sudo
function alx_kube_create_secrets__()
{
	local	project="$1";
	local	stack="$2";
	local	secret_files=$(find -L "/run/secrets/${project}/" -type f);

	alx_cp_secrets	"${project}";

	for file in ${secret_files}; do
		secret="${file#/run/secrets/${project}/}";
		secret="${secret//\//-}";
		secret="${secret//./-}";
		secret="${secret//_/-}";
		secret="${secret}-${project}-secret";
		kubectl create secret generic "${secret}"		\
				--from-file "${file}" -n "${stack}";
	done

	alx_shred_secrets	"${project}";
}

## sudo
function alx_kube_deploy()
{
	local	project="$1";
	local	stack="$2";
	local	yaml_files=$(find -L "etc/docker/kubernetes/" -type f |sort);

	kubectl create namespace "${stack}";
	alx_kube_create_configmaps__	"${project}" "${stack}";
	alx_kube_create_secrets__	"${project}" "${stack}";
	for file in ${yaml_files}; do
		kubectl apply -f "${file}" -n "${stack}";
	done
}

function alx_kube_delete()
{
	local	stack="$1";

	kubectl delete namespace "${stack}";
}


################################################################################
##	end of file							      ##
################################################################################
