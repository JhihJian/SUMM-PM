---
allowed-tools: Bash, Read, Write, LS
---

# Task Done

Mark a task as complete and update Taskwarrior.

## Usage
```
/pm:task-done <task_file_name>
```

## Preflight Checklist

1. **Find task file:**
   ```bash
   task_file=$(find .claude/epics -name "$ARGUMENTS.md" | head -1)
   if [ -z "$task_file" ]; then
     echo "❌ Task file not found: $ARGUMENTS.md"
     exit 1
   fi
   ```

2. **Check Taskwarrior ID:**
   ```bash
   task_id=$(grep "^taskwarrior_id:" "$task_file" | head -1 | sed 's/^taskwarrior_id: *//')
   if [ -z "$task_id" ] || [ "$task_id" = "null" ]; then
     echo "❌ No taskwarrior_id found"
     exit 1
   fi
   ```

## Instructions

### 1. Verify Acceptance Criteria

Read the task file and verify all acceptance criteria are complete.

### 2. Mark Task Done in Taskwarrior

```bash
ccpm/scripts/pm/taskwarrior.sh done "$task_id"
```

### 3. Update Task File

Get current datetime: `date -u +"%Y-%m-%dT%H:%M:%SZ"`

Update task file frontmatter:
```yaml
---
name: [Task Title]
status: closed
created: [preserve existing date]
updated: [Use REAL datetime from command above]
taskwarrior_id: $task_id
---
```

### 4. Update Progress File

If progress file exists, update it:
```bash
progress_file=".claude/epics/$epic_name/updates/$ARGUMENTS/progress.md"
if [ -f "$progress_file" ]; then
  # Update completion status
  sed -i "s/status: in_progress/status: completed/" "$progress_file"
  echo "" >> "$progress_file"
  echo "## Completed at $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$progress_file"
fi
```

### 5. Update Epic Progress

Count completed tasks and update epic.md frontmatter.

### 6. Output

```
✅ Task $ARGUMENTS completed

Taskwarrior ID: $task_id
Epic progress: {new_progress}% ({closed}/{total} tasks)

Next: Run /pm:task-start {next_task} or /pm:next for available tasks
```

## Error Handling

If any step fails:
- Report clearly: "❌ {What failed}: {How to fix}"
- Keep local state for retry
