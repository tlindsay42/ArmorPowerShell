Class ArmorUser {
    [ValidateNotNullOrEmpty()]
    [String] $Type

    [ValidatePattern( '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$' )]
    [Alias( 'Name' )]
    [String] $UserName

    [ValidateNotNullOrEmpty()]
    [String] $FirstName

    [ValidateNotNullOrEmpty()]
    [String] $LastName

    [ValidateNotNull()]
    [PSCustomObject[]] $Links = @()

    #Constructors
    ArmorUser () {}
}


Class ArmorAccount {
    [ValidateRange( 1, 65535 )]
    [UInt16] $ID

    [ValidateNotNullOrEmpty()]
    [String] $Name

    [ValidateNotNullOrEmpty()]
    [String] $Currency

    [ValidateNotNullOrEmpty()]
    [String] $Status

    [ValidateRange( -1, 65535 )]
    [Int32] $Parent

    [AllowNull()]
    [PSObject[]] $Products = @()

    #Constructors
    ArmorAccount () {}
}


Class ArmorDepartment {
    [ValidateRange( 1, 65535 )]
    [UInt16] $ID

    [ValidateNotNullOrEmpty()]
    [String] $Name

    [ValidateRange( 1, 65535 )]
    [UInt16] $Account

    #Constructors
    ArmorDepartment () {}
}


Class ArmorFeature {
    [ValidateRange( 1, 65535 )]
    [UInt16] $AccountID

    [ValidateNotNullOrEmpty()]
    [String] $Feature

    [ValidateRange( 1, 65535 )]
    [UInt16] $ProductID

    [ValidateRange( 0, 65535 )]
    [UInt16] $FeatureID

    #Constructors
    ArmorFeature () {}
}


Class ArmorSession {
    [ValidateNotNull()]
    [ArmorUser[]] $User = @()

    [ValidateNotNull()]
    [ArmorAccount[]] $Accounts = @()

    [ValidateNotNull()]
    [ArmorDepartment[]] $Departments = @()

    [ValidateNotNull()]
    [PSObject[]] $Permissions = @()

    [ValidateNotNull()]
    [ArmorFeature[]] $Features = @()

    [ValidateNotNullOrEmpty()]
    [String] $Server = 'api.armor.com'

    [ValidateRange( 1, 65535 )]
    [UInt16] $Port = 443

    [ValidateRange( 1, 1800 )]
    [UInt16] $SessionLengthInSeconds

    [ValidateNotNull()]
    [DateTime] $SessionStartTime

    [ValidateNotNull()]
    [DateTime] $SessionExpirationTime

    [ValidateSet( 'v1.0' )]
    [String] $ApiVersion = 'v1.0'

    [ValidateSet( 'X-Account-Context' )]
    Hidden [String] $AccountContextHeader = 'X-Account-Context'

    [ValidateSet( 'FH-AUTH' )]
    Hidden [String] $AuthenticationType = 'FH-AUTH'

    [ValidateSet( 'application/json' )]
    Hidden [String] $MediaType = 'application/json'

    [ValidateNotNull()]
    Hidden [Hashtable] $Headers = @{}

    # Constructors
    ArmorSession () {
        $this.Headers.Add( 'Accept', $this.MediaType )
        $this.Headers.Add( 'Content-Type', $this.MediaType )
    }

    ArmorSession (
        [String] $Server,
        [UInt16] $Port,
        [String] $ApiVersion
    ) {
        $this.Server = $Server
        $this.Port = $Port
        $this.ApiVersion = $ApiVersion
        $this.Headers.Add( 'Accept', $this.MediaType )
        $this.Headers.Add( 'Content-Type', $this.MediaType )
    }

    [Boolean] AuthorizationExists () {
        [Boolean] $return = $false

        if ( $this.Headers.Authorization -match "^$( $this.AuthenticationType ) [a-z0-9]+$" ) {
            $return = $true
        }

        return $return
    }

    [Void] Authorize (
        [String] $AccessToken,
        [UInt16] $SessionLengthInSeconds
    ) {
        if ( $AccessToken -notmatch '^[a-z0-9]{32}$' ) {
            throw "Invalid access token: '${AccessToken}'."
        }

        $this.SessionStartTime = Get-Date
        $this.SessionLengthInSeconds = $SessionLengthInSeconds
        $this.SessionExpirationTime = $this.SessionStartTime.AddSeconds( $this.SessionLengthInSeconds )
        $this.Headers.'Authorization' = "$( $this.AuthenticationType ) ${AccessToken}"
    }

    [ArmorAccount] GetAccountContext () {
        [ArmorAccount] $return = $this.Accounts.Where( { $_.ID -eq $this.Headers.( $this.AccountContextHeader ) } ) |
            Select-Object -First 1

        return $return
    }

    [UInt16] GetAccountContextID () {
        [UInt16] $return = $this.Headers.( $this.AccountContextHeader )

        return $return
    }

    [Int32] GetMinutesRemaining () {
        [Int32] $return = ( $this.SessionExpirationTime - ( Get-Date ) ).Minutes

        return $return
    }

    [Int32] GetSecondsRemaining () {
        [Int32] $return = ( $this.SessionExpirationTime - ( Get-Date ) ).Seconds

        return $return
    }

    [String] GetToken () {
        [String] $return = $this.Headers.Authorization.Split( ' ' )[-1]

        return $return
    }

    [Boolean] IsActive () {
        [Boolean] $return = $false

        if ( $this.SessionExpirationTime -gt ( Get-Date ) ) {
            $return = $true
        }

        return $return
    }

    [ArmorAccount] SetAccountContext (
        [UInt16] $ID
    ) {
        [ArmorAccount] $return = $null

        if ( $this.Accounts.Count -eq 0 ) {
            throw 'Accounts have not been initialized for this Armor API session.'
        }
        elseif ( $ID -in $this.Accounts.ID ) {
            $this.Headers.( $this.AccountContextHeader ) = $ID

            $return = $this.Accounts.Where( { $_.ID -eq $ID } ) |
                Select-Object -First 1
        }
        else {
            throw "Invalid account context: '${ID}'.  Available Armor Account IDs are: '$( $this.Accounts.ID -join ', ' )'."
        }

        return $return
    }
}
