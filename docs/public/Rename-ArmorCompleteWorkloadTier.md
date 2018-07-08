# Rename-ArmorCompleteWorkloadTier

## SYNOPSIS
Renames Armor Complete workload tiers.

## SYNTAX

```
Rename-ArmorCompleteWorkloadTier [-WorkloadID] <UInt16> [-ID] <UInt16> [-NewName] <String>
 [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The specified workload tier in the Armor Complete account in context will be
renamed.

## EXAMPLES

### EXAMPLE 1
```
Rename-ArmorCompleteWorkloadTier -ID 1 -NewName TEST-TIER
```

Renames the workload tier with ID=1 to 'TEST-TIER'.

### EXAMPLE 2
```
[PSCustomObject] @{ ID = 1; NewName = 'TEST-TIER' } | Rename-ArmorCompleteWorkloadTier
```

Renames the workload tier with ID=1 to 'TEST-WORKLOAD' via property names in the
pipeline.

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
Specifies the ID of the workload tier to rename.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NewName
Specifies the new name of the Armor Complete workload tier.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WorkloadID
Specifies the ID of the Armor Complete workload that contains the tier that you want to rename.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
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

### System.Management.Automation.PSObject

## OUTPUTS

### ArmorCompleteWorkloadTier[]

### ArmorCompleteWorkloadTier

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Rename-ArmorCompleteWorkloadTier/](https://tlindsay42.github.io/ArmorPowerShell/public/Rename-ArmorCompleteWorkloadTier/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Rename-ArmorCompleteWorkloadTier.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Rename-ArmorCompleteWorkloadTier.ps1)

[https://docs.armor.com/display/KBSS/Update+Tier](https://docs.armor.com/display/KBSS/Update+Tier)

[https://developer.armor.com/#!/Infrastructure/](https://developer.armor.com/#!/Infrastructure/)

