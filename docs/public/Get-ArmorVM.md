# Get-ArmorVM

## SYNOPSIS
Retrieves Armor Complete and Armor Anywhere virtual machine details.

## SYNTAX

### ID (Default)
```
Get-ArmorVM [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
```

### CoreInstanceID
```
Get-ArmorVM [[-CoreInstanceID] <Guid>] [[-ApiVersion] <String>] [<CommonParameters>]
```

### Name
```
Get-ArmorVM [[-Name] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves details about the virtual machines in the Armor Anywhere or Armor
Complete account in context. 
Returns a set of virtual machines that correspond
to the filter criteria provided by the cmdlet parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-ArmorVM
```

Retrieves the details for all VMs in the Armor account that currently has
context.

### EXAMPLE 2
```
Get-ArmorVM -ID 1
```

Retrieves the details for the VM with ID=1.

### EXAMPLE 3
```
Get-ArmorVM -Name 'web1'
```

Retrieves the details for the VM with Name='web1'.

### EXAMPLE 4
```
Get-ArmorVM -Name db*
```

Retrieves all VMs in the Armor account that currently has context that have a
name that starts with 'db'.

### EXAMPLE 5
```
1 | Get-ArmorVM
```

Retrieves the details for the VM with ID=1 via pipeline value.

### EXAMPLE 6
```
'*secure*' | Get-ArmorVM
```

Retrieves all VMs containing the word 'secure' in the name via pipeline value.

### EXAMPLE 7
```
[PSCustomObject] @{ ID = 1 } | Get-ArmorVM
```

Retrieves the details for the VM with ID=1 via property name in the pipeline.

### EXAMPLE 8
```
[PSCustomObject] @{ Name = 'app1' } | Get-ArmorVM
```

Retrieves the details for the VM with Name='app1' via property name in the
pipeline.

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

### -CoreInstanceID
Specifies the Armor Anywhere Core Agent instance IDs of the virtual machines
that you want to retrieve.

```yaml
Type: Guid
Parameter Sets: CoreInstanceID
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ID
Specifies the IDs of the virtual machines that you want to retrieve.

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
Specifies the names of the virtual machines that you want to retrieve.

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

### System.Guid

### System.String

### System.Management.Automation.PSObject

## OUTPUTS

### ArmorVM[]

### ArmorVM

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorVM/](https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorVM/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorVM.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorVM.ps1)

[https://docs.armor.com/display/KBSS/Get+VMs](https://docs.armor.com/display/KBSS/Get+VMs)

[https://docs.armor.com/display/KBSS/Get+VM+Detail](https://docs.armor.com/display/KBSS/Get+VM+Detail)

[https://developer.armor.com/#!/Infrastructure/Vm_GetVmList](https://developer.armor.com/#!/Infrastructure/Vm_GetVmList)

[https://developer.armor.com/#!/Infrastructure/Vm_GetVmDetail](https://developer.armor.com/#!/Infrastructure/Vm_GetVmDetail)

