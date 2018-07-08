# Restart-ArmorCompleteVM

## SYNOPSIS
Reboots Armor Complete virtual machines gracefully.

## SYNTAX

```
Restart-ArmorCompleteVM [-ID] <UInt16> [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The specified virtual machine will be gracefully rebooted in the Armor Complete
account in context. 
VMware Tools or open-vm-tools must be installed and
running for this request to succeed.

See also: Reset-ArmorCompleteVM

## EXAMPLES

### EXAMPLE 1
```
Retart-ArmorCompleteVM -ID 1
```

Gracefully reboot on the specified Armor Complete VM.

### EXAMPLE 2
```
1 | Retart-ArmorCompleteVM
```

Reboot the Armor Complete VM with ID=1 specified via pipeline value.

### EXAMPLE 3
```
Get-ArmorVM -ID 1 | Retart-ArmorCompleteVM
```

Reboot the Armor Complete VM with ID=1 via property name in the pipeline.

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
Specifies the ID of the Armor Complete virtual machine that you want to
gracefully reboot.

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

System.Management.Automation.PSObject

## OUTPUTS

### ArmorVM[]

### ArmorVM

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Restart-ArmorCompleteVM/](https://tlindsay42.github.io/ArmorPowerShell/public/Restart-ArmorCompleteVM/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Restart-ArmorCompleteVM.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Restart-ArmorCompleteVM.ps1)

[https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions](https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions)

[https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm](https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm)

