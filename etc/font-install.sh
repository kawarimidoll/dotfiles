#!/bin/bash -eux

if ! type jq >/dev/null 2>&1; then
  echo 'jq is required.'
  exit 1
elif ! type unzip >/dev/null 2>&1; then
  echo 'unzip is required.'
  exit 1
fi

browser_download_url="$(curl -sS https://api.github.com/repos/yuru7/PlemolJP/releases/latest | \
    jq -r '.assets[] | select(.name | startswith("PlemolJP_NF")) | .browser_download_url')"

if [[ -z "$browser_download_url" ]]; then
  echo 'browser_download_url does not exist'
  exit 1
fi

echo "download $browser_download_url"
curl -sSLO "$browser_download_url"
archive=${browser_download_url##*/}
opened=${archive%.zip}
unzip $archive
mkdir -p ~/LibraryFonts
mv "${opened}/**/*.ttf" ~/LibraryFonts
rm -rf $opened
rm -f $archive
