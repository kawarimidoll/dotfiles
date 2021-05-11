#!/bin/bash

# Metadata:
# <xbar.title>github-contributions</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>kawarimidoll</xbar.author>
# <xbar.author.github>kawarimidoll</xbar.author.github>
# <xbar.desc>Show github contributions of today.</xbar.desc>
# <xbar.image></xbar.image>
# <xbar.dependencies>curl</xbar.dependencies>

# Variables:
# <xbar.var>string(VAR_USERNAME="kawarimidoll"): Your github username.</xbar.var>

# week=$(curl -sS https://github.com/users/${VAR_USERNAME}/contributions | \
#   grep 'data-date' | \
#   sed -r 's/.+count="([0-9]+)".+date="([0-9\-]+)".+/\2: \1/' | \
#   tail -7 | \
#   tac
# )

# cat $week | head -1 | sed 's/.*: /today: /'
# echo '---'
# echo -e $week

curl -sS "https://github.com/users/${VAR_USERNAME}/contributions" | \
  grep 'data-date' | \
  sed -r 's/.+count="([0-9]+)".+/\1/' | \
  tail -1 | \
  xargs -I_ sh -c 'if [[ "_" == 0 ]]; then echo ":poop: 0 | color=brown"; else echo ":seedling: _ | color=green"; fi'
echo '---'
echo "Open GitHub | href=https://github.com/${VAR_USERNAME}"
