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
            { [ArmorAccount]::New() } |
                Should -Not -Throw
        }
    }

    [ArmorAccount] $temp = [ArmorAccount]::New()

    $property = 'ID'
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
            @{ Value = 'Test Account 1' }
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

    $property = 'Currency'
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
            @{ Value = 'USD' },
            @{ Value = 'GBP' }
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
            @{ Value = '' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'Claimed' },
            @{ Value = 'Cancelled' }
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

    $property = 'Parent'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = -2 },
            @{ Value = 65536 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = -1 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.Int32] )
        }
    }

    $property = 'Products'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = $null }
            @{
                Value = [PSCustomObject] @{
                    'AA-CORE'        = @( 'Invoicing', 'Payment Methods', 'Pricing', 'Account Contacts' )
                    'ARMOR-COMPLETE' = @( 'Invoicing' )
                }
            },
            @{
                Value = [PSCustomObject] @{
                    'AA-CORE' = @(
                        'Server Agent',
                        'Operating System Server Hardening',
                        'Operating System Patching',
                        'Monitoring',
                        'Anti-Malware and Virus Protection',
                        'Log Monitoring and Management',
                        'Vulnerability Scanning',
                        'File Integrity Monitoring',
                        'Invoicing',
                        'Payment Methods',
                        'Pricing',
                        'Account Contacts'
                    )
                }
            },
            @{ Value = [PSCustomObject] @{ 'ARMOR-COMPLETE' = @( 'Invoicing' ) } }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.Management.Automation.PSCustomObject] )
        }
    }

    Remove-Variable -Name 'temp'
}
