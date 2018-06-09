---
external help file: Armor-help.xml
Module Name: Armor
online version: https://armorpowershell.readthedocs.io/en/latest/cmd_disconnect.html#disconnect-armor
schema: 2.0.0
---

# Disconnect-Armor

## SYNOPSIS
Disconnects from Armor and destroys the session information.

## SYNTAX

```
Disconnect-Armor [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Disconnects from the Armor API and destroys the $Global:ArmorSession session variable.

## EXAMPLES

### EXAMPLE 1
```
Disconnect-Armor
```

Disconnects from the Armor API and destroys the $Global:ArmorSession session variable.

## PARAMETERS

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None- this function does not accept pipeline inputs.

## OUTPUTS

### System.Void

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://armorpowershell.readthedocs.io/en/latest/cmd_disconnect.html#disconnect-armor](https://armorpowershell.readthedocs.io/en/latest/cmd_disconnect.html#disconnect-armor)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Disconnect-Armor.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Disconnect-Armor.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

