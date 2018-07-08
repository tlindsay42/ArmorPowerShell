# Connect-Armor

## SYNOPSIS
Connects to the Armor API and establishes a session.

## SYNTAX

```
Connect-Armor [[-Credential] <PSCredential>] [[-AccountID] <UInt16>] [[-Server] <String>] [[-Port] <UInt16>]
 [[-ApiVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Connects to the Armor RESTful API and supplies credentials to the method. 
The
Armor API then returns a unique, temporary authorization code, which is then
converted into a token to represent the user's credentials for subsequent
calls. 
Last, the account context is set. 
If an account ID is not specified,
one is automatically selected from the list of authorized account IDs. 
Returns
the session details which are stored in the variable: $Global:ArmorSession.

## EXAMPLES

### EXAMPLE 1
```
Connect-Armor
```

Prompts for the username and password, and then attempts to log into the Armor
API.

### EXAMPLE 2
```
Connect-Armor -Credential $pscredential
```

Attempts to log into the Armor API with the credentials stored in the
$pscredential object.

### EXAMPLE 3
```
Connect-Armor -Credential $pscredential -AccountID 12345
```

Attempts to log into the Armor API with the credentials stored in the
$pscredential object, and sets the account context to '12345'.

### EXAMPLE 4
```
Connect-Armor -Credential $pscredential -ApiVersion 'v1.0'
```

Attempts to log into the Armor API with the credentials stored in the $pscredential object and sets the specified API version as the default for the session, which is stored in $Global:ArmorSession.ApiVersion.

### EXAMPLE 5
```
Connect-Armor -Credential $pscredential -Server 'localhost' -Port 8443
```

Attempts to log into a local test/dev Armor API instance listening on port
8443/tcp with the credentials stored in the $pscredential object.

## PARAMETERS

### -AccountID
Specifies the Armor account ID to use for all subsequent requests. 
The
permitted range is 1-65535.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
Specifies the API version for this request. 
The specified value is also set as
the default API version for the session as a parameter of the session variable:
'$Global:ArmorSession.ApiVersion'.

The API version can be specified when any other public cmdlets are called or
the value of '$Global:ArmorSession.ApiVersion' can be updated afterward to set
a different default API version for the session.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: V1.0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Your Armor API username and password. 
If not supplied as a parameter, you will
be prompted for your credentials.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: ( Get-Credential )
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Specifies the Armor API server listening TCP port. 
The permitted range is:
1-65535.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 443
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Specifies the Armor API server IP address or FQDN.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Api.armor.com
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
    You cannot pipe input to this cmdlet.

## OUTPUTS

### ArmorSession

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Connect-Armor/](https://tlindsay42.github.io/ArmorPowerShell/public/Connect-Armor/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Connect-Armor.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Connect-Armor.ps1)

[https://docs.armor.com/display/KBSS/Log+into+Armor+API](https://docs.armor.com/display/KBSS/Log+into+Armor+API)

[https://docs.armor.com/display/KBSS/Post+Authorize](https://docs.armor.com/display/KBSS/Post+Authorize)

[https://docs.armor.com/display/KBSS/Post+Token](https://docs.armor.com/display/KBSS/Post+Token)

[https://docs.armor.com/display/KBSS/Get+Authenticated+User+Info](https://docs.armor.com/display/KBSS/Get+Authenticated+User+Info)

[https://developer.armor.com/#!/Authentication/TenantOAuth_AuthorizeAsync](https://developer.armor.com/#!/Authentication/TenantOAuth_AuthorizeAsync)

[https://developer.armor.com/#!/Authentication/TenantOAuth_TokenAsync](https://developer.armor.com/#!/Authentication/TenantOAuth_TokenAsync)

[https://developer.armor.com/#!/Authentication/Me_GetMeAsync](https://developer.armor.com/#!/Authentication/Me_GetMeAsync)

