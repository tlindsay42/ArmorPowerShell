$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_LIB_PATH -ChildPath $systemUnderTest

. $filePath

Describe -Name 'ArmorUser' -Tag 'ArmorUser', 'Class' -Fixture {
    #region init
    [ArmorUser] $temp = [ArmorUser]::New()
    #endregion

    Context -Name 'Constructors' -Fixture {
        It -Name 'should create an object with the default constructor' -Test {
            { [ArmorUser]::New() } |
                Should -Not -Throw
        }
    } # End of Context

    Context -Name 'Properties/Type' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorUser.Type is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Type = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'User' }
        )
        It -Name "should not fail when ArmorUser.Type is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Type = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/UserName' -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'username' },
            @{ 'Value' = 'username@example' },
            @{ 'Value' = 'username@example.c' }
        )
        It -Name "should fail when ArmorUser.UserName is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.UserName = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'username@example.com' },
            @{ 'Value' = 'user.name@example.com' }
        )
        It -Name "should not fail when ArmorUser.UserName is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.UserName = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/FirstName' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorUser.FirstName is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.FirstName = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'First' }
        )
        It -Name "should not fail when ArmorUser.FirstName is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.FirstName = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/LastName' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorUser.LastName is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.LastName = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Last' }
        )
        It -Name "should not fail when ArmorUser.LastName is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.LastName = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Links' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should fail when ArmorUser.Links is set to `$null" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Links = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [PSCustomObject] @{ 'UserID' = 1 } }
        )
        It -Name "should not fail when ArmorUser.Links is set to '<Value>'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Links = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Remove-Variable -Name 'temp'
} # End of Describe

Describe -Name 'ArmorAccount' -Tag 'ArmorAccount', 'Class' -Fixture {
    #region init
    [ArmorAccount] $temp = [ArmorAccount]::New()
    #endregion

    Context -Name 'Constructors' -Fixture {
        It -Name 'should create an object with the default constructor' -Test {
            { [ArmorAccount]::New() } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/ID' -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65536 }
        )
        It -Name "should fail when ArmorAccount.ID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.ID = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name "should not fail when ArmorAccount.ID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.ID = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Name' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorAccount.Name is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Name = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Test Account 1' }
        )
        It -Name "should not fail when ArmorAccount.Name is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Name = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Status' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorAccount.Status is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Status = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Claimed' },
            @{ 'Value' = 'Cancelled' }
        )
        It -Name "should not fail when ArmorAccount.Status is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Status = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Parent' -Fixture {
        $testCases = @(
            @{ 'Value' = -2 },
            @{ 'Value' = 65536 }
        )
        It -Name "should fail when ArmorAccount.Parent is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.Parent = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = -1 },
            @{ 'Value' = 65535 }
        )
        It -Name "should not fail when ArmorAccount.Parent is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.Parent = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Products' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should not fail when ArmorAccount.Products is set to `$null" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Products = $Value } |
                Should -Not -Throw
        } # End of It

        $testCases = @(
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
        It -Name "should not fail when ArmorAccount.Products is set to '<Value>'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Products = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Remove-Variable -Name 'temp'
} # End of Describe

Describe -Name 'ArmorDepartment' -Tag 'ArmorDepartment', 'Class' -Fixture {
    #region init
    [ArmorDepartment] $temp = [ArmorDepartment]::New()
    #endregion

    Context -Name 'Constructors' -Fixture {
        It -Name 'should create an object with the default constructor' -Test {
            { [ArmorDepartment]::New() } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/ID' -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65536 }
        )
        It -Name "should fail when ArmorDepartment.ID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.ID = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name "should not fail when ArmorDepartment.ID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.ID = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Name' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorDepartment.Name is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Name = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Test Department 1' }
        )
        It -Name "should not fail when ArmorDepartment.Name is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Name = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Account' -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65536 }
        )
        It -Name "should fail when ArmorDepartment.Account is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.Account = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name "should not fail when ArmorDepartment.Account is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.Account = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Remove-Variable -Name 'temp'
} # End of Describe

Describe -Name 'ArmorFeature' -Tag 'ArmorFeature', 'Class' -Fixture {
    #region init
    [ArmorFeature] $temp = [ArmorFeature]::New()
    #endregion

    Context -Name 'Constructors' -Fixture {
        It -Name 'should create an object with the default constructor' -Test {
            { [ArmorFeature]::New() } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/ID' -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65536 }
        )
        It -Name "should fail when ArmorFeature.AccountID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.AccountID = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name "should not fail when ArmorFeature.AccountID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.AccountID = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Feature' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorFeature.Feature is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Feature = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Advanced Backup' },
            @{ 'Value' = 'Encryption' }
        )
        It -Name "should not fail when ArmorFeature.Feature is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Feature = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/ProductID' -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65536 }
        )
        It -Name "should fail when ArmorFeature.ProductID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.ProductID = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name "should not fail when ArmorFeature.ProductID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.ProductID = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/FeatureID' -Fixture {
        $testCases = @(
            @{ 'Value' = -1 },
            @{ 'Value' = 65536 }
        )
        It -Name "should fail when ArmorFeature.FeatureID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.FeatureID = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65535 }
        )
        It -Name "should not fail when ArmorFeature.FeatureID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.FeatureID = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Remove-Variable -Name 'temp'
} # End of Describe

Describe -Name 'ArmorSession' -Tag 'ArmorSession', 'Class' -Fixture {
    #region init
    $validServer = 'api.armor.com'
    $validPort = 443
    $validApiVersion = 'v1.0'
    $validMediaType = 'application/json'
    $validSessionLength = 1800
    $validToken = 'ee3b7d9cc1204434a990d896926d0433'
    #endregion

    Context -Name 'Constructors' -Fixture {
        It -Name 'should not fail when creating an object with no parameters' -Test {
            { [ArmorSession]::New() } |
                Should -Not -Throw
        } # End of It

        $testCases = @(
            @{
                'Server'     = $validServer
                'Port'       = $validPort
            },
            @{
                'Server'     = 'banana'
                'Port'       = 80
            },
            @{
                'Server'     = 'google.com'
                'Port'       = 8443
            }
        )
        It -Name 'should not fail when creating an object with invalid parameters' -TestCases $testCases -Test {
            param ( [String] $Server, [UInt16] $Port )
            { [ArmorSession]::New( $Server, $Port, $validApiVersion ) } |
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
        It -Name 'should fail when creating an object with invalid parameters' -TestCases $testCases -Test {
            param ( [String] $Server, [UInt16] $Port, [String] $ApiVersion )
            { [ArmorSession]::New( $Server, $Port, $ApiVersion ) } |
                Should -Throw
        } # End of It
    } # End of Context

    [ArmorSession] $temp = [ArmorSession]::New( $validServer, $validPort, $validApiVersion )

    Context -Name 'Properties/User' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should fail when ArmorSession.User is set to '`$null'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.User = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [ArmorUser]::New() }
        )
        It -Name "should not fail when ArmorSession.User is set to '<Value>'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.User = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Accounts' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should fail when ArmorSession.Accounts is set to '`$null'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Accounts = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [ArmorAccount]::New() },
            @{ 'Value' = [ArmorAccount]::New(), [ArmorAccount]::New() }
        )
        It -Name "should not fail when ArmorSession.Accounts is set to '<Value>'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Accounts = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Departments' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should fail when ArmorSession.Departments is set to '`$null'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Departments = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [ArmorDepartment]::New() },
            @{ 'Value' = [ArmorDepartment]::New(), [ArmorDepartment]::New() }
        )
        It -Name "should not fail when ArmorSession.Departments is set to '<Value>'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Departments = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Permissions' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should fail when ArmorSession.Permissions is set to '`$null'" -TestCases $testCases -Test {
            param ( [PSObject[]] $Value )
            { $temp.Permissions = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [PSCustomObject] @{ 1 = @( 1, 10, 100 ) } },
            @{ 'Value' = [PSCustomObject] @{ 1 = @( 1, 10, 100 ) }, [PSCustomObject] @{ 2 = @( 1, 10, 100 ) } }
        )
        It -Name "should not fail when ArmorSession.Permissions is set to '<Value>'" -TestCases $testCases -Test {
            param ( [PSObject[]] $Value )
            { $temp.Permissions = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Features' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should fail when ArmorSession.Features is set to '`$null'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Features = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = [ArmorFeature]::New() },
            @{ 'Value' = [ArmorFeature]::New(), [ArmorFeature]::New() }
        )
        It -Name "should not fail when ArmorSession.Features is set to '<Value>'" -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Value )
            { $temp.Features = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Server' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorSession.Server is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Server = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = $validServer },
            @{ 'Value' = 'banana' },
            @{ 'Value' = 'google.com' }
        )
        It -Name "should not fail when ArmorSession.Server is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Server = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Port' -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65536 }
        )
        It -Name "should fail when ArmorSession.Port is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.Port = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = $validPort },
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name "should not fail when ArmorSession.Port is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.Port = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/SessionLengthInSeconds' -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 1801 }
        )
        It -Name "should fail when ArmorSession.SessionLengthInSeconds is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.SessionLengthInSeconds = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 1800 }
        )
        It -Name "should not fail when ArmorSession.SessionLengthInSeconds is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Int32] $Value )
            { $temp.SessionLengthInSeconds = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/SessionStartTime' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should fail when ArmorSession.SessionStartTime is set to '<Value>'" -TestCases $testCases -Test {
            param ( [PSObject] $Value )
            { $temp.SessionStartTime = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = Get-Date }
        )
        It -Name "should not fail when ArmorSession.SessionStartTime is set to '<Value>'" -TestCases $testCases -Test {
            param ( [DateTime] $Value )
            { $temp.SessionStartTime = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/SessionExpirationTime' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should fail when ArmorSession.SessionExpirationTime is set to '<Value>'" -TestCases $testCases -Test {
            param ( [PSObject] $Value )
            { $temp.SessionExpirationTime = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = Get-Date }
        )
        It -Name "should not fail when ArmorSession.SessionExpirationTime is set to '<Value>'" -TestCases $testCases -Test {
            param ( [DateTime] $Value )
            { $temp.SessionExpirationTime = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/ApiVersion' -Fixture {
        $testCases = @(
            @{ 'Value' = 'v0.1' },
            @{ 'Value' = 'v1' }
        )
        It -Name "should fail when ArmorSession.ApiVersion is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.ApiVersion = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = $validApiVersion }
        )
        It -Name "should not fail when ArmorSession.ApiVersion is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.ApiVersion = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/AccountContextHeader' -Fixture {
        $testCases = @(
            @{ 'Value' = 'Account-Context' },
            @{ 'Value' = 'X-Account-Context1' }
        )
        It -Name "should fail when ArmorSession.AccountContextHeader is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.AccountContextHeader = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'X-Account-Context' }
        )
        It -Name "should not fail when ArmorSession.AccountContextHeader is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.AccountContextHeader = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/AuthenticationType' -Fixture {
        $testCases = @(
            @{ 'Value' = 'Bearer' },
            @{ 'Value' = 'FH-AUTH1' }
        )
        It -Name "should fail when ArmorSession.AuthenticationType is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.AuthenticationType = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'FH-AUTH' }
        )
        It -Name "should not fail when ArmorSession.AuthenticationType is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.AuthenticationType = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/MediaType' -Fixture {
        $testCases = @(
            @{ 'Value' = 'application/javascript' },
            @{ 'Value' = 'application/xml' }
        )
        It -Name "should fail when ArmorSession.MediaType is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.MediaType = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = $validMediaType }
        )
        It -Name "should not fail when ArmorSession.MediaType is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.MediaType = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Headers' -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name "should fail when ArmorSession.Headers is set to '`$null'" -TestCases $testCases -Test {
            param ( [Hashtable] $Value )
            { $temp.Headers = $Value } |
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
        It -Name "should not fail when ArmorSession.Headers is set to '<Value>'" -TestCases $testCases -Test {
            param ( [Hashtable] $Value )
            { $temp.Headers = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Invalid session' -Fixture {
        It -Name 'should fail to authorize an invalid token' -Test {
            { $temp.Authorize( '-', $validSessionLength ) } |
                Should -Throw
        } # End of It

        It -Name 'should not be an active session' -Test {
            $temp.IsActive() |
                Should -Be $false
        } # End of It

        It -Name 'should not be an authorized session' -Test {
            $temp.AuthorizationExists() |
                Should -Be $false
        } # End of It
    } # End of Context

    Context -Name 'Valid session' -Fixture {
        It -Name 'should authorize the session' -Test {
            $temp.Authorize( $validToken, $validSessionLength ) |
                Should -Be $null
        } # End of It

        It -Name 'should be an active session' -Test {
            $temp.IsActive() |
                Should -Be $true
        } # End of It

        It -Name 'should be an authorized session' -Test {
            $temp.AuthorizationExists() |
                Should -Be $true
        } # End of It

        It -Name 'should get seconds remaining before session expiration' -Test {
            $temp.GetSecondsRemaining() |
                Should -BeGreaterThan 0
        } # End of It

        It -Name 'should get minutes remaining before session expiration' -Test {
            $temp.GetMinutesRemaining() |
                Should -BeGreaterThan 0
        } # End of It

        It -Name 'should get the authentication token' -Test {
            $temp.GetToken() |
                Should -BeExactly $validToken
        } # End of It
    } # End of Context

    Context -Name 'Account Context' -Fixture {
        #region init
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

        $temp.Accounts = $accounts
        #endregion

        It -Name 'should fail to set the account context when no accounts have been loaded' -Test {
            { [ArmorSession]::New().SetAccountContext( 1 ) } |
                Should -Throw
        } # End of It

        It -Name 'should fail to set the account context to an invalid account ID' -Test {
            { $temp.SetAccountContext( 3 ) } |
                Should -Throw
        } # End of It

        It -Name 'should set the account context to a valid account ID' -Test {
            $temp.SetAccountContext( 1 ) |
                Should -Be $accounts[0]
        } # End of It

        It -Name 'should get the current account context' -Test {
            $temp.GetAccountContext() |
                Should -Be $accounts[0]
        } # End of It

        It -Name 'should get the current account context ID' -Test {
            $temp.GetAccountContextID() |
                Should -Be 1
        } # End of It
    } # End of Context
} # End of Describe
