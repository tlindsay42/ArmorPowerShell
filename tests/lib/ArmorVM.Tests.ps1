$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $Env:CI_MODULE_LIB_PATH -ChildPath 'ArmorTypes.ps1'

. $filePath

$class = $systemUnderTest.Split( '.' )[0]
$describe = $Global:ClassForm -f $class
Describe -Name $describe -Tag 'Class', $class -Fixture {
    #region init
    #endregion

    Context -Name $Global:Constructors -Fixture {
        It -Name $Global:DefaultConstructorForm -Test {
            { [ArmorVM]::New() } |
                Should -Not -Throw
        }
    } # End of Context

    [ArmorVM] $temp = [ArmorVM]::New()

    $property = 'AccountID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'ActivationKey'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'bad_activation_key' },
            @{ 'Value' = '71568846-4c76-4904-9c7f-632a014a69f3' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'ABCDE-FGHIJ-KLMNO-PQRST-UVWXY' },
            @{ 'Value' = '01234-56789-LMNOP-QRSTU-VWXYZ' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'AdvBackupSKU'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = @() },
            @{
                'Value' = @(
                    [PSCustomObject] @{ 'SKU' = 1 },
                    [PSCustomObject] @{ 'SKU' = 2 }
                )
            }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Management.Automation.PSCustomObject] )
        } # End of It
    } # End of Context

    $property = 'AdvBackupStatus'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'AgentVersion'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'bad_agent_version' },
            @{ 'Value' = '0.1' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '2.3.1.1' },
            @{ 'Value' = '2.3.0' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'AppID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'AppName'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'AppName' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'BiosUuid'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'bad_uuid' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '00000000-0000-0000-0000-000000000000' },
            @{ 'Value' = '077a7ae2-7b8f-4741-9f8c-a67929e4efa0' },
            @{ 'Value' = '05b67525-281c-4a1f-afa5-f6ba2d5151c0' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Guid] )
        } # End of It
    } # End of Context

    $property = 'CanReplicate'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'CanUseFluidScale'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'CoreDateRegistered'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '2018-06-03 17:01:43' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'CoreInstanceID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'bad_uuid' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '00000000-0000-0000-0000-000000000000' },
            @{ 'Value' = '44261d25-d50c-4483-b8a1-a7c01c2086a7' },
            @{ 'Value' = '159b4bc8-3950-4ea0-9738-78e95763fe5d' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Guid] )
        } # End of It
    } # End of Context

    $property = 'CoreLastPing'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '2018-06-03 17:04:28' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'CPU'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'CoreLastPing'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '2018-06-03 17:04:28' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'CPU'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'CustomLocation'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'The Final Frontier' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'CustomProvider'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Discount Cloud Shack' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'DateCreated'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '2018-06-03 19:27:56' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'DateRegistered'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '2018-06-03 19:28:26' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'Deployed'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'Disks'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = @() },
            @{ 'Value' = [ArmorDisk]::New() }
            @{ 'Value' = [ArmorDisk]::New(), [ArmorDisk]::New() }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorDisk] )
        } # End of It
    } # End of Context

    $property = 'ExternalAddress'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '::1' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '8.8.8.8' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'ExternalVmIsDeleted'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'Health'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'HostName'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'web1' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'HostType'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Virtual Machine' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'ID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 },
            @{ 'Value' = 'bbb22dd5-6699-49fb-a40a-046aaf2ffec' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 },
            @{ 'Value' = '0e6b2fc3-f50a-42d6-aca2-2bb736d123d1' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'InstanceType'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'IPAddress'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '::1' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '192.168.1.1' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'IsArmor'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'IsCore'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'IsDeleted'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'IsHealthy'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'IsRecoveryVM'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'IsRegistered'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'LastPing'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '2018-06-03 17:01:43' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'Location'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'Ragnarok' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'AMS01' },
            @{ 'Value' = 'DFW01' },
            @{ 'Value' = 'LHR01' },
            @{ 'Value' = 'PHX01' },
            @{ 'Value' = 'SIN01' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'Memory'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    $property = 'MultiVmVapp'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'Name'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'db1' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'NeedsReboot'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'Notes'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'This is a note.' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'OperatingSystem'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Ubuntu 16.04' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'OS'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Ubuntu 16.04' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'OsID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'Product'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = @() },
            @{ 'Value' = @( [ArmorVmProduct]::New() ) },
            @{ 'Value' = @( [ArmorVmProduct]::New(), [ArmorVmProduct]::New() ) }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorVmProduct] )
        } # End of It
    } # End of Context

    $property = 'ProfileName'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'Provider'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Amazon Web Services' },
            @{ 'Value' = 'AWS' },
            @{ 'Value' = 'complete' },
            @{ 'Value' = 'ArmorComplete' },
            @{ 'Value' = 'Armor Complete' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'ProviderID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'ProviderRefID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'i-06b18a64062dddbbf' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'ScheduledEvents'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = @() },
            @{
                'Value' = @(
                    [PSCustomObject] @{ 'ScheduledEvent' = 1 },
                    [PSCustomObject] @{ 'ScheduledEvent' = 2 }
                )
            }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Management.Automation.PSCustomObject] )
        } # End of It
    } # End of Context

    $property = 'Status'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'Banana' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = -1 },
            @{ 'Value' = 19 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorStatus] )
        } # End of It
    } # End of Context

    $property = 'StatusID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'Storage'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 18446744073709551615 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt64] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt64] )
        } # End of It
    } # End of Context

    $property = 'Tags'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = @() },
            @{ 'Value' = 'tag1' },
            @{ 'Value' = 'tag1', 'tag2' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'VmDateCreated'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '2018-06-04 01:32:16' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'vCenterID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'vCenterName'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'Nested Lab' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'AMS01T01-VC01' },
            @{ 'Value' = 'DFW01R01-VC01' },
            @{ 'Value' = 'DFW01T01-VC01' },
            @{ 'Value' = 'DFW01T01-VC02' },
            @{ 'Value' = 'DFW01T01-VC03' },
            @{ 'Value' = 'DFW01T01-VC04' },
            @{ 'Value' = 'LHR01T01-VC01' },
            @{ 'Value' = 'PHX01R01-VC01' },
            @{ 'Value' = 'PHX01T01-VC01' },
            @{ 'Value' = 'PHX01T01-VC02' },
            @{ 'Value' = 'PHX01T01-VC03' },
            @{ 'Value' = 'SIN01T01-VC01' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'vCDOrgVdcID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'VmBackupInProgress'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'VmID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'VmServices'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = @() },
            @{
                'Value' = @(
                    [PSCustomObject] @{ 'Service' = 1 },
                    [PSCustomObject] @{ 'Service' = 2 }
                )
            }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Management.Automation.PSCustomObject] )
        } # End of It
    } # End of Context

    $property = 'WorkloadID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'WorkloadName'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'WorkloadName' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $property = 'Zone'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'Danger' },
            @{ 'Value' = 'Twilight' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'AMS01-CD01' },
            @{ 'Value' = 'DFW01-CD01' },
            @{ 'Value' = 'LHR01-CD01' },
            @{ 'Value' = 'PHX01-CD01' },
            @{ 'Value' = 'SIN01-CD01' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context
} # End of Describe
