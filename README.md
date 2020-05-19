This project consists of an HTML static website powered by NginX.

The website is deployed in AWS on a production-grade highly available and secure infrastructure consisting of private and public subnets, NAT gateways, security groups and application load balancers in order to ensure the isolation and resilience of the different components.

You can set up your infrastructure in AWS running the following commands from a terminal in a Cloud9 environment with enough privileges.
You may also configure the variables so as to customize the setup:

```BASH 


#########################################################################
apps=" web "								;
AWS=secobau/docker/master/AWS						;
debug=false                                                     	;
debug=true                                                     		;
deploy=latest                                                   	;
deploy=release                                                   	;
domain=raw.githubusercontent.com					;
HostedZoneName=example.com                                  	 	;
HostedZoneName=alejandro-colomar.com                                   	;
# Identifier is the ID of the certificate in case you are using HTTPS	#
Identifier=8245427e-fbfa-4f2b-b23f-97f13d6d3e7c				;
KeyName=mySSHpublicKey							;
KeyName=proxy2aws							;
mode=Kubernetes                                                       	;
mode=Swarm                                                       	;
RecordSetName1=service-1                                   		;
RecordSetName1=www                                   			;
RecordSetName2=service-2                                   		;
RecordSetName2=downloads                                   		;
RecordSetName3=service-3                                   		;
RecordSetName3=ca                                   			;
repository=myproject							;
repository=www.alejandro-colomar.com					;
stack=$repository                                                     	;
username=johndoe							;
username=secobau							;
#########################################################################
export apps								;
export AWS								;
export debug								;
export deploy								;
export domain								;
export HostedZoneName							;
export Identifier							;
export KeyName								;
export mode								;
export RecordSetName1							;
export RecordSetName2							;
export RecordSetName3							;
export repository							;
export stack								;
export username								;
#########################################################################
path=$AWS								;
file=init.sh								;
date=$( date +%F_%H%M )							;
mkdir $date								;
cd $date								;
curl --remote-name https://$domain/$path/$file				;
chmod +x ./$file							;
nohup ./$file								&
#########################################################################



```

