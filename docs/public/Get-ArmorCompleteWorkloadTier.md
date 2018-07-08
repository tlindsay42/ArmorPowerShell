# Get-ArmorCompleteWorkloadTier

## SYNOPSIS
Retrieves tiers in an Armor Complete workload.

## SYNTAX

### ID (Default)
```
Get-ArmorCompleteWorkloadTier [-WorkloadID] <UInt16> [[-ID] <UInt16>] [[-ApiVersion] <String>]
 [<CommonParameters>]
```

### Name
```
Get-ArmorCompleteWorkloadTier [-WorkloadID] <UInt16> [[-Name] <String>] [[-ApiVersion] <String>]
 [<CommonParameters>]
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

Returns a set of tiers in a workload that correspond to the filter criteria
provided by the cmdlet parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorCompleteWorkloadTier -WorkloadID 1
```

Retrieves the details for all workload tiers in the workload with WorkloadID=1
in the Armor Complete account that currently has context.

### EXAMPLE 2
```
Get-ArmorCompleteWorkloadTier -WorkloadID 1 -ID 1
```

Retrieves the details for the workload tier with ID=1 in the workload with
WorkloadID=1.

### EXAMPLE 3
```
Get-ArmorCompleteWorkloadTier -WorkloadID 1 -Name 'Database'
```

Retrieves the details for the workload tier with Name='Database' in the
workload with WorkloadID=1.

### EXAMPLE 4
```
2, 3 | Get-ArmorCompleteWorkloadTier -ApiVersion 'v1.0'
```

Retrieves the API version 1.0 details for all of the workload tiers in
workloads with WorkloadID=2 and WorkloadID=3 via pipeline values.

### EXAMPLE 5
```
[PSCustomObject] @{ WorkloadID = 1; ID = 1 } | Get-ArmorCompleteWorkloadTier
```

Retrieves the details for the workload tier with ID=1 in the workload with
WorkloadID=1 via property names in the pipeline.

### EXAMPLE 6
```
[PSCustomObject] @{ WorkloadID = 1; Name = 'Presentation' } | Get-ArmorCompleteWorkloadTier
```

Retrieves the details for the workload tier with Name='Presentation' in the
workload with WorkloadID=1 via property names in the pipeline.

## PARAMETERS

### -ApiVersion
Specifies the API version for this request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Global:ArmorSession.ApiVersion
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Specifies the ID of the workload tier.

```yaml
Type: UInt16
Parameter Sets: ID
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the names of the workload tiers.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
```

### -WorkloadID
Specifies the ID of the workload that contains the tier(s).

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
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

### ArmorCompleteWorkloadTier[]

### ArmorCompleteWorkloadTier

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorCompleteWorkloadTier/](https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorCompleteWorkloadTier/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorCompleteWorkloadTier.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorCompleteWorkloadTier.ps1)

[https://docs.armor.com/display/KBSS/Get+Tiers](https://docs.armor.com/display/KBSS/Get+Tiers)

[https://docs.armor.com/display/KBSS/Get+Tier](https://docs.armor.com/display/KBSS/Get+Tier)

[https://developer.armor.com/#!/Infrastructure/Tier_GetAppTiers](https://developer.armor.com/#!/Infrastructure/Tier_GetAppTiers)

[https://developer.armor.com/#!/Infrastructure/Tier_Get](https://developer.armor.com/#!/Infrastructure/Tier_Get)

