Class ArmorUser
{
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

Class ArmorAccount
{
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

	[PSObject[]] $Products = @()

	#Constructors
	ArmorAccount () {}
}

Class ArmorDepartment
{
	[ValidateRange( 1, 65535 )]
	[UInt16] $ID

	[ValidateNotNullOrEmpty()]
	[String] $Name

	[ValidateRange( 1, 65535 )]
	[UInt16] $Account

	#Constructors
	ArmorDepartment () {}
}

Class ArmorFeature
{
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

Class ArmorSession
{
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
	[DateTime] $SessionStartTime = ( Get-Date )

	[ValidateNotNull()]
	[DateTime] $SessionExpirationTime

	[ValidateSet( 'v1.0' )]
	[String] $ApiVersion = 'v1.0'

	[ValidateSet( 'X-Account-Context' )]
	Hidden [String] $AccountContextHeader = 'X-Account-Context'

	[ValidateSet( 'FH-AUTH' )]
	Hidden [String] $AuthenticationType = 'FH-AUTH'

	[ValidateNotNull()]
	Hidden [Hashtable] $Headers = @{ 
		'Content-Type' = 'application/json'
		'Accept'       = 'application/json'
	}

	# Constructors
	ArmorSession () {}

	ArmorSession (
		[String] $Server,
		[UInt16] $Port,
		[String] $ApiVersion
	)
	{
		$this.Server = $Server
		$this.Port = $Port
		$this.ApiVersion = $ApiVersion
	}

	[Boolean] AuthorizationExists()
	{
		$return = $false

		If ( $this.Headers.Authorization -match ( '^{0} [a-z0-9]+$' -f $this.AuthenticationType ) )
		{
			$return = $true
		}

		Return $return
	}

	[Void] Authorize (
		[String] $AccessToken,
		[UInt16] $SessionLengthInSeconds
	)
	{
		If ( $AccessToken -match '^[a-z0-9]+$' )
		{
			$this.Headers.Authorization = '{0} {1}' -f $this.AuthenticationType, $AccessToken
		}
		Else
		{
			Throw ( 'Invalid access token: "{0}".' -f $AccessToken )
		}

		$this.SessionLengthInSeconds = $SessionLengthInSeconds
		$this.SessionExpirationTime = ( Get-Date ).AddSeconds( $this.SessionLengthInSeconds )
	}

	[PSObject] GetAccountContext ()
	{
		Return $this.Accounts.Where( { $_.ID -eq $this.Headers.( $this.AccountContextHeader ) } )
	}

	[Int32] GetMinutesRemaining()
	{
		Return ( $this.SessionExpirationTime - ( Get-Date ) ).Minutes
	}

	[Int32] GetSecondsRemaining()
	{
		Return ( $this.SessionExpirationTime - ( Get-Date ) ).Second
	}

	[String] GetToken()
	{
		Return $this.Headers.Authorization.Split( ' ' )[-1]
	}

	[Boolean] IsActive()
	{
		$return = $false

		If ( $this.SessionExpirationTime -gt ( Get-Date ) )
		{
			$return = $true
		}

		Return $return
	}

	[PSObject] SetAccountContext (
		[UInt16] $ID
	)
	{
		$return = $null

		If ( $this.Accounts.Count -eq 0 )
		{
			Throw 'Accounts have not been initialized for this Armor API session.'
		}
		ElseIf ( $ID -in $this.Accounts.ID )
		{
			$this.Headers.( $this.AccountContextHeader ) = $ID

			$return = $this.Accounts.Where( { $_.ID -eq $ID } )
		}
		Else
		{
			Throw ( 'Invalid account context: "{0}".  Available Armor Account IDs are: {1}.' -f $ID, ( $this.Accounts.ID -join ', ' ) )
		}

		Return $return
	}
}
