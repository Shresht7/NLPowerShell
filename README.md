# NLPowerShell

Use natural language to interact with PowerShell

Inspired by: [Codex-CLI](https://github.com/microsoft/Codex-CLI)

![Demonstration](Docs/demo.gif)

> **NOTE**: _Nothing is perfect!_ Read and verify AI-generated commands before running them. Treat them as if you found them on the internet—because they **are** commands from the internet. **Do not run** any command that you **do not understand**.

---

## Features

### Convert Natural Language to PowerShell Commands

```powershell
PS> # Get a list of the 5 most CPU-intensive processes
```

Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Insert</kbd>

```powershell
PS> Get-Process | Sort-Object CPU -Descending | Select-Object -First 5    # Get a list of the 5 most CPU-intensive processes
```

### Get an Explanation for a PowerShell Command

```powershell
PS> Get-Command | Get-Random | Get-Help -Full
```

Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Insert</kbd>

```powershell
PS> Get-Command | Get-Random | Get-Help -Full   # Retrieve a random command and display its full help information.
```

### TODO: Use In-Line Context for More Accurate Suggestions

```powershell
PS> git # list all tags
```

Press <kbd>Ctrl</kbd> + <kbd>Ctrl</kbd> + <kbd>Insert</kbd>

```powershell
PS> git tag --list    # list all tags
```

### TODO: Automatic Help Extraction

- If a command is an external executable (not a cmdlet), NLPowerShell will attempt to retrieve help documentation using `--help` or `-h` to improve command suggestions.
- Cmdlet-based help is enriched using `Get-Help` when available.

---

## Installation

### 1. Clone this repository

```powershell
gh repo clone Shresht7/NLPowerShell
```

or

```powershell
git clone https://github.com/Shresht7/NLPowerShell.git
```

### 2. Import the module

```powershell
Import-Module -Name <Path\To\This\Module>
```

> **Tip:** If the module is placed in `$PSModulePath` (either manually, by installation, or via symlink), it can be imported with `Import-Module -Name NLPowerShell`.

> **Tip:** Adding this import to your `$PROFILE` will load the module automatically when PowerShell starts.

### 3. Initialize the configuration

```powershell
Initialize-NLPowerShell -Ollama -Model "llama3.2" 
```

or 

```powershell
Initialize-NLPowerShell -OpenAI -Model "gpt-4" -API_KEY (Read-Host -AsSecureString -Prompt "OpenAI API Key") 
```

### 4. Invoke NLPowerShell with <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Insert</kbd>

Example usage:

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
