# AI-Assisted Coding Workflow Documentation

> **Complete Git Worktree + Neovim + Claude Code Integration**  
> Safe AI experimentation with real-time diff visualization and seamless context switching

## 🎯 Overview

This workflow provides isolated AI coding sessions using git worktrees, allowing you to:
- ✅ Experiment with AI code changes safely in isolated environments
- ✅ Real-time visualization of AI changes with gitsigns
- ✅ Automatic file opening and change attribution 
- ✅ Seamless switching between sessions and main repository
- ✅ Clean folder organization (no more scattered directories)
- ✅ Automatic Claude Code context reconnection

## 🏗️ Architecture

```
your-project/
├── .git/
├── .gitignore          # Auto-updated with .worktrees/
├── .worktrees/         # All AI sessions organized here
│   ├── project-feature-auth-20250731-091015/
│   ├── project-bugfix-api-20250731-092030/
│   └── project-refactor-ui-20250731-093045/
├── src/                # Your main project files
└── README.md
```

## 🚀 Quick Start

### 1. Start New AI Session
```bash
# Navigate to your project
cd /path/to/your-project

# Create new Claude session
claude_session_start "feature-auth"
# Creates: project/.worktrees/myproject-feature-auth-20250731-091015/
# ✓ Auto-switches to worktree directory
# ✓ Configures git authorship for Claude
# ✓ Updates Neovim working directory
# ✓ Starts file watcher
# ✓ Sets up Claude Code context
```

### 2. Work with AI
- **In Neovim**: Files created by Claude automatically open
- **Gitsigns**: Real-time diff visualization shows Claude's changes
- **Attribution**: Git commits clearly marked as Claude's work

### 3. Review and Merge
```bash
# Review changes
claude_status                    # Show session details

# Merge back to main (interactive)
claude_session_merge            # Choose merge strategy

# Or abandon if not needed
claude_session_abandon "feature-auth" "not needed"
```

## 📋 Command Reference

### Core Session Management

| Command | Alias | Description | Example |
|---------|-------|-------------|---------|
| `claude_session_start <name>` | `css` | Create new AI session | `css "feature-auth"` |
| `claude_session_switch <name>` | `csw` | Switch to existing session | `csw "feature-auth"` |
| `claude_session_merge` | `csm` | Merge session to main | `csm --interactive` |
| `claude_session_abandon <name>` | `csa` | Delete session | `csa "feature-auth"` |
| `claude_sessions` | `cs` | List all sessions | `cs` |
| `claude_status` | `cst` | Show current status | `cst` |

### Navigation & Context

| Command | Description | Example |
|---------|-------------|---------|
| `claude_cd <path>` | Enhanced cd with auto-detection | `claude_cd .worktrees/project-auth-*` |
| `ccd <path>` | Alias for `claude_cd` | `ccd ../main-project` |

### Advanced Management

| Command | Description |
|---------|-------------|
| `~/bin/claude-session-manager.sh status` | Detailed session report |
| `~/bin/claude-session-manager.sh cleanup 7` | Remove sessions older than 7 days |
| `~/bin/claude-session-manager.sh analytics` | Usage statistics |
| `~/bin/claude-session-manager.sh kill-watchers` | Stop all file watchers |

## 🔧 Neovim Integration

### Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cs` | Normal | Start new Claude session |
| `<leader>cw` | Normal | Switch Git worktree (Telescope) |
| `<leader>cwc` | Normal | Create Git worktree (Telescope) |
| `]c` / `[c` | Normal | Navigate git hunks |
| `<leader>hp` | Normal | Preview hunk inline |
| `<leader>hs` | Normal | Stage hunk |
| `<leader>hr` | Normal | Reset hunk |

### Auto-Commands
- **File watching**: Automatically opens files created by Claude
- **Context switching**: Updates working directory on worktree changes
- **Server communication**: Maintains connection for external tools

## 🔍 Usage Examples

### Example 1: Feature Development
```bash
# Start working on authentication feature
css "auth-system"
# → Creates: myproject-auth-system-20250731-091015/

# Claude creates files, they auto-open in Neovim
# Work with Claude, review changes in real-time with gitsigns

# When done, merge back
csm
# Choose: 1) Merge all changes, 2) Interactive merge, 3) Cancel
```

### Example 2: Bug Investigation
```bash
# Create session for bug investigation
css "fix-memory-leak"

# Work with Claude to identify and fix the issue
# Review each change with gitsigns

# If fix works, merge
csm --all

# If not needed, abandon
csa "fix-memory-leak" "issue was elsewhere"
```

### Example 3: Multiple Sessions
```bash
# List all active sessions
cs
# 🤖 auth-system → myproject-auth-system-20250731-091015 (claude-session-auth-system)
# 🤖 fix-api → myproject-fix-api-20250731-092030 (claude-session-fix-api)

# Switch between sessions
csw "auth-system"    # Switch to auth work
csw "fix-api"        # Switch to API fix

# Check status
cst
# 🤖 Claude Session: auth-system
# Git Status: M src/auth.js, ?? src/auth.test.js
```

### Example 4: Reconnecting After Restart
```bash
# After restarting terminal/Neovim, reconnect to session
claude_cd .worktrees/myproject-auth-system-20250731-091015
# 🤖 Detected Claude session worktree
# ✓ Updated Neovim working directory
# ✓ Updated Claude Code context
# Active session: myproject-auth-system-20250731-091015
```

## 🛠️ Configuration

### Environment Variables
Set in `~/.zshrc`:
```bash
export NVIM_LISTEN_ADDRESS="/tmp/nvim-ai-session"
export AI_WORKTREE_PREFIX="claude-session-"
export CLAUDE_CLEANUP_DAYS="7"  # Auto-cleanup age
```

### Git Configuration
Automatically configured for each session:
```bash
# Claude authorship for clear attribution
git config user.name "claude-code"
git config user.email "claude@ai.assistant"
```

## 📁 File Structure

### Session Files
Each session contains:
- `.claude-session` - Session metadata and timestamp
- Source code files with Claude's changes
- Git history with clear attribution

### Main Project
- `.worktrees/` automatically added to `.gitignore`
- Clean separation between main and AI work
- No scattered directories

## 🔧 Troubleshooting

### Issue: Session not detected
```bash
# Check if you're in the right directory
pwd
ls -la .claude-session

# Manually reconnect
claude_cd .
```

### Issue: Neovim not updating
```bash
# Check server status
ls -la /tmp/nvim-ai-session

# Restart Neovim server
# In Neovim: :lua vim.fn.serverstart("/tmp/nvim-ai-session")
```

### Issue: File watcher not working
```bash
# Check if watcher is running
ps aux | grep file-watcher

# Restart manually
~/bin/file-watcher.sh $(pwd)
```

### Issue: Too many old sessions
```bash
# Clean up old sessions
~/bin/claude-session-manager.sh cleanup 3  # Remove sessions older than 3 days

# View analytics
~/bin/claude-session-manager.sh analytics
```

## 🎛️ Advanced Features

### Session Analytics
```bash
~/bin/claude-session-manager.sh analytics
# 📈 Claude Session Analytics
# Total sessions created: 15
# Sessions merged: 12
# Sessions abandoned: 3
# Success rate: 80%
```

### Session Archiving
```bash
# Archive session instead of deleting
~/bin/claude-session-manager.sh archive "feature-auth"
# Creates patch file in ~/.local/share/claude-sessions/archives/

# Restore from archive later
~/bin/claude-session-manager.sh restore "feature-auth-20240130"
```

### Multiple Concurrent Sessions
```bash
# Work on multiple features simultaneously
css "auth-system"    # Terminal 1
css "api-refactor"   # Terminal 2  
css "ui-updates"     # Terminal 3

# Each session is completely isolated
```

## 🔍 File Locations

| Component | Location |
|-----------|----------|
| Worktree functions | `~/.config/zsh/worktree-functions.zsh` |
| File watcher | `~/bin/file-watcher.sh` |
| Session manager | `~/bin/claude-session-manager.sh` |
| Neovim config | `~/.config/nvim/lua/plugins/git-worktree.lua` |
| Auto-commands | `~/.config/nvim/lua/config/autocmds.lua` |
| Gitsigns config | `~/.config/nvim/lua/plugins/gitsigns.lua` |
| Session logs | `~/.local/share/claude-sessions/` |

## 🚨 Safety Features

- **Isolated environments**: Each session is completely separate
- **Clear attribution**: Git commits clearly marked as Claude's work
- **Automatic backups**: Session history and analytics maintained
- **Safe merging**: Interactive merge options prevent accidental overwrites
- **Easy abandonment**: Quick cleanup if experiments don't work out

## 🎯 Best Practices

1. **Descriptive session names**: Use clear, specific names like "fix-auth-bug" vs "test"
2. **Regular cleanup**: Use analytics to monitor and clean old sessions
3. **Review before merging**: Always review Claude's changes with gitsigns
4. **Small, focused sessions**: One feature/fix per session for clarity
5. **Use interactive merging**: Selectively choose which changes to keep

---

**🎉 Your AI-assisted coding workflow is now fully documented and ready to use!**

For questions or issues, check the troubleshooting section above or review the configuration files.