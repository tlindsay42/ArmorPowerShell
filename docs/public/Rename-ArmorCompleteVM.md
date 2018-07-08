# Rename-ArmorCompleteVM

## SYNOPSIS
Renames Armor Complete virtual machines.

## SYNTAX

```
Rename-ArmorCompleteVM [-ID] <UInt16> [-NewName] <String> [[-ApiVersion] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The specified virtual machine in the Armor Complete account in context will be
renamed.

## EXAMPLES

### EXAMPLE 1
```
Rename-ArmorCompleteVM -ID 1 -NewName TEST-VM
```

Renames the VM with ID=1 to 'TEST-VM'.

### EXAMPLE 2
```
[PSCustomObject] @{ ID = 1; NewName = 'TEST-VM' } | Rename-ArmorCompleteVM
```

Renames the VM with ID=1 to 'TEST-VM' via property names in the pipeline.

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
Specifies the ID of the Armor Complete virtual machine that you want to
rename.

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

### -NewName
Specifies the new name for the Armor Complete virtual machine.

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

### ArmorVM[]

### ArmorVM

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Rename-ArmorCompleteVM/](https://tlindsay42.github.io/ArmorPowerShell/public/Rename-ArmorCompleteVM/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Rename-ArmorCompleteVM.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Rename-ArmorCompleteVM.ps1)

[https://docs.armor.com/display/KBSS/Update+VM+Name](https://docs.armor.com/display/KBSS/Update+VM+Name)

[https://developer.armor.com/#!/Infrastructure/Vm_UpdateVm](https://developer.armor.com/#!/Infrastructure/Vm_UpdateVm)

