alias ll='ls -la'
alias lh='ls -lah'
alias ...='cd ../..'

alias gs='git status'
alias gc='git commit'
alias ga='git add'

function man-preview() {
  man -t "$@" | open -f -a Preview
}
