Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PUBLIC -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full

    $Global:ArmorSession = [ArmorSession]::New( 'api.armor.com', 443, 'v1.0' )
    #endregion

    $splat = @{
        ExpectedFunctionName = $function
        FoundFunctionName    = $help.Name
    }
    Test-AdvancedFunctionName @splat

    Test-AdvancedFunctionHelpMain -Help $help

    Test-AdvancedFunctionHelpInput -Help $help

    $splat = @{
        ExpectedOutputTypeNames = 'ArmorCompleteVmOrder', 'ArmorCompleteVmOrder[]'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'Name', 'Location', 'WorkloadID', 'WorkloadName', 'TierID', 'TierName',
            'VirtualDisks', 'Secret', 'SKU', 'Quantity', 'ApiVersion', 'WhatIf', 'Confirm'
        Help                   = $help
    }
    Test-AdvancedFunctionHelpParameter @splat

    $splat = @{
        ExpectedNotes = $Global:FORM_FUNCTION_HELP_NOTES
        Help          = $help
    }
    Test-AdvancedFunctionHelpNote @splat

    Context -Name $Global:EXECUTION -Fixture {
        InModuleScope -ModuleName $Global:CI_MODULE_NAME -ScriptBlock {
            #region init
            $invalidName = ''
            $validName = 'app1'
            $invalidLocation = ''
            $validLocation = 'DFW01'
            $invalidWorkloadID = 0
            $validWorkloadID = 1
            $invalidWorkloadName = ''
            $validWorkloadName = 'WISP stack'
            $invalidTierID = 0
            $validTierID = 1
            $invalidTierName = ''
            $validTierName = 'business logic'
            $invalidSecret = 'weak password'
            $validSecret = 'only password length is tested client-side'
            $invalidSKU = ''
            $validSKU = 'A1-101'
            $invalidQuantity = 0
            $validQuantity = 1
            $invalidApiVersion = 'v0.0'
            $validApiVersion = 'v1.0'
            #endregion

            $testCases = @(
                @{
                    Name       = $invalidName
                    Location   = $validLocation
                    WorkloadID = $validWorkloadID
                    TierID     = $validTierID
                    Secret     = $validSecret
                    SKU        = $validSKU
                    Quantity   = $validQuantity
                    ApiVersion = $validApiVersion
                },
                @{
                    Name       = $validName
                    Location   = $invalidLocation
                    WorkloadID = $validWorkloadID
                    TierID     = $validTierID
                    Secret     = $validSecret
                    SKU        = $validSKU
                    Quantity   = $validQuantity
                    ApiVersion = $validApiVersion
                },
                @{
                    Name       = $validName
                    Location   = 'AMS01'
                    WorkloadID = $invalidWorkloadID
                    TierID     = $validTierID
                    Secret     = $validSecret
                    SKU        = $validSKU
                    Quantity   = $validQuantity
                    ApiVersion = $validApiVersion
                },
                @{
                    Name       = $validName
                    Location   = 'LHR01'
                    WorkloadID = $validWorkloadID
                    TierID     = $invalidTierID
                    Secret     = $validSecret
                    SKU        = $validSKU
                    Quantity   = $validQuantity
                    ApiVersion = $validApiVersion
                },
                @{
                    Name       = $validName
                    Location   = 'PHX01'
                    WorkloadID = $validWorkloadID
                    TierID     = $validTierID
                    Secret     = $invalidSecret
                    SKU        = $validSKU
                    Quantity   = $validQuantity
                    ApiVersion = $validApiVersion
                },
                @{
                    Name       = $validName
                    Location   = 'SIN01'
                    WorkloadID = $validWorkloadID
                    TierID     = $validTierID
                    Secret     = $validSecret
                    SKU        = $invalidSKU
                    Quantity   = $validQuantity
                    ApiVersion = $validApiVersion
                },
                @{
                    Name       = $validName
                    Location   = $validLocation
                    WorkloadID = $validWorkloadID
                    TierID     = $validTierID
                    Secret     = $validSecret
                    SKU        = $validSKU
                    Quantity   = $invalidQuantity
                    ApiVersion = $validApiVersion
                },
                @{
                    Name       = $validName
                    Location   = $validLocation
                    WorkloadID = $validWorkloadID
                    TierID     = $validTierID
                    Secret     = $validSecret
                    SKU        = $validSKU
                    Quantity   = $validQuantity
                    ApiVersion = $invalidApiVersion
                }
            )
            $testName = (
                'should fail when set to: Name: <Name>, Location: <Location>, WorkloadID: <WorkloadID>, ' +
                'TierID: <TierID>, Secret: <Secret>, SKU: <SKU>, Quantity: <Quantity>, ApiVersion: <ApiVersion> (named)'
            )
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [UInt16] $WorkloadID,
                    [UInt16] $TierID,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                {
                    $splat = @{
                        Name       = $Name
                        Location   = $Location
                        WorkloadID = $WorkloadID
                        TierID     = $TierID
                        Secret     = $Secret
                        SKU        = $SKU
                        Quantity   = $Quantity
                        ApiVersion = $ApiVersion
                    }
                    New-ArmorCompleteVM @splat
                } |
                    Should -Throw
            }

            $testName = $testName -replace '\(named\)', '(positional)'
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [UInt16] $WorkloadID,
                    [UInt16] $TierID,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                { New-ArmorCompleteVM $Name $Location $WorkloadID $TierID $Secret $SKU $Quantity $ApiVersion } |
                    Should -Throw
            }

            $testName = $testName -replace '\(positional\)', '(pipeline by value)'
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [UInt16] $WorkloadID,
                    [UInt16] $TierID,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                {
                    $splat = @{
                        Location   = $Location
                        WorkloadID = $WorkloadID
                        TierID     = $TierID
                        Secret     = $Secret
                        SKU        = $SKU
                        Quantity   = $Quantity
                        ApiVersion = $ApiVersion
                    }
                    $Name |
                        New-ArmorCompleteVM @splat
                } |
                    Should -Throw
            }

            $testCases = @(
                @{
                    Name         = $invalidName
                    Location     = $validLocation
                    WorkloadName = $validWorkloadName
                    TierName     = $validTierName
                    Secret       = $validSecret
                    SKU          = $validSKU
                    Quantity     = $validQuantity
                    ApiVersion   = $validApiVersion
                },
                @{
                    Name         = $validName
                    Location     = $invalidLocation
                    WorkloadName = $validWorkloadName
                    TierName     = $validTierName
                    Secret       = $validSecret
                    SKU          = $validSKU
                    Quantity     = $validQuantity
                    ApiVersion   = $validApiVersion
                },
                @{
                    Name         = $validName
                    Location     = 'AMS01'
                    WorkloadName = $invalidWorkloadName
                    TierName     = $validTierName
                    Secret       = $validSecret
                    SKU          = $validSKU
                    Quantity     = $validQuantity
                    ApiVersion   = $validApiVersion
                },
                @{
                    Name         = $validName
                    Location     = 'LHR01'
                    WorkloadName = $validWorkloadName
                    TierName     = $invalidTierName
                    Secret       = $validSecret
                    SKU          = $validSKU
                    Quantity     = $validQuantity
                    ApiVersion   = $validApiVersion
                },
                @{
                    Name         = $validName
                    Location     = 'PHX01'
                    WorkloadName = $validWorkloadName
                    TierName     = $validTierName
                    Secret       = $invalidSecret
                    SKU          = $validSKU
                    Quantity     = $validQuantity
                    ApiVersion   = $validApiVersion
                },
                @{
                    Name         = $validName
                    Location     = 'SIN01'
                    WorkloadName = $validWorkloadName
                    TierName     = $validTierName
                    Secret       = $validSecret
                    SKU          = $invalidSKU
                    Quantity     = $validQuantity
                    ApiVersion   = $validApiVersion
                },
                @{
                    Name         = $validName
                    Location     = $validLocation
                    WorkloadName = $validWorkloadName
                    TierName     = $validTierName
                    Secret       = $validSecret
                    SKU          = $validSKU
                    Quantity     = $invalidQuantity
                    ApiVersion   = $validApiVersion
                },
                @{
                    Name         = $validName
                    Location     = $validLocation
                    WorkloadName = $validWorkloadName
                    TierName     = $validTierName
                    Secret       = $validSecret
                    SKU          = $validSKU
                    Quantity     = $validQuantity
                    ApiVersion   = $invalidApiVersion
                }
            )
            $testName = (
                'should fail when set to: Name: <Name>, Location: <Location>, WorkloadName: <WorkloadName>, ' +
                'TierName: <TierName>, Secret: <Secret>, SKU: <SKU>, Quantity: <Quantity>, ApiVersion: <ApiVersion> (named)'
            )
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [String] $WorkloadName,
                    [String] $TierName,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                {
                    $splat = @{
                        Name         = $Name
                        Location     = $Location
                        WorkloadName = $WorkloadName
                        TierName     = $TierName
                        Secret       = $Secret
                        SKU          = $SKU
                        Quantity     = $Quantity
                        ApiVersion   = $ApiVersion
                    }
                    New-ArmorCompleteVM @splat
                } |
                    Should -Throw
            }

            $testName = $testName -replace '\(named\)', '(positional)'
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [String] $WorkloadName,
                    [String] $TierName,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                { New-ArmorCompleteVM $Name $Location $WorkloadName $TierName $Secret $SKU $Quantity $ApiVersion } |
                    Should -Throw
            }

            $testName = $testName -replace '\(positional\)', '(pipeline by value)'
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [String] $WorkloadName,
                    [String] $TierName,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                {
                    $splat = @{
                        Location     = $Location
                        WorkloadName = $WorkloadName
                        TierName     = $TierName
                        Secret       = $Secret
                        SKU          = $SKU
                        Quantity     = $Quantity
                        ApiVersion   = $ApiVersion
                    }
                    $Name |
                        New-ArmorCompleteVM @splat
                } |
                    Should -Throw
            }
        }


        InModuleScope -ModuleName $Global:CI_MODULE_NAME -ScriptBlock {
            #region init
            $validName = 'VM1'
            $validLocation = 'DFW01'
            $validWorkloadID = 1
            $validWorkloadName = 'WL1'
            $validTierID = 1
            $validTierName = 'TR1'
            $validSecret = '$MySecretPassword1'
            $validSKU = 'A1-101'
            $validQuantity = 5
            $validApiVersion = 'v1.0'

            $workload = [ArmorCompleteWorkload] ( $Global:JSON_RESPONSE_BODY.Workloads1Tiers1VMs1 | ConvertFrom-Json )
            #endregion

            Mock -CommandName Get-ArmorCompleteWorkload -Verifiable -MockWith { $workload }
            # Mock -CommandName Get-ArmorCompleteWorkloadTier -Verifiable -MockWith { $true }
            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode        = 400
                    StatusDescription = 'Bad request'
                    Content           = '{"error":true,"message":"Invalid request"}'
                }
            }

            $testCases = @(
                @{
                    Name        = $validName
                    Location    = $validLocation
                    WorkloadID  = $validWorkloadID
                    TierID      = $validTierID
                    Secret      = $validSecret
                    SKU         = $validSKU
                    Quantity    = $validQuantity
                    ApiVersion  = $validApiVersion
                }
            )
            $testName = (
                'should fail when set to: Name: <Name>, Location: <Location>, WorkloadID: <WorkloadID>, ' +
                'TierID: <TierID>, Secret: <Secret>, SKU: <SKU>, Quantity: <Quantity>, ApiVersion: <ApiVersion>' +
                "and HTTP response code is: '400'"
            )
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [UInt16] $WorkloadID,
                    [UInt16] $TierID,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                {
                    $splat = @{
                        Name       = $Name
                        Location   = $Location
                        WorkloadID = $WorkloadID
                        TierID     = $TierID
                        Secret     = $Secret
                        SKU        = $SKU
                        Quantity   = $Quantity
                        ApiVersion = $ApiVersion
                        Confirm    = $false
                    }
                    New-ArmorCompleteVM @splat
                } |
                    Should -Throw
            }
            Assert-VerifiableMock
            #region Upstream issue #122
            # Assert-MockCalled -CommandName Get-ArmorCompleteWorkload -Times 1
            # Assert-MockCalled -CommandName Get-ArmorCompleteWorkloadTier -Times 1
            Assert-MockCalled -CommandName Get-ArmorCompleteWorkload -Times 2
            #endregion
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases[0].TierID = 2
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [UInt16] $WorkloadID,
                    [UInt16] $TierID,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                {
                    $splat = @{
                        Name       = $Name
                        Location   = $Location
                        WorkloadID = $WorkloadID
                        TierID     = $TierID
                        Secret     = $Secret
                        SKU        = $SKU
                        Quantity   = $Quantity
                        ApiVersion = $ApiVersion
                        Confirm    = $false
                    }
                    New-ArmorCompleteVM @splat
                } |
                    Should -Throw
            }
            Assert-VerifiableMock
            #region Upstream issue #122
            # Assert-MockCalled -CommandName Get-ArmorCompleteWorkload -Times 1
            # Assert-MockCalled -CommandName Get-ArmorCompleteWorkloadTier -Times 1
            Assert-MockCalled -CommandName Get-ArmorCompleteWorkload -Times 2
            #endregion
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count

            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode        = 200
                    StatusDescription = 'OK'
                    Content           = $Global:JSON_RESPONSE_BODY.VmOrders1
                }
            }

            $testCases[0].TierID = $validTierID
            $testName = (
                'should not fail when set to: Name: <Name>, Location: <Location>, WorkloadID: <WorkloadID>, ' +
                'TierID: <TierID>, Secret: <Secret>, SKU: <SKU>, Quantity: <Quantity>, ApiVersion: <ApiVersion>' +
                "and HTTP response code is: '200'"
            )
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [UInt16] $WorkloadID,
                    [UInt16] $TierID,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                {
                    $splat = @{
                        Name       = $Name
                        Location   = $Location
                        WorkloadID = $WorkloadID
                        TierID     = $TierID
                        Secret     = $Secret
                        SKU        = $SKU
                        Quantity   = $Quantity
                        ApiVersion = $ApiVersion
                        Confirm    = $false
                    }
                    New-ArmorCompleteVM @splat
                } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            #region Upstream issue #122
            # Assert-MockCalled -CommandName Get-ArmorCompleteWorkload -Times 1
            # Assert-MockCalled -CommandName Get-ArmorCompleteWorkloadTier -Times 1
            Assert-MockCalled -CommandName Get-ArmorCompleteWorkload -Times 2
            #endregion
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode        = 400
                    StatusDescription = 'Bad request'
                    Content           = '{"error":true,"message":"Invalid request"}'
                }
            }

            $testCases = @(
                @{
                    Name         = $validName
                    Location     = $validLocation
                    WorkloadName = $validWorkloadName
                    TierName     = $validTierName
                    Secret       = $validSecret
                    SKU          = $validSKU
                    Quantity     = $validQuantity
                    ApiVersion   = $validApiVersion
                }
            )
            $testName = (
                'should fail when set to: Name: <Name>, Location: <Location>, WorkloadName: <WorkloadName>, ' +
                'TierName: <TierName>, Secret: <Secret>, SKU: <SKU>, Quantity: <Quantity>, ApiVersion: <ApiVersion>' +
                "and HTTP response code is: '400'"
            )
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [String] $WorkloadName,
                    [String] $TierName,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                {
                    $splat = @{
                        Name         = $Name
                        Location     = $Location
                        WorkloadName = $WorkloadName
                        TierName     = $TierName
                        Secret       = $Secret
                        SKU          = $SKU
                        Quantity     = $Quantity
                        ApiVersion   = $ApiVersion
                        Confirm      = $false
                    }
                    New-ArmorCompleteVM @splat
                } |
                    Should -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode        = 200
                    StatusDescription = 'OK'
                    Content           = $Global:JSON_RESPONSE_BODY.VmOrders1
                }
            }

            $testName = (
                'should not fail when set to: Name: <Name>, Location: <Location>, WorkloadName: <WorkloadName>, ' +
                'TierName: <TierName>, Secret: <Secret>, SKU: <SKU>, Quantity: <Quantity>, ApiVersion: <ApiVersion>' +
                "and HTTP response code is: '200'"
            )
            It -Name $testName -TestCases $testCases -Test {
                param (
                    [String] $Name,
                    [String] $Location,
                    [String] $WorkloadName,
                    [String] $TierName,
                    [String] $Secret,
                    [String] $SKU,
                    [UInt16] $Quantity,
                    [String] $ApiVersion
                )
                {
                    $splat = @{
                        Name         = $Name
                        Location     = $Location
                        WorkloadName = $WorkloadName
                        TierName     = $TierName
                        Secret       = $Secret
                        SKU          = $SKU
                        Quantity     = $Quantity
                        ApiVersion   = $ApiVersion
                        Confirm      = $false
                    }
                    New-ArmorCompleteVM @splat
                } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        InModuleScope -ModuleName $Global:CI_MODULE_NAME -ScriptBlock {
            #region init
            $splatID = @{
                Name        = 'VM1'
                Location    = 'DFW01'
                WorkloadID  = 1
                TierID      = 1
                Secret      = '$MySecretPassword1'
                SKU         = 'A1-101'
                Quantity    = 1
                ApiVersion  = 'v1.0'
                Confirm     = $false
                ErrorAction = 'Stop'
            }
            $splatName = @{
                Name         = 'VM1'
                Location     = 'DFW01'
                WorkloadName = 'WL1'
                TierName     = 'TR1'
                Secret       = '$MySecretPassword1'
                SKU          = 'A1-101'
                Quantity     = 1
                ApiVersion   = 'v1.0'
                Confirm      = $false
                ErrorAction  = 'Stop'
            }

            $workload = [ArmorCompleteWorkload] ( $Global:JSON_RESPONSE_BODY.Workloads1Tiers1VMs1 | ConvertFrom-Json )
            #endregion

            Mock -CommandName Get-ArmorCompleteWorkload -Verifiable -MockWith { $workload }
            # Mock -CommandName Get-ArmorCompleteWorkloadTier -Verifiable -MockWith { $true }
            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode        = 200
                    StatusDescription = 'OK'
                    Content           = $Global:JSON_RESPONSE_BODY.VmOrders1
                }
            }

            $testCases = @(
                @{
                    FoundReturnType    = ( New-ArmorCompleteVM @splatID ).GetType().FullName
                    ExpectedReturnType = 'ArmorCompleteVmOrder'
                },
                @{
                    FoundReturnType    = ( New-ArmorCompleteVM @splatName ).GetType().FullName
                    ExpectedReturnType = 'ArmorCompleteVmOrder'
                }
            )
            $testName = $Global:FORM_RETURN_TYPE
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -Be $ExpectedReturnType
            }
            Assert-VerifiableMock
            #region Upstream issue #122
            # Assert-MockCalled -CommandName Get-ArmorCompleteWorkload -Times 1
            # Assert-MockCalled -CommandName Get-ArmorCompleteWorkloadTier -Times 1
            Assert-MockCalled -CommandName Get-ArmorCompleteWorkload -Times 2
            #endregion
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testName = "has an 'OutputType' entry for <FoundReturnType>"
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -BeIn ( Get-Help -Name 'New-ArmorCompleteVM' -Full ).ReturnValues.ReturnValue.Type.Name
            }
        }
    }
}
