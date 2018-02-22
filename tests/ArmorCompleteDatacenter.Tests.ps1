$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_LIB_PATH -ChildPath $systemUnderTest

. $filePath

Describe -Name 'ArmorCompleteDatacenter' -Tag 'ArmorCompleteDatacenter', 'Class' -Fixture {
    #region init
    #endregion

    Context -Name 'Constructors' -Fixture {
        It -Name 'should create an object with the default constructor' -Test {
            { [ArmorCompleteDatacenter]::New() } |
                Should -Not -Throw
        }
    } # End of Context

    [ArmorCompleteDatacenter] $temp = [ArmorCompleteDatacenter]::New()

    Context -Name 'Properties/ID' -Fixture {
        $testCases = @(
            @{ 'Value' = 0 },
            @{ 'Value' = 6 }
        )
        It -Name "should fail when ArmorCompleteDatacenter.ID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.ID = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 5 }
        )
        It -Name "should not fail when ArmorCompleteDatacenter.ID is set to '<Value>'" -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.ID = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Location' -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'DFW' },
            @{ 'Value' = 'Banana' }
        )
        It -Name "should fail when ArmorCompleteDatacenter.Location is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Location = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'AMS01' },
            @{ 'Value' = 'DFW01' },
            @{ 'Value' = 'LHR01' },
            @{ 'Value' = 'PHX01' },
            @{ 'Value' = 'SIN01' }
        )
        It -Name "should not fail when ArmorCompleteDatacenter.Location is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Location = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Name' -Fixture {
        $testCases = @(
            @{ 'Value' = 'AS' },
            @{ 'Value' = 'US' },
            @{ 'Value' = 'DFW01' },
            @{ 'Value' = 'Banana' }
        )
        It -Name "should fail when ArmorCompleteDatacenter.Name is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Name = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'AS East' },
            @{ 'Value' = 'EU Central' },
            @{ 'Value' = 'EU West' },
            @{ 'Value' = 'US Central' },
            @{ 'Value' = 'US West' }
        )
        It -Name "should not fail when ArmorCompleteDatacenter.Name is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Name = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name 'Properties/Zones' -Fixture {
        $testCases = @(
            @{ 'Value' = 'DFW01-VC01' },
            @{ 'Value' = 'DFW01T01-VC05' },
            @{ 'Value' = 'Banana' }
        )
        It -Name "should fail when ArmorCompleteDatacenter.Zones is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Zones = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'AMS01T01-VC01' },
            @{ 'Value' = 'DFW01R01-VC01' },
            @{ 'Value' = 'DFW01T01-VC01' },
            @{ 'Value' = 'DFW01T01-VC02' },
            @{ 'Value' = 'DFW01T01-VC03' },
            @{ 'Value' = 'DFW01T01-VC04' },
            @{ 'Value' = 'LHR01T01-VC01' },
            @{ 'Value' = 'PHX01R01-VC01' },
            @{ 'Value' = 'PHX01T01-VC01' },
            @{ 'Value' = 'PHX01T01-VC02' },
            @{ 'Value' = 'PHX01T01-VC03' },
            @{ 'Value' = 'SIN01T01-VC01' }
        )
        It -Name "should not fail when ArmorCompleteDatacenter.Zones is set to '<Value>'" -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.Zones = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Remove-Variable -Name 'temp'
} # End of Describe
