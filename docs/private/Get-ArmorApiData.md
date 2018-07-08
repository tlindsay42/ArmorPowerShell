# Get-ArmorApiData

## SYNOPSIS
Retrieves data for making requests to the Armor API.

## SYNTAX

### ApiVersion (Default)
```
Get-ArmorApiData [[-FunctionName] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```

### ApiVersions
```
Get-ArmorApiData [[-FunctionName] <String>] [-ApiVersions] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the data necessary to construct an API request based on the specified
cmdlet name.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorApiData -FunctionName 'Connect-Armor' -ApiVersion 'v1.0'
```

Retrieves the data necessary to construct a request for \`Connect-Armor\` for
Armor API version 1.0.

### EXAMPLE 2
```
Get-ArmorApiData -FunctionName 'Get-ArmorVM' -ApiVersions
```

Retrieves the Armor API versions available for \`Get-ArmorVM\`.

### EXAMPLE 3
```
'Get-ArmorCompleteWorkload', 'Get-ArmorCompleteWorkloadTier' | Get-ArmorApiData -ApiVersion 'v1.0'
```

Retrieves the data necessary to construct a request for
\`Get-ArmorCompleteWorkload\` and \`Get-ArmorCompleteWorkloadTier\` for Armor API
version 1.0.

### EXAMPLE 4
```
'Rename-ArmorCompleteVM', 'Rename-ArmorCompleteWorkload' | Get-ArmorApiData -ApiVersions
```

Retrieves the Armor API versions available for \`Rename-ArmorCompleteVM\` and
\`Rename-ArmorCompleteWorkload\`.

## PARAMETERS

### -ApiVersion
Specifies the API version for this request.

```yaml
Type: String
Parameter Sets: ApiVersion
Aliases:

Required: False
Position: 2
Default value: $Global:ArmorSession.ApiVersion
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApiVersions
Specifies that the available API versions for the specified function should be
enumerated.

```yaml
Type: SwitchParameter
Parameter Sets: ApiVersions
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FunctionName
Specifies the cmdlet name to lookup the API data for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Example
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

### System.Management.Automation.PSObject[]

### System.Management.Automation.PSObject

### System.String[]

### System.String

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/private/Get-ArmorApiData/](https://tlindsay42.github.io/ArmorPowerShell/private/Get-ArmorApiData/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Get-ArmorApiData.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Get-ArmorApiData.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

