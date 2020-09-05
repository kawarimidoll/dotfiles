# -----------------
#  xd - extended cd
# -----------------

XD_LOG_DIR="${HOME}/.kawarimidoll"
XD_LOG_LINES=10

alias xdf='xd $OLDPWD'

xd() {
  local arg_dir="${@: -1}" dir

  if [ -d "$arg_dir" ]; then
    dir="$arg_dir"
  else
    dir=$(find -mindepth 1 -path '*/\.*' -prune -o -type d -print 2> /dev/null | \
      cut -c3- | \
      fzf --no-multi --exit-0 --query="$arg_dir" --preview 'echo {} | xargs ls -FA1')
  fi

  if [ -n "$dir" ]; then
    builtin cd "$dir"

    if [ $? -eq 0 ]; then
      [ ! -d "$XD_LOG_DIR" ] && mkdir -p "$XD_LOG_DIR"
      local logfile="${XD_LOG_DIR}/xd.log"
      echo "$PWD" >> "${logfile}.tmp"
      grep -v -e "^${PWD}\$" "$logfile" >> "${logfile}.tmp"
      head -n "$XD_LOG_LINES" "${logfile}.tmp" > "$logfile"
      [ -f "${logfile}.tmp" ] && rm -f "${logfile}.tmp"
    fi
  fi
}

__xd_tab_helper() {
  local out=$(eval "$1" | nl -w3 -s": " | \
    fzf --no-multi --select-1 --query="${@:2}" \
    --preview 'echo {} | cut -c6- | xargs ls -FA1' \
    --header 'Enter to cd, Tab to cd and xd' \
    --expect=tab)
  local cmd="$(echo "$out" | head -1)"
  local dir="$(echo "$out" | tail -1 | cut -c6- )"
  if [ -n "$dir" ]; then
    xd "$dir"
    if [ $? -eq 0 -a "$cmd" = 'tab' ]; then
      echo "xd from $PWD"
      xd
    else
      :
    fi
  fi
}

xdd() {
  local parent=$(dirname "$PWD")
  local dirs="$parent"
  while [ "$parent" != "/" ]; do
    parent=$(dirname "$parent")
    dirs="${dirs}\n${parent}"
  done
  __xd_tab_helper "echo -e '$dirs'" "$@"
}

xdr() {
  local logfile="${XD_LOG_DIR}/xd.log"
  [ ! -f "$logfile" ] && return
  __xd_tab_helper "tail -n $XD_LOG_LINES $logfile | grep -v -e '^${PWD}\$'" "$@"
}
