#requires -Version 5
#requires -Modules platyPS

<#
    .SYNOPSIS
    Builds the module's Markdown documentation via platyPS.

    .DESCRIPTION
    The psake module (version 4.7.0 and earlier) has an odd scoping issue that
    prevents sourced scripts from being accessible within other modules.  This
    functionality provides a workaround that permits platyPS to access the help
    content of your module's private functions.

    .INPUTS
    None
        You cannot pipe input to this cmdlet.

    .NOTES
    - Troy Lindsay
    - Twitter: @troylindsay42
    - GitHub: tlindsay42

    .EXAMPLE
    $splat = @{
        FilePath     = Join-Path -Path $CI_BUILD_SCRIPTS_PATH -ChildPath 'Build-Documentation.ps1'
        ArgumentList = @(
            $Global:CI_MODULE_NAME,
            $Script:CI_MODULE_VERSION,
            $CI_MODULE_GUID,
            $TEXT.GitHubPagesProjectUrl,
            $CI_PROJECT_PATH,
            $CI_MODULE_PATH,
            $CI_MODULE_MANIFEST_PATH,
            $CI_DOCS_PATH,
            $CI_BUILD_SCRIPTS_PATH
        )
    }
    Start-Job @splat |
        Receive-Job -Wait -AutoRemoveJob |
        Out-Null

    .LINK https://get-powershellblog.blogspot.com/2017/05/the-classy-platyps-automated-class-enum.html
#>

[CmdletBinding()]
[OutputType( [Void] )]
param (
    # Specifies the name of the module.
    [Parameter( Position = 0 )]
    [ValidateNotNullOrEmpty()]
    [String]
    $ModuleName,

    # Specifies the version of the module.
    [Parameter( Position = 1 )]
    [ValidatePattern( '^\d+\.\d+\.\d+$' )]
    [String]
    $ModuleVersion,

    # Specifies the globally unique identifier for the module.
    [Parameter( Position = 2 )]
    [ValidatePattern( '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' )]
    [String]
    $ModuleGuid,

    # Specifies the updatable help link.
    [Parameter( Position = 3 )]
    [ValidatePattern( '^https://\S+$' )]
    [String]
    $FwLink,

    # Specifies the path to where the project was cloned.
    [Parameter( Position = 4 )]
    [ValidateScript( { ( Test-Path -Path $_ ) -eq $true } )]
    [String]
    $ProjectPath,

    # Specifies the path to the PowerShell module in the project.
    [Parameter( Position = 5 )]
    [ValidateScript( { ( Test-Path -Path $_ ) -eq $true } )]
    [String]
    $ModulePath,

    # Specifies the path to the PowerShell module manifest in the project.
    [Parameter( Position = 6 )]
    [ValidateScript( { ( Test-Path -Path $_ ) -eq $true } )]
    [String]
    $ModuleManifestPath,

    <#
    Specifies the path to the 'docs' directory in the project that stores the content
    for the documentation website.
    #>
    [Parameter( Position = 7 )]
    [ValidateScript( { ( Test-Path -Path $_ ) -eq $true } )]
    [String]
    $DocsPath
)

begin {
    $script = $MyInvocation.MyCommand.Name

    Write-Verbose -Message "Beginning: '${script}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"

    . ( Join-Path -Path $ProjectPath -ChildPath 'build' | Join-Path -ChildPath 'private' | Join-Path -ChildPath 'Write-StatusUpdate.ps1' )

    Push-Location -Path $ProjectPath

    #region Set the progress bar preference
    # The progress bar generates really ugly console output in most continuous integration environments
    $ProgressPreference = 'SilentlyContinue'
    #endregion

    #region init
    $docsPrivatePath = Join-Path -Path $DocsPath -ChildPath 'private'
    $docsPublicPath = Join-Path -Path $DocsPath -ChildPath 'public'
    $docsModulePagePath = Join-Path -Path $docsPublicPath -ChildPath "${ModuleName}.md"
    $cultureCode = 'en-US'
    $modulePrivatePath = Join-Path -Path $ModulePath -ChildPath 'Private'
    $moduleExternalHelpPath = Join-Path -Path $ModulePath -ChildPath $cultureCode
    #endregion
}

process {}

end {
    Write-StatusUpdate -Message "Import module: '${ModuleName}'"
    Remove-Module "${ModuleName}*" -Force -ErrorAction 'SilentlyContinue'
    Import-Module $ModuleManifestPath -Force

    $docsPublicRelativePath = Resolve-Path -Path $docsPublicPath -Relative
    Write-StatusUpdate -Message "Build the public cmdlet documentation with metadata for building external help files: '${docsPublicRelativePath}'."
    $splat = @{
        Module                = $ModuleName
        OutputFolder          = $docsPublicPath
        WithModulePage        = $true
        AlphabeticParamsOrder = $true
        HelpVersion           = $ModuleVersion
        Locale                = $cultureCode
        FwLink                = $FwLink
        Force                 = $true
    }
    $details = New-MarkdownHelp @splat |
        Out-String
    Write-StatusUpdate -Message 'Public cmdlet documentation files:' -Details $details

    $docsModulePageRelativePath = Resolve-Path -Path $docsModulePagePath -Relative
    Write-StatusUpdate -Message "Update the module page content: '${docsModulePageRelativePath}'."
    $splat = @{
        Path                  = $docsPublicPath
        RefreshModulePage     = $true
        AlphabeticParamsOrder = $true
    }
    $details = Update-MarkdownHelpModule @splat

    Write-StatusUpdate -Message "Update the module description in the module page: '${docsModulePageRelativePath}'."
    ( Get-Content -Path $docsModulePagePath ) -replace
        '^{{Manually Enter Description Here}}$', "The ${ModuleName} command-line interface" |
        Set-Content -Path $docsModulePagePath -Force

    Write-StatusUpdate -Message 'Build the external help file.'
    $details = New-ExternalHelp -Path $docsPublicPath -OutputPath $moduleExternalHelpPath -Force
    Write-StatusUpdate -Message 'External help file:' -Details $details
    Write-Host

    if ( $Env:CI_WINDOWS -eq $true ) {
        Write-StatusUpdate -Message 'Build the updatable help files.'
        $splat = @{
            CabFilesFolder  = $docsPublicPath
            LandingPagePath = $docsModulePagePath
            OutputFolder    = $DocsPath
        }
        New-ExternalHelpCab @splat
    }
    else {
        $splat = @{
            Message  = 'Skipping build of the updatable help files as this is only supported on Windows for now.'
            Category = 'Warning'
        }
        Write-StatusUpdate @splat
    }

    $fileNames = @(
        "${ModuleName}_${ModuleGuid}_${cultureCode}_HelpContent.cab",
        "${ModuleName}_${ModuleGuid}_${cultureCode}_HelpContent.zip",
        "${ModuleName}_${ModuleGuid}_HelpInfo.xml"
    )
    $details = Join-Path -Path $DocsPath -ChildPath '*' |
        Get-ChildItem -Include $fileNames |
        Format-Table |
        Out-String
    Write-StatusUpdate -Message 'Updatable help files:' -Details $details

    Write-StatusUpdate -Message 'Remove the front matter metadata from the public cmdlet documentation.'
    $splat = @{
        Module                = $ModuleName
        OutputFolder          = $docsPublicPath
        AlphabeticParamsOrder = $true
        NoMetadata            = $true
        Force                 = $true
    }
    $details = New-MarkdownHelp @splat |
        Out-String
    Write-StatusUpdate -Message 'Public cmdlet documentation files:' -Details $details

    Write-StatusUpdate -Message "Remove the front matter metadata from the module page: '${docsModulePageRelativePath}'."
    Get-Content -Path $docsModulePagePath |
        Select-Object -Skip 8 |
        Out-String |
        Set-Content -Path $docsModulePagePath -Force

    Write-StatusUpdate -Message 'Build the private function documentation.'
    foreach ( $file in ( Get-ChildItem -Path $modulePrivatePath -Filter '*.ps1' ) ) {
        . $file.FullName

        $splat = @{
            Command               = $file.BaseName
            OutputFolder          = $docsPrivatePath
            AlphabeticParamsOrder = $true
            NoMetadata            = $true
            Force                 = $true
        }
        New-MarkdownHelp @splat
    }
    $details = Get-ChildItem -Path $docsPrivatePath |
        Out-String
    Write-StatusUpdate -Message 'Private function documentation files:' -Details $details

    # Write-StatusUpdate -Message 'Building class documentation.'
    # $modulePattern =
    #     $Module.ModuleBase.
    #     Replace( [System.IO.Path]::DirectorySeparatorChar, '.' ).
    #     Replace( [System.IO.Path]::VolumeSeparatorChar, '.' )

    # $classes =
    #     [System.Management.Automation.DynamicClassImplementationAssemblyAttribute]
    #     [AppDomain]::
    #     CurrentDomain.
    #     GetAssemblies().
    #     Where( {
    #             $_.GetCustomAttributes($true).TypeId -contains $DynamicClassAttribute -and
    #             $_.FullName -match $ModulePattern
    #         }).
    #     GetTypes().
    #     Where( { $_.IsPublic -and $_.IsClass } )

    # foreach ( $class in $classes ) {
    #     $HelpDoc = $AboutHelpDocs | Where-Object {$_.basename -like "about_$($Class.Name)"}
    #     if ($HelpDoc) {
    #         Update-ClassMarkdown -Class $Class -Path $HelpDoc.FullName
    #         continue
    #     }
    #     $AboutPath = Join-Path $ModuleHelpPath "about_$($Class.Name).md"
    #     Classtext $Class | Set-Content -Path $AboutPath
    # }

    # 'Removing about Topics from external help...'
    # Get-ChildItem "$ModuleFolder\en-US" -Filter "about_*.txt" |
    #     Remove-Item -Force -Confirm:$false

    Pop-Location

    Write-Verbose -Message "Ending: '${script}'."
}
