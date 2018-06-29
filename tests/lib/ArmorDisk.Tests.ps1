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
            { [ArmorDisk]::New() } |
                Should -Not -Throw
        }
    }

    [ArmorDisk] $temp = [ArmorDisk]::New()

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
        }

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 4294967295 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt32] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt32] )
        }
    }

    $property = 'Capacity'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 0 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 9223372036854775807 }
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

    $property = 'Name'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Disk' },
            @{ 'Value' = 'Disk ' },
            @{ 'Value' = 'Disk1' },
            @{ 'Value' = 'Disk sda' },
            @{ 'Value' = 'Disk 0' },
            @{ 'Value' = 'Disk 61' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ 'Value' = 'Disk 1' },
            @{ 'Value' = 'Disk 60' }
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

    $property = 'Type'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Performance' },
            @{ 'Value' = 'Capacity' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ 'Value' = 'SSD' },
            @{ 'Value' = 'Fluid' },
            @{ 'Value' = 'Raw' }
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
