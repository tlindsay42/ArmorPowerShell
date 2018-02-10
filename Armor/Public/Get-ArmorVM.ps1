function Get-ArmorVM {
    <#
        .SYNOPSIS
        The Get-ArmorVM function displays a list of virtual machines in your account.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        None
            You cannot pipe objects to Get-ArmorVM.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorVM

        Description
        -----------

        Returns all VMs in the Armor account that currently has context.

        .EXAMPLE
        Get-ArmorVM -Name ARMO25VML01-gen4

        Description
        -----------

        Returns the specified VM in the Armor account that currently has context.

        .EXAMPLE
        Get-ArmorVM -Name *-gen4

        Description
        -----------

        Returns all VMs in the Armor account that currently has context that have a name that ends with '-gen4'.

        .EXAMPLE
        Get-ArmorVM -Name *hacked*

        Description
        -----------
        Returns null.

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        Specifies the IDs of the virtual machines that you want to retrieve.
        #>
        [Parameter(
            ParameterSetName = 'ID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = 0,

        <#
        Specifies the names of the virtual machines that you want to retrieve.
        Wildcard matches are supported.
        #>
        [Parameter(
            ParameterSetName = 'Name',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyString()]
        [String]
        $Name = '',

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

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        Test-ArmorSession
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

        $uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Description $resources.Description

        $results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

        if ( $results.Count -eq 0 ) {
            Write-Host -Object 'Armor VM not found.'
        }
        else {
            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
