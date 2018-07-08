# Update-ArmorApiToken

## SYNOPSIS
Retrieves a new authentication token.

## SYNTAX

```
Update-ArmorApiToken [[-Token] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves a new Armor API authentication token and updates the variable storing
the session details: $Global:ArmorSession.

## EXAMPLES

### EXAMPLE 1
```
Update-ArmorApiToken -Token '2261bac252204c2ea93ed32ea1ffd3ab' -ApiVersion 'v1.0'
```

## PARAMETERS

### -ApiVersion
Specifies the API version for this request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Global:ArmorSession.ApiVersion
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Token
Specifies the Armor API authorization token.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Global:ArmorSession.GetToken()
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Management.Automation.PSObject

## OUTPUTS

### System.Void

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/private/Update-ArmorApiToken/](https://tlindsay42.github.io/ArmorPowerShell/private/Update-ArmorApiToken/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Update-ArmorApiToken.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Update-ArmorApiToken.ps1)

[https://docs.armor.com/display/KBSS/Post+Reissue+Token](https://docs.armor.com/display/KBSS/Post+Reissue+Token)

[https://developer.armor.com/#!/Authentication/TenantOAuth_ReissueAsync](https://developer.armor.com/#!/Authentication/TenantOAuth_ReissueAsync)

