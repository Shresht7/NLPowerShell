---
external help file: NLPowerShell-help.xml
Module Name: NLPowerShell
online version:
schema: 2.0.0
---

# Initialize-NLPowerShell

## SYNOPSIS
Initializes the NLPowerShell configuration

## SYNTAX

### Ollama
```
Initialize-NLPowerShell [-Ollama] -Model <String> [-URL <String>] [-MaxTokens <Int32>] [-Temperature <Double>]
 [-TopP <Double>] [-KeyBind <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### OpenAI
```
Initialize-NLPowerShell [-OpenAI] -Model <String> -API_KEY <SecureString> [-Organization <String>]
 [-MaxTokens <Int32>] [-Temperature <Double>] [-TopP <Double>] [-N <Int32>] [-KeyBind <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Sets up the configuration for either Ollama or OpenAI

## EXAMPLES

### EXAMPLE 1
```
Get-NLPowerShellConfig -Path "C:\path\to\config.json"
```

## PARAMETERS

### -Ollama
{{ Fill Ollama Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Ollama
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenAI
{{ Fill OpenAI Description }}

```yaml
Type: SwitchParameter
Parameter Sets: OpenAI
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Model
The model to use

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
The URL address of the running Ollama instance

```yaml
Type: String
Parameter Sets: Ollama
Aliases:

Required: False
Position: Named
Default value: Http://localhost:11434
Accept pipeline input: False
Accept wildcard characters: False
```

### -API_KEY
The OpenAI \`API_KEY\` for authentication.
This is required to make api requests to OpenAI.

```yaml
Type: SecureString
Parameter Sets: OpenAI
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
Users can belong to multiple organizations, you can specify which organization is used for an API request.
Usage from these API requests will count against the specified organization's subscription quota.

```yaml
Type: String
Parameter Sets: OpenAI
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTokens
The maximum number of tokens to generate in the completion

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Temperature
The sampling temperature to use.
Higher values mean the model will take more risks.
Higher values are for creative applications, and 0 for well-defined answers.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0.1
Accept pipeline input: False
Accept wildcard characters: False
```

### -TopP
{{ Fill TopP Description }}

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -N
How many completions to generate for each prompt

```yaml
Type: Int32
Parameter Sets: OpenAI
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyBind
The keybinding to use to trigger NLPowerShell

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Ctrl+Shift+Insert
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

## RELATED LINKS
