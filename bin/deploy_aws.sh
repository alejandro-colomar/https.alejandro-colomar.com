#!/bin/bash
###############################################################################
##       Copyright (C) 2020        Sebastian Francisco Colomar Bauza         ##
##       Copyright (C) 2020        Alejandro Colomar Andrés                  ##
##       SPDX-License-Identifier:  GPL-2.0-only                              ##
###############################################################################


################################################################################
##	variables							      ##
################################################################################
apps=" web.yaml "
debug=false
debug=true
deploy=latest
deploy=release
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
stack=mystack
stack=web
TypeManager=t3a.nano
TypeWorker=t3a.nano
username=johndoe
username=alejandro-colomar


################################################################################
##	export								      ##
################################################################################
export apps
export AWS=secobau/docker/master/AWS
export debug
export deploy
export domain=raw.githubusercontent.com
export HostedZoneName
export Identifier
export KeyName
export mode
export RecordSetName1
export RecordSetName2
export RecordSetName3
export repository
export stack
export TypeManager
export TypeWorker
export username


################################################################################
##	run								      ##
################################################################################
path=${AWS}/Shell
fname=init.sh
date=$( date +%F_%H%M )
mkdir	${date}
cd	${date}
curl --remote-name https://${domain}/${path}/${fname}
chmod +x ./${fname}
nohup	./${fname} &


################################################################################
##	end of file							      ##
################################################################################
