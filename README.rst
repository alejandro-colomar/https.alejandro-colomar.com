This project consists of an HTML static website powered by NginX.


________________________________________________________________________________

Versioning
==========

Start working in a new branch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	git checkout -b <branch>;
	./bin/release/version.sh;
	./bin/release/port.sh 32001;
	git commit -a -m "Branch $(git branch --show-current)";

Pre-release an experimental version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Experimental pre-releases are named ending with ``-aX`` or ``-bX``.

.. code-block:: BASH

	exp_version=<exp-version>;
	./bin/release/version.sh ${exp_version};
	./bin/release/port.sh 32001;
	git commit -a -m "Pre-release ${exp_version}";
	git tag ${exp_version};

Pre-release a release-critical version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Release-critical pre-releases are named ending with ``-rcX``.

.. code-block:: BASH

	rc_version=<rc-version>;
	./bin/release/version.sh ${rc_version};
	./bin/release/port.sh 31001;
	git commit -a -m "Pre-release ${rc_version}";
	git tag -a ${rc_version} -m "";

Release a stable version
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	version=<version>;
	./bin/release/version.sh ${version};
	./bin/release/port.sh 30001;
	git commit -a -m "Release ${version}";
	git tag -a ${version} -m "";

Continue working in the current branch after a release
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	./bin/release/version.sh;
	./bin/release/port.sh 32001;
	git commit -a -m "Branch $(git branch --show-current)";


________________________________________________________________________________

Local deployment
================

This repository assumes a docker swarm is already running.  See
the `parent repository`_ to know how to prepare the machines for docker
swarm.

_`parent repository`: https://github.com/alejandro-colomar/alejandro-colomar.git

Releases use port 30001.
Release-critical pre-releases use port 31001.
Experimental deployments use ports 3x001 (x >= 2).

For a seamless deployment, the following steps need to be done:

- Assuming there is an old stack deployed at port 30001.

- Release a release-critical pre-release (see
  `Pre-release a release-critical version`_).

- Deploy the release-critical pre-release at port 31001:

.. code-block:: BASH

	sudo ./bin/deploy/deploy.sh;


- If the pre-release isn't good engough, that deployment has to be
  removed (see following command), and then work continues in the
  current branch (see
  `Continue working in the current branch after a release`_).  The
  current stable deployment is left untouched.

.. code-block:: BASH

	## rc_version should match $(git describe --tags)
	docker stack rm www_${rc_version};


- Else, if the pre-release passes the tests, the published port will
  be forwarded to 31001 (this is done in the parent repository).

- Release a new stable version (see `Release a stable version`_).

- Deploy the stable release at port 30001:

.. code-block:: BASH

	sudo ./bin/deploy/deploy.sh;

- The published port will be forwarded back to 30001 (this is done in
  the parent repository).

- Remove the deployment at port 31001:

.. code-block:: BASH

	## rc_version should end in ``-rcX``
	docker stack rm www_${rc_version};


________________________________________________________________________________

AWS
===

The website can be deployed in AWS on a production-grade highly
available and secure infrastructure consisting of private and public
subnets, NAT gateways, security groups and application load balancers
in order to ensure the isolation and resilience of the different
components.

You can set up your infrastructure in AWS running the following
script from a terminal in a Cloud9 environment with enough
privileges:

.. code-block:: BASH

	./bin/aws/deploy.sh

You may also reconfigure the variables so as to customize the setup:

.. code-block:: BASH

	etc/docker-aws/config.sh

You can optionally remove the AWS infrastructure created in
CloudFormation otherwise you might be charged for any created object:

.. code-block:: BASH

	./bin/aws/delete.sh
