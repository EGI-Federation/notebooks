FAQ (Frequently Asked Questions)
--------------------------------

How do I install library *X*?
=============================

You can install new software easily on the notebooks using ``conda`` or
``pip``. The ``%conda`` and ``%pip`` `magics <https://ipython.readthedocs.io/en/stable/interactive/magics.html#magic-conda>`_
can be used in a cell of your notebooks to do so, e.g. installing ``rdkit``:

.. code-block:: pycon

   %conda install rdkit


Once installed you can import the libray as usual.

.. note::

   Any modifications to the libraries/software of your notebooks will
   be lost when your notebook server is stoped (automatically after
   1 hour of inactivity)!

Can I request library *X* to be installed permanently?
======================================================

Yes! Just let us know what are your needs. You can contact us via:

* Opening a ticket in the `EGI Helpdesk <https://ggus.eu>`_, or

* Creating a `Github Issue <https://github.com/EGI-foundation/notebooks/issues>`_

We will analyse your request and get back to you.
