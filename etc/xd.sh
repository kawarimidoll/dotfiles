# -----------------
#  xd - extended cd
# -----------------

alias xdf='xd $OLDPWD'

xd() {
  local arg_dir="${@: -1}"
  [ -d "$arg_dir" ] && cd "$arg_dir"
  local dir=$(find -mindepth 1 -path '*/\.*' -prune -o -type d -print 2> /dev/null | \
    cut -c3- | \
    fzf --no-multi --exit-0 --query="$arg_dir" --preview "echo {} | xargs ls -FA1")
  [ -n "$dir" ] && cd "$dir"
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
  [ -n "$dir" ] && cd $(echo "$dir" | awk '{print $2}')
  [ "$cmd" = 'tab' ] && xd
}
