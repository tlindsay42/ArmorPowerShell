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
            { [ArmorDepartment]::New() } |
                Should -Not -Throw
        }
    }

    [ArmorDepartment] $temp = [ArmorDepartment]::New()

    $property = 'ID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65536 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

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
        }

        $testCases = @(
            @{ 'Value' = 'Test Department 1' }
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

    $property = 'Account'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65536 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    Remove-Variable -Name 'temp'
}
