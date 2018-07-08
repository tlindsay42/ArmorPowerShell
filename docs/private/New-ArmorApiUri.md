# New-ArmorApiUri

## SYNOPSIS
Builds the Armor API URI with the endpoint.

## SYNTAX

```
New-ArmorApiUri [[-Server] <String>] [[-Port] <UInt16>] [-Endpoints] <String[]> [[-IDs] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Builds the Armor API URI with the appropriate endpoint for the number of IDs
specified.

## EXAMPLES

### EXAMPLE 1
```
New-ArmorApiUri -Server 'api.armor.com' -Port 443 -Endpoints '/auth/authorize'
```

This will return 'https://api.armor.com:443/auth/authorize'.

### EXAMPLE 2
```
New-ArmorApiUri -Server 'api.armor.com' -Port 443 -Endpoints '/vms', '/vms/{0}' -IDs 1
```

This will return 'https://api.armor.com:443/vms/1'.

### EXAMPLE 3
```
New-ArmorApiUri -Server 'api.armor.com' -Port 443 -Endpoint '/apps/{id}/tiers', '/apps/{id}/tiers/{id}' -IDs 1, 2
```

This will return 'https://api.armor.com:443/apps/1/tiers/2'.

## PARAMETERS

### -Endpoints
Specifies the array of available endpoint paths.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IDs
Specifies the positional ID values to be inserted into the path.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Specifies the Armor API server port.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Global:ArmorSession.Port
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
Position: 1
Default value: $Global:ArmorSession.Server
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

### System.String

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/private/New-ArmorApiUri/](https://tlindsay42.github.io/ArmorPowerShell/private/New-ArmorApiUri/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/New-ArmorApiUri.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/New-ArmorApiUri.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

