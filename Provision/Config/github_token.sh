response=$(gh api --method POST -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" repos/$1/$2/actions/runners/registration-token)
echo "$response" | sed -n 's/.*"token":"\([^"]*\)".*/\1/p'