#!/usr/bin/env python3
"""Replace the content inside the module usage markers within a README."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

BEGIN_MARKER = "<!-- BEGIN_MODULE_USAGE -->"
END_MARKER = "<!-- END_MODULE_USAGE -->"


def main() -> int:
    parser = argparse.ArgumentParser(description="Replace Usage block content in a README")
    parser.add_argument("readme", type=Path, help="Path to README.md")
    parser.add_argument("content_file", type=Path, help="File containing the new Usage block content")
    args = parser.parse_args()

    readme_path = args.readme
    content_path = args.content_file

    if not readme_path.exists():
        raise SystemExit(f"README not found: {readme_path}")
    if not content_path.exists():
        raise SystemExit(f"Content file not found: {content_path}")

    text = readme_path.read_text(encoding="utf-8")
    begin_idx = text.find(BEGIN_MARKER)
    if begin_idx == -1:
        raise SystemExit(f"{BEGIN_MARKER} not found in {readme_path}")
    end_idx = text.find(END_MARKER, begin_idx)
    if end_idx == -1:
        raise SystemExit(f"{END_MARKER} not found in {readme_path}")

    after_end_idx = end_idx + len(END_MARKER)
    before = text[:begin_idx]
    after = text[after_end_idx:]

    content_raw = content_path.read_text(encoding="utf-8")
    replacement_body = content_raw.strip("\n")
    if replacement_body:
        new_block = f"{BEGIN_MARKER}\n{replacement_body}\n{END_MARKER}"
    else:
        new_block = f"{BEGIN_MARKER}\n{END_MARKER}"

    new_text = before + new_block + after
    readme_path.write_text(new_text, encoding="utf-8")
    print(f"[UPDATED] Replaced Usage block in {readme_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
