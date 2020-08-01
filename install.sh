#!/bin/bash

# ref:
# https://qiita.com/b4b4r07/items/24872cdcbec964ce2178

DOTDIR="${HOME}/dotfiles"
GITHUB_URL="https://github.com/kawarimidoll/dotfiles"

has() {
  type "$1" > /dev/null 2>&1
}
die() {
  echo "$1"
  exit 1
}

# download
if [ -d "$DOTDIR" ]; then
  echo "$DOTDIR is already exist"
else
  if has "git"; then
    git clone --recursive "$GITHUB_URL" "$DOTDIR"
  elif has "curl" || has "wget"; then
    local tarball_url="${GITHUB_URL}/archive/master.tar.gz"
    if has "curl"; then
      curl -L "$tarball_url"
    else
      wget -O - "$tarball_url"
      fi | tar xv
      mv -f dotfiles-master "$DOTDIR"
    else
      die "cannot download dotfiles."
  fi
fi
# download

# deploy
cd "$DOTDIR"
if [ $? -ne 0 ]; then
  die "cannot cd to $DOTDIR"
fi

for f in .??*
do
  [ "$f" = ".git" ] && continue
  [ "$f" = ".DS_Store" ] && continue

  ln -snfv "$DOTDIR/$f" "$HOME/$f"
done
# deploy

echo "finished."
