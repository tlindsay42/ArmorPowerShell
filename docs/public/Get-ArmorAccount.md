# Get-ArmorAccount

## SYNOPSIS
Retrieves Armor account details.

## SYNTAX

### ID (Default)
```
Get-ArmorAccount [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
```

### Name
```
Get-ArmorAccount [[-Name] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves a list of Armor account memberships for the currently authenticated
user. 
Returns a set of accounts that correspond to the filter criteria
provided by the cmdlet parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorAccount
```

Gets all Armor accounts assigned to the logged in user account.

### EXAMPLE 2
```
Get-ArmorAccount -Name *Child*
```

Gets all Armor accounts assigned to the logged in user account with a name
containing the word 'Child'.

### EXAMPLE 3
```
1, 'Example Child Account' | Get-ArmorAccount
```

Gets the Armor accounts assigned to the logged in user account with ID=1 and
Name='Example Child Account' via pipeline values.

### EXAMPLE 4
```
[PSCustomObject] @{ ID = 1 } | Get-ArmorAccount
```

Gets the Armor account assigned to the logged in user account with ID=1 via
property name in the pipeline.

### EXAMPLE 5
```
[PSCustomObject] @{ Name = 'My Secure Account' } | Get-ArmorAccount
```

Gets the Armor account assigned to the logged in user account with
Name='My Secure Account' via property name in the pipeline.

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
Specifies the ID of the Armor account.

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

### -Name
Specifies the name of the Armor account.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.UInt16

### System.String

### System.Management.Automation.PSObject

## OUTPUTS

### ArmorAccount

### ArmorAccount[]

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorAccount/](https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorAccount/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccount.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccount.ps1)

[https://docs.armor.com/display/KBSS/Get+Accounts](https://docs.armor.com/display/KBSS/Get+Accounts)

[https://developer.armor.com/#!/Account_Management/Accounts_GetAccounts](https://developer.armor.com/#!/Account_Management/Accounts_GetAccounts)

