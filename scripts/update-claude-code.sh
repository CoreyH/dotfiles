#!/bin/bash

# Update Claude Code and sync Volta registry
# This handles the issue where Claude Code self-updates but Volta doesn't know about it

echo "Updating Claude Code..."

# First, let Claude Code check for its own updates
claude update

# Then refresh Volta's registry to match the actual installed version
echo "Syncing Volta registry..."
volta install @anthropic-ai/claude-code@latest

# Show current version
echo ""
echo "Current Claude Code version:"
claude --version