alias ll='ls -la'
alias lh='ls -lah'
alias ...='cd ../..'

alias gs='git status'
compdef _git gs=git-status
alias gc='git commit'
compdef _git gc=git-commit
alias ga='git add'
compdef _git ga=git-add

function man-preview() {
  man -t "$@" | open -f -a Preview
}
