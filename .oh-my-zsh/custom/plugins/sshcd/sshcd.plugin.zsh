# sshcd plugin: ssh into a host and start an interactive login shell in a
# specific directory. All args except the last are passed through to ssh,
# so flags like -i, -p, -L, -J, etc. work as usual.
#
# Usage: sshcd [ssh-opts] destination path

sshcd() {
  if (( $# < 2 )); then
    echo "Usage: sshcd [ssh-opts] destination path" >&2
    return 1
  fi
  local cwd=${@[-1]}
  ssh -t "${@[1,-2]}" "cd ${(q)cwd} && exec \$SHELL -il"
}
