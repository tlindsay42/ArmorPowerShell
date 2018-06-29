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
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'ABCDE-FGHIJ-KLMNO-PQRST-UVWXY' },
            @{ 'Value' = '01234-56789-LMNOP-QRSTU-VWXYZ' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Management.Automation.PSCustomObject] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '2.3.1.1' },
            @{ 'Value' = '2.3.0' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = '00000000-0000-0000-0000-000000000000' },
            @{ 'Value' = '077a7ae2-7b8f-4741-9f8c-a67929e4efa0' },
            @{ 'Value' = '05b67525-281c-4a1f-afa5-f6ba2d5151c0' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Guid] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = '00000000-0000-0000-0000-000000000000' },
            @{ 'Value' = '44261d25-d50c-4483-b8a1-a7c01c2086a7' },
            @{ 'Value' = '159b4bc8-3950-4ea0-9738-78e95763fe5d' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Guid] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorDisk] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '8.8.8.8' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '192.168.1.1' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = @() },
            @{ 'Value' = @( [ArmorVmProduct]::New() ) },
            @{ 'Value' = @( [ArmorVmProduct]::New(), [ArmorVmProduct]::New() ) }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorVmProduct] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Management.Automation.PSCustomObject] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = -1 },
            @{ 'Value' = 19 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorStatus] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 18446744073709551615 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt64] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt64] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Management.Automation.PSCustomObject] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

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
        }

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
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }
}
