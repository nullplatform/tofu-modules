#!/usr/bin/env bash
set -euo pipefail

# Every module that has tests must be listed in the test workflow, which names its
# modules by hand. A module left out has tests that never run.
#
# Usage: check-test-coverage.sh   (from anywhere inside the repository)

cd "$(git rev-parse --show-toplevel)"

WORKFLOW=".github/workflows/tofu-test.yml"

with_tests="$(git ls-files '*.tftest.hcl' | sed -E 's#/[^/]+$##; s#/tests$##' | sort -u)"
listed_all="$(grep -E "^[[:space:]]*modules:" "$WORKFLOW" | grep -oE '"[^"]+"' | tr -d '"' | sort)"
listed="$(printf '%s\n' "$listed_all" | sort -u)"

missing="$(comm -23 <(printf '%s\n' "$with_tests") <(printf '%s\n' "$listed"))"
stale="$(comm -13 <(printf '%s\n' "$with_tests") <(printf '%s\n' "$listed"))"
repeated="$(printf '%s\n' "$listed_all" | uniq -d)"

FAILED=0

report() {
  [ -n "$2" ] || return 0
  printf '%s\n' "$1" >&2
  printf '%s\n' "$2" | sed 's/^/  /' >&2
  FAILED=1
}

report "Modules with tests that $WORKFLOW never runs. Add each to a job's modules list:" "$missing"
report "Modules listed in $WORKFLOW that have no tests. Remove them, or add tests:" "$stale"
report "Modules listed more than once in $WORKFLOW:" "$repeated"

exit $FAILED
