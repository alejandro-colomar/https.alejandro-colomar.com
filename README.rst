This project consists of an HTML static website powered by NginX.


________________________________________________________________________________

Versioning
==========

Releasing will create the x86_64 docker image.  However, DockerHub only
automates x86_64; for other architectures, and for the multi-arch
docker manifest, which is needed for the deployment, the images have to be
built manually in machines of the supported architectures.

Pre-release a test version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	./bin/release_test	 X.Y-extraversion;
	git push origin		vX.Y-extraversion;

Release a stable version
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	./bin/release_stable	 X.Y;
	git push origin		vX.Y;

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

Specify the digests of the multi-arch Docker image manifest
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To avoid loading different docker images with the same name (possibly crafted
by crackers), we should specify the digests of the docker image manifest for
production releases.  Based on a stable image, specify the digest of the image
in <./etc/docker/images/www>, and release a patch.  In the code below,
`DIGEST_*` shall be replaced by the appropriate digest.  Note that the `main`
branch shall not receive the patches `vX.Y.0`, and should instead continue
from `vX.Y`, so after running the code below and deploying the image, the user
should use `git switch main`.

.. code-block:: BASH

	git checkout	vX.Y;
	sed -i '/digest	aarch64/s/<digest>/DIGEST_arm64/' etc/docker/images/www;
	sed -i '/digest	x86_64/s/<digest>/DIGEST_amd64/' etc/docker/images/www;
	make digest;
	git commit -am 'Specify digest of X.Y';
	git tag -a vX.Y.0 -m 'Release X.Y.0';
	git push origin	vX.Y.0;

Continue after a release + patch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Note that the `main` branch shall not receive the patches `vX.Y.0`, and should
instead continue from `vX.Y`, so after running the code above and deploying
the image, the user should go back to `main`.

.. code-block:: BASH

	git checkout main;


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

- `Pre-release an test version`_ (see above).

- `Build and push multi-arch Docker image manifest`_ (see above).

- Deploy the test pre-release at port 31001:

.. code-block:: BASH

	sudo make stack-deploy;


- If the pre-release isn't good engough, that deployment has to be removed.
  The current stable deployment is left untouched.

.. code-block:: BASH

	make stack-rm-test;


- Else, if the pre-release passes the tests, the published port should be
  forwarded to 31001 (this is done in the nlb repository).

- `Release a stable version`_ (see above).

- `Specify the digests of the multi-arch Docker image manifest`_ (see above)

- Remove the oldstable release, and deploy the stable release at port 30001:

.. code-block:: BASH

	make stack-rm-stable;
	sudo make stack-deploy;

- The published port should be forwarded back to 30001 (this is done in
  the nlb repository).

- Remove the test deployment at port 31001:

.. code-block:: BASH

	make stack-rm-test;


________________________________________________________________________________

Kubernetes | OpenShift
======================

To use kubernetes or openshift, simply replace "swarm" by "kubernetes"
or "openshift", in <./etc/docker/orchestrator>.  Then, and after setting up
the corresponding cluster, follow the same steps above.
