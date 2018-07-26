$moduleManifest = Test-ModuleManifest -Path $Env:BHPSModuleManifest
$moduleVersion = "$( $moduleManifest.Version )-$( Get-Metadata -Path $moduleManifest.Path -PropertyName 'Prerelease' )"

Deploy 'DeveloperBuild' {
    By 'AppVeyorModule' {
        FromSource $moduleManifest.Path
        To 'AppVeyor'
        WithOptions @{
            Author                   = 'Troy Lindsay'
            Description              = $moduleManifest.Description
            LicenseUrl               = $moduleManifest.LicenseUri
            Owners                   = 'tlindsay42'
            PackageName              = $moduleManifest.Name
            ProjectUrl               = $moduleManifest.ProjectUri
            ReleaseNotes             = $moduleManifest.ReleaseNotes
            Tags                     = $moduleManifest.Tags
            Version                  = $moduleVersion
        }
    }
}
