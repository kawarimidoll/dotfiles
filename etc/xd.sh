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
  local dirs="$parent"
  while [ "$parent" != "/" ]; do
    parent=$(dirname "$parent")
    dirs="${dirs}\n${parent}"
  done
  local out=$(echo -e "$dirs" | nl -w3 -s": " | \
    fzf --no-multi --select-1 --query="$@" \
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

xdr() {
  local logfile="${XD_LOG_DIR}/xd.log"
  [ ! -f "$logfile" ] && return
  local out=$(tail -n "$XD_LOG_LINES" "$logfile" | \
    grep -v -e "^${PWD}\$" | nl -w3 -s": " | \
    fzf --no-multi --exit-0 --query="$@" \
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
