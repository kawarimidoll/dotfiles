#!/bin/bash

# -----------------
#  xd - extended cd
# -----------------

alias xdf='xd $OLDPWD'

__xd_log_dir() {
  echo "${XD_LOG_DIR:-"${HOME}/.kawarimidoll"}"
}

__xd_log_file() {
  echo "$(__xd_log_dir)/xd.log"
}

__xd_log_lines() {
  echo "${XD_LOG_LINES:-10}"
}

xd() {
  local arg_dir="${*: -1}" dir

  if [ -d "$arg_dir" ]; then
    dir="$arg_dir"
  else
    # .gitignore is not always existing even if it's git directory...
    # grep '^[^#]' $(git rev-parse --show-toplevel)/.gitignore | \
    #   sed -e 's#/$##' -e 's/\./\\\./g' -e 's/\*/\.\*/g'
    dir=$(find . -mindepth 1 -regextype posix-extended \
      -not -regex '.*/(\.git|node_modules)(/.*)?$' \
      -type d -print 2> /dev/null | \
      cut -c3- | \
      fzf --no-multi --exit-0 --query="$arg_dir" --preview 'echo {} | xargs ls -FA1')
  fi

  if [ -n "$dir" ]; then
    if builtin cd "$dir"; then
      [ ! -d "$(__xd_log_dir)" ] && mkdir -p "$(__xd_log_dir)"
      local logfile tmpfile loglines
      logfile="$(__xd_log_file)"
      tmpfile="${logfile}.tmp"
      loglines="$(__xd_log_lines)"
      echo "$PWD" >> "$tmpfile"
      grep -v -e "^${PWD}\$" "$logfile" >> "$tmpfile"
      head -n "$loglines" "$tmpfile" > "$logfile"
      [ -f "$tmpfile" ] && rm -f "$tmpfile"
    fi
  fi
}

__xd_tab_helper() {
  local out cmd dir
  out=$(eval "$1" | nl -w3 -s': ' | \
    fzf --no-multi --select-1 --query="${*:2}" \
    --preview 'echo {} | cut -c6- | xargs ls -FA1' \
    --header 'Enter to cd, Tab to cd and xd' \
    --expect=tab)
  cmd="$(echo "$out" | head -1)"
  dir="$(echo "$out" | tail -1 | cut -c6- )"
  if [ -n "$dir" ]; then
    if xd "$dir" && [ "$cmd" = 'tab' ]; then
      echo "xd from $PWD"
      xd
    else
      :
    fi
  fi
}

xdd() {
  local parent
  parent=$(dirname "$PWD")
  local dirs="$parent"
  while [ "$parent" != '/' ]; do
    parent=$(dirname "$parent")
    dirs="${dirs}\n${parent}"
  done
  __xd_tab_helper "echo -e '$dirs'" "$@"
}

xdr() {
  local logfile loglines
  logfile="$(__xd_log_file)"
  loglines="$(__xd_log_lines)"
  [ ! -f "$logfile" ] && return
  __xd_tab_helper "tail -n $loglines $logfile | grep -v -e '^${PWD}\$'" "$@"
}
