# Submit-ArmorApiRequest

## SYNOPSIS
Sends data to an Armor API endpoint and then formats the response for further
use.

## SYNTAX

```
Submit-ArmorApiRequest [-Uri] <String> [[-Headers] <Hashtable>] [-Method] <String> [[-Body] <String>]
 [-SuccessCode] <UInt16> [<CommonParameters>]
```

## DESCRIPTION
Sends HTTPS requests to a web page or web service via Invoke-WebRequest.
If the
expected HTTP response code is received, the response content is converted from
JSON and passed to the pipeline; otherwise, the HTTP response code description
is thrown as a terminating error.

## EXAMPLES

### EXAMPLE 1
```
Submit-ArmorApiRequest -Uri https://api.armor.com/me -Method Get -SuccessCode 200
```

Submits a GET request to the Armor Identity API endpoint during a valid
session, converts the JSON response body to an object, passes the object to the
pipeline, and then outputs the object.

### EXAMPLE 2
```
Submit-ArmorApiRequest -Uri https://api.armor.com:443/vms/1 -Headers $Global:ArmorSession.Headers -Method Post -SuccessCode 200 -Body '{"name":"app1","id":1}'
```

Submits a GET request to the Armor Identity API endpoint during a valid
session, converts the JSON response body to an object, passes the object to the
pipeline, and then outputs the object.

## PARAMETERS

### -Body
Specifies the body of the Armor API request. 
Ignored if the request method is
set to Get.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Specifies the action/method used for the Armor API web request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: Get
Accept pipeline input: False
Accept wildcard characters: False
```

### -SuccessCode
Specifies the success code expected in the response.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
Specifies the Uniform Resource Identifier (URI) of the Armor API resource to
which the web request is sent.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
    You cannot pipe input to this cmdlet.

## OUTPUTS

### System.Management.Automation.PSObject[]

### System.Management.Automation.PSObject

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/private/Submit-ArmorApiRequest/](https://tlindsay42.github.io/ArmorPowerShell/private/Submit-ArmorApiRequest/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Submit-ArmorApiRequest.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Submit-ArmorApiRequest.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

