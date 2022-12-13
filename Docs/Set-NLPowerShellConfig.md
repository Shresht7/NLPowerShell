---
external help file: NLPowerShell-help.xml
Module Name: NLPowerShell
online version:
schema: 2.0.0
---

# Set-NLPowerShellConfig

## SYNOPSIS
Update the NLPowerShell Config File

## SYNTAX

```
Set-NLPowerShellConfig [[-API_KEY] <SecureString>] [[-Organization] <String>] [[-ModelName] <String>]
 [[-MaxTokens] <Int32>] [[-Temperature] <Double>] [[-N] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Update the NLPowerShell Config File

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -API_KEY
OpenAI API_KEY for authentication.
This is used to make api requests.
The API_KEY is a secret.
Do not expose it as plain-text

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
Users can belong to multiple organizations, you can specify which
organization is used for an API request.
Usage from these API requests will count
against the specified organization's subscription quota.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModelName
ID of the model to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name, Model

Required: False
Position: 3
Default value: code-davinci-002
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTokens
The maximum number of tokens to generate in the completion.
The token count of your prompt + the max tokens cannot exceed the model's context length.
Most models have a context length of 2048 tokens (except for the newest models that have 4096)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 32
Accept pipeline input: False
Accept wildcard characters: False
```

### -Temperature
The sampling temperature to use.
Higher values means the model will take more risks.
Try 0.9 for more creative applications, and 0 for ones with a well-defined answer.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0.1
Accept pipeline input: False
Accept wildcard characters: False
```

### -N
How many completions to generate for each prompt.
Note: Because this parameters generates many completions, it can quickly consume your token quota.
Use carefully and ensure that you have reasonable settings for \`$MaxTokens\` and \`$Stop\`.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Count, Number

Required: False
Position: 6
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
