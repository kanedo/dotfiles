# -----------------------------------------------------------------------------
# Parquet REPL - Load parquet files into an interactive Python REPL with Polars
# Uses uv with inline dependencies for zero-config setup
# -----------------------------------------------------------------------------

parquet-repl() {
    if [[ -z "$1" ]]; then
        echo "Usage: pls <parquet_file> [variable_name]"
        echo "  parquet_file: Path to the parquet file to load"
        echo "  variable_name: Name of the DataFrame variable (default: df)"
        return 1
    fi

    local parquet_file="$1"
    local var_name="${2:-df}"

    if [[ ! -f "$parquet_file" ]]; then
        echo "Error: File not found: $parquet_file"
        return 1
    fi

    # Get absolute path
    local abs_path
    abs_path="$(cd "$(dirname "$parquet_file")" && pwd)/$(basename "$parquet_file")"

    echo "Loading $abs_path into '$var_name'..."

    uv run --quiet --with polars --with ipython ipython -i -c "
import polars as pl

# Disable table truncation
pl.Config.set_tbl_rows(-1)
pl.Config.set_tbl_cols(-1)
pl.Config.set_fmt_str_lengths(1000)

${var_name} = pl.scan_parquet('${abs_path}')
print(f'Loaded LazyFrame with {len(${var_name}.collect_schema())} columns into \"${var_name}\"')
print()
print(${var_name}.head().collect())
print()
print('Available: pl (polars), ${var_name} (LazyFrame)')
"
}

# Alias for convenience
alias pls='parquet-repl'
