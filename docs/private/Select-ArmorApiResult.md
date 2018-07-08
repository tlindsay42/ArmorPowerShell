# Select-ArmorApiResult

## SYNOPSIS
Criteria-based object filtering.

## SYNTAX

```
Select-ArmorApiResult [[-Results] <PSObject[]>] [[-Filters] <PSObject[]>] [<CommonParameters>]
```

## DESCRIPTION
Filters objects returned from an Armor API endpoint for result object
property values matching parameter values.

Wildcard filtering is supported via the use of the \`-like\` operator.

## EXAMPLES

### EXAMPLE 1
```
$results = Submit-ArmorApiRequest -Uri 'https://api.armor.com/vms'; $filters = $resources.Filter | Get-Member -MemberType 'NoteProperty'; $results = Select-ArmorApiResult -Results $results -Filters $filters
```

Sets $results to the VMs matching the parameters defined in the calling cmdlet:
\`Get-ArmorVM\`, such as 'Name'='TEST-VM'.

There are no available use cases for the bi-level filter yet, but one example
is to define a filter key in ApiData.json such as \`"SKU": "Product.SKU"\`,
and then define a $SKU parameter for \`Get-ArmorVM\`, so that you could then
filter for VMs by SKU via the \`Get-ArmorVM\` cmdlet.

## PARAMETERS

### -Filters
Specifies the list of parameters that the user can use to filter response data.
Each key is the parameter name without the "$" and each value corresponds to
the response data's key.

If a '.' is included in the key name, the filter key name will be split so that
the first part of the filter key will be applied to a root-level property in
the result object, and the second part will be applied to a child property
within the parent property.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -Results
Specifies the formatted API response contents.

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

[https://tlindsay42.github.io/ArmorPowerShell/private/Select-ArmorApiResult/](https://tlindsay42.github.io/ArmorPowerShell/private/Select-ArmorApiResult/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Select-ArmorApiResult.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Select-ArmorApiResult.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

