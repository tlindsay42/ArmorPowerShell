Describe 'Module' {
    Context 'Import' {
        It "should import module: '${env:CI_MODULE_NAME}'" {
            { Import-Module -Name $env:CI_MODULE_MANIFEST_PATH -Force } |
                Should -Not -Throw
        }
    }

    Context 'Advanced Functions' {
        $moduleInfo = Import-Module -Name $env:CI_MODULE_MANIFEST_PATH -PassThru
        $functionFileNames = ( Get-ChildItem -Path $env:CI_MODULE_PUBLIC_PATH -Filter '*.ps1' ).Name
        $functionNames = $moduleInfo.ExportedFunctions.Keys

        <#
        Checks to make sure that each script file in the module's Public directory
        has been exported.
        #>
        foreach ( $functionFileName in $functionFileNames ) {
            It "should import public function script file: '${functionFileName}'" {
                $functionFileName.Split( '.' )[0] |
                    Should -BeIn $functionNames
            }
        }

        <#
        Checks to make sure that each exported function has a matching file in
        the module's Public directory.  Check the psm1 file if any extras functions
        are found.
        #>
        foreach ( $functionName in $functionNames ) {
            It "should export public member function: '${functionName}'" {
                $functionName |
                    Should -BeIn $functionFileNames.ForEach( { $_.Split( '.' )[0] } )
            }
        }
    }
}
