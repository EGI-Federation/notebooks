Notebooks Service
-----------------

Unique Features
:::::::::::::::

EGI Notebooks provides the well-known Jupyter interface for notebooks with the
following added features:

* Integration with EGI Check-in for authentication, login with any EduGAIN or
  social accounts (e.g. Google, Facebook)

* Persistent storage associated to each user, available in the notebooks
  environment.

* Customisable with new notebook environments, expose any existing notebook to
  your users.

* Runs on EGI e-Infrastructure so can easily use EGI compute and storage from
  your notebooks.


Service Modes
:::::::::::::

We offer different service modes depending on your needs:

* Individual users can use the centrally operated service from EGI. Users,
  after lightweight approval, can login, write and play and re-play notebooks.
  Notebooks can use storage and compute capacity from the access.egi.eu
  Virtual Organisation. Request access via 
  `EGI marketplace <https://marketplace.egi.eu/applications-on-demand-beta/65-jupyter.html>`_.

* User communities can have their customised EGI Notebooks service instance.
  EGI offers consultancy and support, as well as can operate the setup.
  Contact support@egi.eu to make an arrangement. A community specific setup
  allows the community to use the community's own Virtual Organisation
  (i.e. federated compute and storage sites) for Jupyter, add custom libraries
  into Jupyter (e.g. discipline-specific analysis libraries) or have fine
  grained control on who can access the instance (based on the information
  available to the EGI Check-in AAI service).

.. BinderHub mode that allows to recreate notebooks from existing repositories
   making the code immediately reproducible by anyone, anywhere. While under
   development, this option does not have persistent storage and does not
   require authentication, there is ongoing work to integrate with the modes
   described above. Alpha instance available at https://binderhub.fedcloud-tf.fedcloud.eu
