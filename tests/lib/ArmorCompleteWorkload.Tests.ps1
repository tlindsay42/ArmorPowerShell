$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $Env:CI_MODULE_LIB_PATH -ChildPath $systemUnderTest

. $filePath

$class = $systemUnderTest.Split( '.' )[0]
$describe = $Global:ClassForm -f $class
Describe -Name $describe -Tag 'Class', $class -Fixture {
    #region init
    #endregion

    Context -Name $Global:Constructors -Fixture {
        It -Name $Global:DefaultConstructorForm -Test {
            { [ArmorCompleteWorkload]::New() } |
                Should -Not -Throw
        }
    } # End of Context

    [ArmorCompleteWorkload] $temp = [ArmorCompleteWorkload]::New()

    $property = 'ID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 0 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
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

    $property = 'Name'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'LAMP stack' }
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
            @{ 'Value' = 'DFW' },
            @{ 'Value' = 1 }
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

    $property = 'Zone'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'DFW01-VC01' },
            @{ 'Value' = 'DFW01T01-VC05' },
            @{ 'Value' = 1 }
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

    $property = 'Status'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
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

    $property = 'TierCount'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
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

    $property = 'VMCount'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
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

    $property = 'TotalCPU'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
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

    $property = 'TotalMemory'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
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

    $property = 'TotalStorage'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
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

    $property = 'IsRecoveryWorkload'
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

    $property = 'Tiers'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = [PSCustomObject] @() },
            @{ 'Value' = [PSCustomObject] @{ 'Tier1' = '1' } }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [PSCustomObject] )
        } # End of It
    } # End of Context

    $property = 'Notes'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Note to self.' }
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

    $property = 'Health'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
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

    $property = 'Tags'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Tag1', 'Tag2' }
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

    Remove-Variable -Name 'temp'
} # End of Describe
