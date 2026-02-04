# Migrating from GitHub Issues to Taskwarrior

## Overview

This guide helps you migrate from GitHub-based task tracking to Taskwarrior.

## Prerequisites

1. Install Taskwarrior:
   - Ubuntu/Debian: `sudo apt install taskwarrior`
   - macOS: `brew install taskwarrior`
   - Other platforms: https://taskwarrior.org/download/

2. Verify installation:
   ```bash
   task --version
   ```

## Migration Steps

### For New Epics

Simply run the commands as normal:
```bash
/pm:prd-new feature-name
/pm:prd-parse feature-name
/pm:epic-decompose feature-name
```

Tasks will automatically be created in Taskwarrior.

### For Existing Epics

1. Run epic-decompose again to recreate tasks:
   ```bash
   /pm:epic-decompose existing-epic
   ```

2. This will create Taskwarrior entries for each task.

3. Start work with `/pm:task-start` instead of `/pm:issue-start`

## Command Mapping

| Old Command | New Command |
|-------------|-------------|
| `/pm:issue-start 1234` | `/pm:task-start 001` |
| `/pm:issue-close 1234` | `/pm:task-done 001` |
| `/pm:issue-sync 1234` | Not needed (automatic) |
| `/pm:epic-sync epic-name` | Not needed (automatic) |
| `/pm:next` | `/pm:next` (still works) |

## Taskwarrior Quick Reference

```bash
# View all tasks
task

# View pending tasks
task +PENDING

# View by project
task project:myapp

# View by type
task +bug
task +feature

# Start a task
task 42 start

# Complete a task
task 42 done

# Add a new task directly
task add "Fix login bug" project:myapp +bug
```

## Benefits

- No GitHub dependency
- Cross-platform support
- Faster command-line interface
- Local data ownership
- Works with any git host
