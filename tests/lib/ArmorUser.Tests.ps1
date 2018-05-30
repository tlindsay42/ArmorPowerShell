$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
foreach ( $class in 'ArmorPhoneNumber' ) {
    $filePath = Join-Path -Path $env:CI_MODULE_LIB_PATH -ChildPath "${class}.ps1"

    . $filePath
}

$filePath = Join-Path -Path $env:CI_MODULE_LIB_PATH -ChildPath $systemUnderTest

. $filePath

$class = $systemUnderTest.Split( '.' )[0]
$describe = $Global:ClassForm -f $class
Describe -Name $describe -Tag 'Class', $class -Fixture {
    #region init
    #endregion

    Context -Name $Global:Constructors -Fixture {
        It -Name $Global:DefaultConstructorForm -Test {
            { [ArmorUser]::New() } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    [ArmorUser] $temp = [ArmorUser]::New()

    $property = 'ID'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 0 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'Status'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Garbage' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Enabled' },
            @{ 'Value' = 'Disabled' }
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

    $property = 'Title'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Mr' },
            @{ 'Value' = 'Mrs' },
            @{ 'Value' = 'Dr' },
            @{ 'Value' = 'God Emperor' }
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
            @{ 'Value' = 'William' },
            @{ 'Value' = 'Caprica' }
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
            @{ 'Value' = 'Adama' },
            @{ 'Value' = 'Six' }
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

    $property = 'Email'
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
            @{ 'Value' = 'jane@serenity.com' },
            @{ 'Value' = 'malcolm.reynolds@firefly.com' },
            @{ 'Value' = 'inara.serra@the.serenity.io' }
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

    $property = 'PhonePrimary'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null },
            @{
                'Value' = @{
                    'CountryCode'    = 0
                    'CountryIsoCode' = ''
                    'Number'         = '555.867.5309'
                    'PhoneExt'       = ''
                }
            },
            @{
                'Value' = @{
                    'CountryCode'    = 1
                    'CountryIsoCode' = ''
                    'Number'         = ''
                    'PhoneExt'       = ''
                }
            }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [PSCustomObject] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{
                'Value' = @{
                    'CountryCode'    = 1
                    'CountryIsoCode' = ''
                    'Number'         = '555.867.5309'
                    'PhoneExt'       = ''
                }
            }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [PSCustomObject] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorPhoneNumber] )
        } # End of It
    } # End of Context

    $property = 'TimeZone'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'CDT' },
            @{ 'Value' = 'America/Chicago' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Central Standard Time' },
            @{ 'Value' = 'Kamchatka Standard Time' },
            @{ 'Value' = 'UTC' }
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

    $property = 'Culture'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = $null }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [CultureInfo] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'en-US' },
            @{ 'Value' = 'en-GB' },
            @{ 'Value' = 'zh-SG' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    $property = 'IsMfaEnabled'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'MfaMode'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'RsaKeyFob' },
            @{ 'Value' = 'RetinalScan' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'PhoneApp' },
            @{ 'Value' = 'VoiceCall' }
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

    $property = 'MfaPinMode'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Post-It Note' },
            @{ 'Value' = 'Google' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 'Standard' }
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

    $property = 'Permissions'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 0, 1 },
            @{ 'Value' = 0 }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [UInt16[]] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = 1 },
            @{ 'Value' = 1, 2, 3 },
            @{ 'Value' = 1, 65535 }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [UInt16[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        } # End of It
    } # End of Context

    $property = 'LastModified'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'When dinosaurs ruled the Earth' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '1999-12-31 23:59:59' },
            @{ 'Value' = '2018-05-25 21:38:02' },
            @{ 'Value' = '0001-01-01 00:00:00' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.DateTime] )
        } # End of It
    } # End of Context

    $property = 'PasswordLastSet'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'When trilobytes ruled the Earth' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '2505-03-31 12:02:41' },
            @{ 'Value' = '2018-05-25 21:38:02' },
            @{ 'Value' = '0001-01-01 00:00:00' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.DateTime] )
        } # End of It
    } # End of Context

    $property = 'MustChangePassword'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = 'True' },
            @{ 'Value' = 'False' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        } # End of It
    } # End of Context

    $property = 'LastLogin'
    $context = $Global:PropertyForm -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ 'Value' = '' },
            @{ 'Value' = 'Now!' }
        )
        It -Name $Global:PropertyFailForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'Value' = '2019-11-13 23:14:22' },
            @{ 'Value' = '2018-05-25 21:52:39' },
            @{ 'Value' = '0001-01-01 00:00:00' }
        )
        It -Name $Global:PropertyPassForm -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        } # End of It

        It -Name $Global:PropertyTypeForm -Test {
            $temp.$property |
                Should -BeOfType ( [System.DateTime] )
        } # End of It
    } # End of Context

    Remove-Variable -Name 'temp'
} # End of Describe
