# Reset-ArmorCompleteVM

## SYNOPSIS
Resets Armor Complete virtual machines.

## SYNTAX

```
Reset-ArmorCompleteVM [-ID] <UInt16> [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The specified virtual machine in the Armor Complete account in context will be
hard reset- effectively disconnecting the virtual power cord from the VM,
plugging it back in, and then powering it back on. 
This reboot method has the
potential to cause data corruption and should only be used when necessary.

See also: Restart-ArmorCompleteVM

## EXAMPLES

### EXAMPLE 1
```
Reset-ArmorCompleteVM -ID 1
```

If confirmed, powers off & on the Armor Complete VM with ID=1.

### EXAMPLE 2
```
1 | Reset-ArmorCompleteVM -Confirm:$false
```

Powers off & on the Armor Complete VM with ID=1 via pipeline value.

### EXAMPLE 3
```
Get-ArmorVM -ID 1 | Reset-ArmorCompleteVM -Confirm:$false
```

Powers off & on the Armor Complete VM with ID=1 via property name in the
pipeline without confirmation.

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
Specifies the ID of the Armor Complete virtual machine that you want to power
off & on.

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

[https://tlindsay42.github.io/ArmorPowerShell/public/Reset-ArmorCompleteVM/](https://tlindsay42.github.io/ArmorPowerShell/public/Reset-ArmorCompleteVM/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Reset-ArmorCompleteVM.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Reset-ArmorCompleteVM.ps1)

[https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions](https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions)

[https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm](https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm)

