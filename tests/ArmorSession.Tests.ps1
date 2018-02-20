$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_LIB_PATH -ChildPath $systemUnderTest

. $filePath

$server = 'api.armor.com'
$port = 443
$apiVersion = 'v1.0'
$sessionLength = 1800
$token = 'ee3b7d9cc1204434a990d896926d0433'

[ArmorUser] $user = [ArmorUser]::New()
[ArmorAccount] $account = [ArmorAccount]::New()
[ArmorDepartment] $department = [ArmorDepartment]::New()
[ArmorFeature] $feature = [ArmorFeature]::New()

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

[ArmorSession] $session = [ArmorSession]::New( $server, $port, $apiVersion )
$session.Accounts = $accounts

Describe 'ArmorUser' {
    Context 'Constructor' {
        It 'should create an object with the default constructor' {
            { [ArmorUser]::New() } |
                Should -Not -Throw
        }
    }

    Context 'Properties' {
        It "should fail when ArmorUser.UserName is set to '<value>'" -TestCases @(
            @{ value = 'username' },
            @{ value = 'username@example' },
            @{ value = 'username@example.c' }
        ) {
            param ( [String] $value )
            { $user.UserName = $value } |
                Should -Throw
        }

        It "should not fail when ArmorUser.UserName is set to '<value>'" -TestCases @(
            @{ value = 'username@example.com' }
            @{ value = 'user.name@example.com' }
        ) {
            param ( [String] $value )
            { $user.UserName = $value } |
                Should -Not -Throw
        }
    }
}

Describe 'ArmorAccount' {
    Context 'Constructor' {
        It 'should create an object with the default constructor' {
            { [ArmorAccount]::New() } |
                Should -Not -Throw
        }
    }

    Context 'Properties' {
        It "should fail when ArmorAccount.ID is set to '<value>'" -TestCases @(
            @{ value = 0 },
            @{ value = 65536 }
        ) {
            param ( [Int32] $value )
            { $account.ID = $value } |
                Should -Throw
        }

        It "should not fail when ArmorAccount.ID is set to '<value>'" -TestCases @(
            @{ value = 1 },
            @{ value = 65535 }
        ) {
            param ( [Int32] $value )
            { $account.ID = $value } |
                Should -Not -Throw
        }

        It "should fail when ArmorAccount.Parent is set to '<value>'" -TestCases @(
            @{ value = -2 },
            @{ value = 65536 }
        ) {
            param ( [Int32] $value )
            { $account.Parent = $value } |
                Should -Throw
        }

        It "should not fail when ArmorAccount.Parent is set to '<value>'" -TestCases @(
            @{ value = -1 },
            @{ value = 65535 }
        ) {
            param ( [Int32] $value )
            { $account.Parent = $value } |
                Should -Not -Throw
        }
    }
}

Describe 'ArmorDepartment' {
    Context 'Constructor' {
        It 'should create an object with the default constructor' {
            { [ArmorDepartment]::New() } |
                Should -Not -Throw
        }
    }

    Context 'Properties' {
        It "should fail when ArmorDepartment.ID is set to '<value>'" -TestCases @(
            @{ value = 0 },
            @{ value = 65536 }
        ) {
            param ( [Int32] $value )
            { $department.ID = $value } |
                Should -Throw
        }

        It "should not fail when ArmorDepartment.ID is set to '<value>'" -TestCases @(
            @{ value = 1 },
            @{ value = 65535 }
        ) {
            param ( [Int32] $value )
            { $department.ID = $value } |
                Should -Not -Throw
        }

        It "should fail when ArmorDepartment.Account is set to '<value>'" -TestCases @(
            @{ value = 0 },
            @{ value = 65536 }
        ) {
            param ( [Int32] $value )
            { $department.Account = $value } |
                Should -Throw
        }

        It "should not fail when ArmorDepartment.Account is set to '<value>'" -TestCases @(
            @{ value = 1 },
            @{ value = 65535 }
        ) {
            param ( [Int32] $value )
            { $department.Account = $value } |
                Should -Not -Throw
        }
    }
}

Describe 'ArmorFeature' {
    Context 'Constructor' {
        It 'should create an object with the default constructor' {
            { [ArmorFeature]::New() } |
                Should -Not -Throw
        }
    }

    Context 'Properties' {
        It "should fail when ArmorFeature.AccountID is set to '<value>'" -TestCases @(
            @{ value = 0 },
            @{ value = 65536 }
        ) {
            param ( [Int32] $value )
            { $feature.AccountID = $value } |
                Should -Throw
        }

        It "should not fail when ArmorFeature.AccountID is set to '<value>'" -TestCases @(
            @{ value = 1 },
            @{ value = 65535 }
        ) {
            param ( [Int32] $value )
            { $feature.AccountID = $value } |
                Should -Not -Throw
        }

        It "should fail when ArmorFeature.ProductID is set to '<value>'" -TestCases @(
            @{ value = 0 },
            @{ value = 65536 }
        ) {
            param ( [Int32] $value )
            { $feature.ProductID = $value } |
                Should -Throw
        }

        It "should not fail when ArmorFeature.ProductID is set to '<value>'" -TestCases @(
            @{ value = 1 },
            @{ value = 65535 }
        ) {
            param ( [Int32] $value )
            { $feature.ProductID = $value } |
                Should -Not -Throw
        }

        It "should fail when ArmorFeature.FeatureID is set to '<value>'" -TestCases @(
            @{ value = -1 },
            @{ value = 65536 }
        ) {
            param ( [Int32] $value )
            { $feature.FeatureID = $value } |
                Should -Throw
        }

        It "should not fail when ArmorFeature.FeatureID is set to '<value>'" -TestCases @(
            @{ value = 0 },
            @{ value = 65535 }
        ) {
            param ( [Int32] $value )
            { $feature.FeatureID = $value } |
                Should -Not -Throw
        }
    }
}

Describe 'ArmorSession' {
    Context 'Constructor' {
        It 'should create an object with the default constructor' {
            { [ArmorSession]::New() } |
                Should -Not -Throw
        }

        It 'should create an object with the overloaded constructor' {
            { [ArmorSession]::New( $server, $port, $apiVersion ) } |
                Should -Not -Throw
        }
    }

    Context 'Properties' {
        It "should fail when ArmorSession.Port is set to '<value>'" -TestCases @(
            @{ value = 0 },
            @{ value = 65536 }
        ) {
            param ( [Int32] $value )
            { $session.Port = $value } |
                Should -Throw
        }

        It "should not fail when ArmorSession.Port is set to '<value>'" -TestCases @(
            @{ value = 443 },
            @{ value = 1 },
            @{ value = 65535 }
        ) {
            param ( [Int32] $value )
            { $session.Port = $value } |
                Should -Not -Throw
        }

        It "should fail when ArmorSession.SessionLengthInSeconds is set to '<value>'" -TestCases @(
            @{ value = 0 },
            @{ value = 1801 }
        ) {
            param ( [Int32] $value )
            { $session.SessionLengthInSeconds = $value } |
                Should -Throw
        }

        It "should not fail when ArmorSession.SessionLengthInSeconds is set to '<value>'" -TestCases @(
            @{ value = 1 },
            @{ value = 1800 }
        ) {
            param ( [Int32] $value )
            { $session.SessionLengthInSeconds = $value } |
                Should -Not -Throw
        }

        It "should fail when ArmorSession.ApiVersion is set to '<value>'" -TestCases @(
            @{ value = 'v0.1' },
            @{ value = 'v1' }
        ) {
            param ( [String] $value )
            { $session.ApiVersion = $value } |
                Should -Throw
        }

        It "should not fail when ArmorSession.ApiVersion is set to '<value>'" -TestCases @(
            @{ value = 'v1.0' }
        ) {
            param ( [String] $value )
            { $session.ApiVersion = $value } |
                Should -Not -Throw
        }

        It "should fail when ArmorSession.AccountContextHeader is set to '<value>'" -TestCases @(
            @{ value = 'Account-Context' },
            @{ value = 'X-Account-Context1' }
        ) {
            param ( [String] $value )
            { $session.AccountContextHeader = $value } |
                Should -Throw
        }

        It "should not fail when ArmorSession.AccountContextHeader is set to '<value>'" -TestCases @(
            @{ value = 'X-Account-Context' }
        ) {
            param ( [String] $value )
            { $session.AccountContextHeader = $value } |
                Should -Not -Throw
        }

        It "should fail when ArmorSession.AuthenticationType is set to '<value>'" -TestCases @(
            @{ value = 'Bearer' },
            @{ value = 'FH-AUTH1' }
        ) {
            param ( [String] $value )
            { $session.AuthenticationType = $value } |
                Should -Throw
        }

        It "should not fail when ArmorSession.AuthenticationType is set to '<value>'" -TestCases @(
            @{ value = 'FH-AUTH' }
        ) {
            param ( [String] $value )
            { $session.AuthenticationType = $value } |
                Should -Not -Throw
        }
    }

    Context 'Invalid session' {
        It 'should fail to authorize an invalid token' {
            { $session.Authorize( '-', $sessionLength ) } |
                Should -Throw
        }

        It 'should not be an active session' {
            $session.IsActive() |
                Should -Be $false
        }

        It 'should not be an authorized session' {
            $session.AuthorizationExists() |
                Should -Be $false
        }
    }

    Context 'Valid session' {
        It 'should authorize the session' {
            $session.Authorize( $token, $sessionLength ) |
                Should -Be $null
        }

        It 'should be an active session' {
            $session.IsActive() |
                Should -Be $true
        }

        It 'should be an authorized session' {
            $session.AuthorizationExists() |
                Should -Be $true
        }

        It 'should get seconds remaining before session expiration' {
            $session.GetSecondsRemaining() |
                Should -BeGreaterThan 0
        }

        It 'should get minutes remaining before session expiration' {
            $session.GetMinutesRemaining() |
                Should -BeGreaterThan 0
        }

        It 'should get the token' {
            $session.GetToken() |
                Should -BeExactly $token
        }
    }

    Context 'Account Context' {
        It 'should fail to set the account context when no accounts have been loaded' {
            {
                [ArmorSession]::New().SetAccountContext( 1 )
            } |
                Should -Throw
        }

        It 'should fail to set the account context to an invalid account ID' {
            { $session.SetAccountContext( 3 ) } |
                Should -Throw
        }

        It 'should set the account context to a valid account ID' {
            $session.SetAccountContext( 1 ) |
                Should -Be $accounts[0]
        }

        It 'should get the current account context' {
            $session.GetAccountContext() |
                Should -Be $accounts[0]
        }

        It 'should get the current account context ID' {
            $session.GetAccountContextID() |
                Should -Be 1
        }
    }
}
