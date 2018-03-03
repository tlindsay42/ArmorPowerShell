Remove-Module -Name $env:CI_MODULE_NAME -ErrorAction 'SilentlyContinue'
Import-Module -Name $env:CI_MODULE_MANIFEST_PATH

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_PUBLIC_PATH -ChildPath $systemUnderTest

. $filePath

$privateFunctionFiles = Get-ChildItem -Path $env:CI_MODULE_PRIVATE_PATH
foreach ( $privateFunctionFile in $privateFunctionFiles ) {
    . $privateFunctionFile.FullName
}

$Global:ArmorSession = [ArmorSession]::New( 'api.armor.com', 443, 'v1.0' )

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PublicFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    #endregion

    Context -Name $Global:FunctionName -Fixture {
        $testName = $Global:ShouldBeForm -f $function
        It -Name $testName -Test {
            $help.Name |
                Should -BeExactly $function
        }
    } # End of Context

    Context -Name $Global:FunctionHelpContext -Fixture {
        $testCases = @(
            @{ 'Property' = 'Synopsis' },
            @{ 'Property' = 'Description' }
        )
        It -Name $Global:FunctionHelpContentForm -TestCases $testCases -Test {
            param ( [String] $Property )
            $help.$Property.Length |
                Should -BeGreaterThan 0
        } # End of It

        $testCases = @(
            @{ 'Value' = 'System.UInt16' },
            @{ 'Value' = 'System.String' }
        )
        $testName = $Global:FunctionHelpSpecificContentForm -f 'Inputs', '<Value>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Value )
            $Value |
                Should -BeIn $help.InputTypes.InputType.Type.Name.Split( "`n" )
        } # End of It

        $value = 'System.Management.Automation.PSObject[]'
        $testName = $Global:FunctionHelpSpecificContentForm -f 'Outputs', $value
        It -Name $testName -Test {
            $help.ReturnValues.ReturnValue.Type.Name |
                Should -BeExactly $value
        } # End of It

        $value = $Global:FunctionHelpNotes
        $testName = $Global:FunctionHelpSpecificContentForm -f 'Notes', ( $value -replace '\n', ', ' )
        It -Name $testName -Test {
            $help.AlertSet.Alert.Text |
                Should -BeExactly $value
        } # End of It

        $testName = $Global:FunctionHelpExampleEntry
        It -Name $testName -Test {
            $help.Examples.Example.Remarks.Length |
                Should -BeGreaterThan 0
        } # End of It

        $testName = $Global:FunctionHelpLinkEntry
        It -Name $testName -Test {
            $help.RelatedLinks.NavigationLink.Uri.Count |
                Should -BeGreaterThan 3
        } # End of It

        foreach ( $uri in $help.RelatedLinks.NavigationLink.Uri ) {
            $testName = $Global:FunctionHelpLinkValidForm -f $uri
            It -Name $testName -Test {
                ( Invoke-WebRequest -Method 'Get' -Uri $uri ).StatusCode |
                    Should -Be 200
            } # End of It
        }
    } # End of Context

    Context -Name 'Parameters' -Fixture {
        $value = 5
        $testName = $Global:FunctionParameterCountForm -f $value
        It -Name $testName -TestCases $testCases -Test {
            $help.Parameters.Parameter.Count |
                Should -Be $value
        } # End of It

        $testCases = @(
            @{ 'Name' = 'ID' },
            @{ 'Name' = 'Name' },
            @{ 'Name' = 'ApiVersion' },
            @{ 'Name' = 'WhatIf' },
            @{ 'Name' = 'Confirm' }
        )
        $testName = $Global:FunctionParameterNameForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Name )
            $Name |
                Should -BeIn $help.Parameters.Parameter.Name
        } # End of It
    } # End of Context

    Context -Name 'Execution' -Fixture {
        Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
        Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
            @{
                'StatusCode'        = 200
                'StatusDescription' = 'OK'
                'Content'           = $Global:JsonResponseBodyWorkload
            }
        }
        $testName = $Global:MethodTypeForm
        It -Name $testName -Test {
            Rename-ArmorCompleteWorkload -ID 1 -Name 'Test' -Confirm:$false |
                Should -BeOfType ( [PSCustomObject] )
        } # End of It
        Assert-VerifiableMock
        Assert-MockCalled -CommandName Test-ArmorSession -Times 1
        Assert-MockCalled -CommandName Invoke-WebRequest -Times 1
    } # End of Context
} # End of Describe
