---
external help file: Armor-help.xml
Module Name: Armor
online version: https://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoruser
schema: 2.0.0
---

# Get-ArmorUser

## SYNOPSIS
Retrieves details about the user accounts in your account.

## SYNTAX

### ID (Default)
```
Get-ArmorUser [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
```

### UserName
```
Get-ArmorUser [[-UserName] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```

### Name
```
Get-ArmorUser [-FirstName <String>] [-LastName <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves details about the user accounts in the Armor Anywhere or Armor
Complete account in context.
Returns a set of user accounts that correspond to
the filter criteria provided by the cmdlet parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorUser
```

Retrieves the details for all user accounts in the Armor account that currently
has context.

### EXAMPLE 2
```
Get-ArmorUser -ID 1
```

Retrieves the details for all user accounts in the Armor account that currently
has context.

## PARAMETERS

### -ID
Specifies the ID of the Armor user account.

```yaml
Type: UInt16
Parameter Sets: ID
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -UserName
Specifies the username of the Armor user account.

```yaml
Type: String
Parameter Sets: UserName
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
```

### -FirstName
Specifies the first name of the Armor user account.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

### -LastName
Specifies the last name of the Armor user account.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### UInt16

String

PSCustomObject

## OUTPUTS

### ArmorUser[]

### ArmorUser

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoruser](https://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoruser)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorUser.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorUser.ps1)

[https://docs.armor.com/display/KBSS/Get+Users](https://docs.armor.com/display/KBSS/Get+Users)

[https://docs.armor.com/display/KBSS/Get+User](https://docs.armor.com/display/KBSS/Get+User)

[https://developer.armor.com/#!/Account_Management/Users_GetUsers](https://developer.armor.com/#!/Account_Management/Users_GetUsers)

[https://developer.armor.com/#!/Account_Management/Users_GetUser](https://developer.armor.com/#!/Account_Management/Users_GetUser)

