# Get-ArmorCompleteWorkload

## SYNOPSIS
Retrieves Armor Complete workloads.

## SYNTAX

### ID (Default)
```
Get-ArmorCompleteWorkload [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
```

### Name
```
Get-ArmorCompleteWorkload [[-Name] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Workloads and tiers are logical grouping tools for helping you organize your
virtual machines and corresponding resources in your Armor Complete
software-defined datacenters.

Workloads contain tiers, and tiers contain virtual machines.

Workloads are intended to help you describe the business function of a group of
servers, such as 'My Secure Website', which could be useful for chargeback or
showback to your customers, as well as helping your staff and the Armor Support
teams understand the architecture of your environment.

Tiers are intended to describe the application tiers within each workload. 
A
typical three tiered application workload is comprised of presentation,
business logic, and persistence tiers. 
Common labels for each are: web,
application, and database respectively, but you can group your VMs however you
choose.

Returns a set of workloads that correspond to the filter criteria provided by
the cmdlet parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorCompleteWorkload
```

Retrieves the details for all workloads in the Armor Complete account that
currently has context.

### EXAMPLE 2
```
Get-ArmorCompleteWorkload -ID 1
```

Retrieves the details for the workload with ID=1.

### EXAMPLE 3
```
Get-ArmorCompleteWorkload -Name 'LAMP stack'
```

Retrieves the details for the workload with Name='LAMP stack'.

### EXAMPLE 4
```
2, 'WISP stack' | Get-ArmorCompleteWorkload -ApiVersion 'v1.0'
```

Retrieves the API version 1.0 details for the workloads with ID=2 and
Name='WISP stack' via pipeline values.

### EXAMPLE 5
```
[PSCustomObject] @{ Name = 'Secure stack' } | Get-ArmorCompleteWorkload
```

Retrieves the details for the workload with Name='Secure stack' via property
name in the pipeline.

### EXAMPLE 6
```
[PSCustomObject] @{ ID = 1 } | Get-ArmorCompleteWorkload
```

Retrieves the details for the workload with ID=1 via property name in the
pipeline.

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
Specifies the ID of the Armor Complete workload.

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

### -Name
Specifies the name of the Armor Complete workload.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.UInt16

### System.String

### System.Management.Automation.PSObject

## OUTPUTS

### ArmorCompleteWorkload[]

### ArmorCompleteWorkload

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorCompleteWorkload/](https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorCompleteWorkload/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorCompleteWorkload.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorCompleteWorkload.ps1)

[https://docs.armor.com/display/KBSS/Get+Workloads](https://docs.armor.com/display/KBSS/Get+Workloads)

[https://docs.armor.com/display/KBSS/Get+Workload](https://docs.armor.com/display/KBSS/Get+Workload)

[https://developer.armor.com/#!/Infrastructure/App_GetAppList](https://developer.armor.com/#!/Infrastructure/App_GetAppList)

[https://developer.armor.com/#!/Infrastructure/App_GetAppDetail](https://developer.armor.com/#!/Infrastructure/App_GetAppDetail)

