# sis-clear-error plugin: find error files in a directory and remove
# matching error, log, and usage files by extracted ID.

sis-clear-error() {
  local force=0
  local dir=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--force) force=1; shift ;;
      -h|--help)
        echo "Usage: sis-clear-error [-f|--force] <directory>"
        echo ""
        echo "Find error.* files in <directory>, extract their IDs, and remove"
        echo "the corresponding error.*, log.*, and usage.* files."
        echo ""
        echo "Options:"
        echo "  -f, --force   Skip confirmation prompt"
        echo "  -h, --help    Show this help message"
        return 0
        ;;
      *)
        if [[ -z "$dir" ]]; then
          dir="$1"
        else
          echo "Error: unexpected argument '$1'" >&2
          return 1
        fi
        shift
        ;;
    esac
  done

  if [[ -z "$dir" ]]; then
    echo "Usage: sis-clear-error [-f|--force] <directory>" >&2
    return 1
  fi

  if [[ ! -d "$dir" ]]; then
    echo "Error: '$dir' is not a directory" >&2
    return 1
  fi

  # Find error files and extract IDs (the part after the last dot)
  local -a error_files
  error_files=("$dir"/error.*(N))

  if [[ ${#error_files[@]} -eq 0 ]]; then
    echo "No error files found in $dir"
    return 0
  fi

  # Extract IDs from error filenames
  local -a ids
  for f in "${error_files[@]}"; do
    local basename="${f:t}"
    # Get everything after "error." prefix
    local prefix="error."
    local id="${basename#${prefix}}"
    # Extract the last dot-separated segment as the ID
    id="${id##*.}"
    ids+=("$id")
  done

  # Remove duplicates
  ids=(${(u)ids})

  # Build list of files to remove
  local -a to_remove
  for id in "${ids[@]}"; do
    for prefix in error log usage; do
      for f in "$dir"/${prefix}.*."${id}"(N); do
        to_remove+=("$f")
      done
    done
  done

  if [[ ${#to_remove[@]} -eq 0 ]]; then
    echo "No matching files found to remove."
    return 0
  fi

  echo "Files to remove (${#to_remove[@]}):"
  for f in "${to_remove[@]}"; do
    echo "  $f"
  done

  if [[ $force -eq 0 ]]; then
    echo ""
    echo -n "Proceed with deletion? [y/N] "
    read -r answer
    if [[ "$answer" != [yY] ]]; then
      echo "Aborted."
      return 0
    fi
  fi

  rm -- "${to_remove[@]}"
  echo "Removed ${#to_remove[@]} files."
}
