#!/bin/bash

# Migrate from nvm to Volta - macOS Edition
# This script safely migrates from nvm to Volta for Node.js version management

set -e

echo "==================================="
echo "Migrating from nvm to Volta"
echo "==================================="
echo

# Check if nvm is installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "❌ nvm doesn't appear to be installed. Exiting."
    exit 1
fi

# Step 1: Backup current Node information
echo "📦 Step 1: Backing up current Node setup..."
CURRENT_NODE_VERSION=$(node --version 2>/dev/null || echo "none")
echo "Current Node version: $CURRENT_NODE_VERSION"

# Save list of global packages (if Node is installed)
if command -v npm &> /dev/null; then
    echo "Saving global npm packages list..."
    npm list -g --depth=0 --json > ~/nvm-global-packages-backup.json 2>/dev/null || true
    # Also create a simple text list for reference
    npm list -g --depth=0 2>/dev/null | grep -E "^├──|^└──" | sed 's/^[├└]── //g' | sed 's/@.*//g' > ~/nvm-global-packages.txt || true
    echo "Global packages saved to ~/nvm-global-packages-backup.json and ~/nvm-global-packages.txt"
fi

echo
echo "📋 Step 2: Removing nvm from shell configuration..."

# Function to remove nvm lines from a file
remove_nvm_from_file() {
    local file="$1"
    if [ -f "$file" ]; then
        echo "Cleaning $file..."
        # Create backup
        cp "$file" "${file}.nvm-backup.$(date +%Y%m%d_%H%M%S)"

        # Remove nvm-related lines
        sed -i '' '/NVM_DIR/d' "$file"
        sed -i '' '/\.nvm/d' "$file"
        sed -i '' '/nvm.sh/d' "$file"
        sed -i '' '/nvm use/d' "$file"
        sed -i '' '/load-nvmrc/d' "$file"
        sed -i '' '/# NVM auto-switching/d' "$file"
        sed -i '' '/local node_version="\$(nvm version)"/d' "$file"
        sed -i '' '/local nvmrc_path="\$(nvm_find_nvmrc)"/d' "$file"
        sed -i '' '/if \[ -n "\$nvmrc_path" \]/d' "$file"
        sed -i '' '/local nvmrc_node_version/d' "$file"
        sed -i '' '/if \[ "\$nvmrc_node_version" = "N\/A" \]/d' "$file"
        sed -i '' '/elif \[ "\$nvmrc_node_version" != "\$node_version" \]/d' "$file"
        sed -i '' '/autoload -U add-zsh-hook/d' "$file"
        sed -i '' '/add-zsh-hook chpwd load-nvmrc/d' "$file"
    fi
}

# Remove from common shell files
remove_nvm_from_file "$HOME/.bashrc"
remove_nvm_from_file "$HOME/.bash_profile"
remove_nvm_from_file "$HOME/.zshrc"
remove_nvm_from_file "$HOME/.profile"

echo
echo "🗑️  Step 3: Uninstalling nvm..."
echo "Removing ~/.nvm directory..."
if [ -d "$HOME/.nvm" ]; then
    rm -rf "$HOME/.nvm"
    echo "✅ nvm directory removed"
fi

echo
echo "🚀 Step 4: Installing Volta..."
curl https://get.volta.sh | bash

echo
echo "⚙️  Step 5: Configuring shell..."

# Add Volta to PATH for current session
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Ensure Volta is in shell config
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    SHELL_CONFIG="$HOME/.profile"
fi

# Check if Volta path already exists in shell config
if ! grep -q "VOLTA_HOME" "$SHELL_CONFIG" 2>/dev/null; then
    echo "" >> "$SHELL_CONFIG"
    echo "# Volta" >> "$SHELL_CONFIG"
    echo 'export VOLTA_HOME="$HOME/.volta"' >> "$SHELL_CONFIG"
    echo 'export PATH="$VOLTA_HOME/bin:$PATH"' >> "$SHELL_CONFIG"
    echo "✅ Added Volta to $SHELL_CONFIG"
else
    echo "✅ Volta already configured in $SHELL_CONFIG"
fi

echo
echo "📦 Step 6: Installing Node.js with Volta..."

# Install Node.js (latest LTS by default)
if [ "$CURRENT_NODE_VERSION" != "none" ]; then
    # Try to install the same major version
    MAJOR_VERSION=$(echo "$CURRENT_NODE_VERSION" | sed 's/v//' | cut -d. -f1)
    echo "Installing Node.js $MAJOR_VERSION (closest to your previous $CURRENT_NODE_VERSION)..."
    volta install node@$MAJOR_VERSION || volta install node@lts
else
    echo "Installing latest LTS Node.js..."
    volta install node@lts
fi

echo
echo "🔧 Step 7: Restoring global packages..."
if [ -f "$HOME/nvm-global-packages.txt" ]; then
    echo "Found package list. Installing global packages with Volta..."

    # Common global packages that should be installed with Volta
    while IFS= read -r package; do
        # Skip npm itself and empty lines
        if [[ "$package" != "npm" ]] && [[ -n "$package" ]]; then
            echo "Installing $package..."
            volta install "$package" 2>/dev/null || npm install -g "$package" || true
        fi
    done < "$HOME/nvm-global-packages.txt"

    echo "✅ Global packages restored"
fi

echo
echo "✅ Step 8: Verification..."
echo "Node version: $(node --version 2>/dev/null || echo 'Not found')"
echo "npm version: $(npm --version 2>/dev/null || echo 'Not found')"
echo "Volta version: $(volta --version 2>/dev/null || echo 'Not found')"

echo
echo "==================================="
echo "✨ Migration Complete!"
echo "==================================="
echo
echo "Next steps:"
echo "1. Open a new terminal window/tab for changes to take effect"
echo "2. Your previous shell configs were backed up with .nvm-backup.* extension"
echo "3. Global packages list saved to ~/nvm-global-packages.txt"
echo
echo "Volta benefits over nvm:"
echo "• Faster shell startup (no shell integration needed)"
echo "• Automatic version switching based on package.json"
echo "• Better Windows/cross-platform support"
echo "• Simpler global package management"
echo
echo "Common Volta commands:"
echo "  volta install node          # Install latest LTS Node"
echo "  volta install node@18       # Install specific version"
echo "  volta pin node@18           # Pin version in package.json"
echo "  volta install typescript    # Install global package"
echo "  volta list                  # List installed tools"