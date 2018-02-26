function Get-ArmorApiData {
    <#
        .SYNOPSIS
        This cmdlet retrieves data for making requests to the Armor API.

        .DESCRIPTION
        This cmdlet gets all of the data necessary to construct an API request
        based on the specified cmdlet name.

        .INPUTS
        None- you cannot pipe objects to this cmdlet.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorApiData -Endpoint 'Connect-Armor' -ApiVersion 'v1.0'

        Name        Value
        ----        -----
        SuccessCode 200
        Query       {}
        Description Create a new login session
        Body        {Password, Username}
        Location
        Method      Post
        Filter      {}
        URI         {/auth/authorize}


        Description
        -----------
        This command gets all of the data necessary to construct an API request
        for the Connect-Armor cmdlet.

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [Hashtable] )]
    param (
        <#
        Specifies the cmdlet name to lookup the API data for.
        #>
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullorEmpty()]
        [String]
        $Endpoint = 'Example',

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin
    
    process {
        [Hashtable] $return = $null

        Write-Verbose -Message "Gather API Data for: '${Endpoint}'."

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
            'Remove-ArmorCompleteWorkload'  = @{
                'v1.0' = @{
                    'Description' = 'Deletes the specified workload in your account'
                    'URI'         = @(
                        '/apps/{id}'
                    )
                    'Method'      = 'Delete'
                    'Body'        = @{}
                    'Query'       = @{}
                    'Location'    = ''
                    'Filter'      = @{}
                    'SuccessCode' = '202'
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
            'Rename-ArmorCompleteVM'        = @{
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
            'Rename-ArmorCompleteWorkload'  = @{
                'v1.0' = @{
                    'Description' = 'Renames the specified workload in your account'
                    'URI'         = @(
                        '/apps/{id}'
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
            'Restart-ArmorCompleteVM'               = @{
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
            'Start-ArmorCompleteVM'         = @{
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
            'Stop-ArmorCompleteVM'          = @{
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
            throw "Invalid endpoint: '${Endpoint}'"
        }
        elseif ( $api.$Endpoint.$ApiVersion -eq $null ) {
            throw "Invalid endpoint version: '${ApiVersion}'"
        }
        else {
            $return = $api.$Endpoint.$ApiVersion
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
