# boulder-info plugin: print info file sibling to first output directory after work in a path.

boulder-info() {
  if [ $# -eq 0 ]; then
    echo "Usage: boulder-info <path>" >&2
    return 1
  fi

  local resolved
  if ! resolved="$(realpath "$1" 2>/dev/null)"; then
    echo "Failed to resolve path: $1" >&2
    return 1
  fi

  local target_dir=""
  local current=""
  local seen_work=0
  local -a segments

  segments=("${(@s:/:)${resolved#/}}")
  for segment in "${segments[@]}"; do
    [ -n "$segment" ] || continue
    current="$current/$segment"

    if [ "$segment" = "work" ]; then
      seen_work=1
      continue
    fi

    if [ "$segment" = "output" ] && [ $seen_work -eq 1 ]; then
      target_dir="$(dirname "$current")"
      break
    fi
  done

  if [ -z "$target_dir" ]; then
    echo "No output directory after a work directory found in: $resolved" >&2
    return 1
  fi

  local info_file="$target_dir/info"

  if [ ! -f "$info_file" ]; then
    echo "Info file not found: $info_file" >&2
    return 1
  fi

  echo ">>> ${info_file}"
  cat "$info_file"
}
