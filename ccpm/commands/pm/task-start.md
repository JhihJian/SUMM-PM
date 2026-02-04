---
allowed-tools: Bash, Read, Write, LS, Task
---

# Task Start

Begin work on a task with parallel agents based on work stream analysis.

## Usage
```
/pm:task-start <task_file_name>
```

Example: `/pm:task-start 001` (for file .claude/epics/epic-name/001.md)

## Preflight Checklist

1. **Find task file:**
   ```bash
   task_file=$(find .claude/epics -name "$ARGUMENTS.md" | head -1)
   if [ -z "$task_file" ]; then
     echo "❌ Task file not found: $ARGUMENTS.md"
     exit 1
   fi
   ```

2. **Check task status:**
   ```bash
   status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//')
   if [ "$status" = "closed" ]; then
     echo "⚠️ Task is already closed"
     exit 0
   fi
   ```

3. **Check Taskwarrior ID:**
   ```bash
   task_id=$(grep "^taskwarrior_id:" "$task_file" | head -1 | sed 's/^taskwarrior_id: *//')
   if [ -z "$task_id" ] || [ "$task_id" = "null" ]; then
     echo "❌ No taskwarrior_id found. Run: /pm:epic-decompose {epic_name}"
     exit 1
   fi
   ```

4. **Check for worktree:**
   ```bash
   epic_dir=$(dirname "$task_file")
   epic_name=$(basename "$(dirname "$epic_dir")")
   if ! git worktree list | grep -q "epic-$epic_name"; then
     echo "❌ No worktree for epic. Run: /pm:epic-start-worktree $epic_name"
     exit 1
   fi
   ```

## Instructions

### 1. Start Task in Taskwarrior

```bash
ccpm/scripts/pm/taskwarrior.sh start "$task_id"
```

### 2. Update Task File

Get current datetime: `date -u +"%Y-%m-%dT%H:%M:%SZ"`

Update task file frontmatter:
```yaml
---
name: [Task Title]
status: in_progress
created: [preserve existing date]
updated: [Use REAL datetime from command above]
taskwarrior_id: $task_id
---
```

### 3. Create Progress Tracking

```bash
mkdir -p "$epic_dir/updates/$ARGUMENTS"
echo "---" > "$epic_dir/updates/$ARGUMENTS/progress.md"
echo "task: $ARGUMENTS" >> "$epic_dir/updates/$ARGUMENTS/progress.md"
echo "taskwarrior_id: $task_id" >> "$epic_dir/updates/$ARGUMENTS/progress.md"
echo "started: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$epic_dir/updates/$ARGUMENTS/progress.md"
echo "status: in_progress" >> "$epic_dir/updates/$ARGUMENTS/progress.md"
echo "---" >> "$epic_dir/updates/$ARGUMENTS/progress.md"
```

### 4. Read Task Requirements

Read the task file to understand:
- Description and acceptance criteria
- Technical details
- Files affected
- Dependencies

### 5. Launch Parallel Agents (if applicable)

If task can be parallelized, spawn sub-agents:

```yaml
Task:
  description: "Task $ARGUMENTS Stream {X}"
  subagent_type: "general-purpose"
  prompt: |
    You are working on Task $ARGUMENTS in the epic worktree.

    Worktree location: ../epic-$epic_name/
    Task file: .claude/epics/$epic_name/$ARGUMENTS.md

    Read the task file and complete the work:
    1. Read the task file for requirements
    2. Work in the worktree directory
    3. Commit frequently with format: "Task $ARGUMENTS: {specific change}"
    4. Update progress in: .claude/epics/$epic_name/updates/$ARGUMENTS/progress.md
```

### 6. Output

```
✅ Started work on task $ARGUMENTS

Epic: $epic_name
Worktree: ../epic-$epic_name/
Taskwarrior ID: $task_id

Progress tracking:
  .claude/epics/$epic_name/updates/$ARGUMENTS/

Mark complete: /pm:task-done $ARGUMENTS
```

## Error Handling

If any step fails:
- Report clearly: "❌ {What failed}: {How to fix}"
- Never leave partial state
