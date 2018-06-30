$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_LIB_PATH -ChildPath 'ArmorTypes.ps1'

. $filePath

$enum = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_ENUM -f $enum
Describe -Name $describe -Tag 'Enum', $enum -Fixture {
    #region init
    #endregion

    [ArmorStatus] $temp = [ArmorStatus]::New()

    $context = 'Values'
    Context -Name $context -Fixture {
        $testCases = @(
            @{
                ValueName   = [ArmorStatus]::FAILED_CREATION
                ValueNumber = -1
            },
            @{
                ValueName   = [ArmorStatus]::UNRESOLVED
                ValueNumber = 0
            },
            @{
                ValueName   = [ArmorStatus]::RESOLVED
                ValueNumber = 1
            },
            @{
                ValueName   = [ArmorStatus]::DEPLOYED
                ValueNumber = 2
            },
            @{
                ValueName   = [ArmorStatus]::SUSPENDED
                ValueNumber = 3
            },
            @{
                ValueName   = [ArmorStatus]::POWERED_ON
                ValueNumber = 4
            },
            @{
                ValueName   = [ArmorStatus]::WAITING_FOR_INPUT
                ValueNumber = 5
            },
            @{
                ValueName   = [ArmorStatus]::UNKNOWN
                ValueNumber = 6
            },
            @{
                ValueName   = [ArmorStatus]::UNRECOGNIZED
                ValueNumber = 7
            },
            @{
                ValueName   = [ArmorStatus]::POWERED_OFF
                ValueNumber = 8
            },
            @{
                ValueName   = [ArmorStatus]::INCONSISTENT_STATE
                ValueNumber = 9
            },
            @{
                ValueName   = [ArmorStatus]::MIXED
                ValueNumber = 10
            },
            @{
                ValueName   = [ArmorStatus]::DESCRIPTION_PENDING
                ValueNumber = 11
            },
            @{
                ValueName   = [ArmorStatus]::COPYING_CONTENTS
                ValueNumber = 12
            },
            @{
                ValueName   = [ArmorStatus]::DISK_CONTENTS_PENDING
                ValueNumber = 13
            },
            @{
                ValueName   = [ArmorStatus]::QUARANTINED
                ValueNumber = 14
            },
            @{
                ValueName   = [ArmorStatus]::QUARANTINE_EXPIRED
                ValueNumber = 15
            },
            @{
                ValueName   = [ArmorStatus]::REJECTED
                ValueNumber = 16
            },
            @{
                ValueName   = [ArmorStatus]::TRANSFER_TIMEOUT
                ValueNumber = 17
            },
            @{
                ValueName   = [ArmorStatus]::VAPP_UNDEPLOYED
                ValueNumber = 18
            },
            @{
                ValueName   = [ArmorStatus]::VAPP_PARTIALLY_DEPLOYED
                ValueNumber = 19
            },
            @{
                ValueName   = [ArmorStatus]::CHANGES_PENDING
                ValueNumber = 100
            },
            @{
                ValueName   = [ArmorStatus]::COMPLETE
                ValueNumber = 101
            },
            @{
                ValueName   = [ArmorStatus]::BUSY
                ValueNumber = 102
            },
            @{
                ValueName   = [ArmorStatus]::TEMPLATE_PENDING
                ValueNumber = 103
            }
        )
        It -Name 'should set: ValueName: <ValueName>, ValueNumber: <ValueNumber>' -TestCases $testCases -Test {
            param ( [String] $ValueName, [Int16] $ValueNumber )
            [ArmorStatus]::$ValueName |
                Should -Be $ValueNumber
        }
    }
}
