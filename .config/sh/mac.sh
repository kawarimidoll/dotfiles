# -----------------
#  settings.sh for mac
# -----------------

# if running zsh
if [ -n "$ZSH_VERSION" ]; then

  if [ -f "/opt/homebrew/bin/brew" ]; then
    # apple silicon
    if [ ! -f /tmp/zsh_brew.cache ]; then
      /opt/homebrew/bin/brew shellenv > /tmp/zsh_brew.cache
      zcompile /tmp/zsh_brew.cache
    fi
    # eval $(/opt/homebrew/bin/brew shellenv)
    BREW_PREFIX="/opt/homebrew"
    alias nnn="nnn-apple-silicon"

    if [ ! -f /tmp/zsh_fnm.cache ]; then
      /opt/homebrew/bin/fnm env > /tmp/zsh_fnm.cache
      zcompile /tmp/zsh_fnm.cache
    fi
  else
    # intel chip
    if [ ! -f /tmp/zsh_brew.cache ]; then
      /usr/local/bin/brew shellenv > /tmp/zsh_brew.cache
      zcompile /tmp/zsh_brew.cache
    fi
    # eval $(/usr/local/bin/brew shellenv)
    BREW_PREFIX="/usr/local"
    alias nnn="nnn-intel-chip"

    if [ ! -f /tmp/zsh_fnm.cache ]; then
      /usr/local/bin/fnm env > /tmp/zsh_fnm.cache
      zcompile /tmp/zsh_fnm.cache
    fi
  fi
  source /tmp/zsh_brew.cache
  source /tmp/zsh_fnm.cache

  __source "${BREW_PREFIX}/share/zsh-autopair/autopair.zsh"
  __source "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  __source "${BREW_PREFIX}/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

  # zsh-autocomplete
  # Installation
  # 1. Add at or near the top of your .zshrc file (before any calls to compdef):
  #   source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
  # 2. Remove any calls to compinit from your .zshrc file.
  # 3. If you're using Ubuntu, add to your .zshenv file:
  #   skip_global_compinit=1
  # Then restart your shell.
  # For more details, see:
  #   https://github.com/marlonrichert/zsh-autocomplete

  __add_fpath "${BREW_PREFIX}/share/zsh-completions"
  __add_fpath "${BREW_PREFIX}/share/zsh/site-functions"
  __add_fpath "${BREW_PREFIX}/opt/curl/share/zsh/site-functions"

  alias -g NOTIFY="&& notify"
  # alias -g NOTIFY="&& osascript -e 'display notification \"Done!\" with title \"Terminal\"'"
fi

# https://techracho.bpsinc.jp/hachi8833/2022_12_02/124761
export MAKEFLAGS="--jobs $(sysctl -n hw.ncpu)"
export RUBY_CONFIGURE_OPTS="--disable-install-doc --disable-install-rdoc"

# export HOMEBREW_UPDATE_REPORT_ALL_FORMULAE=1
export OBSIDIAN_VAULT="${HOME}/Dropbox/Obsidian"

alias brewer="sh ${DOT_OS_DIR}/brewer.sh"
alias cob="cd ${OBSIDIAN_VAULT}"
alias ds_store_all_delete="find . -name '.DS_Store' -type f -delete"
alias notify="osascript -e 'display notification \"Done!\" with title \"Terminal\"'"

PATH="${BREW_PREFIX}/bin:$PATH"
PATH="${BREW_PREFIX}/sbin:$PATH"

# Define PATH to coreutils/findutils by using symlinks to avoid brew warnings
# This may cause error on building gmp/python
PATH="${DOT_OS_DIR}/symlinks/core_gnubin:$PATH"
PATH="${DOT_OS_DIR}/symlinks/find_gnubin:$PATH"

PATH="${BREW_PREFIX}/opt/binutils/bin:$PATH"
# PATH="${BREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/ed/bin:$PATH"
PATH="${BREW_PREFIX}/opt/ed/libexec/gnubin:$PATH"
# PATH="${BREW_PREFIX}/opt/findutils/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/grep/libexec/gnubin:$PATH"
PATH="${BREW_PREFIX}/opt/unzip/bin:$PATH"
PATH="${BREW_PREFIX}/opt/curl/bin:$PATH"

export LDFLAGS="-L${BREW_PREFIX}/opt/binutils/lib -L${BREW_PREFIX}/opt/curl/lib"
export CPPFLAGS="-I${BREW_PREFIX}/opt/binutils/include -I${BREW_PREFIX}/opt/curl/include"

MANPATH="${BREW_PREFIX}/opt/coreutils/libexec/gnuman:$MANPATH"
MANPATH="${BREW_PREFIX}/opt/ed/libexec/gnuman:$MANPATH"
MANPATH="${BREW_PREFIX}/opt/findutils/libexec/gnuman:$MANPATH"
MANPATH="${BREW_PREFIX}/opt/gnu-sed/libexec/gnuman:$MANPATH"
MANPATH="${BREW_PREFIX}/opt/gnu-tar/libexec/gnuman:$MANPATH"
MANPATH="${BREW_PREFIX}/opt/grep/libexec/gnuman:$MANPATH"

export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/curl/lib/pkgconfig"

# -----------------
# mise
# -----------------
eval "$(/opt/homebrew/bin/mise activate zsh)"
