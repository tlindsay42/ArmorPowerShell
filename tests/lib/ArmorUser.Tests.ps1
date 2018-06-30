$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_LIB_PATH -ChildPath 'ArmorTypes.ps1'

. $filePath

$class = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_CLASS -f $class
Describe -Name $describe -Tag 'Class', $class -Fixture {
    #region init
    #endregion

    Context -Name $Global:CONSTRUCTORS -Fixture {
        It -Name $Global:FORM_DEFAULT_CONTRUCTORS -Test {
            { [ArmorUser]::New() } |
                Should -Not -Throw
        }
    }

    [ArmorUser] $temp = [ArmorUser]::New()

    $property = 'ID'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 0 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 1 },
            @{ Value = 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [UInt16] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'Status'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'Garbage' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'Enabled' },
            @{ Value = 'Disabled' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'Title'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'Mr' },
            @{ Value = 'Mrs' },
            @{ Value = 'Dr' },
            @{ Value = 'God Emperor' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'FirstName'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'William' },
            @{ Value = 'Caprica' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'LastName'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'Adama' },
            @{ Value = 'Six' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'Email'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'username' },
            @{ Value = 'username@example' },
            @{ Value = 'username@example.c' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'jane@serenity.com' },
            @{ Value = 'malcolm.reynolds@firefly.com' },
            @{ Value = 'inara.serra@the.serenity.io' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'PhonePrimary'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = $null },
            @{
                Value = @{
                    CountryCode    = 0
                    CountryIsoCode = ''
                    Number         = '555.867.5309'
                    PhoneExt       = ''
                }
            },
            @{
                Value = @{
                    CountryCode    = 1
                    CountryIsoCode = ''
                    Number         = ''
                    PhoneExt       = ''
                }
            }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [PSCustomObject] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{
                Value = @{
                    CountryCode    = 1
                    CountryIsoCode = ''
                    Number         = '555.867.5309'
                    PhoneExt       = ''
                }
            }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [PSCustomObject] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [ArmorPhoneNumber] )
        }
    }

    $property = 'TimeZone'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'CDT' },
            @{ Value = 'America/Chicago' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'Central Standard Time' },
            @{ Value = 'Kamchatka Standard Time' },
            @{ Value = 'UTC' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'Culture'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = $null }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [CultureInfo] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'en-US' },
            @{ Value = 'en-GB' },
            @{ Value = 'zh-SG' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.Globalization.CultureInfo] )
        }
    }

    $property = 'IsMfaEnabled'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 'True' },
            @{ Value = 'False' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

    $property = 'MfaMode'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'RsaKeyFob' },
            @{ Value = 'RetinalScan' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'PhoneApp' },
            @{ Value = 'VoiceCall' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'MfaPinMode'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'Post-It Note' },
            @{ Value = 'Google' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 'Standard' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.String] )
        }
    }

    $property = 'Permissions'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 0, 1 },
            @{ Value = 0 }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [UInt16[]] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = 1 },
            @{ Value = 1, 2, 3 },
            @{ Value = 1, 65535 }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [UInt16[]] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.UInt16] )
        }
    }

    $property = 'LastModified'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'When dinosaurs ruled the Earth' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = '1999-12-31 23:59:59' },
            @{ Value = '2018-05-25 21:38:02' },
            @{ Value = '0001-01-01 00:00:00' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.DateTime] )
        }
    }

    $property = 'PasswordLastSet'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'When trilobytes ruled the Earth' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = '2505-03-31 12:02:41' },
            @{ Value = '2018-05-25 21:38:02' },
            @{ Value = '0001-01-01 00:00:00' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.DateTime] )
        }
    }

    $property = 'MustChangePassword'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = 'True' },
            @{ Value = 'False' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.Boolean] )
        }
    }

    $property = 'LastLogin'
    $context = $Global:FORM_PROPERTY -f $property
    Context -Name $context -Fixture {
        $testCases = @(
            @{ Value = '' },
            @{ Value = 'Now!' }
        )
        It -Name $Global:FORM_PROPERTY_FAIL -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Throw
        }

        $testCases = @(
            @{ Value = '2019-11-13 23:14:22' },
            @{ Value = '2018-05-25 21:52:39' },
            @{ Value = '0001-01-01 00:00:00' }
        )
        It -Name $Global:FORM_PROPERTY_PASS -TestCases $testCases -Test {
            param ( [String] $Value )
            { $temp.$property = $Value } |
                Should -Not -Throw
        }

        It -Name $Global:FORM_PROPERTY_TYPE -Test {
            $temp.$property |
                Should -BeOfType ( [System.DateTime] )
        }
    }

    Remove-Variable -Name 'temp'
}
