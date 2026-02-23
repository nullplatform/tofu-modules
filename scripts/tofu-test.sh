#!/usr/bin/env bash
set -euo pipefail

# Finds modules with tests affected by changed files and runs tofu test.
# Usage: tofu-test.sh <file1> <file2> ...

MODULE_DIRS=""

for file in "$@"; do
  dir="$file"
  while [ "$dir" != "." ] && [ "$dir" != "/" ]; do
    dir=$(dirname "$dir")
    if ls "$dir"/tests/*.tftest.hcl &>/dev/null; then
      case "$MODULE_DIRS" in
        *"|${dir}|"*) ;;
        *) MODULE_DIRS="${MODULE_DIRS}|${dir}|" ;;
      esac
      break
    fi
  done
done

if [ -z "$MODULE_DIRS" ]; then
  exit 0
fi

FAILED=0

for module_dir in $(echo "$MODULE_DIRS" | tr '|' '\n' | sort -u); do
  [ -z "$module_dir" ] && continue
  echo "==> Running tofu test in ${module_dir}"
  if ! (cd "$module_dir" && tofu init -backend=false -lockfile=readonly &>/dev/null && tofu test); then
    FAILED=1
  fi
done

exit $FAILED
