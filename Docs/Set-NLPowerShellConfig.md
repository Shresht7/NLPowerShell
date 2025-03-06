---
external help file: NLPowerShell-help.xml
Module Name: NLPowerShell
online version:
schema: 2.0.0
---

# Set-NLPowerShellConfig

## SYNOPSIS
Sets the configuration for NLPowerShell.

## SYNTAX

```
Set-NLPowerShellConfig [[-Provider] <String>] [[-Model] <String>] [[-URL] <String>] [[-API_KEY] <SecureString>]
 [[-Organization] <String>] [[-N] <Double>] [[-MaxTokens] <Int32>] [[-Temperature] <Double>] [[-TopP] <Double>]
```

## DESCRIPTION
Updates configuration settings, including provider, model, URL, and parameters.
The API key is handled separately for security.

## EXAMPLES

### EXAMPLE 1
```
Set-NLPowerShellConfig -Provider "openai" -Model "gpt-4"
```

### EXAMPLE 2
```
Set-NLPowerShellConfig -Temperature 0.7 -MaxTokens 1000
```

## PARAMETERS

### -Provider
{{ Fill Provider Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Model
{{ Fill Model Description }}

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

### -URL
{{ Fill URL Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -API_KEY
{{ Fill API_KEY Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
{{ Fill Organization Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -N
{{ Fill N Description }}

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTokens
{{ Fill MaxTokens Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Temperature
{{ Fill Temperature Description }}

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
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
Position: 9
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
