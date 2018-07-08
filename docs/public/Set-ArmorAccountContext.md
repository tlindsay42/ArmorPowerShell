# Set-ArmorAccountContext

## SYNOPSIS
Sets the Armor Anywhere or Armor Complete account context.

## SYNTAX

```
Set-ArmorAccountContext [-ID] <UInt16> [<CommonParameters>]
```

## DESCRIPTION
If your user account has access to more than one Armor Anywhere and/or Armor
Complete accounts, this cmdlet allows you to update the context, so that all
future requests reference the specified account.

## EXAMPLES

### EXAMPLE 1
```
Set-ArmorAccountContext -ID 1
```

Set the account context to the specified account ID so that all subsequent
commands reference that account.

### EXAMPLE 2
```
2 | Set-ArmorAccountContext
```

Set the account context to 2 via the value in the pipeline.

### EXAMPLE 3
```
Get-ArmorAccount -ID 3 | Set-ArmorAccountContext
```

Set the account context to 3 via the ID property name in the pipeline.

## PARAMETERS

### -ID
Specifies which Armor account should be used for the context of all
subsequent requests.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.UInt16

### System.Management.Automation.PSObject

## OUTPUTS

### ArmorAccount

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Set-ArmorAccountContext/](https://tlindsay42.github.io/ArmorPowerShell/public/Set-ArmorAccountContext/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Set-ArmorAccountContext.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Set-ArmorAccountContext.ps1)

[https://docs.armor.com/display/KBSS/Log+into+Armor+API](https://docs.armor.com/display/KBSS/Log+into+Armor+API)

[https://developer.armor.com/](https://developer.armor.com/)

