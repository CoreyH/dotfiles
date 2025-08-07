# Claude Code Setup Guide

## Overview
Claude Code is Anthropic's official CLI for interacting with Claude. It provides a powerful command-line interface for AI-assisted development.

## Installation

### Option 1: Using Volta (Recommended)
Volta provides better version management and doesn't require sudo for global packages.

```bash
# Install Volta if not already installed
~/dotfiles/scripts/install-volta.sh

# Restart terminal or source bashrc
source ~/.bashrc

# Install Node.js
volta install node

# Install Claude Code
volta install @anthropic-ai/claude-code
```

### Option 2: Using npm
If you already have Node.js installed via dnf:

```bash
# Install Node.js if needed
sudo dnf install nodejs npm

# Install Claude Code globally
npm install -g @anthropic-ai/claude-code
```

### Option 3: Automated Script
```bash
~/dotfiles/scripts/install-claude-code.sh
```

## Configuration

### API Key Setup
On first run, Claude Code will prompt for your API key:
1. Get your key from: https://console.anthropic.com/settings/keys
2. The key will be stored securely in `~/.config/claude/config.json`

### Environment Variable (Alternative)
```bash
export CLAUDE_API_KEY="your-api-key-here"
```

## Usage

### Starting Claude Code
```bash
# Start from your project directory (recommended)
cd ~/dotfiles
claude

# Or start with a specific task
claude "help me understand this codebase"
```

### Key Commands
- `/help` - Show available commands
- `/clear` - Clear the conversation
- `/exit` or `Ctrl+C` - Exit Claude Code
- `/model` - Switch between Claude models
- `/tokens` - Show token usage

### Best Practices

#### For Dotfiles Management
Always start Claude Code from the dotfiles directory:
```bash
cd ~/dotfiles && claude
```

This ensures:
- CLAUDE.md context is automatically loaded
- File paths are relative to dotfiles root
- Git operations work correctly

#### Context Management
- Claude Code reads `CLAUDE.md` for project context
- Keep CLAUDE.md updated with project decisions
- Use clear, specific requests for best results

#### Multi-Machine Sync
Since Claude Code stores config in `~/.config/claude/`:
- API key must be configured per machine
- Settings don't sync across machines
- Each machine maintains its own conversation history

## Integration with Dotfiles

### CLAUDE.md Context
The `~/dotfiles/CLAUDE.md` file provides:
- Project structure overview
- Key decisions and preferences
- Common commands and workflows
- Current status and TODOs

### Workflow Example
```bash
# Start Claude Code from dotfiles
cd ~/dotfiles && claude

# Example requests:
"help me add a new GNOME extension to my setup"
"create a script to backup my Edge profiles"
"explain how my OneDrive sync is configured"
```

## Troubleshooting

### Command Not Found
```bash
# Check installation
which claude

# If using Volta, ensure it's in PATH
echo $PATH | grep volta

# Reinstall if needed
volta install @anthropic-ai/claude-code
```

### API Key Issues
```bash
# Check config exists
ls ~/.config/claude/

# Remove and reconfigure if needed
rm -rf ~/.config/claude/
claude  # Will prompt for new key
```

### Node.js Version Issues
```bash
# If using Volta, update Node
volta install node@latest

# Check current version
node --version  # Should be 18+ for Claude Code
```

## Updates

### Check Current Version
```bash
claude --version
```

### Update Claude Code
```bash
# With Volta
volta install @anthropic-ai/claude-code@latest

# With npm
npm update -g @anthropic-ai/claude-code
```

## Security Notes

- API keys are stored locally in `~/.config/claude/config.json`
- Never commit API keys to version control
- Each machine needs its own API key configuration
- Keys are not synced via dotfiles for security

## References
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [API Keys](https://console.anthropic.com/settings/keys)
- [Volta](https://volta.sh/)
- [GitHub Issues](https://github.com/anthropics/claude-code/issues)