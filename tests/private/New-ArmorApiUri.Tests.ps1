Import-Module -Name $Env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $Env:CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PrivateFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $invalidServer = ''
    $validServer = 'api.armor.com'
    $invalidPort = 0
    $validPort = 443
    $invalidEndpoints = '', '/{id}/{id}/{id}'
    $validEndpoints = '/', '/{id}', '/{id}/{id}'
    $invalidIDs = 0, 0, 0
    $validIDs = 1, 65535

    $Global:ArmorSession = [ArmorSession]::New()
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
        'ExpectedParameterNames' = 'Server', 'Port', 'Endpoints', 'IDs'
        'Help'                   = $help
    }
    TestAdvancedFunctionHelpParameters @splat

    $splat = @{
        'ExpectedNotes' = $Global:FunctionHelpNotes
        'Help'          = $help
    }
    TestAdvancedFunctionHelpNotes @splat

    Context -Name $Global:Execution -Fixture {
        $testCases = @(
            @{
                'Server'    = $invalidServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints
                'IDs'       = $validIDs
            },
            @{
                'Server'    = $validServer
                'Port'      = $invalidPort
                'Endpoints' = $validEndpoints
                'IDs'       = $validIDs
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $invalidEndpoints[0]
                'IDs'       = $validIDs
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $invalidEndpoints[1]
                'IDs'       = $validIDs
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints[0]
                'IDs'       = $invalidIDs
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints[0]
                'IDs'       = $null
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints[0], $validEndpoints[0]
                'IDs'       = @()
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints[1]
                'IDs'       = $validIDs
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints[1]
                'IDs'       = @()
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints[1], $validEndpoints[1]
                'IDs'       = $validIDs[0]
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints[2]
                'IDs'       = $validIDs[0]
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints[2], $validEndpoints[2]
                'IDs'       = $validIDs
            }
        )
        $testName = 'should fail when set to: Server: <Server>, Port: <Port>, Endpoints: <Endpoints>, IDs: <IDs>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Server, [UInt16] $Port, [String[]] $Endpoints, [UInt16[]] $IDs )
            { New-ArmorApiUri -Server $Server -Port $Port -Endpoints $Endpoints -IDs $IDs } |
                Should -Throw
        }

        $testCases = @(
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints
                'IDs'       = @()
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints
                'IDs'       = $validIDs[0]
            },
            @{
                'Server'    = $validServer
                'Port'      = $validPort
                'Endpoints' = $validEndpoints
                'IDs'       = $validIDs
            }
        )
        $testName = 'should not fail when set to: Server: <Server>, Port: <Port>, Endpoints: <Endpoints>, IDs: <IDs>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Server, [UInt16] $Port, [String[]] $Endpoints, [UInt16[]] $IDs )
            { New-ArmorApiUri -Server $Server -Port $Port -Endpoints $Endpoints -IDs $IDs } |
                Should -Not -Throw
        }
    }

    Context -Name $Global:ReturnTypeContext -Fixture {
        $testCases = @(
            @{
                'FoundReturnType'    = ( New-ArmorApiUri -Server $validServer -Port $validPort -Endpoints '/' -ErrorAction 'Stop' ).GetType().FullName
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
                Should -BeIn $help.ReturnValues.ReturnValue.Type.Name
        }
    }
}
