# Hide-SensitiveData

## SYNOPSIS
Redact sensitive property values.

## SYNTAX

```
Hide-SensitiveData [-InputObject] <Hashtable> [[-SensitiveProperties] <String[]>] [-ForceVerbose]
 [<CommonParameters>]
```

## DESCRIPTION
Redact sensitive property values and then return objects to the pipeline.

## EXAMPLES

### EXAMPLE 1
```
Hide-SensitiveData -InputObject @{ Credential = ( Get-Credential )) }
```

Returns the input object with the value of the Credential key set to
'\[REDACTED\]'.

### EXAMPLE 2
```
@{ PlainText = 'do not display' } | Hide-SensitiveData -SensitiveProperties 'PlainText'
```

Returns the object input via the pipeline with the value of the 'PlainText' key
set to '\[REDACTED\]', because the SensitiveProperties parameter specified this
key as sensitive.

### EXAMPLE 3
```
Hide-SensitiveData -InputObject @{ Authorization = $authorization } -ForceVerbose
```

Returns the input object with the value of the Authorization key intact.

### EXAMPLE 4
```
Hide-SensitiveData @{ Uri = '/uri' } @('Uri')
```

Uses a positional parameter Returns the hashtable with the Uri value set to '\[REDACTED\]'.

## PARAMETERS

### -ForceVerbose
Prevents sensitive property values from being redacted for troubleshooting
purposes.

*** WARNING ***
This will expose your sensitive property values.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Specifies the objects to evaluate for sensitive property keys.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SensitiveProperties
Specifies the properties that should be redacted.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @(
            'Credential',
            'Authorization',
            'Token'
        )
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Collections.Hashtable
## OUTPUTS

### System.Collections.Hashtable
## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/private/Hide-SensitiveData/](https://tlindsay42.github.io/ArmorPowerShell/private/Hide-SensitiveData/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Hide-SensitiveData.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Hide-SensitiveData.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

