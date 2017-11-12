# Include required classes
ForEach ( $class In '10-ArmorUser', '11-ArmorAccount', '12-ArmorDepartment', '13-ArmorFeature' )
{
	$classFilePath = '{0}\{1}.ps1' -f $PSScriptRoot, $class

	If ( Test-Path -Path $classFilePath )
	{
		. $classFilePath
	}
	Else
	{
		Throw ( 'File not found: "{0}"' -f $classFilePath )
	}
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

	[UInt16] GetAccountContext ()
	{
		Return $this.Headers.( $this.AccountContextHeader )
	}

	[Int32] GetMinutesRemaining()
	{
		Return ( $this.SessionExpirationTime - ( Get-Date ) ).Minutes
	}

	[Int32] GetSecondsRemaining()
	{
		Return ( $this.SessionExpirationTime - ( Get-Date ) ).Second
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

	[Void] SetAccountContext (
		[UInt16] $ID
	)
	{
		If ( $this.Accounts.Count -eq 0 )
		{
			Throw 'Accounts have not been initialized for this Armor API session.'
		}
		ElseIf ( $ID -in $this.Accounts.ID )
		{
			$this.Headers.( $this.AccountContextHeader ) = $ID
		}
		Else
		{
			Throw ( 'Invalid account context: "{0}".  Available Armor Account IDs are: {1}.' -f $ID, ( $this.Accounts.ID -join ', ' ) )
		}
	}
}
