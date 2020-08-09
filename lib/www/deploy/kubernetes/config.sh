################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Generate the config maps
## ========================
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
function kube_create_configmaps()
{
	local	namespace="$1";

	kubectl create configmap "etc-nginx-confd-cm"			\
		--from-file "/run/configs/www/etc/nginx/conf.d/security-parameters.conf" \
		--from-file "/run/configs/www/etc/nginx/conf.d/server.conf" \
		-n "${namespace}";
}

## sudo
#function create_secrets()
#{
#}


################################################################################
##	end of file							      ##
################################################################################
