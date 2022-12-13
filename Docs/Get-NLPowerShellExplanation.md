---
external help file: NLPowerShell-help.xml
Module Name: NLPowerShell
online version:
schema: 2.0.0
---

# Get-NLPowerShellExplanation

## SYNOPSIS
Returns an explanation of the given line of PowerShell code

## SYNTAX

```
Get-NLPowerShellExplanation [-Line] <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-NLPowerShellExplanation function returns an explanation
of the given line of PowerShell code, using the OpenAI API.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Line
The line of PowerShell code to explain

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This function uses the OpenAI API to generate the explanation.
You must provide a valid API key and model name in the CONFIG script variable to use this function.

## RELATED LINKS
