################################################################################
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################
##
## Copy configs and secrets into /run/
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
function alx_cp_configs()
{
	local	project="$1";

	mkdir -pv	/run/configs/;
	cp --remove-destination -LrvT					\
			run/configs/${project}/	/run/configs/${project};
}

## sudo
function alx_shred_configs()
{
	local	project="$1";

	for file in $(find "/run/configs/${project}/" -L -type f); do
		shred -fv --remove=wipe "${file}";
	done
	rm -rfv /run/configs/${project};
}

## sudo
function alx_cp_secrets()
{
	local	project="$1";

	mkdir -pv	/run/secrets/;
	cp --remove-destination -LrvT					\
			run/secrets/${project}/	/run/secrets/${project};
}

## sudo
function alx_shred_secrets()
{
	local	project="$1";

	for file in $(find "/run/secrets/${project}/" -L -type f); do
		shred -fv --remove=wipe "${file}";
	done
	rm -rfv /run/secrets/${project};
}


################################################################################
##	end of file							      ##
################################################################################
