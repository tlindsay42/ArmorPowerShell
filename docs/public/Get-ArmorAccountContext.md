# Get-ArmorAccountContext

## SYNOPSIS
Retrieves the Armor Anywhere or Armor Complete account currently in context.

## SYNTAX

```
Get-ArmorAccountContext [<CommonParameters>]
```

## DESCRIPTION
If your user account has access to more than one Armor Anywhere and/or Armor
Complete accounts, this cmdlet allows you to get the current context, which all
future requests will reference.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorAccountContext
```

Retrieves the Armor account currently in context.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None- this function does not accept pipeline inputs

## OUTPUTS

### ArmorAccount

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoraccountcontext](https://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoraccountcontext)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccountContext.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccountContext.ps1)

[https://docs.armor.com/display/KBSS/Log+into+Armor+API](https://docs.armor.com/display/KBSS/Log+into+Armor+API)

[https://developer.armor.com/](https://developer.armor.com/)

