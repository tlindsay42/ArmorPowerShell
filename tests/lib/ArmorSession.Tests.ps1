$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_LIB_PATH -ChildPath $systemUnderTest

. $filePath

$class = 'ArmorUser'
$describe = $Global:ClassForm -f $class
Describe -Name $describe -Tag 'Class', $class -Fixture {
    #region init
    #endregion

    Context -Name $Global:Constructors -Fixture {
        It -Name $Global:DefaultConstructorForm -Test {
            { [ArmorUser]::New() } |
                Should -Not -Throw
        }
    } # End of Context

    [ArmorUser] $temp = [ArmorUser]::New()

    $property = 'Type'
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
            @{ 'Value' = 'User' }
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

    $property = 'UserName'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'username' },
            @{ 'Value' = 'username@example' },
            @{ 'Value' = 'username@example.c' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'username@example.com' },
            @{ 'Value' = 'user.name@example.com' },
            @{ 'Value' = 'user.name@example.company.com' }
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

    $property = 'FirstName'
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
            @{ 'Value' = 'First' },
            @{ 'Value' = 'First Name' }
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

    $property = 'LastName'
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
            @{ 'Value' = 'Last' },
            @{ 'Value' = 'Last Name' }
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

    $property = 'Links'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [PSCustomObject] @{ 'UserID' = 1 } }
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

$class = 'ArmorAccount'
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
                    'AA-CORE' = @( 'Invoicing', 'Payment Methods', 'Pricing', 'Account Contacts' )
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

$class = 'ArmorDepartment'
$describe = $Global:ClassForm -f $class
Describe -Name $describe -Tag 'Class', $class -Fixture {
    #region init
    #endregion

    Context -Name $Global:Constructors -Fixture {
        It -Name $Global:DefaultConstructorForm -Test {
            { [ArmorDepartment]::New() } |
                Should -Not -Throw
        } # End of It
    } # End of Context

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
            @{ 'Value' = 'Test Department 1' }
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

    Remove-Variable -Name 'temp'
} # End of Describe

$class = 'ArmorFeature'
$describe = $Global:ClassForm -f $class
Describe -Name $describe -Tag 'Class', $class -Fixture {
    #region init
    #endregion

    Context -Name $Global:Constructors -Fixture {
        It -Name $Global:DefaultConstructorForm -Test {
            { [ArmorFeature]::New() } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    [ArmorFeature] $temp = [ArmorFeature]::New()

    $property = 'AccountID'
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

    $property = 'Feature'
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
            @{ 'Value' = 'Advanced Backup' },
            @{ 'Value' = 'Encryption' }
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

    $property = 'ProductID'
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

    $property = 'FeatureID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = -1 },
            @{ 'Value' = 65536 }
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
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    Remove-Variable -Name 'temp'
} # End of Describe

$class = 'ArmorSession'
$describe = $Global:ClassForm -f $class
Describe -Name $describe -Tag 'Class', $class -Fixture {
    #region init
    $validServer = 'api.armor.com'
    $validPort = 443
    $validApiVersion = 'v1.0'
    $validMediaType = 'application/json'
    $validSessionLength = 15
    $validToken = 'ee3b7d9cc1204434a990d896926d0433'

    [ArmorAccount[]] $accounts = @()
    $accounts += @{
        'ID'       = 1
        'Name'     = 'Test account 1'
        'Currency' = 'USD'
        'Parent'   = -1
        'Products' = $null
    }
    $accounts += @{
        'ID'       = 2
        'Name'     = 'Test account 2'
        'Currency' = 'GBP'
        'Parent'   = 1
        'Products' = $null
    }
    #endregion

    Context -Name $Global:Constructors -Fixture {
        It -Name $Global:DefaultConstructorForm -Test {
            { [ArmorSession]::New() } |
                Should -Not -Throw
        } # End of It

        $testCases = @(
            @{
                # Invalid server
                'Server'     = ''
                'Port'       = $validPort
                'ApiVersion' = $validApiVersion
            },
            @{
                # Invalid port
                'Server'     = $validServer
                'Port'       = 0
                'ApiVersion' = $validApiVersion
            },
            @{
                # Invalid API version
                'Server'     = $validServer
                'Port'       = $validPort
                'ApiVersion' = 'v1'
            }
        )
        $testName = (
            'should fail when creating an object with parameters: ' +
            "'Server': <Server> 'Port': <Port> 'ApiVersion': <ApiVersion>"
        )
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Server, [UInt16] $Port, [String] $ApiVersion )
            { [ArmorSession]::New( $Server, $Port, $ApiVersion ) } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{
                'Server'     = $validServer
                'Port'       = $validPort
            },
            @{
                'Server'     = 'localhost'
                'Port'       = 80
            },
            @{
                'Server'     = 'api.armor.local'
                'Port'       = 8443
            }
        )
        $testName = (
            'should not fail when creating an object with parameters: ' +
            "'Server': <Server> 'Port': <Port> 'ApiVersion': '${validApiVersion}'"
        )
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Server, [UInt16] $Port )
            { [ArmorSession]::New( $Server, $Port, $validApiVersion ) } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    [ArmorSession] $temp = [ArmorSession]::New( $validServer, $validPort, $validApiVersion )

    $property = 'User'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [ArmorUser]::New() }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorUser] )
        } # End of It
    } # End of Context

    $property = 'Accounts'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [ArmorAccount]::New() },
            @{ 'Value' = [ArmorAccount]::New(), [ArmorAccount]::New() }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorAccount] )
        } # End of It
    } # End of Context

    $property = 'Departments'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [ArmorDepartment]::New() },
            @{ 'Value' = [ArmorDepartment]::New(), [ArmorDepartment]::New() }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorDepartment] )
        } # End of It
    } # End of Context

    $property = 'Permissions'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [PSCustomObject] @{ 1 = @( 1, 10, 100 ) } },
            @{ 'Value' = [PSCustomObject] @{ 1 = @( 1, 10, 100 ) }, [PSCustomObject] @{ 2 = @( 1, 10, 100 ) } }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSObject[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Management.Automation.PSCustomObject] )
        } # End of It
    } # End of Context

    $property = 'Features'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Features = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [ArmorFeature]::New() },
            @{ 'Value' = [ArmorFeature]::New(), [ArmorFeature]::New() }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Features = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.Features |
                Should -BeOfType ( [ArmorFeature] )
        } # End of It
    } # End of Context

    $property = 'Server'
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
            @{ 'Value' = $validServer },
            @{ 'Value' = 'localhost' },
            @{ 'Value' = 'api.armor.local' }
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

    $property = 'Port'
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
            @{ 'Value' = $validPort },
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

    $property = 'SessionLengthInMinutes'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 1801 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 15 }
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

    $property = 'SessionStartTime'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSObject] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = Get-Date }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [DateTime] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.DateTime] )
        } # End of It
    } # End of Context

    $property = 'SessionExpirationTime'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSObject] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = Get-Date }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [DateTime] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.DateTime] )
        } # End of It
    } # End of Context

    $property = 'ApiVersion'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'v0.1' },
            @{ 'Value' = 'v1' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = $validApiVersion }
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

    $property = 'AccountContextHeader'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'Account-Context' },
            @{ 'Value' = 'X-Account-Context1' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'X-Account-Context' }
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

    $property = 'AuthenticationType'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'Bearer' },
            @{ 'Value' = 'FH-AUTH1' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'FH-AUTH' }
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

    $property = 'MediaType'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'application/javascript' },
            @{ 'Value' = 'application/xml' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = $validMediaType }
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

    $property = 'Headers'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [Hashtable] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = @{} },
            @{
                'Value' = @{
                    'Accept'       = $validMediaType
                    'Content-Type' = $validMediaType
                }
            }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [Hashtable] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Collections.Hashtable] )
        } # End of It
    } # End of Context

    $method = 'Authorize'
    $context = $Global:MethodNegativeForm -f $method
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = '-' },
            @{ 'Value' = '63724fcc-e004-44d2-88a2-d5f5877386d3' }
        )
        It -Name 'should not authorize a session when passed an invalid token: <Value>' -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$method( $Value, $validSessionLength ) } |
                Should -Throw
        } # End of It
    } # End of Context

    $returnForm = "should return 'false'"

    $method = 'IsActive'
    $context = $Global:MethodNegativeForm -f $method
    Context -Name $context -Fixture {
        It -Name $returnForm -Test {
            $temp.$method() |
                Should -Be $false
        } # End of It
    } # End of Context

    $method = 'AuthorizationExists'
    $context = $Global:MethodNegativeForm -f $method
    Context -Name $context -Fixture {
        It -Name $returnForm -Test {
            $temp.$method() |
                Should -Be $false
        } # End of It
    } # End of Context

    $testName = 'should be less than one since the session has not been authorized'

    $method = 'GetMinutesRemaining'
    $context = $Global:MethodNegativeForm -f $method
    Context -Name $context -Fixture {
        It -Name $testName -Test {
            $temp.$method() |
                Should -BeLessThan 1
        } # End of It

        It -Name $Global:ReturnTypeForm -Test {
            $temp.$method() |
                Should -BeOfType ( [System.Int32] )
        } # End of It
    } # End of Context

    $method = 'GetSecondsRemaining'
    $context = $Global:MethodNegativeForm -f $method
    Context -Name $context -Fixture {
        It -Name $testName -Test {
            $temp.$method() |
                Should -BeLessThan 1
        } # End of It

        It -Name $Global:ReturnTypeForm -Test {
            $temp.$method() |
                Should -BeOfType ( [System.Int32] )
        } # End of It
    } # End of Context

    $method = 'GetToken'
    $context = $Global:MethodNegativeForm -f $method
    Context -Name $context -Fixture {
        It -Name 'should fail to get an authentication token since the session has not been authorized' -Test {
            { $temp.$method() } |
                Should -Throw
        } # End of It
    } # End of Context

    $method = 'SetAccountContext'
    $context = $Global:MethodNegativeForm -f $method
    Context -Name $context -Fixture {
        It -Name 'should fail to set the account context when no accounts have been loaded' -Test {
            { [ArmorSession]::New().$method( 1 ) } |
                Should -Throw
        } # End of It
    } # End of Context

    $method = 'GetAccountContext'
    $context = $Global:MethodNegativeForm -f $method
    Context -Name $context -Fixture {
        It -Name 'should fail to get the account context since it has not been set' -Test {
            { $temp.$method() } |
                Should -Throw
        } # End of It
    } # End of Context

    $method = 'GetAccountContextID'
    $context = $Global:MethodNegativeForm -f $method
    Context -Name $context -Fixture {
        It -Name 'should fail to get the account context ID since it has not been set' -Test {
            { $temp.$method() } |
                Should -Throw
        } # End of It
    } # End of Context

    $method = 'Authorize'
    $context = $Global:MethodPositiveForm -f $method
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $validToken }
        )
        It -Name 'should authorize a session when passed a valid token: <Value>' -TestCases $testCases -Test {
            param ( [String] $Value )
            $temp.$method( $Value, $validSessionLength ) |
                Should -Be $null
        } # End of It
    } # End of Context

    $returnForm = "should return 'true'"

    $method = 'IsActive'
    $context = $Global:MethodPositiveForm -f $method
    Context -Name $context -Fixture {
        It -Name $returnForm -Test {
            $temp.$method() |
                Should -Be $true
        } # End of It

        It -Name $Global:ReturnTypeForm -Test {
            $temp.$method() |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $method = 'AuthorizationExists'
    $context = $Global:MethodPositiveForm -f $method
    Context -Name $context -Fixture {
        It -Name $returnForm -Test {
            $temp.$method() |
                Should -Be $true
        } # End of It

        It -Name $Global:ReturnTypeForm -Test {
            $temp.$method() |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $method = 'GetMinutesRemaining'
    $context = $Global:MethodPositiveForm -f $method
    Context -Name $context -Fixture {
        It -Name 'should get minutes remaining before session expiration' -Test {
            $temp.$method() |
                Should -BeGreaterThan 0
        } # End of It

        It -Name $Global:ReturnTypeForm -Test {
            $temp.$method() |
                Should -BeOfType ( [System.Int32] )
        } # End of It
    } # End of Context

    $method = 'GetSecondsRemaining'
    $context = $Global:MethodPositiveForm -f $method
    Context -Name $context -Fixture {
        It -Name 'should get seconds remaining before session expiration' -Test {
            $temp.$method() |
                Should -BeGreaterThan 0
        } # End of It

        It -Name $Global:ReturnTypeForm -Test {
            $temp.$method() |
                Should -BeOfType ( [System.Int32] )
        } # End of It
    } # End of Context

    $method = 'GetToken'
    $context = $Global:MethodPositiveForm -f $method
    Context -Name $context -Fixture {
        It -Name 'should get the authentication token' -Test {
            $temp.$method() |
                Should -BeExactly $validToken
        } # End of It

        It -Name 'should return the expected data type' -Test {
            $temp.$method() |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    $method = 'SetAccountContext'
    $context = $Global:MethodForm -f $method
    Context -Name $context -Fixture {
        $temp.Accounts = $accounts

        It -Name 'should fail to set the account context to invalid account ID' -Test {
            param ( [Int32] $Value )
            { $temp.$method( $Value ) } |
                Should -Throw
        } # End of It

        It -Name 'should not fail to set the account context to a valid account ID' -Test {
            $temp.$method( 1 ) |
                Should -Be $accounts[0]
        } # End of It

        It -Name $Global:ReturnTypeForm -Test {
            $temp.$method( 1 ) |
                Should -BeOfType ( [ArmorAccount] )
        } # End of It
    } # End of Context

    $method = 'GetAccountContext'
    $context = $Global:MethodPositiveForm -f $method
    Context -Name $context -Fixture {
        It -Name 'should get the expected account context' -Test {
            $temp.$method() |
                Should -Be $accounts[0]
        } # End of It

        It -Name $Global:ReturnTypeForm -Test {
            $temp.$method() |
                Should -BeOfType ( [ArmorAccount] )
        } # End of It
    } # End of Context

    $method = 'GetAccountContextID'
    $context = $Global:MethodPositiveForm -f $method
    Context -Name $context -Fixture {
        It -Name 'should get the expected account context ID' -Test {
            $temp.$method() |
                Should -Be 1
        } # End of It

        It -Name $Global:ReturnTypeForm -Test {
            $temp.$method() |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context
} # End of Describe
