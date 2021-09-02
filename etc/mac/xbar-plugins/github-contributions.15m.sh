#!/bin/bash

# Metadata:
# <xbar.title>github-contributions</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>kawarimidoll</xbar.author>
# <xbar.author.github>kawarimidoll</xbar.author.github>
# <xbar.desc>Show github contributions of today.</xbar.desc>
# <xbar.image></xbar.image>
# <xbar.dependencies>curl,jq(homebrew)</xbar.dependencies>

# Variables:
# <xbar.var>string(VAR_USERNAME="kawarimidoll"): Your github username.</xbar.var>

curl -sS "https://github-contributions-api.deno.dev/${VAR_USERNAME}.json?flat=true" | \
  /opt/homebrew/bin/jq -r '.contributions[-7:] | map(
      (
        if .contributionLevel == "NONE" then ":fallen_leaf:"
        elif .contributionLevel == "FIRST_QUARTILE" then ":seedling:"
        elif .contributionLevel == "SECOND_QUARTILE" then ":leaves:"
        elif .contributionLevel == "THIRD_QUARTILE" then ":herb:"
        else ":evergreen_tree:" end
      ) + .date + ": " +
      (.contributionCount | tostring) + " | color=" +
      (if .contributionLevel == "NONE" then "brown" else "green" end)
    ) | .[]' | \
  sed '1!G;h;$!d' | \
  sed -e '1a\'$'\n''---'
echo '---'
echo "Open GitHub | href=https://github.com/${VAR_USERNAME}"

# [jq not working · Issue #732 · matryer/xbar](https://github.com/matryer/xbar/issues/732)
# tac with sed: https://stackoverflow.com/questions/742466/how-can-i-reverse-the-order-of-lines-in-a-file
# insert on mac sed: https://unix.stackexchange.com/questions/52131/sed-on-osx-insert-at-a-certain-line
