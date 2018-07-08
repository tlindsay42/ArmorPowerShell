# New-ArmorCompleteVM

## SYNOPSIS
Creates new Armor Complete VMs.

## SYNTAX

### ExistingWorkloadAndTier (Default)
```
New-ArmorCompleteVM [-Name] <String> [-Location] <String> [-WorkloadID] <UInt16> [-TierID] <UInt16>
 [[-VirtualDisks] <ArmorDisk[]>] [-Secret] <String> [-SKU] <String> [[-Quantity] <UInt16>]
 [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### NewWorkloadAndTier
```
New-ArmorCompleteVM [-Name] <String> [-Location] <String> [-WorkloadName] <String> [-TierName] <String>
 [[-VirtualDisks] <ArmorDisk[]>] [-Secret] <String> [-SKU] <String> [[-Quantity] <UInt16>]
 [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Orders and provisions new Armor Complete virtual machines of the specified SKU.

## EXAMPLES

### EXAMPLE 1
```
New-ArmorCompleteVM -Name 'web' -Location 'DFW01' -WorkloadName 'portal' -TierName 'presentation' -Secret $mySecurePassword -SKU 'A1-121' -Quantity 3
```

### EXAMPLE 2
```
New-ArmorCompleteVM -Name 'app' -Location 'DFW01' -WorkloadID 1 -TierID 1 -Secret $mySecurePassword -SKU 'A1-131' -Quantity 2
```

## PARAMETERS

### -ApiVersion
Specifies the API version for this request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: $Global:ArmorSession.ApiVersion
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Specifies the location code for the Armor Complete datacenter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the name for the new virtual machine.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Quantity
Specifies the quantity of VMs to order of this specification.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 1
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Secret
Specifies the password for the new VM.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SKU
Specifies the stock keeping unit (SKU) product identification code that
includes the CPU & memory specifications.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TierID
Specifies the ID of the existing workload tier.

```yaml
Type: UInt16
Parameter Sets: ExistingWorkloadAndTier
Aliases:

Required: True
Position: 4
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TierName
Specifies the names of the workload tiers.

```yaml
Type: String
Parameter Sets: NewWorkloadAndTier
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VirtualDisks
Specifies the virtual disks that should be added to the new VM.

```yaml
Type: ArmorDisk[]
Parameter Sets: (All)
Aliases: Storage

Required: False
Position: 5
Default value: @()
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WorkloadID
Specifies the ID of the existing Armor Complete workload.

```yaml
Type: UInt16
Parameter Sets: ExistingWorkloadAndTier
Aliases: AppID

Required: True
Position: 3
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WorkloadName
Specifies the name for a new Armor Complete workload.

```yaml
Type: String
Parameter Sets: NewWorkloadAndTier
Aliases: AppName

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### ArmorCompleteVmOrder[]

### ArmorCompleteVmOrder

## NOTES
- Troy Lindsay
- Twitter: @troylindsay42
- GitHub: tlindsay42

## RELATED LINKS

[https://tlindsay42.github.io/ArmorPowerShell/public/New-ArmorCompleteVM/](https://tlindsay42.github.io/ArmorPowerShell/public/New-ArmorCompleteVM/)

[https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/New-ArmorCompleteVM.ps1](https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/New-ArmorCompleteVM.ps1)

[https://docs.armor.com/display/KBSS/Create+New+Virtual+Machine](https://docs.armor.com/display/KBSS/Create+New+Virtual+Machine)

[https://developer.armor.com/#!/Infrastructure/Orders_PostVmOrderAsync](https://developer.armor.com/#!/Infrastructure/Orders_PostVmOrderAsync)

