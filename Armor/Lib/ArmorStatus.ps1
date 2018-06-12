# https://docs.armor.com/display/KBSS/Get+VM+Detail#GetVMDetail-Output
# https://docs.armor.com/display/KBSS/Get+Workload#GetWorkload-Output

enum ArmorStatus {
    # The object could not be created
    FAILED_CREATION = -1

    # The object is unresolved
    UNRESOLVED = 0

    # The object is resolved
    RESOLVED = 1

    # The object is deployed
    DEPLOYED = 2

    # The object is suspended
    SUSPENDED = 3

    # The object is powered on
    POWERED_ON = 4

    # The object is waiting for user input
    WAITING_FOR_INPUT = 5

    # The object is in an unknown state
    UNKNOWN = 6

    # The object is in an unrecognized state
    UNRECOGNIZED = 7

    # The object is in an unrecognized state
    POWERED_OFF = 8

    # The object is in an inconsistent
    INCONSISTENT_STATE = 9

    # Children do not all have the same status
    MIXED = 10

    # Upload initiated, OVF descriptor pending
    DESCRIPTION_PENDING = 11

    # Upload initiated, copying contents
    COPYING_CONTENTS = 12

    # Upload initiated, disk contents pending
    DISK_CONTENTS_PENDING = 13

    # Upload has been quarantined
    QUARANTINED = 14

    # Upload quarantine period has expired
    QUARANTINE_EXPIRED = 15

    # Upload has been rejected
    REJECTED = 16

    # Upload transfer session timed out
    TRANSFER_TIMEOUT = 17

    # The vApp is resolved and undeployed
    VAPP_UNDEPLOYED = 18

    # The vApp is resolved and partially deployed
    VAPP_PARTIALLY_DEPLOYED = 19

    # Undocumented at this time
    CHANGES_PENDING = 100

    # Undocumented at this time
    COMPLETE = 101

    # Undocumented at this time
    BUSY = 102

    # Undocumented at this time
    TEMPLATE_PENDING = 103
}
