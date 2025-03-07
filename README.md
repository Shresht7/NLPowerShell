# NLPowerShell

Use natural language to interact with PowerShell

Inspired by: [Codex-CLI](https://github.com/microsoft/Codex-CLI)

![Demonstration](Docs/demo.gif)

> [!CAUTION]
>
> _Nothing is perfect!_ Read and verify AI-generated commands before running them. Treat them as if you found them on the internet—because they **are** commands from the internet. **Do not run** any command that you **do not understand**.

---

## ⭐ Features

1. Convert Natural Language to PowerShell Commands
2. Get an Explanation

### 1. Convert Natural Language to PowerShell Commands

```powershell
PS> # Get a list of the 5 most CPU-intensive processes
```

Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Insert</kbd>

```powershell
PS> Get-Process | Sort-Object CPU -Descending | Select-Object -First 5  # Get a list of the 5 most CPU-intensive processes
```

>[!TIP]
> 
>  **NLPowerShell can leverage `Get-Help` or `--help` automatically to improve prediction accuracy**
>
> ```powershell
> PS> git # list all tags
> ```
>
> Press <kbd>Ctrl</kbd> + <kbd>Ctrl</kbd> + <kbd>Insert</kbd>
>
> ```powershell
> PS> git tag --list  # list all tags
> ```

### 2. Get an Explanation

```powershell
PS> Get-Command | Get-Random | Get-Help -Full
```

Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Insert</kbd>

```powershell
PS> Get-Command | Get-Random | Get-Help -Full  # Retrieve a random command and display its full help information.
```

---

## 📦 Installation

### 1. Clone this repository

```powershell
git clone https://github.com/Shresht7/NLPowerShell.git
```

or

```powershell
gh repo clone Shresht7/NLPowerShell
```


### 2. Import the module

```powershell
Import-Module -Name <Path\To\This\Module>
```

> [!TIP]
> 
> If the module is placed in `$PSModulePath` (either manually, by installation, or via symlink), it can be imported with `Import-Module -Name NLPowerShell`.

>[!NOTE]
>
> Adding this import to your `$PROFILE` will load the module automatically when PowerShell starts. You can also `Initialize-NLPowerShell` straight-away with your desired configuration.
> 
> ```powershell
> Import-Module -Name NLPowerShell
> Initialize-NLPowerShell -Ollama -Model "qwen2.5-coder" -Temperature 0.2
> ```

### 3. Initialize the configuration

#### Using Ollama

```powershell
Initialize-NLPowerShell -Ollama -Model "llama3.2" 
```

#### Using OpenAI

```powershell
Initialize-NLPowerShell -OpenAI -Model "gpt-4" -API_KEY (Read-Host -AsSecureString -Prompt "OpenAI API Key") 
```

or you can read configuration from a file

```powershell
Initialize-NLPowerShell -Path "Config.json"
```

#### Changing the Keybinding

```powershell
Initialize-NLPowerShell -KeyBind "Ctrl+Insert"
```

---

## ⚙️ Configuration

### To view the configuration

```powershell
Get-NLPowerShellConfig
```

### To update the configuration parameters

```powershell
Set-NLPowerShellConfig -Provider Ollama -Model "llama3.2" -MaxTokens 64
```

### To export the configuration to file

```powershell
Export-NLPowerShellConfig -Path "Config.json"
```
or
```powershell
Export-NLPowerShellConfig -Path "config.xml"
```

### To import the configuration

```powershell
Import-NLPowerShellConfig -Path "config.xml"
```
---

## 📖 Examples

```powershell
PS> # Get a list of markdown files
```

Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Insert</kbd>

```powershell
PS> Get-ChildItem -Path . -Filter "*.md"    # Get a list of markdown files
```

```powershell
PS> Get-Date
```

Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Insert</kbd>

```powershell
PS> Get-Date    # Get the current date
```


---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
