$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_LIB_PATH -ChildPath $systemUnderTest

. $filePath

Describe -Name 'ArmorAccountAddress' -Tag 'ArmorAccountAddress', 'Class' -Fixture {
    #region init
    #endregion

    Context -Name 'Constructors' -Fixture {
        It -Name 'should create an object with the default constructor' -Test {
            { [ArmorAccountAddress]::New() } |
                Should -Not -Throw
        }
    } # End of Context

    [ArmorAccountAddress] $temp = [ArmorAccountAddress]::New()

    Context -Name 'Properties/AccountID' -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 65536 }
        )
        It -Name "should fail when ArmorAccountAddress.AccountID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [UInt32] $Value )
            { $temp.AccountID = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name "should not fail when ArmorAccountAddress.AccountID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.AccountID = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name 'should be the expected data type' -Test {
            $temp.AccountID |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    Context -Name 'Properties/Name' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorAccountAddress.Name is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Name = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Armor' },
            @{ 'Value' = 'Banana' }
        )
        It -Name "should not fail when ArmorAccountAddress.Name is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Name = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name 'should be the expected data type' -Test {
            $temp.Name |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    Context -Name 'Properties/AddressLine1' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorAccountAddress.AddressLine1 is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.AddressLine1 = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '2360 Campbell Creek Blvd' },
            @{ 'Value' = 'Banana' }
        )
        It -Name "should not fail when ArmorAccountAddress.AddressLine1 is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.AddressLine1 = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name 'should be the expected data type' -Test {
            $temp.AddressLine1 |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    Context -Name 'Properties/AddressLine2' -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Suite 525' }
        )
        It -Name "should not fail when ArmorAccountAddress.AddressLine2 is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.AddressLine2 = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name 'should be the expected data type' -Test {
            $temp.AddressLine2 |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    Context -Name 'Properties/City' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorAccountAddress.City is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.City = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Richardson' },
            @{ 'Value' = 'Banana' }
        )
        It -Name "should not fail when ArmorAccountAddress.City is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.City = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name 'should be the expected data type' -Test {
            $temp.City |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    Context -Name 'Properties/State' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorAccountAddress.State is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.State = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Richardson' },
            @{ 'Value' = 'Banana' }
        )
        It -Name "should not fail when ArmorAccountAddress.State is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.State = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name 'should be the expected data type' -Test {
            $temp.State |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    Context -Name 'Properties/PostalCode' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorAccountAddress.PostalCode is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.PostalCode = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Richardson' },
            @{ 'Value' = 'Banana' }
        )
        It -Name "should not fail when ArmorAccountAddress.PostalCode is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.PostalCode = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name 'should be the expected data type' -Test {
            $temp.PostalCode |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    Context -Name 'Properties/Country' -Fixture {
        $testCases = @(
            @{ 'Value' = '' }
        )
        It -Name "should fail when ArmorAccountAddress.Country is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Country = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Richardson' },
            @{ 'Value' = 'Banana' }
        )
        It -Name "should not fail when ArmorAccountAddress.Country is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Country = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name 'should be the expected data type' -Test {
            $temp.Country |
                Should -BeOfType ( [System.String] )
        } # End of It
    } # End of Context

    Remove-Variable -Name 'temp'
} # End of Describe
