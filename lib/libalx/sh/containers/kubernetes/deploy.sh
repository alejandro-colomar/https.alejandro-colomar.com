################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Deploy stack
## ============
##
################################################################################


################################################################################
##	source								      ##
################################################################################
source	lib/libalx/sh/containers/common/config.sh;
source	lib/libalx/sh/containers/kubernetes/config.sh;


################################################################################
##	definitions							      ##
################################################################################


################################################################################
##	functions							      ##
################################################################################
## sudo
function alx_kube_deploy()
{
	local	project="$1";
	local	stack="$2";
	local	yaml_files=$(find "etc/docker/kubernetes/" -type f |sort);

	alx_cp_configs	"${project}";
	alx_cp_secrets	"${project}";

	kubectl create namespace "${stack}";
	alx_kube_create_configmaps	"${project}" "${stack}";
	alx_kube_create_secrets		"${project}" "${stack}";
	for file in ${yaml_files}; do
		kubectl apply -f "${file}" -n "${stack}";
	done

	alx_shred_secrets	"${project}";
	alx_shred_configs	"${project}";
}


################################################################################
##	end of file							      ##
################################################################################
