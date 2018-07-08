# Stop-ArmorCompleteVM

## SYNOPSIS
Stops Armor Complete virtual machines.

## SYNTAX

```
Stop-ArmorCompleteVM [-ID] <UInt16> [[-Type] <String>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The specified virtual machine in the Armor Complete account in context will be
powered down.

## EXAMPLES

### EXAMPLE 1
```
Stop-ArmorCompleteVM -ID 1 -Type Shutdown
```

If confirmed, gracefully shutdown the specified Armor Complete VM.

### EXAMPLE 2
```
2 | Stop-ArmorCompleteVM -Type Poweroff -Confirm:$false
```

Power off the Armor Complete VM with ID=2 via pipeline value without prompting
for confirmation.

### EXAMPLE 3
```
Get-ArmorVM -ID 3 | Stop-ArmorCompleteVM -Type ForceOff -Confirm:$false
```

Break the state of the Armor Complete VM with ID=3 via parameter name in the
pipeline without prompting for confirmation, so that the VM appears to be
powered off in the Armor Management Portal (AMP), but is still powered on in
the Armor Complete cloud.

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
Specifies the ID of the Armor Complete virtual machine that you want to stop.

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

### -Type
Specifies how you want to stop the Armor Complete virtual machine.

- Shutdown
  - Initiates a graceful shutdown of the operating system.
  - VMware Tools or open-vm-tools must be installed, running, and in a good
    state for this request to succeed.
  - This is the recommend way to stop your VMs.
- Poweroff
  - Initiates a hard shutdown of the VM- effectively disconnecting the virtual
    power cord from the VM.
  - This shutdown method has the potential to cause data corruption.
  - This should only be used when necessary.
- ForceOff
  - Breaks the state of the environment by marking the VM as powered off in
    the Armor Management Portal (AMP), but leaves the VM running in the Armor
    Complete cloud.
  - This should not be used unless recommended by a Senior Armor Support team
    member.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Shutdown
Accept pipeline input: False
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

[https://tlindsay42.github.io/ArmorPowerShell/public/Stop-ArmorCompleteVM/](https://tlindsay42.github.io/ArmorPowerShell/public/Stop-ArmorCompleteVM/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Stop-ArmorCompleteVM.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Stop-ArmorCompleteVM.ps1)

[https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions](https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions)

[https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm](https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm)

