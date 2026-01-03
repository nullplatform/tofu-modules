#!/usr/bin/env python3
"""Insert BEGIN/END markers around the Usage section of a README."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

BEGIN_MARKER = "<!-- BEGIN_MODULE_USAGE -->"
END_MARKER = "<!-- END_MODULE_USAGE -->"
USAGE_HEADER = "## Usage"
TF_DOCS_BEGIN = "<!-- BEGIN_TF_DOCS"


def find_usage_section(lines: list[str]) -> int | None:
    for idx, line in enumerate(lines):
        if line.strip() == USAGE_HEADER:
            return idx
    return None


def find_section_end(lines: list[str], usage_header_idx: int) -> int:
    """Return the line index that delimits the end of the Usage section."""
    for idx in range(usage_header_idx + 1, len(lines)):
        stripped = lines[idx].strip()
        if stripped.startswith(TF_DOCS_BEGIN):
            return idx
        if stripped.startswith("## "):
            return idx
        if stripped.startswith("# ") and not stripped.startswith(USAGE_HEADER):
            return idx
    return len(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Ensure Usage markers exist inside a README")
    parser.add_argument("readme", type=Path, help="Path to the README.md file")
    args = parser.parse_args()

    readme_path = args.readme
    if not readme_path.exists():
        print(f"[SKIP] README not found: {readme_path}")
        return 0

    text = readme_path.read_text(encoding="utf-8")
    if BEGIN_MARKER in text and END_MARKER in text:
        print(f"[OK] Markers already present in {readme_path}")
        return 0

    lines = text.splitlines()
    usage_header_idx = find_usage_section(lines)
    if usage_header_idx is None:
        print(f"[SKIP] '## Usage' not found in {readme_path}")
        return 0

    section_start = usage_header_idx + 1
    section_end = find_section_end(lines, usage_header_idx)

    before = lines[:section_start]
    section_lines = lines[section_start:section_end]
    after = lines[section_end:]

    new_lines: list[str] = []
    new_lines.extend(before)
    new_lines.append(BEGIN_MARKER)
    if section_lines:
        new_lines.extend(section_lines)
    else:
        new_lines.append("")
    new_lines.append(END_MARKER)
    new_lines.extend(after)

    new_content = "\n".join(new_lines)
    # Preserve trailing newline if original had it.
    if text.endswith("\n"):
        new_content += "\n"

    readme_path.write_text(new_content, encoding="utf-8")
    print(f"[UPDATED] Added Usage markers in {readme_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
