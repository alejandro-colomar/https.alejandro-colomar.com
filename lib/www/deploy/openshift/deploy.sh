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
source	etc/www/config.sh;
source	lib/www/deploy/common/config.sh;
source	lib/www/deploy/openshift/config.sh;


################################################################################
##	definitions							      ##
################################################################################


################################################################################
##	functions							      ##
################################################################################
## sudo
function oc_deploy()
{
	local	namespace="${WWW_STACK_BASENAME}-${WWW_STABILITY}";

	prepare_configs;
	#prepare_secrets;

	oc new-project "${namespace}";
	oc_create_configmaps	"${namespace}";
	oc apply -f "etc/docker/openshift/deployment.yaml" -n "${namespace}";
	oc apply -f "etc/docker/openshift/network-policy.yaml" -n "${namespace}";
	oc apply -f "etc/docker/openshift/service.yaml" -n "${namespace}";
	oc apply -f "etc/docker/openshift/route.yaml" -n "${namespace}";
}


################################################################################
##	end of file							      ##
################################################################################
