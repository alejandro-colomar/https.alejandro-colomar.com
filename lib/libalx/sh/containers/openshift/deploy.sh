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
source	lib/libalx/sh/containers/openshift/config.sh;


################################################################################
##	definitions							      ##
################################################################################


################################################################################
##	functions							      ##
################################################################################
## sudo
function alx_oc_deploy()
{
	local	project="$1";
	local	stack="$2";
	local	yaml_files=$(find "etc/docker/openshift/" -type f |sort);

	alx_cp_configs	"${project}";
	alx_cp_secrets	"${project}";

	oc new-project "${stack}";
	alx_oc_create_configmaps	"${project}" "${stack}";
	alx_oc_create_secrets		"${project}" "${stack}";
	for file in ${yaml_files}; do
		oc apply -f "${file}" -n "${stack}";
	done

	alx_shred_secrets	"${project}";
	alx_shred_configs	"${project}";
}


################################################################################
##	end of file							      ##
################################################################################
