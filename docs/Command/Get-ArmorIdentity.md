---
external help file: Armor-help.xml
Module Name: Armor
online version: https://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoridentity
schema: 2.0.0
---

# Get-ArmorIdentity

## SYNOPSIS
Retrieves identity details about your Armor user account.

## SYNTAX

```
Get-ArmorIdentity [[-ApiVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves details about your Armor user account that you used to establish the
session, including account membership and permissions.

This also updates the identity information in the session variable:
$Global:ArmorSession.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorIdentity
```

Retrieves the identity details about your Armor user account.

### EXAMPLE 2
```
Get-ArmorIdentity -ApiVersion 1.0
```

Retrieves the Armor API version 1.0 identity details about your Armor user
account.

## PARAMETERS

### -ApiVersion
Specifies the API version for this request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Global:ArmorSession.ApiVersion
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None- this function does not accept pipeline inputs.

## OUTPUTS

### ArmorSession

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoridentity](https://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoridentity)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorIdentity.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorIdentity.ps1)

[https://docs.armor.com/display/KBSS/Get+Authenticated+User+Info](https://docs.armor.com/display/KBSS/Get+Authenticated+User+Info)

[https://developer.armor.com/#!/Authentication/Me_GetMeAsync](https://developer.armor.com/#!/Authentication/Me_GetMeAsync)

