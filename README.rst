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

Pre-release an unstable version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	./bin/release_unstable	<version>;

Release a stable version
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	./bin/release_stable	<version>;

Build and push arch-specific Docker images
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The image will have the architecture of the machine in which it is run.
For various architectures, simply run in various machines.

.. code-block:: BASH

	make image && make image-push;

Build and push multi-arch Docker image manifest
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This step requires that arch-specific images of all supported architectures are
already pushed to the Docker registry (see
`Build and push arch-specific Docker images`_).

.. code-block:: BASH

	make image-manifest && make image-manifest-push;


________________________________________________________________________________

Deployment
==========

This repository assumes a docker swarm is already running.  See the
`parent repository`_ to know how to prepare the machines for docker swarm.

_`parent repository`: https://github.com/alejandro-colomar/alejandro-colomar.git

Releases use port 30001.
Pre-releases use port 31001.

For a seamless deployment, the following steps need to be done:

- Assuming there is an old stack deployed at port 30001.

- `Pre-release an unstable version`_ (see above).

- `Build and push multi-arch Docker image manifest`_ (see above).

- Deploy the unstable pre-release at port 31001:

.. code-block:: BASH

	sudo make stack-deploy;


- If the pre-release isn't good engough, that deployment has to be removed.
  The current stable deployment is left untouched.

.. code-block:: BASH

	make stack-rm-unstable;


- Else, if the pre-release passes the tests, the published port should be
  forwarded to 31001 (this is done in the nlb repository).

- `Release a stable version`_ (see above).

- Remove the oldstable release, and deploy the stable release at port 30001:

.. code-block:: BASH

	make stack-rm-stable;
	sudo make stack-deploy;

- The published port should be forwarded back to 30001 (this is done in
  the nlb repository).

- Remove the unstable deployment at port 31001:

.. code-block:: BASH

	make stack-rm-unstable;


________________________________________________________________________________

Kubernetes | OpenShift
======================

To use kubernetes or openshift, simply replace "swarm" by "kubernetes"
or "openshift", in <./etc/docker/orchestrator>.  Then, and after setting up
the corresponding cluster, follow the same steps above.
