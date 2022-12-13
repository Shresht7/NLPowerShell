---
external help file: NLPowerShell-help.xml
Module Name: NLPowerShell
online version:
schema: 2.0.0
---

# Get-NLPowerShellCommand

## SYNOPSIS
Converts a natural language prompt to a PowerShell command

## SYNTAX

```
Get-NLPowerShellCommand [-Comment] <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-CommandCompletion function takes a natural language prompt as input
and uses the OpenAI API to generate a corresponding PowerShell command

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Comment
The natural language prompt to convert to a PowerShell command

```yaml
Type: String
Parameter Sets: (All)
Aliases: Line

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function uses the OpenAI API to generate the PowerShell command.
You must provide a valid API key and model name in the CONFIG script variable to use this function.

## RELATED LINKS
