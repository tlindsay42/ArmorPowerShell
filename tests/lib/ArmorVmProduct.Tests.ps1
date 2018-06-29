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
            { [ArmorVmProduct]::New() } |
                Should -Not -Throw
        }
    }

    [ArmorVmProduct] $temp = [ArmorVmProduct]::New()

    $property = 'SKU'
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
            @{ 'Value' = 'A3-143' },
            @{ 'Value' = 'M3-102' },
            @{ 'Value' = 'T2-102' }
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

    $property = 'Size'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'A1' }
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

    $property = 'IsExpired'
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

    $property = 'StoragePolicyClass'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'SSD' }
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
