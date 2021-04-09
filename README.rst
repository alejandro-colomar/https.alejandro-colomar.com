This project consists of an HTML static website powered by NginX.


________________________________________________________________________

Versioning
==========

Pre-release a test version
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	./bin/release_test	 X.Y-extraversion;
	git push origin		vX.Y-extraversion;

Release a stable version
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: BASH

	./bin/release_stable	 X.Y;
	git push origin		vX.Y;

Build and push multi-arch Docker images
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This creates and pushes images for all the supported architectures from
a single building machine, and also a multi-arch manifest.  This command
also stores the digest of the created images in ``<./etc/docker/images/www>``.

To avoid loading different docker images with the same name (possibly crafted
by crackers), the build system specifies the digests of the docker images
in ``<./etc/docker/images/www>``.

.. code-block:: BASH

	make image;

Release first patch vX.Y.0
^^^^^^^^^^^^^^^^^^^^^^^^^^

The previous ``make image`` stored the digest of the released image.  The
stable releases need to use that image, so the first patch will do that.

.. code-block:: BASH

	git checkout	vX.Y;
	make digest;
	git commit -am 'Specify digest of X.Y';
	git tag -a vX.Y.0 -m 'Release X.Y.0';
	git push origin	vX.Y.0;

Continue after a release + patch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Note that the ``main`` branch shall not receive the patches ``vX.Y.Z``, and
should instead continue from ``vX.Y``, so after running the code above and
deploying the image, the user should go back to ``main``.

.. code-block:: BASH

	git checkout main;


________________________________________________________________________

Deployment
==========

This repository assumes a docker swarm is already running.  See the
`parent repository`_ to know how to prepare the machines for docker swarm.

Releases use port 30001.
Pre-releases use port 31001.

For a seamless deployment, the following steps need to be done:

- Assuming there is an old stack deployed at port 30001.

- `Pre-release a test version`_ (see above).

- `Build and push multi-arch Docker images`_ (see above).

- Deploy the test pre-release at port 31001:

.. code-block:: BASH

	sudo make stack-deploy;


- If the pre-release isn't good engough, that deployment has to be removed.
  The current stable deployment is left untouched.

.. code-block:: BASH

	make stack-rm-test;


- Else, if the pre-release passes the tests, the published port should be
  forwarded to 31001 (this is done in the nlb_ repository).

- `Release a stable version`_ (see above).

- `Build and push multi-arch Docker images`_ (see above).

- `Release first patch vX.Y.0`_ (see above).

- Remove the oldstable release, and deploy the stable release at port 30001:

.. code-block:: BASH

	make stack-rm-stable;
	sudo make stack-deploy;

- The published port should be forwarded back to 30001 (this is done in
  the nlb_ repository).

- Remove the test deployment at port 31001:

.. code-block:: BASH

	make stack-rm-test;


________________________________________________________________________

Kubernetes | OpenShift
======================

To use kubernetes or openshift, simply replace ``swarm`` by ``kubernetes``
or ``openshift``, in ``<./etc/docker/orchestrator>``.  Then, and after setting
up the corresponding cluster, follow the same steps above.


________________________________________________________________________

_`parent repository`: https://github.com/alejandro-colomar/server.git

_`nlb`: https://github.com/alejandro-colomar/nlb.git
