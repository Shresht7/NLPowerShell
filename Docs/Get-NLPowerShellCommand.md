---
external help file: NLPowerShell-help.xml
Module Name: NLPowerShell
online version:
schema: 2.0.0
---

# Get-NLPowerShellCommand

## SYNOPSIS
Converts a natural language prompt into a PowerShell command.

## SYNTAX

```
Get-NLPowerShellCommand [-Comment] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function takes a natural language description of a task and generates a valid PowerShell command.
It uses the configured AI provider (Ollama or OpenAI) to generate the command.

## EXAMPLES

### EXAMPLE 1
```
Get-NLPowerShellCommand -Comment "List the 5 most CPU-intensive processes"
Returns: Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
```

## PARAMETERS

### -Comment
A natural language description of the desired task.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Requires a valid AI provider, model, and API key to be configured in $Script:CONFIG.

## RELATED LINKS
