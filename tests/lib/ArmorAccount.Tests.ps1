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
            { [ArmorAccount]::New() } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    [ArmorAccount] $temp = [ArmorAccount]::New()

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
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
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
            @{ 'Value' = 'Test Account 1' }
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

    $property = 'Currency'
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
            @{ 'Value' = 'USD' },
            @{ 'Value' = 'GBP' }
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
            @{ 'Value' = '' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Claimed' },
            @{ 'Value' = 'Cancelled' }
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

    $property = 'Parent'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -2 },
            @{ 'Value' = 65536 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = -1 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Int32] )
        } # End of It
    } # End of Context

    $property = 'Products'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
            @{
                'Value' = [PSCustomObject] @{
                    'AA-CORE'        = @( 'Invoicing', 'Payment Methods', 'Pricing', 'Account Contacts' )
                    'ARMOR-COMPLETE' = @( 'Invoicing' )
                }
            },
            @{
                'Value' = [PSCustomObject] @{
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
            @{ 'Value' = [PSCustomObject] @{ 'ARMOR-COMPLETE' = @( 'Invoicing' ) } }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Management.Automation.PSCustomObject] )
        } # End of It
    } # End of Context

    Remove-Variable -Name 'temp'
} # End of Describe
