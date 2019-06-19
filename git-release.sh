#works to ssh & http link
#https://github.community/t5/How-to-use-Git-and-GitHub/How-to-create-full-release-from-command-line-not-just-a-tag/td-p/6895

version=$1
text=$2
branch=$(git rev-parse --abbrev-ref HEAD)
repo_full_name=$(git config --get remote.origin.url | sed 's/.*:\/\/github.com\///;s/.git$//')
# stored token
token=$(git config --global github.token)

generate_post_data()
{
  cat <<EOF
  {
    "tag_name": "$version",
    "target_commitish": "$branch",
    "name": "$version",
    "body": "$text",
    "draft": false,
    "prerelease": false
  }
EOF
}

echo "Create release $version for repo: $repo_full_name branch: $branch"
curl --data "$(generate_post_data)" "https://api.github.com/repos/$repo_full_name/releases?access_token=$token"
