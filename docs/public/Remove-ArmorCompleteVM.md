# Remove-ArmorCompleteVM

## SYNOPSIS
Deletes Armor Complete VMs.

## SYNTAX

```
Remove-ArmorCompleteVM [-ID] <UInt16> [-IsActive] [-DeleteNow] [[-AccountID] <UInt16>] [[-UserName] <String>]
 [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The specified VM in the Armor Complete account in context will be deleted.

## EXAMPLES

### EXAMPLE 1
```
Remove-ArmorCompleteVM -ID 1
```

If confirmed and empty of child objects, deletes VM with ID=1.

### EXAMPLE 2
```
1 | Remove-ArmorCompleteVM
```

If confirmed and empty of child objects, deletes VM with ID=1 identified
via pipeline value.

### EXAMPLE 3
```
[PSCustomObject] @{ ID = 1 } | Remove-ArmorCompleteVM
```

If confirmed and empty of child objects, deletes workload with ID=1 identified
via property name in the pipeline.

## PARAMETERS

### -AccountID
Specifies the Armor account ID to use for all subsequent requests. 
The
permitted range is 1-65535.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Global:ArmorSession.GetAccountContext().ID
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
Specifies the API version for this request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: $Global:ArmorSession.ApiVersion
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteNow
Specifies whether the VM should be deleted now or at the end of the billing
cycle.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ID
Specifies the ID of the Armor Complete workload.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases: VmID

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -IsActive
Confirms that the user is aware of the current state of the Armor Complete VM.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UserName
Specifies the username of the Armor user account. 
The only accepted value is
the current logged in username for meeting the requirements for the v1.0 API
request body.

```yaml
Type: String
Parameter Sets: (All)
Aliases: UserEmail

Required: False
Position: 5
Default value: $Global:ArmorSession.User.UserName
Accept pipeline input: False
Accept wildcard characters: True
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

[https://tlindsay42.github.io/ArmorPowerShell/public/Remove-ArmorCompleteVM/](https://tlindsay42.github.io/ArmorPowerShell/public/Remove-ArmorCompleteVM/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Remove-ArmorCompleteVM.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Remove-ArmorCompleteVM.ps1)

[https://docs.armor.com/display/KBSS/Delete+VM](https://docs.armor.com/display/KBSS/Delete+VM)

[https://developer.armor.com/#!/Infrastructure/Vm_DeleteVm](https://developer.armor.com/#!/Infrastructure/Vm_DeleteVm)

