This page contains details on the artifacts found within the repository.

<!-- tree -nI site -P 'Armor.ps?1|Armor-help.xml' --dirsfirst -->

```none
.
├── Armor
│   ├── en-US
│   │   └── Armor-help.xml
│   ├── Etc
│   ├── Formats
│   ├── Lib
│   ├── Private
│   ├── Public
│   ├── Armor.psd1
│   └── Armor.psm1
├── build
├── deploy
├── docs
│   ├── img
│   ├── private
│   ├── public
│   └── user
├── templates
├── tests
│   ├── config
│   ├── etc
│   ├── lib
│   ├── private
│   └── public
└── workflows
```

* **Armor**: The parent folder containing the module
    * **en-US:** American English MAML-xml external PowerShell help file
    * **Etc**: Configuration files
    * **Formats**: Output decoration definition files
    * **Lib**: Class files
    * **Private**: Private functions that are used internally by the module
    * **Public**: Published functions that are available to the user when the PowerShell module is loaded
    * **Armor.psd1**: Module manifest
    * **Armor.psm1**: Script module file
* **build**: Continuous integration initialization and build scripts
* **deploy**: Continuous deployment scripts to publish to the PowerShell Gallery and GitHub
* **docs**: Module documentation
    * **img**: Module documentation image assets
    * **private**: Private functions documentation
    * **public**: Public functions documentation
    * **user**: User guide documentation
* **templates**: Templates for creating your own functions
* **tests**: Pester unit tests used to validate the public functions
    * **config**: Continuous integration environment and module configuration tests
    * **etc**: Configuration files
    * **lib**: Class tests
    * **private**: Private function tests
    * **public**: Public function tests
* **workflows**: Sample workflows for more complex automation tasks
