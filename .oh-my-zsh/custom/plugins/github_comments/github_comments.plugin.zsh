gh_comments() {
  # Usage: get_pr_comments <owner/repo> <pr_number> [user]
  local repo="$1"
  local pr_number="$2"
  local gh_user="$3"
  gh_bin="$(which -a gh | rg bin)"

  # Validate required arguments
  if [ -z "$repo" ] || [ -z "$pr_number" ]; then
    echo "Usage: get_pr_comments <owner/repo> <pr_number> [user]"
    echo "Example: get_pr_comments facebook/react 12345"
    echo "Example: get_pr_comments facebook/react 12345 johndoe"
    return 1
  fi

  # Build jq filter based on whether user is specified
  local jq_filter
  if [ -n "$gh_user" ]; then
    jq_filter='[ .[] | select(.user.type == "User" and .user.login == $user) | { user: .user.login, diff_hunk, line, start_line, body } ]'
  else
    jq_filter='[ .[] | select(.user.type == "User") | { user: .user.login, diff_hunk, line, start_line, body } ]'
  fi

  # Execute API call with appropriate filter
  if [ -n "$gh_user" ]; then
    ${gh_bin} api "repos/$repo/pulls/$pr_number/comments" | \
      jq --arg user "$gh_user" "$jq_filter"
  else
    ${gh_bin} api "repos/$repo/pulls/$pr_number/comments" | \
      jq "$jq_filter"
  fi
}

