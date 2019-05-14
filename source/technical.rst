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

.. image:: /_static/egi_notebooks_architecture.png

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

.. Ideas for future development
   ::::::::::::::::::::::::::::

   * Provide a way to parametrise and execute notebooks like https://github.com/nteract/papermill

EGI Customisations
::::::::::::::::::

EGI Notebooks is deployed as a set of customisations of the `JupyterHub helm
charts <https://jupyterhub.github.io/helm-chart/>`_.


Authentication
==============

EGI Check-in can be easily configured as a OAuth2.0 provider for `JupyterHub's
oauthenticator <https://github.com/jupyterhub/oauthenticator>`_. See below a
sample configuration for the helm chart using Check-in production environment:

.. code-block:: yaml

   hub:
     extraEnv:
       OAUTH2_AUTHORIZE_URL: https://aai.egi.eu/oidc/authorize
       OAUTH2_TOKEN_URL: https://aai.egi.eu/oidc/token
       OAUTH_CALLBACK_URL: https://<your host>/hub/oauth_callback

   auth:
     type: custom
     custom:
       className: oauthenticator.generic.GenericOAuthenticator
       config:
         login_service: "EGI Check-in"
         client_id: "<your client id>"
         client_secret: "<your client secret>"
         oauth_callback_url: "https://<your host>/hub/oauth_callback"
         username_key: "sub"
         token_url: "https://aai.egi.eu/oidc/token"
         userdata_url: "https://aai.egi.eu/oidc/userinfo"
         scope: ["openid", "profile", "email", "eduperson_scoped_affiliation", "eduperson_entitlement"]


To simplify the configuration and to add refresh capabilities to the
credentials, we have created a new `EGI Check-in authenticator <https://github.com/enolfc/oauthenticator>`_
that can be configued as follows:

.. code-block:: yaml

   auth:
     state:
       enabled: true
       cryptoKey: <some unique crypto key>
     type: custom
     custom:
       className: oauthenticator.egicheckin.EGICheckinAuthenticator
       config:
         client_id: "<your client id>"
         client_secret: "<your client secret>"
         oauth_callback_url: "https://<your host>/hub/oauth_callback"
         scope: ["openid", "profile", "email", "offline_access", "eduperson_scoped_affiliation", "eduperson_entitlement"]


The ``auth.state`` configuration allows to store refresh tokens for the users
that will allow to get up-to-date valid credentials as needed.

Accounting
==========

.. warning::

   documentation is not yet final!


`Accounting module <https://github.com/EGI-Foundation/egi-notebooks-accounting>`_
generates VM-like accounting records for each of the notebooks started at the
service. It's available as a `helm chart <https://egi-foundation.github.io/egi-notebooks-chart/>_`
that can be deployed in the same namespace as the JupyterHub chart. The only
needed configuration for the chart is an IGTF-recognised certificate for the
host registered in GOCDB as accounting.


.. code-block:: yaml

   ssm:
     hostcert: |-
       <hostcert>
     hostkey: |-
       <hostkey>


Monitoring
==========

`Monitoring <https://github.com/EGI-Foundation/egi-notebooks-monitoring>`_ is
performed by trying to execute a user notebook every hour. This is accomplished
by registering a new service in the hub that has admin permissions. Monitoring
is then deployed as a `helm chart <https://egi-foundation.github.io/egi-notebooks-chart/>_`
that must be deployed in the same namespace as the JupyterHub chart.
Configuration of JupyterHub must include this section:

.. code-block:: yaml

   hub:
     services:
       status:
          url: "http://status-web/"
          admin: true
          apiToken: "<a unique API token>"


Likewise the monitoring chart is configured as follows:

.. code-block:: yaml

  service:
    api_token: "<same API token as above>"
