Project Architecture
========================

This page contains details on the artifacts found within the repository.

* **Armor**: The parent folder containing the module
    * **Formats**: Output decoration definition files
    * **Etc**: Configuration files
    * **Lib**: Class files
    * **Private**: Private functions that are used internally by the module
    * **Public**: Published functions that are available to the user when the PowerShell module is loaded
    * **Armor.psd1**: Module manifest
    * **Armor.psm1**: Script module file
* **build**: Continuous integration initialization and build scripts
* **deploy**: Continuous deployment scripts to publish to the PowerShell Gallery and GitHub
* **docs**: Module documentation
* **templates**: Templates for creating your own functions
* **tests**: Pester unit tests used to validate the public functions
    * **config**: Continuous integration environment and module configuration tests
    * **etc**: Configuration files
    * **lib**: Class tests
    * **private**: Private function tests
    * **public**: Public function tests
* **workflows**: Sample workflows for more complex automation tasks
