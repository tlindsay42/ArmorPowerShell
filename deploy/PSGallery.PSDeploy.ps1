Deploy 'Module' {
    By 'PSGalleryModule' {
        FromSource $Global:CI_MODULE_NAME
        To 'PSGallery'
        WithOptions @{
            ApiKey = $Env:NUGET_API_KEY
        }
    }
}
