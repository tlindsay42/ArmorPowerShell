Import-Module -Name $Env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $Env:CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PrivateFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $validKeys = 'FirstName', 'LastName', 'Email'
    $validParameters = [PSCustomObject] @{
        'FirstName' = 'John'
        'LastName'  = 'Hartigan'
    }
    $validUri = 'https://api.armor.mock/users'

    function Test-NewArmorApiUriQuery1 {
        param ( [String] $FirstName, [String] $LastName, [String] $UserName )
        $parameters = ( Get-Command -Name $MyInvocation.MyCommand.Name ).Parameters.Values
        New-ArmorApiUriQuery -Keys $validKeys -Parameters $parameters -Uri $validUri
    }
    #endregion

    $splat = @{
        'ExpectedFunctionName' = $function
        'FoundFunctionName'    = $help.Name
    }
    TestAdvancedFunctionName @splat

    TestAdvancedFunctionHelpMain -Help $help

    TestAdvancedFunctionHelpInputs -Help $help

    $splat = @{
        'ExpectedOutputTypeNames' = 'System.String'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'Keys', 'Parameters', 'Uri'
        'Help'                   = $help
    }
    TestAdvancedFunctionHelpParameters @splat

    $splat = @{
        'ExpectedNotes' = $Global:FunctionHelpNotes
        'Help'          = $help
    }
    TestAdvancedFunctionHelpNotes @splat

    Context -Name $Global:Execution -Fixture {
        #region init
        #endregion

        $testCases = @(
            @{
                'Keys'       = ''
                'Parameters' = $validParameters
                'Uri'        = $validUri
            },
            @{
                'Keys'       = 'key1', ''
                'Parameters' = $validParameters
                'Uri'        = $validUri
            },
            @{
                'Keys'       = $validKeys
                'Parameters' = ''
                'Uri'        = $validUri
            },
            @{
                'Keys'       = $validKeys
                'Parameters' = @()
                'Uri'        = $validUri
            },
            @{
                'Keys'       = $validKeys
                'Parameters' = 'parameter1', ''
                'Uri'        = $validUri
            },
            @{
                'Keys'       = $validKeys
                'Parameters' = $validParameters
                'Uri'        = 'http://insecure.api/users'
            }
        )
        $testName = 'should fail when set to: Keys: <Keys>, Parameters: <Parameters>, Uri: <Uri>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String[]] $Keys, [PSCustomObject[]] $Parameters, [String] $Uri )
            { New-ArmorApiUriQuery -Keys $Keys -Parameters $Parameters -Uri $Uri } |
                Should -Throw
        }

        $splat = @{
            'FirstName'   = $validParameters.FirstName
            'ErrorAction' = 'Stop'
        }
        $testName = "should not fail when set to: FirstName: '$( $validParameters.FirstName )'"
        It -Name $testName -Test {
            { Test-NewArmorApiUriQuery1 @splat } |
                Should -Not -Throw
        }

        $uri = "${validUri}?FirstName=$( $validParameters.FirstName )"
        $testName = "should build URI: '${uri}'"
        It -Name $testName -Test {
            Test-NewArmorApiUriQuery1 @splat |
                Should -BeExactly $uri
        }

        $splat = @{
            'LastName'    = $validParameters.LastName
            'ErrorAction' = 'Stop'
        }
        $testName = "should not fail when set to: LastName: '$( $validParameters.LastName )'"
        It -Name $testName -Test {
            { Test-NewArmorApiUriQuery1 @splat } |
                Should -Not -Throw
        }

        $uri = "${validUri}?LastName=$( $validParameters.LastName )"
        $testName = "should build URI: '${uri}'"
        It -Name $testName -Test {
            Test-NewArmorApiUriQuery1 @splat |
                Should -BeExactly $uri
        }

        $splat = @{
            'FirstName'   = $validParameters.FirstName
            'LastName'    = $validParameters.LastName
            'ErrorAction' = 'Stop'
        }
        $testName = "should not fail when set to: FirstName: '$( $validParameters.FirstName )', " +
            "LastName: '$( $validParameters.LastName )'"
        It -Name $testName -Test {
            { Test-NewArmorApiUriQuery1 @splat } |
                Should -Not -Throw
        }

        $uri = "${validUri}?FirstName=$( $validParameters.FirstName )&LastName=$( $validParameters.LastName )"
        $testName = "should build URI: '${uri}'"
        It -Name $testName -Test {
            Test-NewArmorApiUriQuery1 @splat |
                Should -BeExactly $uri
        }
    }

    Context -Name $Global:ReturnTypeContext -Fixture {
        #region init
        $splat = @{
            'FirstName'   = $validParameters.FirstName
            'LastName'    = $validParameters.LastName
            'ErrorAction' = 'Stop'
        }
        #endregion

        $testCases = @(
            @{
                'FoundReturnType'    = ( Test-NewArmorApiUriQuery1 @splat ).GetType().FullName
                'ExpectedReturnType' = 'System.String'
            }
        )
        $testName = $Global:ReturnTypeForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -Be $ExpectedReturnType
        }

        $testName = "has an 'OutputType' entry for <FoundReturnType>"
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -BeIn ( Get-Help -Name 'New-ArmorApiUriQuery' ).ReturnValues.ReturnValue.Type.Name
        }
    }
}
