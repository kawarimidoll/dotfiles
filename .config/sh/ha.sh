# Git worktree helper functions
# Usage: source this file from your shell rc

# Internal: get base worktree path
_ha_base_path() {
  git worktree list | head -1 | awk '{print $1}'
}

# Internal: get worktree path for branch
_ha_worktree_path() {
  echo "$(_ha_base_path)@$1"
}

# Internal: check if in a worktree (not base)
_ha_is_worktree() {
  [[ "$(git rev-parse --show-toplevel)" != "$(_ha_base_path)" ]]
}

# Internal: get remote HEAD (e.g., origin/main)
_ha_remote_head() {
  git symbolic-ref refs/remotes/origin/HEAD
}

# Internal: fetch latest from remote
_ha_fetch() {
  git fetch --all --prune --quiet
}

# Internal: run hook if exists
_ha_exec_hook() {
  local hook_file="$(_ha_base_path)/.ha/hooks/$1"
  if [[ -x "$hook_file" ]]; then
    "$hook_file"
  elif [[ -f "$hook_file" ]]; then
    source "$hook_file"
  fi
}

# Main entry point
ha() {
  local cmd="$1"
  shift 2>/dev/null
  case "$cmd" in
    new)    ha-new "$@" ;;
    mv)     ha-mv "$@" ;;
    del)    ha-del "$@" ;;
    cd)     ha-cd "$@" ;;
    home)   ha-home "$@" ;;
    use)    ha-use "$@" ;;
    gone)   ha-gone "$@" ;;
    ls)     ha-ls "$@" ;;
    copy)   ha-copy "$@" ;;
    link)   ha-link "$@" ;;
    *)
      cat <<'EOF'
Usage: ha <command> [args]

Commands:
  new [name]    Create new worktree + branch and cd (default: wip-$RANDOM)
  mv <name>     Rename current worktree + branch
  del [-f]      Delete current worktree + branch
  cd            Select worktree with fzf and cd
  home          Go back to base directory
  use           Checkout current commit to base
  gone          Delete all gone worktrees + branches
  ls            List worktrees
  copy <path>   Copy file/dir from base to current worktree
  link <path>   Symlink file/dir from base to current worktree
EOF
      return 1
      ;;
  esac
}

# List worktrees
ha-ls() {
  git worktree list "$@"
}

# Create new worktree + branch from remote-head
ha-new() {
  local branch_name="${1:-wip-$RANDOM}"

  # Validate branch name
  if ! git check-ref-format --branch "$branch_name" >/dev/null 2>&1; then
    echo "Error: Invalid branch name '$branch_name'" >&2
    return 1
  fi

  local worktree_path="$(_ha_worktree_path "$branch_name")"

  _ha_fetch || return 1

  # Create worktree with detached HEAD
  git worktree add --detach "$worktree_path" "$(_ha_remote_head)" || return 1

  # Move to worktree and create branch
  cd "$worktree_path" || return 1
  git switch --create "$branch_name" --no-track

  _ha_exec_hook post-new
}

# Rename current worktree + branch
ha-mv() {
  local new_name="$1"
  if [[ -z "$new_name" ]]; then
    echo "Usage: ha mv <new-branch-name>" >&2
    return 1
  fi

  _ha_is_worktree || { echo "Error: Not in a worktree" >&2; return 1; }

  local current_path="$(git rev-parse --show-toplevel)"
  local new_path="$(_ha_worktree_path "$new_name")"

  git branch -m "$new_name" || return 1
  git worktree move "$current_path" "$new_path" || return 1

  cd "$new_path" || return 1
}

# Delete current worktree + branch
# -f: force delete
ha-del() {
  local force=false
  if [[ "$1" == "-f" ]]; then
    force=true
  fi

  _ha_is_worktree || { echo "Error: Not in a worktree" >&2; return 1; }

  local current_path="$(git rev-parse --show-toplevel)"
  local branch_name="$(git branch --show-current)"

  if [[ "$force" == false ]]; then
    if [[ -n "$(git status --porcelain)" ]]; then
      echo "Error: Worktree has uncommitted changes or untracked files" >&2
      echo "Use 'ha del -f' to force delete" >&2
      return 1
    fi

    if ! git branch --merged "$(_ha_remote_head)" | grep -qE "^\*?\s*$branch_name$"; then
      echo "Error: Branch '$branch_name' is not merged into $(_ha_remote_head)" >&2
      echo "Use 'ha del -f' to force delete" >&2
      return 1
    fi
  fi

  cd "$(_ha_base_path)" || return 1

  if [[ "$force" == true ]]; then
    git worktree remove --force "$current_path" || return 1
    git branch -D "$branch_name" || return 1
  else
    git worktree remove "$current_path" || return 1
    git branch -d "$branch_name" || return 1
  fi
}

# Select worktree with fzf and cd
ha-cd() {
  local selected
  selected=$(git worktree list | fzf --no-multi --exit-0 \
    --preview="git -C {1} log -5 --oneline --decorate")

  if [[ -n "$selected" ]]; then
    cd "$(echo "$selected" | awk '{print $1}')" || return 1
  fi
}

# Go back to base directory
ha-home() {
  cd "$(_ha_base_path)" || return 1
}

# Checkout current commit to base directory
ha-use() {
  _ha_is_worktree || { echo "Error: Not in a worktree" >&2; return 1; }

  git -C "$(_ha_base_path)" checkout --detach "$(git rev-parse HEAD)"
}

# Copy file/dir from base to current worktree
ha-copy() {
  local path="$1"
  if [[ -z "$path" ]]; then
    echo "Usage: ha copy <path>" >&2
    return 1
  fi

  _ha_is_worktree || { echo "Error: Not in a worktree" >&2; return 1; }

  local base_path="$(_ha_base_path)"
  local current_path="$(git rev-parse --show-toplevel)"

  if [[ ! -e "$base_path/$path" ]]; then
    echo "Error: '$path' does not exist in base" >&2
    return 1
  fi

  if [[ -e "$current_path/$path" ]]; then
    echo "Error: '$path' already exists in current worktree" >&2
    return 1
  fi

  cp -r "$base_path/$path" "$current_path/$path"
}

# Symlink file/dir from base to current worktree
ha-link() {
  local path="$1"
  if [[ -z "$path" ]]; then
    echo "Usage: ha link <path>" >&2
    return 1
  fi

  _ha_is_worktree || { echo "Error: Not in a worktree" >&2; return 1; }

  local base_path="$(_ha_base_path)"
  local current_path="$(git rev-parse --show-toplevel)"

  if [[ ! -e "$base_path/$path" ]]; then
    echo "Error: '$path' does not exist in base" >&2
    return 1
  fi

  if [[ -e "$current_path/$path" ]]; then
    echo "Error: '$path' already exists in current worktree" >&2
    return 1
  fi

  ln -s "$base_path/$path" "$current_path/$path"
}

# Delete all gone worktrees + branches
ha-gone() {
  _ha_fetch || return 1

  local gone_branches
  gone_branches=$(git branch -vv | awk '/: gone]/{print $1}')

  if [[ -z "$gone_branches" ]]; then
    echo "No gone branches found"
    return 0
  fi

  echo "Gone branches:"
  echo "$gone_branches"
  echo ""

  local branch
  for branch in $gone_branches; do
    # Resolve worktree path from branch name
    local worktree_path
    worktree_path=$(git worktree list | grep "\[$branch\]" | awk '{print $1}')

    if [[ -n "$worktree_path" ]]; then
      echo "Removing worktree: $worktree_path"
      git worktree remove "$worktree_path" || continue
    fi

    echo "Deleting branch: $branch"
    git branch -d "$branch"
  done
}
