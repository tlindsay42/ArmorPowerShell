Installation
========================

This repository contains a folder named `Armor`_. The folder needs to be installed into one of your PowerShell Module Paths using one of the installation methods outlined in the next section. To see the full list of available PowerShell Module paths, use ``$env:PSModulePath.Split( ';' )`` in a PowerShell terminal window.

Common PowerShell module paths include:

1. Current User: ``%USERPROFILE%\Documents\WindowsPowerShell\Modules\``
2. All Users: ``%ProgramFiles%\WindowsPowerShell\Modules\``
3. OneDrive: ``$env:OneDrive\Documents\WindowsPowerShell\Modules\``

Option 1: PowerShell Gallery Installation (Recommended)
------------------------

1. Ensure you have the `Windows Management Framework 5.0`_ or greater installed.
2. Open a Powershell console with the *Run as Administrator* option.
3. Run ``Set-ExecutionPolicy`` using the parameter *RemoteSigned* or *Bypass*.
4. Run ``Install-Module -Name Armor -Scope CurrentUser`` to download the module from the PowerShell Gallery. Note that the first time you install from the remote repository it may ask you to first trust the repository.

Option 2: PowerShell Gallery Download
------------------------

1. Ensure you have the `Windows Management Framework 5.0`_ or greater installed.
2. Open a Powershell console with the *Run as Administrator* option.
3. Run ``Set-ExecutionPolicy`` using the parameter *RemoteSigned* or *Bypass*.
4. Run ``Save-Module -Name Armor -Path <path>`` to download the module from the PowerShell Gallery. Note that the first time you install from the remote repository it may ask you to first trust the repository. 
5. Copy the contents of the Armor module folder onto your workstation into the desired PowerShell Module path.

Option 3: Manual Installation
------------------------

1. Download the `master branch`_ to your workstation.
2. Copy the contents of the *Armor* folder onto your workstation into the desired PowerShell Module path.
3. Open a Powershell console with the *Run as Administrator* option.
4. Run ``Set-ExecutionPolicy`` using the parameter *RemoteSigned* or *Bypass*.

.. _master branch: https://github.com/tlindsay42/ArmorPowerShell
.. _Windows Management Framework 5.0: https://www.microsoft.com/en-us/download/details.aspx?id=50395

Verification
------------------------

PowerShell will create a folder for each new version of any module you install. It's a good idea to check and see what version(s) you have installed and running in the session. To begin, let's see what versions of the Armor Module are installed:

``Get-Module -ListAvailable -Name Armor``

The ``-ListAvailable`` switch will pull up all installed versions from any path found in ``$env:PSModulePath``. Check to make sure the version you wanted is installed. You can safely remove old versions, if desired.

To see which version is currently loaded, use:

``Get-Module Armor``

If nothing is returned, you need to first load the module by using:

``Import-Module Armor``

If you wish to load a specific version, use:

``Import-Module Armor -RequiredVersion #.#.#.#``

Where "#.#.#.#" represents the version number.

Updating to a newer version
========================

1. Open a Powershell console with the *Run as Administrator* option.
2. Run ``Update-Module -Name Armor``.
