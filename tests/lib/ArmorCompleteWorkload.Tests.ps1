$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_LIB_PATH -ChildPath 'ArmorTypes.ps1'

. $filePath

$class = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_CLASS -f $class
Describe -Name $describe -Tag 'Class', $class -Fixture {
    #region init
    #endregion

    Context -Name $Global:CONSTRUCTORS -Fixture {
        It -Name $Global:FORM_DEFAULT_CONTRUCTORS -Test {
            { [ArmorCompleteWorkload]::New() } |
                Should -Not -Throw
        }
    }

    [ArmorCompleteWorkload] $temp = [ArmorCompleteWorkload]::New()

    $property = 'ID'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 0 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 1 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'Name'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'LAMP stack' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'Location'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 'DFW' },
            @{ Value = 1 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = '' },
            @{ Value = 'AMS01' },
            @{ Value = 'DFW01' },
            @{ Value = 'LHR01' },
            @{ Value = 'PHX01' },
            @{ Value = 'SIN01' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'Zone'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 'DFW01-VC01' },
            @{ Value = 'DFW01T01-VC05' },
            @{ Value = 1 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = '' },
            @{ Value = 'AMS01T01-VC01' },
            @{ Value = 'DFW01R01-VC01' },
            @{ Value = 'DFW01T01-VC01' },
            @{ Value = 'DFW01T01-VC02' },
            @{ Value = 'DFW01T01-VC03' },
            @{ Value = 'DFW01T01-VC04' },
            @{ Value = 'LHR01T01-VC01' },
            @{ Value = 'PHX01R01-VC01' },
            @{ Value = 'PHX01T01-VC01' },
            @{ Value = 'PHX01T01-VC02' },
            @{ Value = 'PHX01T01-VC03' },
            @{ Value = 'SIN01T01-VC01' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'Status'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 'Banana' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = -1 },
            @{ Value = 19 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [Int16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorStatus] )
        }
    }

    $property = 'Deployed'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 'True' },
            @{ Value = 'False' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

    $property = 'TierCount'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = -1 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 0 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'VMCount'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = -1 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 0 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'TotalCPU'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = -1 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 0 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'TotalMemory'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = -1 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 0 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'TotalStorage'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = -1 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 0 },
            @{ Value = 18446744073709551615 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [UInt64] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt64] )
        }
    }

    $property = 'IsRecoveryWorkload'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 'True' },
            @{ Value = 'False' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

    $property = 'Tiers'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = [PSCustomObject] @{ Tier1 = '1' } }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = @() },
            @{ Value = [ArmorCompleteWorkloadTier]::New() },
            @{ Value = [ArmorCompleteWorkloadTier]::New(), [ArmorCompleteWorkloadTier]::New() }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorCompleteWorkloadTier] )
        }
    }

    $property = 'Notes'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'Note to self.' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'Health'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = -1 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 0 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'Tags'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'Tag1', 'Tag2' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    Remove-Variable -Name 'temp'
}
