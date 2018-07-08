# New-ArmorCompleteWorkloadTier

## SYNOPSIS
Creates tiers in an Armor Complete workload.

## SYNTAX

```
New-ArmorCompleteWorkloadTier [-WorkloadID] <UInt16> [-Name] <String> [[-ApiVersion] <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
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
New-ArmorCompleteWorkloadTier -WorkloadID 1 -Name 'presentation'
```

Creates a new workload tier named 'presentation' in the workload with WorkloadID=1
in the Armor Complete account that currently has context.

### EXAMPLE 2
```
1, 2 | New-ArmorCompleteWorkloadTier -Name 'business logic' -ApiVersion 'v1.0'
```

Creates a new workload tier named 'business logic' in the workloads with
WorkloadID=1 and WorkloadID=2 using Armor API version v1.0 in the Armor
Complete account that currently has context.

### EXAMPLE 3
```
'web', 'app', 'db' | New-ArmorCompleteWorkloadTier -WorkloadID 1
```

Creates new workload tiers named 'web', 'app', and 'db' in the workload with
WorkloadID=1 in the Armor Complete account that currently has context.

### EXAMPLE 4
```
[PSCustomObject] @{ WorkloadID = 1; Name = 'persistence' } | New-ArmorCompleteWorkloadTier
```

Creates a new workload tier named 'persistence' in the workload with
WorkloadID=1 in the Armor Complete account that currently has context.

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

### -Name
Specifies the name of the workload tier.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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

[https://tlindsay42.github.io/ArmorPowerShell/public/New-ArmorCompleteWorkloadTier/](https://tlindsay42.github.io/ArmorPowerShell/public/New-ArmorCompleteWorkloadTier/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/New-ArmorCompleteWorkloadTier.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/New-ArmorCompleteWorkloadTier.ps1)

[https://docs.armor.com/display/KBSS/Create+Tier](https://docs.armor.com/display/KBSS/Create+Tier)

[https://developer.armor.com/#!/Infrastructure/Tier_AddTier](https://developer.armor.com/#!/Infrastructure/Tier_AddTier)

