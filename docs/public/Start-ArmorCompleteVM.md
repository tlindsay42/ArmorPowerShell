# Start-ArmorCompleteVM

## SYNOPSIS
Starts Armor Complete virtual machines.

## SYNTAX

```
Start-ArmorCompleteVM [-ID] <UInt16> [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The specified virtual machine in the Armor Complete account in context will be
powered on.

## EXAMPLES

### EXAMPLE 1
```
Start-ArmorCompleteVM -ID 1
```

Power on the Armor Complete VM with ID=1.

### EXAMPLE 2
```
2 | Start-ArmorCompleteVM
```

Power on the Armor Complete VM with ID=2 via pipeline value.

### EXAMPLE 3
```
Get-ArmorVM -ID 3 | Start-ArmorCompleteVM
```

Power on the Armor Complete VM with ID=3 via property name in the pipeline.

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
Specifies the ID of the VM to power on in the Armor Complete account in
context.

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

### ArmorVM[]

### ArmorVM

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Start-ArmorCompleteVM/](https://tlindsay42.github.io/ArmorPowerShell/public/Start-ArmorCompleteVM/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Start-ArmorCompleteVM.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Start-ArmorCompleteVM.ps1)

[https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions](https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions)

[https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm](https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm)

