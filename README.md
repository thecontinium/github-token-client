# GitHub CLI & Git Secure Wrapper

This repository replaces the legacy `GithubTokenClient` Homebrew Formula setup. It provides a non-privileged, user-space execution interceptor for `gh` commands and native `git` operations, forcing both to resolve access tokens entirely in memory over your local SSH tunnel mapping loopback (`127.0.0.1:8080`).

## 🚀 Setup

No Keychain configurations or Homebrew formula updates required. Simply clone and execute the local installer:

```bash
git clone https://github.com/thecontinium/github-token-client-deployment.git
cd github-token-client-deployment
./install.sh
```

The script will automatically detect whether you are running `zsh` or `bash` and add `~/.local/bin` to the beginning of your profile configuration if it isn't already there.

---

## ⚙️ Verification & Operations

Ensure your local SSH tunnel mapping to the target server is active on port `8080`.

**Crucial:** Apply changes to your current shell session before checking status:
```bash
source ~/.zshrc  # Or source ~/.bash_profile
```

### Verify `gh` Access:
```bash
gh auth status
```

### Verify Native `git` Access:
```bash
git ls-remote https://github.com/YOUR_ORGANIZATION/YOUR_PRIVATE_REPO.git
```
