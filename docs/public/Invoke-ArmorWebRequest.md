# Invoke-ArmorWebRequest

## SYNOPSIS
Sends custom requests to Armor API endpoints.

## SYNTAX

```
Invoke-ArmorWebRequest [-Endpoint] <String> [[-Headers] <Hashtable>] [[-Method] <String>] [[-Body] <String>]
 [[-SuccessCode] <UInt16>] [[-Description] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet sends custom HTTPS requests to the Armor API. 
It can be used for
calling API endpoints that are not yet covered by the cmdlets in this module.

## EXAMPLES

### EXAMPLE 1
```
Invoke-ArmorWebRequest -Endpoint '/me'
```

Retrieves the current user's identity details.

### EXAMPLE 2
```
Invoke-ArmorWebRequest -Endpoint '/vms' -Headers $Global:ArmorSession.Headers
```

Retrieves VM details using the session headers.

## PARAMETERS

### -Body
Specifies the body of the Armor API web request. 
This parameter is ignored for
Get requests.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Description
If the PowerShell $ConfirmPreference value is elevated for this Armor API web
request by setting the -Confirm parameter to $true, this specifies the text to
display at the user prompt.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Test Armor API request
Accept pipeline input: False
Accept wildcard characters: False
```

### -Endpoint
Specifies the Armor API endpoint.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
Specifies the headers of the Armor API web request.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Global:ArmorSession.Headers
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
Specifies the method used for the Armor API web request. 
The permitted values
are:
- Delete
- Get
- Patch
- Post
- Put

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Get
Accept pipeline input: False
Accept wildcard characters: False
```

### -SuccessCode
Specifies the value of the HTTP response code that indicates success for this
Armor API web request.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 200
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

### System.String

### System.Management.Automation.PSObject

## OUTPUTS

### System.Management.Automation.PSObject[]

### System.Management.Automation.PSObject

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Invoke-ArmorWebRequest/](https://tlindsay42.github.io/ArmorPowerShell/public/Invoke-ArmorWebRequest/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Invoke-ArmorWebRequest.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Invoke-ArmorWebRequest.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

