#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = ["langcodes"]
# ///
"""Resolve language names and tags using langcodes."""

import argparse
import sys

from langcodes import Language, standardize_tag, tag_is_valid, find


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", nargs="+", help="Language tag or English name")
    args = parser.parse_args(argv)

    query = " ".join(args.query).strip()
    if not query:
        parser.error("Expected a non-empty query")

    try:
        if tag_is_valid(query):
            lang = Language.get(query)
            print(lang.display_name())
        else:
            lang = find(query)
            print(f"{standardize_tag(lang)}: {lang.describe()}")
        return 0
    except Exception as exc:  # pragma: no cover - simple CLI
        print(f"langcodes: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
