Project Architecture
========================

This page contains details on the artifacts found within the repository.

* docs: Module documentation that is automatically published to ReadTheDocs.io
* templates: Templates for creating your own functions
* tests: Pester unit tests used to validate the public functions
* workflows: Sample workflows for more complex automation tasks
* Armor: The parent folder containing the module
    * Private: Private functions that are used internally by the module
    * Public: Published functions that are available to the user when the PowerShell module is loaded
    * Armor.psd1: Module manifest
    * Armor.psm1: Script module file