Service Architecture
--------------------

The EGI Notebooks service relies on the following technologies to provide its
functionality:

* `JupyterHub <https://github.com/jupyterhub/jupyterhub>`_ with custom
  `EGI Check-in oauthentication <https://github.com/enolfc/oauthenticator>`_
  configured to spawn pods on Kubernetes.

* `Kubernetes <https://kubernetes.io/>`_ as container orchestration platform
  running on top of EGI Cloud resources. Within the service it is in charge of
  managing the allocated resources and providing the right abstraction to
  deploy the containers that build the service. Resources are provided by EGI
  Federated Cloud providers, including persistent storage for users notebooks.

* CA authority to allocate recognised certificates for the HTTPS server

* `Prometheus <https://prometheus.io/>`_ for monitoring resource consumption.

* Specific EGI hooks for `monitoring <https://github.com/EGI-Foundation/egi-notebooks-monitoring>`_
  and `accounting <https://github.com/EGI-Foundation/egi-notebooks-accounting>`_.

* VO-Specific storage/Big data facilities or any pluggable tools into the
  notebooks environment can be added to community specific instances.

.. [[File:EGI_Notebooks_Stack.png|center|650px|EGI Notebooks Achitecture]]

Kubernetes
::::::::::

A Kubernetes (k8s) cluster deployed into a resource provider is in charge of
managing the containers that will provide the service. On this cluster there are:

* 1 master node that manages the whole cluster

* Support for load balancer or alternatively 1 or more edge nodes with a
  public IP and corresponding public DNS name (e.g. notebooks.egi.eu) where
  a k8s ingress HTTP reverse proxy redirects requests from user to other
  components of the service. The HTTP server has a valid certificate from
  one CA recognised at most browsers (e.g. Let's Encrypt).

* 1 or more nodes that host the JupyterHub server, the notebooks servers where
  the users will run their notebooks. Hub is deployed using the
  `JupyterHub helm charts <https://jupyterhub.github.io/helm-chart/>`_. These
  nodes should have enough capacity to run as many concurrent user notebooks as
  needed. Main constraint is usually memory.

* Support for `Kubernetes PersistentVolumeClaims <https://kubernetes.io/docs/concepts/storage/persistent-volumes/>`_
  for storing the persistent folders. Default EGI-Notebooks installation
  uses NFS, but any other volume type with ReadWriteOnce capabilities can be
  used.

* Prometheus installation to monitor the usage of resources so accounting
  records are generated.

All communication with the user goes via HTTPS and the service only needs a
publicly accessible entry point (public IP with resolvable name)

Monitoring and accounting are provided by hooking into the respective monitoring
and accounting EGI services.

There are no specific hardware requirements and the whole environment can run
on commodity virtual machines.

Ideas for future development
::::::::::::::::::::::::::::

* Provide a way to parametrise and execute notebooks like https://github.com/nteract/papermill

