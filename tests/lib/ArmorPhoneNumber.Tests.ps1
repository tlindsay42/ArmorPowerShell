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
            { [ArmorPhoneNumber]::New() } |
                Should -Not -Throw
        }
    }

    [ArmorPhoneNumber] $temp = [ArmorPhoneNumber]::New()

    $property = 'CountryCode'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 1000 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 999 }
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

    $property = 'CountryIsoCode'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '1' },
            @{ 'Value' = '999' },
            @{ 'Value' = '1000' }
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

    $property = 'Number'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ 'Value' = '5558675309' },
            @{ 'Value' = '555.867.5309' },
            @{ 'Value' = '555 867 5309' },
            @{ 'Value' = '555-867-5309' },
            @{ 'Value' = '(555) 867-5309' },
            @{ 'Value' = '(5555) 867 5309' },
            @{ 'Value' = '(555) 5867 5309' }
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

    $property = 'PhoneExt'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '1' },
            @{ 'Value' = ',,,5555' }
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
