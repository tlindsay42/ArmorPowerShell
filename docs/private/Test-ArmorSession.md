# Test-ArmorSession

## SYNOPSIS
Tests the validity of the Armor API session.

## SYNTAX

```
Test-ArmorSession [<CommonParameters>]
```

## DESCRIPTION
Test to see if a session has been established with the Armor API and that it has not yet expired. 
If no token is found, an error will be thrown. 
If the session has expired, Disconnect-Armor will be called with confirmation disabled to clean up the session. 
If less than 2/3 of the session length remain, Update-ArmorApiToken will be called to renew the session.

This cmdlet should be called in the Begin section of public cmdlets for optimal performance, so that the session is not tested repeatedly when pipeline input is processed.

## EXAMPLES

### EXAMPLE 1
```
Test-ArmorSession
```

Validates that the Armor API session stored in $Global:ArmorSession is still active.

## PARAMETERS

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

[https://tlindsay42.github.io/ArmorPowerShell/private/Test-ArmorSession/](https://tlindsay42.github.io/ArmorPowerShell/private/Test-ArmorSession/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Test-ArmorSession.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Test-ArmorSession.ps1)

[https://docs.armor.com/display/KBSS/Armor+API+Guide](https://docs.armor.com/display/KBSS/Armor+API+Guide)

[https://developer.armor.com/](https://developer.armor.com/)

