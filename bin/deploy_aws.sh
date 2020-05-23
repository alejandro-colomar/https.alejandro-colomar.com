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
branch=master
debug=false
debug=true
deploy=latest
deploy=release
docker_branch=v1.0
HostedZoneName=example.com
HostedZoneName=alejandro-colomar.com
## Identifier is the ID of the certificate in case you are using HTTPS
Identifier=8245427e-fbfa-4f2b-b23f-97f13d6d3e7c
KeyName=mySSHpublicKey
KeyName=proxy2aws
mode=kubernetes
mode=swarm
RecordSetName1=service-1
RecordSetName1=www
RecordSetName2=service-2
RecordSetName2=downloads
RecordSetName3=service-3
RecordSetName3=ca
repository=myproject
repository=www.alejandro-colomar
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
export AWS=secobau/docker-aws/${docker_branch}
export branch
export debug
export deploy
export docker_branch
export domain=raw.githubusercontent.com
export HostedZoneName
export Identifier
export KeyName
export mode
export RecordSetName1
export RecordSetName2
export RecordSetName3
export repository
export s3name=docker-aws
export s3region=ap-south-1
export stack
export template=cloudformation-https.yaml
export TypeManager
export TypeWorker
export username


################################################################################
##	run								      ##
################################################################################
fpath=${AWS}/bin
fname=init.sh
date=$( date +%F_%H%M )
path=$HOME/.${repository}/var
mkdir --parents ${path}/${date}
cd	${path}/${date}
curl --remote-name https://${domain}/${fpath}/${fname}
chmod +x ./${fname}
nohup	./${fname} &


################################################################################
##	end of file							      ##
################################################################################
