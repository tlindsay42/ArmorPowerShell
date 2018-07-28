$moduleManifest = Test-ModuleManifest -Path $Env:BHPSModuleManifest
$moduleVersion = "$( $moduleManifest.Version )-$( Get-Metadata -Path $moduleManifest.Path -PropertyName 'Prerelease' )"
$moduleAuthor = 'tlindsay42'

Deploy 'DeveloperBuild' {
    By 'AppVeyorModule' {
        FromSource $moduleManifest.Path
        To 'AppVeyor'
        WithOptions @{
            Author                   = $moduleAuthor
            Description              = $moduleManifest.Description
            LicenseUrl               = $moduleManifest.LicenseUri
            Owners                   = $moduleAuthor
            PackageName              = $moduleManifest.Name
            ProjectUrl               = $moduleManifest.ProjectUri
            Tags                     = $moduleManifest.Tags
            Version                  = $moduleVersion
        }
    }
}
