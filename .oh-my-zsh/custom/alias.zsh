alias isort-branch="git diff --name-only main... | xargs isort"
alias nvimdiff="nvim -d"

# Print last commit hash and copy to clipboard when pbcopy is available.
glc() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not inside a git repository." >&2
    return 1
  fi

  local hash
  hash="$(git rev-parse HEAD)" || return 1
  echo "$hash"

  if command -v pbcopy >/dev/null 2>&1; then
    printf "%s" "$hash" | pbcopy
  fi
}
