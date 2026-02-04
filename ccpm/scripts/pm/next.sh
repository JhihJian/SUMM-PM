#!/bin/bash
# Show next available tasks using Taskwarrior

echo ""
echo "📋 Next Available Tasks"
echo "======================="
echo ""

# Check if Taskwarrior is available
if ! command -v task &> /dev/null; then
  echo "❌ Taskwarrior not found. Install it first:"
  echo "   • Ubuntu/Debian: sudo apt install taskwarrior"
  echo "   • macOS: brew install taskwarrior"
  echo "   • Or visit: https://taskwarrior.org/download/"
  echo ""
  echo "Falling back to file-based scan..."
  echo ""

  # Fallback to original behavior
  for epic_dir in .claude/epics/*/; do
    [ -d "$epic_dir" ] || continue
    epic_name=$(basename "$epic_dir")

    for task_file in "$epic_dir"/[0-9]*.md; do
      [ -f "$task_file" ] || continue

      status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//')
      if [ "$status" != "open" ] && [ -n "$status" ]; then
        continue
      fi

      deps_line=$(grep "^depends_on:" "$task_file" | head -1)
      if [ -n "$deps_line" ]; then
        deps=$(echo "$deps_line" | sed 's/^depends_on: *//' | sed 's/^\[//' | sed 's/\]$//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        [ -z "$deps" ] || [ "$deps" = "depends_on:" ] && deps="" || continue
      fi

      task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
      task_num=$(basename "$task_file" .md)

      echo "✅ Ready: #$task_num - $task_name"
      echo "   Epic: $epic_name"
      echo ""
    done
  done

  exit 0
fi

# Use Taskwarrior if available
# Show ready tasks (pending, not blocked, dependencies satisfied)
task rc.report.next.columns=id,description,epic,status,project \
    rc.report.next.labels=ID,Description,Epic,Status,Project \
    +PENDING +READY 2>/dev/null || task +PENDING +READY

echo ""
echo "💡 Tips:"
echo "  • Start a task: /pm:task-start <id>"
echo "  • Filter by project: task project:myapp list"
echo "  • Filter by type: task +bug, task +feature"
echo ""
