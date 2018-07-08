# Remove-ArmorCompleteWorkload

## SYNOPSIS
Deletes Armor Complete workloads.

## SYNTAX

```
Remove-ArmorCompleteWorkload [-ID] <UInt16> [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The specified workload in the Armor Complete account in context will be deleted
if is empty.

## EXAMPLES

### EXAMPLE 1
```
Remove-ArmorCompleteWorkload -ID 1
```

If confirmed and empty of child objects, deletes workload with ID=1.

### EXAMPLE 2
```
1 | Remove-ArmorCompleteWorkload
```

If confirmed and empty of child objects, deletes workload with ID=1 identified
via pipeline value.

### EXAMPLE 3
```
[PSCustomObject] @{ ID = 1 | Remove-ArmorCompleteWorkload
```

If confirmed and empty of child objects, deletes workload with ID=1 identified
via property name in the pipeline.

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

### System.Management.Automation.PSObject

## OUTPUTS

### ArmorCompleteWorkload[]

### ArmorCompleteWorkload

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Remove-ArmorCompleteWorkload/](https://tlindsay42.github.io/ArmorPowerShell/public/Remove-ArmorCompleteWorkload/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Remove-ArmorCompleteWorkload.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Remove-ArmorCompleteWorkload.ps1)

[https://docs.armor.com/display/KBSS/Delete+Workload](https://docs.armor.com/display/KBSS/Delete+Workload)

[https://developer.armor.com/#!/Infrastructure/App_DeleteApp](https://developer.armor.com/#!/Infrastructure/App_DeleteApp)

