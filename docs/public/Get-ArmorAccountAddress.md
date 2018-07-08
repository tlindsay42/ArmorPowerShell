# Get-ArmorAccountAddress

## SYNOPSIS
Retrieves the mailing address on file for Armor accounts.

## SYNTAX

```
Get-ArmorAccountAddress [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet retrieves the mailing address on file for Armor accounts that your
user account has access to.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorAccountAddress
```

Retrieves the mailing address of the Armor account currently in context.

### EXAMPLE 2
```
Get-ArmorAccountAddress -ID 1
```

Retrieves the mailing address of the Armor account with ID 1.

### EXAMPLE 3
```
1, 2 | Get-ArmorAccountAddress
```

Retrieves the mailing address of the Armor accounts with ID=1 and ID=2 via
pipeline values.

### EXAMPLE 4
```
[PSCustomObject] @{ ID = 1 } | Get-ArmorAccountAddress
```

Retrieves the mailing address of the Armor account with ID=1 and ID=2 via
property names in the pipeline.

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
Specifies the ID of the Armor account with the desired address details.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Global:ArmorSession.GetAccountContextID()
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

### ArmorAccountAddress

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorAccountAddress/](https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorAccountAddress/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccountAddress.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccountAddress.ps1)

[https://docs.armor.com/display/KBSS/Get+Account](https://docs.armor.com/display/KBSS/Get+Account)

[https://developer.armor.com/#!/Account_Management/Accounts_GetAccount](https://developer.armor.com/#!/Account_Management/Accounts_GetAccount)

