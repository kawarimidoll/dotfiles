# -----------------
#  settings.sh for mac
# -----------------

BREW_PREFIX="/opt/homebrew"

# if running zsh
if [ -n "$ZSH_VERSION" ]; then
  # apple silicon
  if [ ! -f /tmp/zsh_brew.cache ]; then
    /opt/homebrew/bin/brew shellenv > /tmp/zsh_brew.cache
    zcompile /tmp/zsh_brew.cache
  fi
  # eval $(/opt/homebrew/bin/brew shellenv)
  source /tmp/zsh_brew.cache

  alias -g NOTIFY="&& notify"
fi

# export HOMEBREW_UPDATE_REPORT_ALL_FORMULAE=1
export OBSIDIAN_VAULT="${HOME}/Dropbox/Obsidian"

alias brewer="sh ${DOT_OS_DIR}/brewer.sh"
alias cob="cd ${OBSIDIAN_VAULT}"
alias ds_store_all_delete="find . -name '.DS_Store' -type f -delete"
alias notify="osascript -e 'display notification \"Done!\" with title \"Terminal\"'"

PATH="${BREW_PREFIX}/bin:$PATH"
PATH="${BREW_PREFIX}/sbin:$PATH"

PATH="${HOME}/.nix-profile/bin:$PATH"
