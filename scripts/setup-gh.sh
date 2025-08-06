#!/bin/bash
# Setup GitHub CLI after installation

echo "=== GitHub CLI Setup ==="
echo ""

if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not installed. Install it first with:"
    echo "  sudo dnf install gh"
    exit 1
fi

echo "Checking GitHub CLI authentication status..."
if gh auth status &>/dev/null; then
    echo "✓ Already authenticated with GitHub"
else
    echo "Need to authenticate with GitHub."
    echo "Choose authentication method:"
    echo "  1. Login with web browser (recommended)"
    echo "  2. Login with authentication token"
    read -p "Choice (1 or 2): " -n 1 -r
    echo
    
    if [[ $REPLY == "1" ]]; then
        gh auth login --web
    else
        gh auth login
    fi
fi

echo ""
echo "GitHub CLI setup complete!"
echo ""
echo "Useful gh commands:"
echo "  gh repo clone OWNER/REPO"
echo "  gh pr create"
echo "  gh issue list"
echo "  gh repo create"