Describe -Name 'Module' -Tag 'Module' -Fixture {
    Context -Name 'Import' -Fixture {
        It -Name "should import module: '${Global:CI_MODULE_NAME}'" -Test {
            { Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force } |
                Should -Not -Throw
        }
    }

    <#
    Get the last index because the script files in ScriptsToProcess are
    returned as earlier index items.
    #>
    $moduleInfo = ( Import-Module -Name $CI_MODULE_MANIFEST_PATH -PassThru )[-1]

    Context -Name 'Manifest' -Fixture {
        $author = 'Troy Lindsay'
        $testCases = @(
            @{
                Property = 'RootModule'
                Value    = "${Global:CI_MODULE_NAME}.psm1"
            },
            @{
                Property = 'Version'
                Value    = $CI_MODULE_VERSION
            },
            @{
                Property = 'GUID'
                Value    = '226c1ea9-1078-402a-861c-10a845a0d173'
            },
            @{
                Property = 'Author'
                Value    = $author
            },
            @{
                Property = 'CompanyName'
                Value    = 'Armor'
            },
            @{
                Property = 'Copyright'
                Value    = "©2017-$( ( Get-Date ).Year ) ${author}. All rights reserved."
            },
            @{
                Property = 'ProcessorArchitecture'
                Value    = 'None'
            },
            @{
                Property = 'Prefix'
                Value    = ''
            },
            @{
                Property = 'HelpInfoURI'
                Value    = 'https://tlindsay42.github.io/ArmorPowerShell/'
            }
        )
        It -Name "should have set property: <Property> to: <Value>" -TestCases $testCases -Test {
            param ( [String] $Property, [String] $Value )
            $moduleInfo.$Property |
                Should -BeExactly $Value
        }

        $testCases = @(
            @{ Property = 'CompatiblePSEditions' },
            @{ Property = 'PowerShellHostName' },
            @{ Property = 'PowerShellHostVersion' },
            @{ Property = 'DotNetFrameworkVersion' },
            @{ Property = 'ClrVersion' },
            @{ Property = 'RequiredModules' },
            @{ Property = 'RequiredAssemblies' },
            @{ Property = 'ExportedTypeFiles' },
            @{ Property = 'ExportedFormatFiles' },
            @{ Property = 'NestedModules' },
            @{ Property = 'ExportedDscResources' },
            @{ Property = 'ModuleList' },
            @{ Property = 'ReleaseNotes' }
        )
        It -Name "should have set property: <Property> to: `$null" -TestCases $testCases -Test {
            param ( [String] $Property )
            $moduleInfo.$Property |
                Should -BeExactly $null
        }

        $testCases = $(
            @{ Value = 'Armor Complete' },
            @{ Value = 'Armor Anywhere' },
            @{ Value = 'Windows' },
            @{ Value = 'AppVeyor' },
            @{ Value = 'macOS' },
            @{ Value = 'Ubuntu Linux' },
            @{ Value = 'Travis CI' },
            @{ Value = 'Code coverage' },
            @{ Value = 'Coveralls' },
            @{ Value = 'PowerShell Gallery' }
        )
        It -Name "should have set property: 'Description' to contain keyword: <Value>" -TestCases $testCases -Test {
            param ( [String] $Value )
            $moduleInfo.Description |
                Should -Match $Value
        }

        $testCases = @(
            @{
                Property = 'PowerShellVersion'
                Value    = '5.0'
            },
            @{
                Property = 'LicenseURI'
                Value    = 'https://github.com/tlindsay42/ArmorPowerShell/blob/master/LICENSE.txt'
            },
            @{
                Property = 'ProjectURI'
                Value    = 'https://github.com/tlindsay42/ArmorPowerShell'
            },
            @{
                Property = 'IconURI'
                Value    = 'https://tlindsay42.github.io/ArmorPowerShell/img/Armor_logo.png'
            }
        )
        It -Name 'should have set property: <Property> to: <Value>' -TestCases $testCases -Test {
            param ( [String] $Property, [String] $Value )
            $moduleInfo.$Property.ToString() |
                Should -BeExactly $Value
        }

        $testCases = @(
            @{ Property = 'ExportedCmdlets' },
            @{ Property = 'ExportedVariables' }
        )
        It -Name 'should have set property: <Property> to an empty collection' -TestCases $testCases -Test {
            param ( [String] $Property )
            $moduleInfo.$Property.Count |
                Should -BeExactly 0
        }

        $testCases = @(
            @{
                Property = 'ExportedAliases'
                Value    = ( Get-Content -Path "${CI_MODULE_ETC_PATH}/Aliases.json" -ErrorAction 'Stop' | ConvertFrom-Json -ErrorAction 'Stop' ).Count
            }
        )
        It -Name 'should have set property: <Property> to: <Value>' -TestCases $testCases -Test {
            param ( [String] $Property, [UInt16] $Value )
            $moduleInfo.$Property.Count |
                Should -Be $Value
        }

        It -Name "should have set property: 'Tags'" -Test {
            $moduleInfo.Tags.Count |
                Should -BeGreaterThan 0
        }
    }

    $fileNames = Get-ChildItem -Path $CI_MODULE_PUBLIC_PATH -File
    $functionNames = $moduleInfo.ExportedFunctions.Keys

    Context -Name 'ExportedFunctions' -Fixture {
        foreach ( $fileName in $fileNames ) {
            It -Name "should contain entry: '${fileName}'" -Test {
                $fileName.BaseName |
                    Should -BeIn $functionNames
            }
        }

        foreach ( $functionName in $functionNames ) {
            It -Name "should have matching file: '${functionName}'" -Test {
                $functionName |
                    Should -BeIn $fileNames.BaseName
            }
        }
    }

    $fileNames = Get-ChildItem -Path $CI_MODULE_LIB_PATH -File

    Context -Name 'ScriptsToProcess' -Fixture {
        foreach ( $fileName in $fileNames ) {
            It -Name "should contain entry: '${fileName}'" -Test {
                $fileName.FullName |
                    Should -BeIn $moduleInfo.Scripts
            }
        }

        foreach ( $fileName in $moduleInfo.Scripts ) {
            It -Name "should have matching file: '$( Split-Path -Path $fileName -Leaf )'" -Test {
                $fileName |
                    Should -BeIn $fileNames.FullName
            }
        }
    }

    $fileNames = Get-ChildItem -Path $CI_MODULE_PATH -File -Recurse

    Context -Name 'FileList' -Fixture {
        foreach ( $fileName in $fileNames ) {
            It -Name "should contain entry: '${fileName}'" -Test {
                $fileName.FullName |
                    Should -BeIn $moduleInfo.FileList
            }
        }

        foreach ( $fileName in $moduleInfo.FileList ) {
            It -Name "should have matching file: '$( Split-Path -Path $fileName -Leaf )'" -Test {
                $fileName |
                    Should -BeIn $fileNames.FullName
            }
        }
    }
}
