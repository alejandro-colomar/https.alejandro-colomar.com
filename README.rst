This project consists of an HTML static website powered by NginX.

The website is deployed in AWS on a production-grade highly available
and secure infrastructure consisting of private and public subnets, NAT
gateways, security groups and application load balancers in order to
ensure the isolation and resilience of the different components.

You can set up your infrastructure in AWS running the following commands
from a terminal in a Cloud9 environment with enough privileges.
You may also configure the variables so as to customize the setup:

.. code-block:: BASH

	./bin/deploy_aws.sh


You can optionally remove the AWS infrastructure created in
CloudFormation otherwise you might be charged for any created object:

.. code-block:: BASH

	./bin/delete_aws.sh
