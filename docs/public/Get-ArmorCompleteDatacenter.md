# Get-ArmorCompleteDatacenter

## SYNOPSIS
Retrieves Armor Complete datacenter details.

## SYNTAX

### ID (Default)
```
Get-ArmorCompleteDatacenter [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
```

### Name
```
Get-ArmorCompleteDatacenter [-Name <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```

### Location
```
Get-ArmorCompleteDatacenter [[-Location] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves details about the Armor Complete datacenters, regions, and compute
zones. 
Returns a set of datacenters that correspond to the filter criteria
provided by the cmdlet parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorCompleteDatacenter
```

Retrieves the details for all Armor Complete datacenters.

### EXAMPLE 2
```
Get-ArmorCompleteDatacenter -ID 2
```

Retrieves the details for the Armor Complete datacenter with ID=2.

### EXAMPLE 3
```
1, 'PHX01' | Get-ArmorCompleteDatacenter
```

Retrieves the details for the Armor Complete datacenter with ID=1 and
Location='PHX01' via pipeline values.

### EXAMPLE 4
```
[PSCustomObject] @{ Location = 'EU West' } | Get-ArmorCompleteDatacenter
```

Retrieves the details for the Armor Complete datacenter with Name='EU West' via
property name in the pipeline.

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
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Specifies the ID of the Armor Complete datacenter.

```yaml
Type: UInt16
Parameter Sets: ID
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Location
Specifies the location code for the Armor Complete datacenter.

```yaml
Type: String
Parameter Sets: Location
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
Specifies the name of the Armor Complete region.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.UInt16

### System.String

### System.Management.Automation.PSObject

## OUTPUTS

### ArmorCompleteDatacenter[]

### ArmorCompleteDatacenter

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorCompleteDatacenter/](https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorCompleteDatacenter/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorCompleteDatacenter.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorCompleteDatacenter.ps1)

[https://docs.armor.com/display/KBSS/Get+Locations](https://docs.armor.com/display/KBSS/Get+Locations)

[https://developer.armor.com/#!/Infrastructure/Location_Get](https://developer.armor.com/#!/Infrastructure/Location_Get)

