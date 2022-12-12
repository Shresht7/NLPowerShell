# NLPowerShell

Use natural language to interact with PowerShell. Powered by OpenAI.

Inspiration: https://github.com/microsoft/Codex-CLI

> **NOTE**: _Nothing is perfect!_ Read and check the commands thoroughly before you run them. Treat the AI generated commands as commands you find on the _internet_ (because they are commands from the internet). **Do not run** a command that you **do not understand**.

## Features

### Convert Natural-Language to PowerShell Commands

```powershell
PS> # Get a list of the 5 most CPU intensive processes
```

Hit <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>RightArrow</kbd>

```powershell
PS> Get-Process | Sort-Object CPU -Descending | Select-Object -First 5    # Get a list of the 5 most CPU intensive processes
```

### Get an Explanation for a PowerShell Command

```powershell
PS> Get-Command | Get-Random | Get-Help -Full
```

Hit <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>RightArrow</kbd>

```powershell
PS> Get-Command | Get-Random | Get-Help -Full   # Retrieve a random command and display its full help information.
```

---

## Installation

### 1. Clone this repository

```powershell
gh repo clone Shresht7/NLPowerShell
```

or 

```powershell
git clone https://...
```

### 2. Import this module

```powershell
Import-Module -Name <Path\To\This\Module>
```

> NOTE: If you add it to a `$PSModulePath` (either directly, by installing or by symlinking it), you can `Import-Module` by using the module name (i.e. `Import-Module -Name NLPowerShell`). PowerShell will automatically import any modules in `$PSModulePath` if you use any provided cmdlet (like `Set-NLPowerShellConfig` below).

> NOTE: Adding the import to your `$PROFILE` will automatically import the module on startup.

### 3. Call `Set-NLPowerShellConfig` to initialize the config file.

```powershell
Set-NLPowerShellConfig -API_KEY (Read-Host "API_KEY" -AsSecureString)
```

### 4. Reload PowerShell and Import the module again (to register the key-handler)

```powershell
Import-Module <Path\To\This\Module>
```

### 5. Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>RightArrow</kbd> to invoke the natural-language handler.

- `PS> # Get a list of markdown files` <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>RightArrow</kbd>

```powershell
PS> Get-ChildItem -Path . -Filter "*.md"    # Get a list of markdown files
```

- `PS> Get-Date` <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>RightArrow</kbd>
```powershell
PS> Get-Date    # Get the current date
```
