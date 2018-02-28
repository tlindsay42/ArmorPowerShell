param (
    [String[]] $Tag,
    [String[]] $ExcludeTag,
    [Switch] $Coverage = $true
)

$Global:ClassForm = 'Class/{0}'
$Global:Constructors = 'Constructors'
$Global:DefaultConstructorForm = 'should not fail when creating an object with the default constructor'
$Global:ConstructorFailForm = 'should fail when creating an object with invalid parameters'
$Global:ConstructorPassForm = 'should not fail when creating an object with valid parameters'
$Global:PropertyForm = 'Property/{0}'
$Global:PropertyFailForm = "should fail when set to: <Value>"
$Global:PropertyPassForm = "should not fail when set to: <Value>"
$Global:PropertyTypeForm = 'should be the expected data type'
$Global:MethodForm = 'Method/{0}'
$Global:MethodNegativeForm = '{0} (Negative)' -f $Global:MethodForm
$Global:MethodPositiveForm = '{0} (Positive)' -f $Global:MethodForm
$Global:MethodTypeForm = 'should return the expected data type'
$Global:PrivateFunctionForm = 'Private/Function/{0}'
$Global:PublicFunctionForm = 'Public/Function/{0}'
$Global:FunctionName = 'Function Name'
$Global:FunctionHelpContext = 'Comment-Based Help'
$Global:FunctionHelpContentForm = 'should have content in section: <Property>'
$Global:FunctionHelpNoInputs = 'None- you cannot pipe objects to this cmdlet.'
$Global:FunctionHelpSpecificContentForm = "should have set '{0}' to '{1}'"
$Global:FunctionHelpNotes = "Troy Lindsay`nTwitter: @troylindsay42`nGitHub: tlindsay42"
$Global:FunctionHelpExampleEntry = "should have at least one 'Example' entry"
$Global:FunctionHelpLinkEntry = "should have at least four help 'Link' entries"
$Global:FunctionHelpLinkValidForm = "should be a valid help link: '{0}'"
$Global:FunctionParameterCountForm = "should have {0} parameters"
$Global:FunctionParameterNameForm = "should have parameter: <Name>"
$Global:ShouldBeForm = "should be: '{0}'"
$Global:VmJsonPaylod = (
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

$splat = @{
    'Path'         = "${env:CI_TESTS_PATH}"
    'OutputFormat' = 'NUnitXml'
    'OutputFile'   = $Env:CI_TEST_RESULTS_PATH
}

if ( $Tag.Count -gt 0 ) {
    $splat.Tag = $Tag
}

if ( $ExcludeTag.Count -gt 0 ) {
    $splat.ExcludeTag = $ExcludeTag
}

if ( $Coverage -eq $true ) {
    $splat.CodeCoverage = Get-ChildItem -Path $Env:CI_MODULE_PATH -Include '*.psm1', '*.ps1' -Recurse
    $splat.CodeCoverageOutputFile = $Env:CI_COVERAGE_RESULTS_PATH
    $splat.CodeCoverageOutputFileFormat = 'JaCoCo'
    $splat.PassThru = $true
}

Write-Host -Object "`nInvoking Pester test framework." -ForegroundColor 'Yellow'
$testsResults = Invoke-Pester @splat

$pathTest = Test-Path -Path $env:CI_TEST_RESULTS_PATH
if ( $pathTest -eq $false ) {
    throw "File not found: '${env:CI_TEST_RESULTS_PATH}'."
}

$pathTest = Test-Path -Path $env:CI_COVERAGE_RESULTS_PATH
if ( $pathTest -eq $false -and $Coverage -eq $true ) {
    throw "File not found: '${env:CI_COVERAGE_RESULTS_PATH}'."
}

if ( $testsResults.FailedCount -gt 0 ) {
    throw "$( $testsResults.FailedCount ) tests failed."
}

if ( $env:APPVEYOR -eq $true ) {
    $webClient = New-Object -TypeName 'System.Net.WebClient'
    $webClient.UploadFile(
        "https://ci.appveyor.com/api/testresults/nunit/${env:APPVEYOR_JOB_ID}",
        $env:CI_TEST_RESULTS_PATH
    )

    $splat = @{
        'PesterResults'     = $testsResults
        'CoverallsApiToken' = $env:COVERALLS_API_KEY
        'BranchName'        = $env:CI_BRANCH
    }
    $coverage = Format-Coverage @splat

    Write-Host -Object 'Publishing code coverage' -ForegroundColor 'Yellow'
    Publish-Coverage -Coverage $coverage
    Write-Host -Object ''
}

Write-Host -Object "Checking the spelling of all documentation in Markdown format." -ForegroundColor 'Yellow'
& mdspell --en-us --ignore-numbers --ignore-acronyms --report '**/*.md'

Write-Host -Object ''
