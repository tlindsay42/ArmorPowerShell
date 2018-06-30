Deploy 'DeveloperBuild' {
    By 'AppVeyorModule' {
        FromSource $CI_PROJECT_NAME
        To 'AppVeyor'
        WithOptions @{
            Version = $CI_MODULE_PRERELEASE_VERSION
        }
    }
}
