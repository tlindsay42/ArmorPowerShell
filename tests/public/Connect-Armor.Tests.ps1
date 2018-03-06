Remove-Module -Name "${env:CI_MODULE_NAME}*" -ErrorAction 'SilentlyContinue'
Import-Module -Name $env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_PUBLIC_PATH -ChildPath $systemUnderTest

. $filePath

$privateFunctionFiles = Get-ChildItem -Path $env:CI_MODULE_PRIVATE_PATH
foreach ( $privateFunctionFile in $privateFunctionFiles ) {
    . $privateFunctionFile.FullName
}

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PublicFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full

    $splat = @{
        'TypeName'     = 'System.Management.Automation.PSCredential'
        'ArgumentList' = 'test', ( 'Fake Password' | ConvertTo-SecureString -AsPlainText -Force )
        'ErrorAction'  = 'Stop'
    }
    $creds = New-Object @splat

    $validCode = 'VGhpcyBpcyBzb21lIHRleHQgdG8gY29udmVydCB2aWEgQ3J5cHQu='
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

        $value = 'ArmorSession'
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
            @{ 'Name' = 'Credential' },
            @{ 'Name' = 'AccountID' },
            @{ 'Name' = 'Server' },
            @{ 'Name' = 'Port' },
            @{ 'Name' = 'ApiVersion' }
        )
        $testName = $Global:FunctionParameterNameForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Name )
            $Name |
                Should -BeIn $help.Parameters.Parameter.Name
        } # End of It
    } # End of Context

    Context -Name 'Return Type' -Fixture {
        # Get the temporary authorization code
        Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
            @{
                'StatusCode' = 200
                'Content'    = $Global:JsonResponseBody.Authorize1
            }
        } -ParameterFilter {
            $Uri -match ( Get-ArmorApiData -FunctionName 'Connect-Armor' -ApiVersion 'v1.0' ).Endpoints
        }

        # Convert the temporary authorization code to an API token
        Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
            @{
                'StatusCode' = 200
                'Content'    = $Global:JsonResponseBody.Token1
            }
        } -ParameterFilter {
            $Uri -match ( Get-ArmorApiData -FunctionName 'New-ArmorApiToken' -ApiVersion 'v1.0' ).Endpoints
        }

        # Get the user's identity information
        Mock -CommandName Invoke-WebRequest -Verifiable -ModuleName $env:CI_MODULE_NAME -MockWith {
            @{
                'StatusCode' = 200
                'Content'    = $Global:JsonResponseBody.Identity1
            }
        }

        $testName = $Global:ReturnTypeForm
        It -Name $testName -Test {
            Connect-Armor -Credential $creds |
                Should -BeOfType ( [ArmorSession] )
        } # End of It
        Assert-VerifiableMock
        Assert-MockCalled -CommandName Invoke-WebRequest -Times 1 -ParameterFilter {
            $Uri -match ( Get-ArmorApiData -FunctionName 'Connect-Armor' -ApiVersion 'v1.0' ).Endpoints
        }
        Assert-MockCalled -CommandName Invoke-WebRequest -Times 1 -ParameterFilter {
            $Uri -match ( Get-ArmorApiData -FunctionName 'New-ArmorApiToken' -ApiVersion 'v1.0' ).Endpoints
        }
        Assert-MockCalled -CommandName Invoke-WebRequest -Times 1 -ModuleName $env:CI_MODULE_NAME

        # Get the temporary authorization code
        Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
            @{
                'StatusCode' = 200
                'Content'    = $Global:JsonResponseBody.Authorize1
            }
        } -ParameterFilter {
            $Uri -match ( Get-ArmorApiData -FunctionName 'Connect-Armor' -ApiVersion 'v1.0' ).Endpoints
        }
    } # End of Context

    Context -Name 'Access Denied' -Fixture {
        # Get the temporary authorization code
        Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
            @{
                'StatusCode'        = 403
                'StatusDescription' = 'Access Denied'
                'Content'    = @{
                    'errorCode'     = 'access_denied'
                    'badLogonCount' = 0
                }
            }
        } -ParameterFilter {
            $Uri -match ( Get-ArmorApiData -FunctionName 'Connect-Armor' -ApiVersion 'v1.0' ).Endpoints
        }

        $testName = 'should fail on invalid credentials'
        It -Name $testName -Test {
            { Connect-Armor -Credential $creds } |
                Should -Throw
        } # End of It

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Invoke-WebRequest -Times 1 -ParameterFilter {
            $Uri -match ( Get-ArmorApiData -FunctionName 'Connect-Armor' -ApiVersion 'v1.0' ).Endpoints
        }
    } # End of Context

    Context -Name 'Authorize' -Fixture {
        Mock -CommandName Submit-ArmorApiRequest -Verifiable -MockWith {
            @{
                'redirect_uri' = $null
                'code'         = ''
                'success'      = 'true'
            }
        }

        $testName = 'should fail on invalid authorization code'
        It -Name $testName -Test {
            param (
                [String] $Code,
                [String] $Success
            )
            { Connect-Armor -Credential $creds } |
                Should -Throw
        } # End of It

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Submit-ArmorApiRequest -Times 1

        Mock -CommandName Submit-ArmorApiRequest -Verifiable -MockWith {
            @{
                'redirect_uri' = $null
                'code'         = $validCode
                'success'      = 'false'
            }
        }

        $testName = 'should fail on invalid success value'
        It -Name $testName -Test {
            param (
                [String] $Code,
                [String] $Success
            )
            { Connect-Armor -Credential $creds } |
                Should -Throw
        } # End of It

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Submit-ArmorApiRequest -Times 1
    } # End of Context

    Context -Name 'API Token' -Fixture {
        Mock -CommandName Submit-ArmorApiRequest -Verifiable -MockWith {
            @{
                'redirect_uri' = $null
                'code'         = $validCode
                'success'      = 'true'
            }
        }
        Mock -CommandName New-ArmorApiToken -Verifiable -MockWith {}

        $testName = 'should fail on invalid token'
        It -Name $testName -Test {
            { Connect-Armor -Credential $creds } |
                Should -Throw
        } # End of It

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Submit-ArmorApiRequest -Times 1
        Assert-MockCalled -CommandName New-ArmorApiToken -Times 1
    } # End of Context
} # End of Describe
