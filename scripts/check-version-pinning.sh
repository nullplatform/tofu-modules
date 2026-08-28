#!/usr/bin/env bash
set -euo pipefail

# Rejects a new moving version reference. See VERSIONS.md.
#
# Usage: check-version-pinning.sh <file1> <file2> ...

BASELINE="$(dirname "$0")/version-pinning-baseline.txt"
FAILED=0

baselined() {
  [ -f "$BASELINE" ] || return 1
  grep -qxF "$1" <(grep -v '^[[:space:]]*#' "$BASELINE" | grep -v '^[[:space:]]*$') 2>/dev/null
}

for file in "$@"; do
  [ -f "$file" ] || continue
  case "$file" in
    */.terraform/*|*/.terragrunt-cache/*) continue ;;
    *.tf) ;;
    *) continue ;;
  esac

  while IFS='|' read -r key message; do
    [ -n "$key" ] || continue
    if baselined "$key"; then
      continue
    fi
    printf '  %s\n    %s\n' "$key" "$message" >&2
    FAILED=1
  done < <(
    awk -v F="$file" '
      function emit(key, msg) { print F ":" key "|" msg }

      /^variable[[:space:]]+"/ {
        match($0, /"[^"]+"/)
        vname = substr($0, RSTART + 1, RLENGTH - 2)
        invar = 1; next
      }
      invar && /^}/ { invar = 0; vname = ""; next }

      invar && $0 ~ /^[[:space:]]*default[[:space:]]*=[[:space:]]*"(latest|main|master|HEAD)"[[:space:]]*$/ {
        emit(vname, "defaults to a moving reference. Pin it, or drop the default so the caller has to pin it.")
        next
      }
      invar && $0 ~ /^[[:space:]]*default[[:space:]]*=[[:space:]]*".*#(latest|main|master|HEAD)"[[:space:]]*$/ {
        emit(vname, "default pins a git ref to a moving branch. Expose the ref as its own variable without a default.")
        next
      }
      invar && $0 ~ /^[[:space:]]*default[[:space:]]*=[[:space:]]*".*\/refs\/heads"?[[:space:]]*$/ {
        emit(vname, "default hardcodes refs/heads, so a caller cannot pin to a tag without also rewriting the URL. Expose the ref namespace as a variable.")
        next
      }

      /^resource[[:space:]]+"helm_release"[[:space:]]+"/ {
        n = $0
        sub(/^resource[[:space:]]+"helm_release"[[:space:]]+"/, "", n)
        sub(/".*$/, "", n)
        rname = n; inres = 1; hasver = 0; next
      }
      inres && $0 ~ /^[[:space:]]+version[[:space:]]*=/ { hasver = 1; next }
      inres && /^}/ {
        if (!hasver) {
          emit("helm_release." rname, "has no version argument, so Helm resolves whatever the chart repository serves at apply time with no diff to review. Add version = var.<something>.")
        }
        inres = 0; next
      }
    ' "$file"
  )
done

if [ "$FAILED" -ne 0 ]; then
  {
    echo ""
    echo "Version pinning check failed."
    echo "Fix the finding, or -- if the fix is deliberately deferred -- add the key to"
    echo "scripts/version-pinning-baseline.txt with a comment saying why and where it is tracked."
  } >&2
fi

exit $FAILED
