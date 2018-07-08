Deploy 'DeveloperBuild' {
    By 'AppVeyorModule' {
        FromSource $Global:CI_MODULE_NAME
        To 'AppVeyor'
        WithOptions @{
            Version = $Script:CI_MODULE_PRERELEASE_VERSION
        }
    }
}
