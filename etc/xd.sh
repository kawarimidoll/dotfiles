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
    cd "$dir"

    if [ $? -eq 0 ]; then
      [ ! -d "$XD_LOG_DIR" ] && mkdir -p "$XD_LOG_DIR"
      local logfile="${XD_LOG_DIR}/xd.log"
      grep -v -e "^${PWD}\$" "$logfile" 1> "${logfile}.tmp1" 2> /dev/null
      echo "$PWD" >> "${logfile}.tmp1"
      tail -n "$XD_LOG_LINES" "${logfile}.tmp1" >> "${logfile}.tmp2"
      [ -f "${logfile}.tmp2" ] && mv -f "${logfile}.tmp2" "$logfile" 2> /dev/null
      [ -f "${logfile}.tmp1" ] && rm -f "${logfile}.tmp1" 2> /dev/null
    fi
  fi
}

xdd() {
  local parent=$(dirname "$PWD")
  local cnt=1
  local dirs="${cnt}: $parent"
  while [ "$parent" != "/" ]; do
    cnt=$((cnt+1))
    parent=$(dirname "$parent")
    dirs="${dirs}\n${cnt}: ${parent}"
  done
  local out=$(echo -e "$dirs" | \
    fzf --no-multi --select-1 --query="$@" \
    --preview "echo {} | awk '{print \$2}' | xargs ls -FA1" \
    --header 'Enter to cd, Tab to cd and xd' \
    --expect=tab)
  local cmd="$(echo "$out" | head -1)"
  local dir="$(echo "$out" | tail -1)"
  [ -n "$dir" ] && xd $(echo "$dir" | awk '{print $2}')
  [ "$cmd" = 'tab' ] && xd
}

xdr() {
  local logfile="${XD_LOG_DIR}/xd.log"
  [ ! -f "$logfile" ] && return
  local out=$(tail -n "$XD_LOG_LINES" "$logfile" | \
    grep -v -e "^${PWD}\$" | \
    fzf --no-multi --exit-0 --query="$@" \
    --preview "echo {} | xargs ls -FA1" \
    --header 'Enter to cd, Tab to cd and xd' \
    --expect=tab)
  local cmd="$(echo "$out" | head -1)"
  local dir="$(echo "$out" | tail -1)"
  [ -n "$dir" ] && xd "$dir"
  [ "$cmd" = 'tab' ] && xd
}
