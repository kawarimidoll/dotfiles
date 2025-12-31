# -----------------
#  settings.sh for mac
# -----------------

# export HOMEBREW_UPDATE_REPORT_ALL_FORMULAE=1
export OBSIDIAN_VAULT="${HOME}/Dropbox/Obsidian"

alias brewer="sh ${DOT_DIR}/etc/mac/brewer.sh"
alias cob="cd ${OBSIDIAN_VAULT}"
alias ds_store_all_delete="find . -name '.DS_Store' -type f -delete"
alias notify="osascript -e 'display notification \"Done!\" with title \"Terminal\"'"

PATH="${HOME}/.nix-profile/bin:$PATH"
