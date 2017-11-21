function Get-ArmorApiData {
    <#
        .SYNOPSIS
        Helper function that retrieves data for making requests to the Armor API.

        .DESCRIPTION
        This command gets all of the data necessary to construct an API request based on the specified cmdlet name.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .PARAMETER Endpoint
        Specifies the cmdlet name to lookup the API data for.  The default value is 'Example', which provides example
        API data for each of the fields for reference.

        .PARAMETER ApiVersion
        The API version.

        .INPUTS
        None
            You cannot pipe objects to Get-ArmorApiData.

        .OUTPUTS
        System.Collections.Hashtable

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .EXAMPLE
        Get-ArmorApiData -Endpoint 'Connect-Armor'

        Name                           Value
        ----                           -----
        v1.0                           {Query, Result, Filter, Method...}

        Description
        -----------

        This command gets all of the data necessary to construct an API request for the Connect-Armor cmdlet.
    #>

    [CmdletBinding()]
    param (
        [Parameter( Position = 0 )]
        [ValidateNotNullorEmpty()]
        [String] $Endpoint = 'Example',
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0' )]
        [String] $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        $return = $null

        $api = @{
            'Example'                       = @{
                'v1.0' = @{
                    'Description' = 'Details about the API endpoint'
                    'URI'         = 'The URI expressed as /endpoint'
                    'Method'      = 'Method to use against the endpoint'
                    'Body'        = 'Parameters to use in the request body'
                    'Query'       = 'Parameters to use in the URI query'
                    'Location'    = 'If the result content is stored in a higher level key, express it here to be unwrapped in the return'
                    'Filter'      = 'If the result content needs to be filtered based on key names, express them here'
                    'SuccessCode' = 'The expected HTTP status code for a successful call'
                }
            }
            'Connect-Armor'                 = @{
                'v1.0' = @{
                    'Description' = 'Create a new login session'
                    'URI'         = @(
                        '/auth/authorize'
                    )
                    'Method'      = 'Post'
                    'Body'        = @{
                        'Username' = 'Username'
                        'Password' = 'Password'
                    }
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
            'Get-ArmorAccount'              = @{
                'v1.0' = @{
                    'Description' = 'Retrieves a list of Armor account memberships'
                    'URI'         = @(
                        '/accounts'
                    )
                    'Method'      = 'Get'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{
                        'Name' = 'Name'
                        'ID'   = 'ID'
                    }
                    'SuccessCode' = '200'
                }
            }
            'Get-ArmorAccountAddress'       = @{
                'v1.0' = @{
                    'Description' = 'Retrieves the address on file for the specified Armor account'
                    'URI'         = @(
                        '/accounts/{id}'
                    )
                    'Method'      = 'Get'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
            'Get-ArmorCompleteDatacenter'   = @{
                'v1.0' = @{
                    'Description' = 'Return a set of available locations for provisioning new Armor Complete servers'
                    'URI'         = @(
                        '/locations'
                    )
                    'Method'      = 'Get'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{
                        'Name'     = 'Name'
                        'Location' = 'Location'
                        'ID'       = 'ID'
                    }
                    'SuccessCode' = '200'
                }
            }
            'Get-ArmorCompleteWorkload'     = @{
                'v1.0' = @{
                    'Description' = 'Retrieve any workloads that are associated to your account'
                    'URI'         = @(
                        '/apps',
                        '/apps/{id}'
                    )
                    'Method'      = 'Get'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{
                        'Name' = 'Name'
                    }
                    'SuccessCode' = '200'
                }
            }
            'Get-ArmorCompleteWorkloadTier' = @{
                'v1.0' = @{
                    'Description' = 'Retrieves all the tiers associated with a specified workload'
                    'URI'         = @(
                        '/apps/{id}/tiers',
                        '/apps/{id}/tiers/{id}'
                    )
                    'Method'      = 'Get'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{
                        'Name' = 'Name'
                    }
                    'SuccessCode' = '200'
                }
            }
            'Get-ArmorIdentity'             = @{
                'v1.0' = @{
                    'Description' = 'Return information about the current authenticated user, including account membership and permissions'
                    'URI'         = @(
                        '/me'
                    )
                    'Method'      = 'Get'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
            'Get-ArmorUser'                 = @{
                'v1.0' = @{
                    'Description' = 'Retrieves a list of users in your account'
                    'URI'         = @(
                        '/users',
                        '/users/{id}'
                    )
                    'Method'      = 'Get'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{
                        'FirstName' = 'FirstName'
                        'LastName'  = 'LastName'
                        'UserName'  = 'Email'
                    }
                    'SuccessCode' = '200'
                }
            }
            'Get-ArmorVM'                   = @{
                'v1.0' = @{
                    'Description' = 'Displays a list of virtual machines in your account'
                    'URI'         = @(
                        '/vms',
                        '/vms/{id}'
                    )
                    'Method'      = 'Get'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{
                        'Name' = 'Name'
                    }
                    'SuccessCode' = '200'
                }
            }
            'New-ArmorApiToken'             = @{
                'v1.0' = @{
                    'Description' = 'Creates an authentication token from an authorization code'
                    'URI'         = @(
                        '/auth/token'
                    )
                    'Method'      = 'Post'
                    'Body'        = @{
                        'code'       = 'GUID'
                        'grant_type' = 'authorization_code'
                    }
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
            'Rename-ArmorVM'                = @{
                'v1.0' = @{
                    'Description' = 'Renames the specified virtual machine in your account'
                    'URI'         = @(
                        '/vms/{id}'
                    )
                    'Method'      = 'Put'
                    'Body'        = @{
                        'id'   = 'ID'
                        'name' = 'Name'
                    }
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
            'Reset-ArmorVM'                 = @{
                'v1.0' = @{
                    'Description' = 'Abruptly reset the specified virtual machine in your account'
                    'URI'         = @(
                        '/vms/{id}/power/reset'
                    )
                    'Method'      = 'Post'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
            'Restart-ArmorVM'               = @{
                'v1.0' = @{
                    'Description' = 'Reboot the specified virtual machine in your account'
                    'URI'         = @(
                        '/vms/{id}/power/reboot'
                    )
                    'Method'      = 'Post'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
            'Start-ArmorVM'                 = @{
                'v1.0' = @{
                    'Description' = 'Power on the specified virtual machine in your account'
                    'URI'         = @(
                        '/vms/{id}/power/on'
                    )
                    'Method'      = 'Post'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
            'Stop-ArmorVM'                  = @{
                'v1.0' = @{
                    'Description' = 'Power off the specified virtual machine in your account'
                    'URI'         = @(
                        '/vms/{id}/power/shutdown',
                        '/vms/{id}/power/off',
                        '/vms/{id}/power/forceOff'
                    )
                    'Method'      = 'Post'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
            'Update-ArmorApiToken'          = @{
                'v1.0' = @{
                    'Description' = 'Reissues an authentication token if requested before session expiration'
                    'URI'         = @(
                        '/auth/token/reissue'
                    )
                    'Method'      = 'Post'
                    'Body'        = @{
                        'token' = 'GUID'
                    }
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '200'
                }
            }
        } # End of $api

        if ( $api.$Endpoint -eq $null ) {
            throw ( 'Invalid endpoint: {0}' -f $Endpoint )
        }
        elseif ( $api.$Endpoint.$ApiVersion -eq $null ) {
            throw ( 'Invalid endpoint version: {0}' -f $ApiVersion )
        }
        else {
            $return = $api.$Endpoint.$ApiVersion
        }

        return $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
