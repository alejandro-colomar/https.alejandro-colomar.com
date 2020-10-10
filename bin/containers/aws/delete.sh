#!/bin/bash -x
##	./bin/containers/aws/delete.sh
###############################################################################
##       Copyright (C) 2020        Sebastian Francisco Colomar Bauza         ##
##       Copyright (C) 2020        Alejandro Colomar Andrés                  ##
##       SPDX-License-Identifier:  GPL-2.0-only                              ##
###############################################################################


################################################################################
## TO REMOVE THE CLOUDFORMATION STACK
stack="web";

aws cloudformation delete-stack --stack-name ${stack};


################################################################################
##	end of file							      ##
################################################################################
