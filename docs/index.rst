Armor PowerShell Module
========================

.. image:: https://img.shields.io/powershellgallery/v/Armor.svg
   :target: https://www.powershellgallery.com/packages/Armor
   :alt: Current Version


.. image:: https://img.shields.io/powershellgallery/dt/Armor.svg
   :target: https://www.powershellgallery.com/packages/Armor
   :alt: Total Downloads



.. image:: https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6/branch/master?svg=true
   :target: https://ci.appveyor.com/project/tlindsay42/ArmorPowerShell/branch/master
   :alt: Build Status


.. image:: https://travis-ci.org/tlindsay42/ArmorPowerShell.svg?branch=master
   :target: https://travis-ci.org/tlindsay42/ArmorPowerShell
   :alt: Build Status


.. image:: https://coveralls.io/repos/github/tlindsay42/ArmorPowerShell/badge.svg?branch=master
   :target: https://coveralls.io/github/tlindsay42/ArmorPowerShell?branch=master
   :alt: Coverage Status


.. image:: https://readthedocs.org/projects/armorpowershell/badge/?version=latest
   :target: http://armorpowershell.readthedocs.io/en/latest/?badge=latest
   :alt: Documentation Status



.. image:: https://badges.gitter.im/ArmorPowerShell/Lobby.svg
   :target: https://gitter.im/ArmorPowerShell/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge
   :alt: Join the chat at https://gitter.im/ArmorPowerShell/Lobby



This is a community project that provides a powerful command-line interface for managing and monitoring your `Armor Complete`_ (secure public cloud) and `Armor Anywhere`_ (security as a service) environments & accounts via a PowerShell module with cmdlets that interact with the published `RESTful APIs`_.

Every code push is built on **Windows** via `AppVeyor`_, as well as on **macOS** and **Ubuntu Linux** via `Travis CI`_, and tested using the `Pester`_ test & mock framework.

Code coverage scores and reports showing how much of the project is covered by automated tests are tracked by `Coveralls`_.

Every successful build is published on the `PowerShell Gallery`_.

The source code is `available on GitHub`_. 

.. _Armor Complete: https://www.armor.com/armor-complete-secure-hosting/

.. _Armor Anywhere: https://www.armor.com/armor-anywhere-security/

.. _RESTful APIs: https://docs.armor.com/display/KBSS/Armor+API+Guide

.. _AppVeyor: https://ci.appveyor.com/project/tlindsay42/ArmorPowerShell/branch/master

.. _Travis CI: https://travis-ci.org/tlindsay42/ArmorPowerShell

.. _Pester: https://github.com/pester/Pester

.. _Coveralls: https://coveralls.io/github/tlindsay42/ArmorPowerShell?branch=master

.. _PowerShell Gallery: https://www.powershellgallery.com/packages/Armor

.. _Gitter: https://gitter.im/ArmorPowerShell/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge

.. _available on GitHub: 

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: User Documentation

   usr_00_requirements.rst
   usr_10_install.rst
   usr_20_update.rst
   usr_30_uninstall.rst
   usr_40_getting_started.rst
   usr_50_project_architecture.rst
   usr_60_support.rst
   usr_80_licensing.rst
   usr_90_faq.rst


.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Command Documentation
   
   cmd_connect
   cmd_disconnect
   cmd_get
   cmd_invoke
   cmd_remove
   cmd_rename
   cmd_reset
   cmd_restart
   cmd_set
   cmd_start
   cmd_stop

