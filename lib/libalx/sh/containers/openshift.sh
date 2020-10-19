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
source	lib/libalx/sh/containers/kubernetes.sh;


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

	alx_kube_create_configmaps__	"${project}" "${stack}";
}

## sudo
function alx_oc_create_secrets__()
{
	local	project="$1";
	local	stack="$2";

	alx_kube_create_secrets__	"${project}" "${stack}";
}

## sudo
function alx_oc_deploy()
{
	local	project="$1";
	local	stack="$2";
	local	yaml_files=$(find -L "etc/docker/openshift/" -type f |sort);

	oc new-project "${stack}";
	alx_oc_create_configmaps__	"${project}" "${stack}";
	alx_oc_create_secrets__		"${project}" "${stack}";
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
