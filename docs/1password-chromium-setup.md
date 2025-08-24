# 1Password in Chromium - CLI vs Extension

## They're Separate
- **CLI session**: 30 days (what we just set up)
- **Browser extension**: Per-profile, separate login
- They DON'T share authentication

## For Your New Chromium Profile

### Option 1: 1Password Extension (Regular)
- Requires 1Password desktop app for Linux
- May not work well on ARM

### Option 2: 1Password X (Recommended for ARM)
- Standalone, no desktop app needed
- Better for multiple profiles
- Install from: https://chrome.google.com/webstore/detail/1password-x/aeblfdkhhhdcdjpifhhbdiojplfjncoa

### Setup for New Profile:
1. Open new profile: `chromium --profile-directory="Profile 5"`
2. Install 1Password X from Chrome Web Store
3. Sign in with email + master password + secret key (first time per profile)
4. **Important Settings** (to reduce re-authentication):
   - Click extension icon → Settings → Security
   - Set "Auto-lock" to: **Never** or **On browser restart**
   - Enable: **Unlock with system authentication** (uses Linux password)

### After First Login Per Profile:
- Extension stays logged in (doesn't expire like CLI)
- Only re-authenticate on browser restart (if you set "Never" for auto-lock)
- Secret key cached per profile after first login

## CLI as Backup
While extension handles browser passwords, CLI is useful for:
```bash
# Quick password copy when extension is locked
op-copy "GitHub"

# Getting passwords for non-web apps
op-get "SSH Key"
```

## Multiple Profile Tips:
- Each profile needs separate extension login (unavoidable)
- But after initial setup, they stay logged in
- Use 1Password X for better persistence
- Set auto-lock to "Never" to avoid constant re-auth