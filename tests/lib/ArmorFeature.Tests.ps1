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
            { [ArmorFeature]::New() } |
                Should -Not -Throw
        }
    }

    [ArmorFeature] $temp = [ArmorFeature]::New()

    $property = 'AccountID'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 0 },
            @{ Value = 65536 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 1 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'Feature'
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
            @{ Value = 'Advanced Backup' },
            @{ Value = 'Encryption' }
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

    $property = 'ProductID'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 0 },
            @{ Value = 65536 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 1 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'FeatureID'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = -1 },
            @{ Value = 65536 }
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
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    Remove-Variable -Name 'temp'
}
