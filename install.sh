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

if has "git"; then
  git clone --recursive "$GITHUB_URL" "$DOTDIR"
elif has "curl" || has "wget"; then
  TARBALL_URL="${GITHUB_URL}/archive/master.tar.gz"
  if has "curl"; then
    curl -L "$TARBALL_URL"
  else
    wget -O - "$TARBALL_URL"
  fi | tar xv
  mv -f dotfiles-master "$DOTDIR"
else
  die "cannot download dotfiles."
fi

cd "$DOTDIR"
if [ $? -ne 0 ]; then
  die "cannot cd to $DOTDIR"
fi

for f in .??*
do
  [ "$f" = ".git" ] && continue
  [ "$f" = ".gitconfig" ] && continue

  ln -snfv "$DOTDIR/$f" "$HOME/$f"
done

echo "finished."
