This project consists of an HTML static website powered by NginX.


________________________________________________________________________________

All scripts in this repository are set up so that they have to be run
from the root directory of this repository.


________________________________________________________________________________

Versioning
==========

Releasing will create the x86_64 docker image.  However, DockerHub only
automates x86_64; for other architectures, and for the multi-arch
docker manifest, which is needed for the deployment, docker has to be
run manually in a building machine.

The following scripts don't automate the push step to the remote git
repository, as a caution.  Every automated commit should be checked by
a human before pushing.

Start working on a new branch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	git checkout -b <branch>;
	./bin/version/branch.sh;

Pre-release an experimental version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Experimental pre-releases are named ending with ``-aX`` or ``-bX``.

.. code-block:: BASH

	./bin/version/release_exp.sh	<exp-version>;

Pre-release a release-critical version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Release-critical pre-releases are named ending with ``-rcX``.

.. code-block:: BASH

	./bin/version/release_rc.sh	<rc-version>;

Release a stable version
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	./bin/version/release_stable.sh	<version>;

Continue working on the current branch after a release
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	./bin/version/branch.sh;


________________________________________________________________________________

Deployment
==========

This repository assumes a docker swarm is already running.  See
the `parent repository`_ to know how to prepare the machines for docker
swarm.

_`parent repository`: https://github.com/alejandro-colomar/alejandro-colomar.git

Releases use port 30001.
Release-critical pre-releases use port 31001.
Experimental deployments use port 32001.

For a seamless deployment, the following steps need to be done:

- Assuming there is an old stack deployed at port 30001.

- Release a release-critical pre-release (see
  `Pre-release a release-critical version`_):

.. code-block:: BASH

	./bin/version/release_rc.sh	<rc-version>;

- Deploy the release-critical pre-release at port 31001:

.. code-block:: BASH

	sudo ./bin/containers/deploy.sh	"swarm";


- If the pre-release isn't good engough, that deployment has to be
  removed (see following command), and then work continues in the
  current branch (see
  `Continue working on the current branch after a release`_).  The
  current stable deployment is left untouched.

.. code-block:: BASH

	./bin/containers/delete.sh	"swarm" "rc";

	./bin/version/branch.sh;


- Else, if the pre-release passes the tests, the published port should
  be forwarded to 31001 (this is done in the nlb repository).

- Release a new stable version (see `Release a stable version`_):

.. code-block:: BASH

	./bin/version/release_stable.sh	<version>;

- Deploy the stable release at port 30001:

.. code-block:: BASH

	./bin/containers/delete.sh	"swarm" "stable";
	sudo ./bin/containers/deploy.sh	"swarm";

- The published port should be forwarded back to 30001 (this is done in
  the nlb repository).

- Remove the deployment at port 31001:

.. code-block:: BASH

	./bin/containers/delete.sh	"swarm" "rc";


________________________________________________________________________________

Kubernetes | OpenShift
======================

There are scripts to deploy using kubernetes or openshift.  The
procedure is exactly the same as above, replacing the word "swarm" by
"kubernetes" or "openshift" as needed.
