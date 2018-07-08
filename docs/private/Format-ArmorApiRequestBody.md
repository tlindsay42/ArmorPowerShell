# Format-ArmorApiRequestBody

## SYNOPSIS
Generates the JSON request body payload for an Armor API request.

## SYNTAX

```
Format-ArmorApiRequestBody [-Keys] <String[]> [-Parameters] <PSObject[]> [<CommonParameters>]
```

## DESCRIPTION
Retrieves the values of the parameters defined in the parent function that
match the names of the specified keys, builds the JSON request body, and then
returns the request body payload.

## EXAMPLES

### EXAMPLE 1
```
Format-ArmorApiRequestBody -Keys 'key1', 'key2' -Parameters $parameters
```

Generates a JSON document with the names and values of objects in the
$parameters array with names matching key1 & key2.

## PARAMETERS

### -Keys
Specifies the variables available in the endpoint request body schema.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parameters
Specifies the parameter names available within the calling cmdlet.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
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

[https://tlindsay42.github.io/ArmorPowerShell/private/Format-ArmorApiRequestBody/](https://tlindsay42.github.io/ArmorPowerShell/private/Format-ArmorApiRequestBody/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Format-ArmorApiRequestBody.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Format-ArmorApiRequestBody.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

