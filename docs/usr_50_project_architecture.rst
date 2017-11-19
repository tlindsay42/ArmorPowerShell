Project Architecture
========================

This page contains details on the artifacts found within the repository.

* Armor: The parent folder containing the module
    * Formats: Output decoration definition files
    * Lib: Class files ordered with a number prefix
    * Private: Private functions that are used internally by the module
    * Public: Published functions that are available to the user when the PowerShell module is loaded
    * Armor.psd1: Module manifest
    * Armor.psm1: Script module file
* build: Continuous integration build scripts
    * appveyor: AppVeyor-specific build scripts
    * shared: General build scripts
    * travis: Travis CI-specific build scripts
* docs: Module documentation
* templates: Templates for creating your own functions
* tests: Pester unit tests used to validate the public functions
* workflows: Sample workflows for more complex automation tasks
