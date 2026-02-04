# Quick Install

## Prerequisites

Before installing CCPM, ensure you have the required dependencies:

### Taskwarrior (Required for task tracking)

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install taskwarrior
```

**macOS:**
```bash
brew install taskwarrior
```

**Fedora/RHEL:**
```bash
sudo dnf install taskwarrior
```

**Arch Linux:**
```bash
sudo pacman -S taskwarrior
```

Visit https://taskwarrior.org/download/ for other platforms.

### GitHub CLI (Optional, for GitHub integration)

**Ubuntu/Debian:**
```bash
sudo apt install gh
```

**macOS:**
```bash
brew install gh
```

Visit https://cli.github.com/ for other platforms.

## Unix/Linux/macOS

```bash
curl -sSL https://automaze.io/ccpm/install | bash
```

Or with wget:

```bash
wget -qO- https://automaze.io/ccpm/install | bash
```

## Windows (PowerShell)

```powershell
iwr -useb https://automaze.io/ccpm/install | iex
```

Or download and execute:

```powershell
curl -o ccpm.bat https://automaze.io/ccpm/install && ccpm.bat
```

## One-liner alternatives

### Unix/Linux/macOS (direct commands)
```bash
git clone https://github.com/automazeio/ccpm.git . && rm -rf .git
```

### Windows (cmd)
```cmd
git clone https://github.com/automazeio/ccpm.git . && rmdir /s /q .git
```

### Windows (PowerShell)
```powershell
git clone https://github.com/automazeio/ccpm.git .; Remove-Item -Recurse -Force .git
```
