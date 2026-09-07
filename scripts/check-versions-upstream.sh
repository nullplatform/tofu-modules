#!/usr/bin/env bash
set -euo pipefail

# Reports upstream releases newer than the versions pinned in VERSIONS.md.
# Compares build dates for container images: a higher version number can be an
# older build (see the k8s-traffic-manager v2.0.2 trap in VERSIONS.md).
#
# Usage: check-versions-upstream.sh [--markdown] [--write]
#
# Exit 0 when every pin is current, 1 when something is behind or unreadable.

# VERSIONS_DOC lets CI run this script against a checkout of another ref, and
# lets a test point it at a fixture.
DOC="${VERSIONS_DOC:-$(dirname "$0")/../VERSIONS.md}"
MARKDOWN=0
WRITE=0

for arg in "$@"; do
  case "$arg" in
    --markdown) MARKDOWN=1 ;;
    --write) WRITE=1 ;;
    *) echo "unknown argument: $arg" >&2; exit 2 ;;
  esac
done

[ -f "$DOC" ] || { echo "VERSIONS.md not found at $DOC" >&2; exit 1; }

# component label in the table -> upstream source | hcl variables to rewrite
# A component with no variables listed is reported but never rewritten.
upstream_for() {
  case "$1" in
    '`nullplatform-base` chart')        echo 'gh-tag:nullplatform/helm-charts:nullplatform-base-' ;;
    '`nullplatform-agent` chart')       echo 'gh-tag:nullplatform/helm-charts:nullplatform-agent-' ;;
    '`cert-manager` chart')             echo 'gh-release:cert-manager/cert-manager' ;;
    '`prometheus` chart')               echo 'helm-index:https://prometheus-community.github.io/helm-charts/index.yaml:prometheus' ;;
    '`istio-base` chart')               echo 'helm-index:https://istio-release.storage.googleapis.com/charts/index.yaml:base' ;;
    '`istiod` chart')                   echo 'helm-index:https://istio-release.storage.googleapis.com/charts/index.yaml:istiod' ;;
    '`gateway-api` CRDs')               echo 'frozen:kubernetes-sigs/gateway-api' ;;
    '`k8s-logs-controller`')            echo 'ecr:nullplatform/k8s-logs-controller' ;;
    '`controlplane-agent`')             echo 'ecr:nullplatform/controlplane-agent' ;;
    '`k8s-traffic-manager`')            echo 'ecr:nullplatform/k8s-traffic-manager' ;;
    'traffic manager (provider config)') echo 'ecr:nullplatform/k8s-traffic-manager' ;;
    '`scopes` repository')              echo 'frozen:nullplatform/scopes' ;;
    *) echo '' ;;
  esac
}

hcl_vars_for() {
  case "$1" in
    '`nullplatform-base` chart')        echo 'nullplatform_base_helm_version' ;;
    '`nullplatform-agent` chart')       echo 'nullplatform_agent_helm_version' ;;
    '`cert-manager` chart')             echo 'cert_manager_version' ;;
    '`prometheus` chart')               echo 'prometheus_version' ;;
    '`istio-base` chart')               echo 'istio_base_version' ;;
    '`istiod` chart')                   echo 'istiod_version' ;;
    '`gateway-api` CRDs')               echo 'gateway_api_crd_ref' ;;
    '`k8s-logs-controller`')            echo 'logging_controller_image_tag' ;;
    '`controlplane-agent`')             echo 'control_plane_agent_image_tag image_tag' ;;
    '`k8s-traffic-manager`')            echo 'agent_traffic_manager_tag' ;;
    'traffic manager (provider config)') echo 'traffic_manager_version' ;;
    '`scopes` repository')              echo 'agent_repos_scope_tag' ;;
    *) echo '' ;;
  esac
}

# Variables in the paste block that no table row is expected to govern.
exempt_var() {
  case "$1" in
    repository_branch) return 0 ;;
    *) return 1 ;;
  esac
}

# Why frozen, printed in the report so the reason travels with the drift.
frozen_reason() {
  case "$1" in
    '`scopes` repository') echo 'pinned deliberately to the ref named in the migration request; see Caveats' ;;
    '`gateway-api` CRDs') echo 'follows the version Istio documents installing, not its own latest; bump it with Istio' ;;
    *) echo 'held by hand' ;;
  esac
}

# One anonymous token for the whole run: the endpoint rate-limits per request,
# and a token fetched inside "$(...)" would be discarded with the subshell.
ECR_TOKEN=''
ecr_token() {
  [ -n "$ECR_TOKEN" ] || ECR_TOKEN="$(curl -fsS https://public.ecr.aws/token/ | jq -r '.token')"
  echo "$ECR_TOKEN"
}

ACCEPT='application/vnd.oci.image.index.v1+json,application/vnd.docker.distribution.manifest.list.v2+json,application/vnd.docker.distribution.manifest.v2+json,application/vnd.oci.image.manifest.v1+json'

# Build date of one tag, as epoch seconds. Empty when it cannot be read.
ecr_build_date() {
  local repo="$1" tag="$2" tok base manifest cfg created
  tok="$(ecr_token)"
  base="https://public.ecr.aws/v2/$repo"
  manifest="$(curl -fsS --retry 3 --retry-delay 2 --retry-all-errors \
    -H "Authorization: Bearer $tok" -H "Accept: $ACCEPT" \
    "$base/manifests/$tag" 2>/dev/null)" || return 0
  # A manifest list carries no config. Follow the first real platform manifest:
  # index entries also include attestations, which have platform unknown/unknown
  # and no image config.
  if [ "$(jq -r 'has("manifests")' <<<"$manifest")" = "true" ]; then
    local child
    child="$(jq -r '[.manifests[] | select((.platform.os // "unknown") != "unknown")][0].digest // empty' <<<"$manifest")"
    [ -n "$child" ] || return 0
    manifest="$(curl -fsS --retry 3 --retry-delay 2 --retry-all-errors \
      -H "Authorization: Bearer $tok" -H "Accept: $ACCEPT" \
      "$base/manifests/$child" 2>/dev/null)" || return 0
  fi
  cfg="$(jq -r '.config.digest // empty' <<<"$manifest")"
  [ -n "$cfg" ] || return 0
  created="$(curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors \
    -H "Authorization: Bearer $tok" -H 'Accept: */*' \
    "$base/blobs/$cfg" 2>/dev/null | jq -r '.created // empty')" || return 0
  [ -n "$created" ] || return 0
  date -u -d "$created" +%s 2>/dev/null || date -u -jf '%Y-%m-%dT%H:%M:%S' "${created:0:19}" +%s 2>/dev/null || true
}

# Newest *build* among the highest-numbered semver tags, not the highest number.
ecr_latest() {
  local repo="$1" tok tags best_tag='' best_date=0 tag d
  tok="$(ecr_token)"
  tags="$(curl -fsS -H "Authorization: Bearer $tok" \
    "https://public.ecr.aws/v2/$repo/tags/list" | jq -r '.tags[]?' |
    grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' | sed 's/^v//' | sort -rV | head -3)" || return 0
  for tag in $tags; do
    d="$(ecr_build_date "$repo" "$tag")"
    [ -z "$d" ] && d="$(ecr_build_date "$repo" "v$tag")"
    # Choosing the newest build among only the tags that answered would turn a
    # rate-limited read into a confident wrong answer, and --write would then
    # commit a downgrade. One unreadable candidate voids the comparison.
    [ -z "$d" ] && return 0
    if [ "$d" -gt "$best_date" ]; then best_date="$d"; best_tag="$tag"; fi
  done
  echo "$best_tag"
}

gh_json() {
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    curl -fsS -H "Authorization: Bearer $GITHUB_TOKEN" \
      -H 'Accept: application/vnd.github+json' "$1"
  else
    curl -fsS -H 'Accept: application/vnd.github+json' "$1"
  fi
}

gh_tag_latest() {
  local repo="$1" prefix="$2"
  gh_json "https://api.github.com/repos/$repo/tags?per_page=100" |
    jq -r '.[].name' |
    grep -E "^${prefix}v?[0-9]+\.[0-9]+\.[0-9]+$" |
    sed "s|^${prefix}||" | sort -rV | head -1
}

# Highest version of one chart in a Helm repository index. The index is the
# authoritative list of published chart versions and needs no tag pagination.
helm_index_latest() {
  local url="$1" chart="$2"
  curl -fsS "$url" | awk -v chart="  $chart:" '
    $0 == chart { inchart = 1; next }
    inchart && /^  [a-zA-Z]/ { inchart = 0 }
    inchart && $1 == "version:" { print $2 }
  ' | grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' | sort -rV | head -1
}

gh_release_latest() {
  gh_json "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name // empty'
}

resolve_latest() {
  local spec="$1" kind rest
  kind="${spec%%:*}"; rest="${spec#*:}"
  case "$kind" in
    ecr)        ecr_latest "$rest" ;;
    gh-release) gh_release_latest "$rest" ;;
    gh-tag)     gh_tag_latest "${rest%%:*}" "${rest#*:}" ;;
    helm-index) helm_index_latest "${rest%:*}" "${rest##*:}" ;;
    frozen)     gh_json "https://api.github.com/repos/$rest/tags?per_page=100" |
                  jq -r '.[].name' | grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' | sort -rV | head -1 ;;
  esac
}

# Compare ignoring a leading v, so v1.21.1 and 1.21.1 are the same version.
bare() { echo "${1#v}"; }

ECR_TOKEN="$(curl -fsS https://public.ecr.aws/token/ | jq -r '.token' || true)"

ROWS=()
DRIFT=0
BROKEN=0

while IFS='|' read -r _ component pinned _; do
  component="$(echo "$component" | sed 's/^ *//; s/ *$//')"
  pinned="$(echo "$pinned" | sed 's/^ *//; s/ *$//; s/^`//; s/`$//')"
  [ -n "$component" ] || continue
  [ "$component" = 'Component' ] && continue
  [ "$component" = '---' ] && continue

  spec="$(upstream_for "$component")"
  if [ -z "$spec" ]; then
    # An unmapped row means the table grew and this script did not. Fail loud.
    ROWS+=("$component|$pinned|-|unmapped: add it to upstream_for()")
    BROKEN=1
    continue
  fi

  latest="$(resolve_latest "$spec" || true)"
  if [ -z "$latest" ]; then
    ROWS+=("$component|$pinned|-|could not read upstream")
    BROKEN=1
    continue
  fi

  if [ "$(bare "$pinned")" = "$(bare "$latest")" ]; then
    ROWS+=("$component|$pinned|$latest|current")
  elif [ "${spec%%:*}" = 'frozen' ]; then
    ROWS+=("$component|$pinned|$latest|frozen: $(frozen_reason "$component")")
  elif [ "$(printf '%s\n%s\n' "$(bare "$pinned")" "$(bare "$latest")" | sort -V | head -1)" \
         = "$(bare "$latest")" ]; then
    # The newest build carries a lower number than what is pinned. That is a real
    # case here (see the v2.0.2 trap), but proposing a downgrade is a human call.
    ROWS+=("$component|$pinned|$latest|newest build has a lower number: decide by hand")
    BROKEN=1
  else
    ROWS+=("$component|$pinned|$latest|behind")
    DRIFT=1
  fi
done < <(awk '/^\| /{print}' "$DOC")

# A version in the Ready-to-paste block with no row governing it drifts silently:
# nothing compares it against upstream. Reported, but it does not block a bump,
# because the versions themselves were read fine.
NOTES=()
COVERED=" "
for row in "${ROWS[@]}"; do
  IFS='|' read -r c _ _ _ <<<"$row"
  for v in $(hcl_vars_for "$c"); do COVERED="$COVERED$v "; done
done
while read -r var; do
  [ -n "$var" ] || continue
  exempt_var "$var" && continue
  case "$COVERED" in *" $var "*) continue ;; esac
  NOTES+=("\`$var\` is set in the Ready-to-paste block but no table row governs it, so nothing checks it against upstream")
done < <(awk '/^```hcl/{inblock=1; next} inblock && /^```/{inblock=0} inblock && match($0, /^[[:space:]]+[a-z_]+[[:space:]]*=[[:space:]]*"[^"]+"/) {print $1}' "$DOC")

if [ "$MARKDOWN" = 1 ]; then
  echo '| Component | Pinned | Latest upstream | Status |'
  echo '| --- | --- | --- | --- |'
  for row in "${ROWS[@]}"; do
    IFS='|' read -r c p l s <<<"$row"
    echo "| $c | \`$p\` | \`$l\` | $s |"
  done
  if [ "${#NOTES[@]}" -gt 0 ]; then
    echo
    for n in "${NOTES[@]}"; do echo "- $n"; done
  fi
else
  printf '%-38s %-10s %-10s %s\n' 'COMPONENT' 'PINNED' 'LATEST' 'STATUS'
  for row in "${ROWS[@]}"; do
    IFS='|' read -r c p l s <<<"$row"
    printf '%-38s %-10s %-10s %s\n' "$c" "$p" "$l" "$s"
  done
  for n in "${NOTES[@]-}"; do [ -n "$n" ] && echo "note: $n"; done
fi

# Any unreadable or unmapped row leaves the table's real state uncertain, so no
# row gets rewritten until that is resolved.
if [ "$WRITE" = 1 ] && [ "$DRIFT" = 1 ] && [ "$BROKEN" = 0 ]; then
  for row in "${ROWS[@]}"; do
    IFS='|' read -r c p l s <<<"$row"
    [ "$s" = 'behind' ] || continue
    # The table cell, matched on the whole row so an identical version elsewhere is left alone.
    awk -v comp="$c" -v old="$p" -v new="$l" '
      index($0, "| " comp " | `" old "` |") == 1 { gsub("`" old "`", "`" new "`"); }
      { print }
    ' "$DOC" > "$DOC.tmp" && mv "$DOC.tmp" "$DOC"
    # The Ready-to-paste HCL block, one line per variable that carries this version.
    for v in $(hcl_vars_for "$c"); do
      awk -v var="$v" -v old="$p" -v new="$l" '
        $1 == var && $2 == "=" && $3 == "\"" old "\"" { sub("\"" old "\"", "\"" new "\""); }
        { print }
      ' "$DOC" > "$DOC.tmp" && mv "$DOC.tmp" "$DOC"
    done
  done
  awk -v d="$(date -u +%Y-%m-%d)" '/^Verified /{print "Verified " d "."; next} {print}' \
    "$DOC" > "$DOC.tmp" && mv "$DOC.tmp" "$DOC"
fi

[ "$DRIFT" = 0 ] && [ "$BROKEN" = 0 ]
