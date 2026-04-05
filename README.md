# NLPowerShell

Use natural language to interact with PowerShell

Inspired by: [Codex-CLI](https://github.com/microsoft/Codex-CLI)

![Demonstration](demo.gif)

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
> Initialize-NLPowerShell -Local -Model "qwen2.5-coder" -Temperature 0.2
> ```

### 3. Initialize the configuration

Add `Initialize-NLPowerShell` to your `$PROFILE`. If no parameters are provided, it will load settings from the [default configuration file](#-configuration).

#### First-time Setup or Overrides

You can initialize with specific parameters. Note that this sets the configuration for the **current session**. To save these settings permanently, see the [Configuration](#-configuration) section.

**Using Local Inference (Ollama, llama.cpp, etc.)**

```powershell
# Default (Ollama)
Initialize-NLPowerShell -Local -Model "llama3.2" 

# Custom Local (e.g. llama.cpp)
Initialize-NLPowerShell -Local -Model "llama-3-8b" -URL "http://localhost:8080"
```

> [!TIP]
> You can still use the `-Ollama` alias for the `-Local` parameter if you prefer.

**Using OpenAI**

```powershell
Initialize-NLPowerShell -OpenAI -Model "gpt-4o" -API_KEY $mySecureKey
```

**From a specific file**

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

### To find the configuration file path

```powershell
Get-NLPowerShellConfigPath
```

> [!NOTE]
> 
> The default location for the configuration is:
> - **Windows:** `$env:LOCALAPPDATA\NLPowerShell\config.json`
> - **Linux:** `~/.local/share/NLPowerShell/config.json`

### To update the configuration parameters

```powershell
Set-NLPowerShellConfig -Provider Local -Model "llama3.2" -MaxTokens 64
```

### To save your current configuration to the default path

```powershell
Export-NLPowerShellConfig -Path (Get-NLPowerShellConfigPath)
```

### Config File Format (JSON)

If you prefer to edit the `config.json` file manually, here is an example of its structure:

```json
{
  "KeyBind": "Ctrl+Shift+Insert",
  "ProviderType": "LocalProvider",
  "ProviderData": {
    "BaseUrl": "http://localhost:11434/v1",
    "Model": "llama3.2",
    "MaxTokens": 64,
    "Temperature": 0.1,
    "TopP": 1.0
  }
}
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
