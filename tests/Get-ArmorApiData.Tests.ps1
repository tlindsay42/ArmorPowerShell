$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

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

        $value = $Global:FunctionHelpNoInputs
        $testName = $Global:FunctionHelpSpecificContentForm -f 'Inputs', $value
        It -Name $testName -Test {
            $help.InputTypes.InputType.Type.Name |
                Should -BeExactly $value
        } # End of It

        $value = 'System.Collections.Hashtable'
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
        $value = 2
        $testName = $Global:FunctionParameterCountForm -f $value
        It -Name $testName -TestCases $testCases -Test {
            $help.Parameters.Parameter.Count |
                Should -Be $value
        } # End of It

        $testCases = @(
            @{ 'Name' = 'Endpoint' },
            @{ 'Name' = 'ApiVersion' }
        )
        $testName = $Global:FunctionParameterNameForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Name )
            $Name |
                Should -BeIn $help.Parameters.Parameter.Name
        } # End of It
    } # End of Context

    Context -Name 'Execution' -Fixture {
        $testCases = @(
            @{
                'Endpoint'   = 'Garbage'
                'ApiVersion' = 'v1.0'
            },
            @{
                'Endpoint'   = 'Example'
                'ApiVersion' = 'Garbage'
            }
        )
        $testName = 'should fail when set to: Endpoint: <Endpoint>, ApiVersion: <ApiVersion>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Endpoint, [String] $ApiVersion )
            { Get-ArmorApiData -Endpoint $Endpoint -ApiVersion $ApiVersion } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{
                'Endpoint'   = 'Example'
                'ApiVersion' = 'v1.0'
            }
        )
        $testName = $Global:MethodTypeForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Endpoint, [String] $ApiVersion )
            Get-ArmorApiData -Endpoint $Endpoint -ApiVersion $ApiVersion |
                Should -BeOfType ( [Hashtable] )
        } # End of It
    } # End of Context
} # End of Describe
