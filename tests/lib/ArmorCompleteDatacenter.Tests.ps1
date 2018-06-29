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
            { [ArmorCompleteDatacenter]::New() } |
                Should -Not -Throw
        }
    }

    [ArmorCompleteDatacenter] $temp = [ArmorCompleteDatacenter]::New()

    $property = 'ID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 0 },
            @{ Value = 6 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 1 },
            @{ Value = 5 }
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

    $property = 'Location'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'DFW' },
            @{ Value = 1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'AMS01' },
            @{ Value = 'DFW01' },
            @{ Value = 'LHR01' },
            @{ Value = 'PHX01' },
            @{ Value = 'SIN01' }
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

    $property = 'Name'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 'AS' },
            @{ Value = 'US' },
            @{ Value = 'DFW01' },
            @{ Value = 1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'AS East' },
            @{ Value = 'EU Central' },
            @{ Value = 'EU West' },
            @{ Value = 'US Central' },
            @{ Value = 'US West' }
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

    $property = 'Zones'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 'DFW01-VC01' },
            @{ Value = 'DFW01T01-VC05' },
            @{ Value = 1 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
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

    Remove-Variable -Name 'temp'
}
