#!/bin/bash
# Helper script for Taskwarrior operations in ccpm

# Usage: taskwarrior.sh create <title> <project> <epic> <tags>
taskwarrior_create() {
  local title="$1"
  local project="$2"
  local epic="$3"
  local tags="$4"

  local cmd="task add \"$title\" project:$project epic:$epic"

  # Add tags if provided
  if [ -n "$tags" ]; then
    cmd="$cmd $tags"
  fi

  # Execute and get the task ID
  eval "$cmd"
  task +LATEST id
}

# Usage: taskwarrior.sh start <task_id>
taskwarrior_start() {
  local task_id="$1"
  task "$task_id" start
}

# Usage: taskwarrior.sh done <task_id>
taskwarrior_done() {
  local task_id="$1"
  task "$task_id" done
}

# Usage: taskwarrior.sh status <task_id>
taskwarrior_status() {
  local task_id="$1"
  task "$task_id" status
}

# Usage: taskwarrior.sh ready <project>
taskwarrior_ready() {
  local project="${1:-.}"
  task project:"$project" +pending ready
}

# Main router
case "${1:-}" in
  create)
    taskwarrior_create "$2" "$3" "$4" "$5"
    ;;
  start)
    taskwarrior_start "$2"
    ;;
  done)
    taskwarrior_done "$2"
    ;;
  status)
    taskwarrior_status "$2"
    ;;
  ready)
    taskwarrior_ready "$2"
    ;;
  *)
    echo "Usage: taskwarrior.sh {create|start|done|status|ready} ..."
    exit 1
    ;;
esac
