# slurm plugin: personal tooling for Slurm clusters. Scripts live in bin/ and
# are put on PATH. Only enabled from .zshrc when squeue is available.
#
# Commands:
#   qu  squeue wrapper with a wider job-name column (qu -h for options)

path=("${0:A:h}/bin" $path)
