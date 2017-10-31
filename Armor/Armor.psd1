#
# Module manifest for module 'Armor'
#
# Generated by: Troy Lindsay
#
# Generated on: 10/31/2017
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'Armor.psm1'

# Version number of this module.
ModuleVersion = '1.0.0.59'

# ID used to uniquely identify this module
GUID = '226c1ea9-1078-402a-861c-10a845a0d173'

# Author of this module
Author = 'Troy Lindsay'

# Company or vendor of this module
CompanyName = 'Armor'

# Copyright statement for this module
Copyright = '(c) 2017 Troy Lindsay. All rights reserved.'

# Description of the functionality provided by this module
Description = 'This is a community project that provides a powerful command-line interface via a Microsoft PowerShell module for managing, monitoring, and automating many aspects of your Armor Complete and Armor Anywhere environments, including firewalls, VMs, and more.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
ProcessorArchitecture = 'None'

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = 'Connect-Armor', 'Disconnect-Armor', 'Get-ArmorAccount', 
               'Get-ArmorDatacenter', 'Get-ArmorUser', 'Get-ArmorVm', 'Rename-ArmorVM', 
               'Reset-ArmorVM', 'Restart-ArmorVM', 'Set-ArmorAccountContext', 
               'Start-ArmorVM', 'Stop-ArmorVM'

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = 'Armor/Armor.psd1', 'Armor/Armor.psm1', 
               'Armor/Private/ConvertFrom-JsonXL.ps1', 
               'Armor/Private/Expand-ArmorApiResult.ps1', 
               'Armor/Private/Expand-JsonItem.ps1', 
               'Armor/Private/Format-ArmorApiJsonRequestBody.ps1', 
               'Armor/Private/Get-ArmorApiData.ps1', 
               'Armor/Private/New-ArmorApiToken.ps1', 
               'Armor/Private/New-ArmorApiUriQueryString.ps1', 
               'Armor/Private/New-ArmorApiUriString.ps1', 
               'Armor/Private/Select-ArmorApiResult.ps1', 
               'Armor/Private/Submit-ArmorApiRequest.ps1', 
               'Armor/Private/Test-ArmorConnection.ps1', 
               'Armor/Private/Update-ArmorApiToken.ps1', 
               'Armor/Public/Connect-Armor.ps1', 
               'Armor/Public/Disconnect-Armor.ps1', 
               'Armor/Public/Get-ArmorAccount.ps1', 
               'Armor/Public/Get-ArmorDatacenter.ps1', 
               'Armor/Public/Get-ArmorUser.ps1', 'Armor/Public/Get-ArmorVm.ps1', 
               'Armor/Public/Rename-ArmorVM.ps1', 'Armor/Public/Reset-ArmorVM.ps1', 
               'Armor/Public/Restart-ArmorVM.ps1', 
               'Armor/Public/Set-ArmorAccountContext.ps1', 
               'Armor/Public/Start-ArmorVM.ps1', 'Armor/Public/Stop-ArmorVM.ps1'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Armor','Defense','Cloud','Security','Performance','Complete','Anywhere','Compliant','PCI-DSS','HIPAA','HITRUST','IaaS','SaaS'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/tlindsay42/ArmorPowerShell/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/tlindsay42/ArmorPowerShell'

        # A URL to an icon representing this module.
        IconUri = 'http://i.imgur.com/fbXjkCn.png'

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable
    
 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

