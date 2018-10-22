Bring your custom notebooks
---------------------------

Adding new notebooks to the service just requires a working Docker image accessible from a public repository that follows these rules:

#.  It must install ``JupyterHub v0.9``
#.  It must **not** run as user ``root``, user with uid 1000 is recommended
#.  It must use ``$HOME`` as notebook directory

If you have such image, let us know so we can add it to the configuration.

.. Once binder integration is complete, you will be able to import any
   notebook just by providing the URL of a repository which contains
   your notebook.
