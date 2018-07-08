# Expand-ArmorApiResult

## SYNOPSIS
Removes any parent variables surrounding response data.

## SYNTAX

```
Expand-ArmorApiResult [[-Results] <PSObject[]>] [[-Location] <String>] [<CommonParameters>]
```

## DESCRIPTION
Removes any parent variables surrounding response data, such as encapsulating
results in a "data" key.

## EXAMPLES

### EXAMPLE 1
```
Expand-ArmorApiResult -Results [PSCustomObject] @{ Data = [PSCustomObject] @{ Important = 'Info' } } -Location 'Data'
```

Returns the value of the 'Data' property.

### EXAMPLE 2
```
[PSCustomObject] @{ Data = [PSCustomObject] @{ Important = 'Info' } } | Expand-ArmorApiResult -Location 'Data'
```

Returns the value of the 'Data' property.

## PARAMETERS

### -Location
Specifies the key/value pair that contains the name of the key holding the
response content's data.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Results
Specifies the unformatted API response content.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: @()
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

### System.Management.Automation.PSObject

## OUTPUTS

### System.Management.Automation.PSObject[]

### System.Management.Automation.PSObject

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/private/Expand-ArmorApiResult/](https://tlindsay42.github.io/ArmorPowerShell/private/Expand-ArmorApiResult/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Expand-ArmorApiResult.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Expand-ArmorApiResult.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

