$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_PUBLIC_PATH -ChildPath $systemUnderTest

. $filePath

$classFiles = Get-ChildItem -Path $env:CI_MODULE_LIB_PATH
foreach ( $classFile in $classFiles ) {
    . $classFile.FullName
}

$privateFunctionFiles = Get-ChildItem -Path $env:CI_MODULE_PRIVATE_PATH
foreach ( $privateFunctionFile in $privateFunctionFiles ) {
    . $privateFunctionFile.FullName
}

$Global:ArmorSession = [ArmorSession]::New( 'api.armor.com', 443, 'v1.0' )
$Global:ArmorSession.SessionLengthInSeconds = 1800
$Global:ArmorSession.SessionStartTime = Get-Date
$Global:ArmorSession.SessionExpirationTime = $Global:ArmorSession.SessionStartTime.AddSeconds( $Global:ArmorSession.SessionLengthInSeconds )

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

        $value = 'System.UInt16'
        $testName = $Global:FunctionHelpSpecificContentForm -f 'Inputs', $value
        It -Name $testName -Test {
            $help.InputTypes.InputType.Type.Name |
                Should -BeExactly $value
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
        $value = 4
        $testName = $Global:FunctionParameterCountForm -f $value
        It -Name $testName -TestCases $testCases -Test {
            $help.Parameters.Parameter.Count |
                Should -Be $value
        } # End of It

        $testCases = @(
            @{ 'Name' = 'ID' },
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
                'Content'           = (
                    '{"hostType":"Virtual Machine", "canUseFluidScale":false, "disks":[ {"id":33263, ' +
                    '"capacity":30720, "name":"Disk 1", "type":"SSD"}], "isDeleted":false, "canReplicate":false, ' +
                    '"id":27464, "coreInstanceId":"10e28e85-fbfe-4100-b181-887d7e6fcdf5", ' +
                    '"biosUuid":"34d75660-d17c-4fae-8658-835a3570600e", "name":"VM1", "provider":"4", ' +
                    '"location":"SIN01", "zone":"SIN01-CD01", "ipAddress":"100.69.215.11", "status":100, ' +
                    '"appId":21654, "appName":"WL2", "osId":null, "os":"Ubuntu 16.04", "deployed":true, ' +
                    '"cpu":1, "memory":2048, "storage":30720, "notes":null, "vCenterId":14, ' +
                    '"vCenterName":"SIN01T01-VC01", "vcdOrgVdcId":5855, "isRecoveryVm":false, ' +
                    '"coreDateRegistered":null, "coreLastPing":null, "vmDateCreated":null, "product": ' +
                    '{"sku":"A1-123", "size":"A1", "isExpired":false, "storagePolicyClass":null}, ' +
                    '"vmServices":null, "uuid":"urn:vcloud:vm:e7b5cbbf-e38a-4d6a-a1a3-e6c7db092dcd", ' +
                    '"isHealthy":null, "health":0, "tags":[], "scheduledEvents":[], "advBackupStatus":false, ' +
                    '"advBackupSku":null, "vmBackupInProgress":false, "profileName":null, "multiVmVapp":false}'
                )
            }
        }
        $testName = $Global:MethodTypeForm
        It -Name $testName -Test {
            Start-ArmorCompleteVM -ID 1 -Confirm:$false |
                Should -BeOfType ( [PSCustomObject] )
        } # End of It
        Assert-VerifiableMock
        Assert-MockCalled -CommandName Test-ArmorSession -Times 1
        Assert-MockCalled -CommandName Invoke-WebRequest -Times 1
    } # End of Context
} # End of Describe
