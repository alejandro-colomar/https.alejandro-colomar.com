#!/bin/bash
###############################################################################
##       Copyright (C) 2020        Sebastian Francisco Colomar Bauza         ##
##       Copyright (C) 2020        Alejandro Colomar Andrés                  ##
##       SPDX-License-Identifier:  GPL-2.0-only                              ##
###############################################################################


################################################################################
##	variables							      ##
################################################################################
apps=" web "
AWS=secobau/docker/master/AWS
debug=false
debug=true
deploy=latest
deploy=release
domain=raw.githubusercontent.com
HostedZoneName=example.com
HostedZoneName=alejandro-colomar.com
## Identifier is the ID of the certificate in case you are using HTTPS
Identifier=8245427e-fbfa-4f2b-b23f-97f13d6d3e7c
KeyName=mySSHpublicKey
KeyName=proxy2aws
mode=Kubernetes
mode=Swarm
RecordSetName1=service-1
RecordSetName1=www
RecordSetName2=service-2
RecordSetName2=downloads
RecordSetName3=service-3
RecordSetName3=ca
repository=myproject
repository=www.alejandro-colomar.bit
stack=web
username=johndoe
username=alejandro-colomar
################################################################################
export apps
export AWS
export debug
export deploy
export domain
export HostedZoneName
export Identifier
export KeyName
export mode
export RecordSetName1
export RecordSetName2
export RecordSetName3
export repository
export stack
export username


################################################################################
##	functions							      ##
################################################################################
create_new_dir()
{
	local	date=$( date +%F_%H%M )

	mkdir	${date}
	cd	${date}
}

run_aws_init_script()
{
	local	fpath=${AWS}
	local	fname="init.sh"

	curl --remote-name https://${domain}/${path}/${file}
	chmod +x ./${fname}
	nohup	./${fname} &
}


################################################################################
##	main								      ##
################################################################################
main()
{

	create_new_dir
	run_aws_init_script
}


################################################################################
##	run								      ##
################################################################################
main


################################################################################
##	end of file							      ##
################################################################################
