#!/usr/bin/env python3
"""Parse variables.tf and detect whether each variable has a default value."""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

VARIABLE_PATTERN = re.compile(r'^\s*variable\s+"([^"]+)"\s*{', re.MULTILINE)


def extract_block(text: str, start_index: int) -> tuple[str, int]:
    """Return the block text and the position just after the block."""
    depth = 0
    block_start = start_index + 1
    for idx in range(start_index, len(text)):
        char = text[idx]
        if char == '{':
            depth += 1
            if depth == 1:
                block_start = idx + 1
        elif char == '}':
            if depth == 0:
                # unmatched brace, treat as finished
                return text[start_index + 1 : idx], idx + 1
            depth -= 1
            if depth == 0:
                return text[block_start:idx], idx + 1
    return text[start_index + 1 :], len(text)


def find_variable_defaults(content: str) -> dict[str, bool]:
    result: dict[str, bool] = {}
    for match in VARIABLE_PATTERN.finditer(content):
        name = match.group(1)
        brace_idx = match.end() - 1
        block_text, _ = extract_block(content, brace_idx)
        has_default = False
        for line in block_text.splitlines():
            stripped = line.lstrip()
            if stripped.startswith('default') and '=' in stripped:
                has_default = True
                break
        result[name] = has_default
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Parse variables defaults from a Terraform variables file")
    parser.add_argument("variables_file", type=Path, help="Path to variables.tf")
    args = parser.parse_args()

    path = args.variables_file
    if not path.exists():
        print("{}")
        return 0

    content = path.read_text(encoding="utf-8")
    defaults = find_variable_defaults(content)
    json.dump(defaults, sys.stdout, indent=2, sort_keys=True)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
