Welcome to the Armor PowerShell Module
========================

.. image:: https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6/branch/master?svg=true
   :target: https://ci.appveyor.com/project/tlindsay42/armorpowershell/branch/master
   :alt: Windows PowerShell Status

.. image:: https://travis-ci.org/tlindsay42/ArmorPowerShell.svg?branch=master
   :target: https://travis-ci.org/tlindsay42/ArmorPowerShell
   :alt: PowerShell Core Status


.. image:: https://coveralls.io/repos/github/tlindsay42/ArmorPowerShell/badge.svg?branch=master
   :target: https://coveralls.io/github/tlindsay42/ArmorPowerShell?branch=master
   :alt: Code Coverage Status

.. image:: https://readthedocs.org/projects/armorpowershell/badge/?version=latest
   :target: http://armorpowershell.readthedocs.io/en/latest/?badge=latest
   :alt: Documentation Status

.. image:: https://img.shields.io/badge/install-PS%20Gallery-blue.svg
   :target: https://www.powershellgallery.com/packages/armor
   :alt: PowerShell Gallery

This is a community project that provides a powerful command-line interface for managing and monitoring your `Armor Complete`_ (secure public cloud) and `Armor Anywhere`_ (security as a service) environments & accounts via a PowerShell module with cmdlets that interact with the published `RESTful APIs`_.  It is continuously tested on Windows Server via `AppVeyor`_, as well as on Ubuntu Linux and macOS via `Travis CI`_, and it is published on the `PowerShell Gallery`_.  The code is open source, and `available on GitHub`_.

.. _Armor Complete: https://www.armor.com/armor-complete-secure-hosting/

.. _Armor Anywhere: https://www.armor.com/armor-anywhere-security/

.. _RESTful APIs: https://docs.armor.com/display/KBSS/Armor+API+Guide

.. _AppVeyor: https://ci.appveyor.com/project/tlindsay42/ArmorPowerShell

.. _Travis CI: https://travis-ci.org/tlindsay42/ArmorPowerShell

.. _PowerShell Gallery: https://www.powershellgallery.com/packages/Armor

.. _available on GitHub: https://github.com/tlindsay42/ArmorPowerShell

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: User Documentation

   requirements
   install
	 update
	 uninstall
   getting_started
   project_architecture
   support
   contribution
   licensing
   faq

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Command Documentation
   
   cmd_connect
   cmd_disconnect
   cmd_get
   cmd_invoke
   cmd_rename
   cmd_reset
   cmd_restart
   cmd_set
   cmd_start
   cmd_stop

