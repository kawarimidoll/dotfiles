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

curl -sS https://github.com/users/${VAR_USERNAME}/contributions | \
  grep 'data-date' | \
  tail -7 | \
  sed -r 's/.+count="([0-9]+)".+date="([0-9\-]+)".+/\2: \1/' | \
  awk '{
    if ($2 == 0) print ":fallen_leaf:", $0, "| color=brown";
    else if ($2 < 5) print ":seedling:", $0, "| color=green";
    else if ($2 < 10) print ":herb:", $0, "| color=green";
    else print ":evergreen_tree:", $0, "| color=green";
    }' | \
  sed '1!G;h;$!d' | \
  sed -e '1a\'$'\n''---'
echo '---'
echo "Open GitHub | href=https://github.com/${VAR_USERNAME}"

# tac with sed: https://stackoverflow.com/questions/742466/how-can-i-reverse-the-order-of-lines-in-a-file
# insert on mac sed: https://unix.stackexchange.com/questions/52131/sed-on-osx-insert-at-a-certain-line
