#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = ["langcodes"]
# ///
"""Resolve language names and tags using langcodes."""

import argparse
import sys
from typing import Iterable

from langcodes import Language, find, standardize_tag, tag_is_valid


def _to_standard_tag(value: Language | str) -> str | None:
    """Return a standardized BCP 47 tag for ``value`` if possible."""

    if isinstance(value, Language):
        value = value.to_tag()
    try:
        return standardize_tag(value)
    except Exception:  # pragma: no cover - defensive, depends on langcodes internals
        return None


def _collect_related_codes(lang: Language, maximized: Language | None = None) -> list[str]:
    """Collect canonical and closely related language tags for ``lang``."""

    tags: list[str] = []
    seen: set[str] = set()

    def add(values: Iterable[str | Language]) -> None:
        for val in values:
            tag = _to_standard_tag(val)
            if tag and tag not in seen:
                seen.add(tag)
                tags.append(tag)

    add([lang])

    try:
        minimized = lang.minimize()
    except Exception:  # pragma: no cover - varies by lang tag completeness
        minimized = None
    if minimized:
        add([minimized])

    if maximized is None:
        try:
            maximized = lang.maximize()
        except Exception:  # pragma: no cover - maximize may fail for unusual tags
            maximized = None

    if maximized:
        add([maximized])

        base = getattr(maximized, "language", None) or None
        script = getattr(maximized, "script", None) or None
        territory = getattr(maximized, "territory", None) or None

        variants: list[str] = []
        for attr in ("variants", "variant"):
            value = getattr(maximized, attr, None)
            if not value:
                continue
            if isinstance(value, str):
                variants.append(value)
            else:
                variants.extend(str(item) for item in value if item)

        components: list[str] = []
        if base:
            components.append(base)
            if script:
                components.append(f"{base}-{script}")
            if territory:
                components.append(f"{base}-{territory}")
            if script and territory:
                components.append(f"{base}-{script}-{territory}")
            for variant in variants:
                components.append(f"{base}-{variant}")
                if script:
                    components.append(f"{base}-{script}-{variant}")
                if territory:
                    components.append(f"{base}-{territory}-{variant}")
                if script and territory:
                    components.append(f"{base}-{script}-{territory}-{variant}")

        add(components)

    primary = _to_standard_tag(lang)
    return [tag for tag in tags if tag and tag != primary]


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", nargs="+", help="Language tag or English name")
    parser.add_argument(
        "-s",
        "--simple",
        action="store_true",
        help="Only show the primary result (legacy behaviour)",
    )
    args = parser.parse_args(argv)

    query = " ".join(args.query).strip()
    if not query:
        parser.error("Expected a non-empty query")

    try:
        if tag_is_valid(query):
            lang = Language.get(query)
            if args.simple:
                print(lang.display_name())
                return 0
        else:
            lang = find(query)
            if args.simple:
                print(f"{standardize_tag(lang)}: {lang.describe()}")
                return 0

        tag = _to_standard_tag(lang) or query
        description = lang.describe()

        print(f"Tag: {tag}")
        print(f"Name: {description}")

        try:
            maximized = lang.maximize()
        except Exception:  # pragma: no cover - maximize may fail for incomplete tags
            maximized = None

        likely_script = getattr(maximized, "script", None) or "Unknown"
        print(f"Likely script: {likely_script}")

        related = _collect_related_codes(lang, maximized=maximized)
        if related:
            print("Identical or near-identical codes:")
            for code in related:
                print(f"  - {code}")
        return 0
    except Exception as exc:  # pragma: no cover - simple CLI
        print(f"langcodes: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
