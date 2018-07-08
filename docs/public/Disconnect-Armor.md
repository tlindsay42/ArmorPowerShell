# Disconnect-Armor

## SYNOPSIS
Disconnects from Armor and destroys the session information.

## SYNTAX

```
Disconnect-Armor [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Disconnects from the Armor API and destroys the $Global:ArmorSession session
variable.

## EXAMPLES

### EXAMPLE 1
```
Disconnect-Armor
```

Disconnects from the Armor API and destroys the $Global:ArmorSession session
variable.

## PARAMETERS

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

### None
    You cannot pipe input to this cmdlet.

## OUTPUTS

### System.Void

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Disconnect-Armor/](https://tlindsay42.github.io/ArmorPowerShell/public/Disconnect-Armor/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Disconnect-Armor.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Disconnect-Armor.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

