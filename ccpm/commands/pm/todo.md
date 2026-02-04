---
allowed-tools: Bash, Read, Write, LS
---

# Todo - Quick Task Creation

Create a simple task and track it with Taskwarrior.

## Usage
```
/pm:todo <task_description>
```

Example: `/pm:todo install code-server on port 10000`

## Instructions

### 1. Check Taskwarrior

```bash
if ! command -v task &> /dev/null; then
  echo "❌ Taskwarrior not installed. Install it first:"
  echo "   Ubuntu/Debian: sudo apt install taskwarrior"
  echo "   macOS: brew install taskwarrior"
  exit 1
fi
```

### 2. Validate Task Description

Read the task description from $ARGUMENTS and validate:

- Is the description clear enough to execute?
- Are there any ambiguities?
- Are there missing details (ports, paths, etc.)?

**If unclear**: Ask the user for clarification:
```
⚠️ Task description needs clarification:

- [What's unclear]

Please provide: [missing information]
```

**If clear**: Proceed to create the task.

### 3. Create Task in Taskwarrior

```bash
# Get current datetime
current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Extract project name (optional) - use "general" if not specified
project="general"

# Extract tags from description (optional)
# Common tags: +setup, +bug, +feature, +docs, +config

# Create the task
task add "$ARGUMENTS" project:$project status:pending entered:"$current_time"

# Get the created task ID
task_id=$(task +LATEST id)
```

### 4. Output

```
✅ Task created: $task_id
📝 Description: $ARGUMENTS

Next commands:
  • Start work: task $task_id start
  • View details: task $task_id
  • Mark done: task $task_id done
  • List tasks: task
```

## Examples

### Simple task
```
/pm:todo install nginx on server
```
Creates: "install nginx on server" in project "general"

### With implied tags
```
/pm:todo fix login bug
```
Creates: "fix login bug" - could add +bug tag

## Task Clarification Guidelines

Ask for clarification when:
- **Ambiguous targets**: "configure the server" → which server? what config?
- **Missing versions**: "install node" → which version?
- **Missing paths**: "backup the files" → which files? where to?
- **Unclear outcomes**: "check the service" → what to check? what's expected?

Don't over-clarify common operations that have standard defaults.
