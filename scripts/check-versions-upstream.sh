#!/usr/bin/env bash
set -euo pipefail

# Reports upstream releases newer than the versions pinned in VERSIONS.md.
# Compares build dates for container images: a higher version number can be an
# older build (see the k8s-traffic-manager v2.0.2 trap in VERSIONS.md).
#
# Usage: check-versions-upstream.sh [--markdown] [--write]
#
# Exit 0 when every pin is current, 1 when something is behind or unreadable,
# 3 when the Ready-to-paste block sets a variable its module does not declare.

# VERSIONS_DOC lets CI run this script against a checkout of another ref, and
# lets a test point it at a fixture. VERSIONS_ROOT is where the modules the
# Ready-to-paste block names are looked up.
DOC="${VERSIONS_DOC:-$(dirname "$0")/../VERSIONS.md}"
ROOT="${VERSIONS_ROOT:-$(dirname "$0")/..}"
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
    '`gateway-api` CRDs')               echo 'istio-gomod' ;;
    '`k8s-logs-controller`')            echo 'ecr:nullplatform/k8s-logs-controller' ;;
    '`controlplane-agent`')             echo 'ecr:nullplatform/controlplane-agent' ;;
    '`k8s-traffic-manager`')            echo 'ecr:nullplatform/k8s-traffic-manager' ;;
    'traffic manager (provider config)') echo 'ecr:nullplatform/k8s-traffic-manager' ;;
    '`scopes` repository')              echo 'gh-semver:nullplatform/scopes' ;;
    '`scopes-lambda` repository')       echo 'gh-semver:nullplatform/scopes-lambda' ;;
    '`scopes-static-files` repository') echo 'gh-semver:nullplatform/scopes-static-files' ;;
    '`external-dns` chart')             echo 'helm-index:https://kubernetes-sigs.github.io/external-dns/index.yaml:external-dns' ;;
    '`aws-load-balancer-controller` chart') echo 'helm-index:https://aws.github.io/eks-charts/index.yaml:aws-load-balancer-controller' ;;
    '`nullplatform-cert-manager-config` chart') echo 'helm-index:https://nullplatform.github.io/helm-charts/index.yaml:nullplatform-cert-manager-config' ;;
    'EKS Kubernetes version')           echo 'eks-n1' ;;
    'EKS node AMI')                     echo 'eks-ami' ;;
    # Addon builds are listed only by the EKS API, which needs AWS credentials
    # this check does not have. Reported, never compared.
    '`vpc-cni` addon' | '`coredns` addon' | '`kube-proxy` addon' | \
    '`aws-ebs-csi-driver` addon' | '`eks-pod-identity-agent` addon')
                                        echo 'manual:no public source; read aws eks describe-addon-versions for the pinned Kubernetes version' ;;
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
    '`scopes` repository')              echo 'agent_repo' ;;
    '`external-dns` chart')             echo 'external_dns_version' ;;
    '`aws-load-balancer-controller` chart') echo 'aws_load_balancer_controller_version' ;;
    '`nullplatform-cert-manager-config` chart') echo 'cert_manager_config_version' ;;
    'EKS Kubernetes version')           echo 'kubernetes_version' ;;
    'EKS node AMI')                     echo 'ami_release_version' ;;
    # Keys of the addon_versions map. Manual rows are never rewritten; listing
    # the key keeps the coverage check from reporting it as ungoverned.
    '`vpc-cni` addon')                  echo 'vpc-cni' ;;
    '`coredns` addon')                  echo 'coredns' ;;
    '`kube-proxy` addon')               echo 'kube-proxy' ;;
    '`aws-ebs-csi-driver` addon')       echo 'aws-ebs-csi-driver' ;;
    '`eks-pod-identity-agent` addon')   echo 'eks-pod-identity-agent' ;;
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

# Module label in the Ready-to-paste block -> module directories. A label that
# stands for several modules lists them all: the variable must exist in each.
module_dirs_for() {
  case "$1" in
    base)                         echo 'nullplatform/base' ;;
    agent)                        echo 'nullplatform/agent' ;;
    container_orchestration)      echo 'nullplatform/container_orchestration/eks nullplatform/container_orchestration/aks nullplatform/container_orchestration/gke' ;;
    cert_manager)                 echo 'infrastructure/commons/cert_manager' ;;
    eks)                          echo 'infrastructure/aws/eks' ;;
    external_dns)                 echo 'infrastructure/commons/external_dns' ;;
    aws_load_balancer_controller) echo 'infrastructure/aws/aws_load_balancer_controller' ;;
    prometheus)                   echo 'infrastructure/commons/prometheus' ;;
    istio)                        echo 'infrastructure/commons/istio' ;;
    service_definition)           echo 'nullplatform/service_definition' ;;
    *) echo '' ;;
  esac
}

# A row with a reason here is frozen: compared against upstream, never rewritten.
# The reason is printed in the report so it travels with the drift.
frozen_reason() {
  case "$1" in
    # No row is held back today: gateway-api follows the pinned Istio and the
    # Kubernetes version follows the minor before the newest. Add one here to
    # report a row without rewriting it.
    *) echo '' ;;
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
# Returned exactly as published: these repositories mix 1.6.1 and v1.6.3, and
# the modules pull the tag verbatim, so the leading v is part of the answer.
ecr_latest() {
  local repo="$1" tok tags best_tag='' best_date=0 tag d
  tok="$(ecr_token)"
  tags="$(curl -fsS -H "Authorization: Bearer $tok" \
    "https://public.ecr.aws/v2/$repo/tags/list" | jq -r '.tags[]?' |
    grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' |
    awk '{ t = $0; sub(/^v/, "", t); print t, $0 }' | sort -rV | head -3 | cut -d' ' -f2)" || return 0
  for tag in $tags; do
    d="$(ecr_build_date "$repo" "$tag")"
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

# The EKS minor before the newest, e.g. "1.36" while 1.37 is the newest. The
# newest minor ships before its addons and tooling settle, so installs run one
# behind it and move on their own when the next one is released.
eks_n1_latest() {
  curl -fsS "https://endoflife.date/api/amazon-eks.json" | jq -r '.[1].cycle // empty'
}

# Newest EKS-optimized AMI release for the Kubernetes minor the table is moving
# to, e.g. "1.36.4-20261012". That is the Kubernetes row's resolved value when
# it was read, so a minor bump carries a matching AMI; otherwise the pin's own.
eks_ami_latest() {
  local minor
  minor="${K8S_TARGET:-$(echo "$1" | cut -d. -f1,2)}"
  gh_json "https://api.github.com/repos/awslabs/amazon-eks-ami/releases/latest" |
    jq -r '.body // empty' |
    grep -oE "${minor//./\\.}\.[0-9]+-[0-9]{8}" | sort -rV | head -1
}

# The Gateway API version Istio itself builds against, read from istio/istio's
# go.mod at the istiod version the table is moving to. Upgrading the CRDs past
# it leaves TLSRoute and ReferenceGrant invisible to istiod (Istio 1.30 notes).
istio_gomod_gateway_api() {
  [ -n "${ISTIO_TARGET:-}" ] || return 0
  curl -fsS "https://raw.githubusercontent.com/istio/istio/$ISTIO_TARGET/go.mod" |
    awk '$1 == "sigs.k8s.io/gateway-api" { print $2; exit }'
}

# Repository URL a row's ref is appended to as url#ref, in the table and in the
# Ready-to-paste agent_repo list. The rewrite replaces url#old with url#new.
repo_url_for() {
  case "$1" in
    '`scopes` repository')              echo 'https://github.com/nullplatform/scopes.git' ;;
    '`scopes-lambda` repository')       echo 'https://github.com/nullplatform/scopes-lambda.git' ;;
    '`scopes-static-files` repository') echo 'https://github.com/nullplatform/scopes-static-files.git' ;;
    *) echo '' ;;
  esac
}

resolve_latest() {
  local spec="$1" pinned="$2" kind rest
  kind="${spec%%:*}"; rest="${spec#*:}"
  case "$kind" in
    ecr)        ecr_latest "$rest" ;;
    gh-release) gh_release_latest "$rest" ;;
    gh-tag)     gh_tag_latest "${rest%%:*}" "${rest#*:}" ;;
    helm-index) helm_index_latest "${rest%:*}" "${rest##*:}" ;;
    gh-semver)  gh_json "https://api.github.com/repos/$rest/tags?per_page=100" |
                  jq -r '.[].name' | grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' | sort -rV | head -1 ;;
    eks-n1)     eks_n1_latest ;;
    eks-ami)    eks_ami_latest "$pinned" ;;
    istio-gomod) istio_gomod_gateway_api ;;
  esac
}

# Compare ignoring a leading v, so v1.21.1 and 1.21.1 are the same release.
# Whether the pin is spelled as published is checked separately.
bare() { echo "${1#v}"; }

ECR_TOKEN="$(curl -fsS https://public.ecr.aws/token/ | jq -r '.token' || true)"

ROWS=()
DRIFT=0
BROKEN=0
# Values some rows derive from others: the AMI from the Kubernetes minor, the
# gateway-api ref from istiod. Set as those rows are read, so the table must
# list the Kubernetes row before the AMI and addons, and istiod before gateway-api.
K8S_TARGET=''
ISTIO_TARGET=''
# The minor the addon pins were picked for. kube-proxy is built per Kubernetes
# minor (v1.36.0-eksbuild.N), so its pin names it; unlike comparing against the
# old Kubernetes pin, this keeps flagging stale addons on every run after the
# bump, until someone updates them.
ADDONS_MINOR="$(awk -F'|' 'index($0, "| `kube-proxy` addon |") == 1 {
  v = $3; gsub(/[ `]/, "", v); sub(/^v/, "", v); split(v, a, "."); print a[1] "." a[2]
}' "$DOC")"

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

  # Nothing to compare against: listed so the pin is visible, and it neither
  # counts as drift nor blocks the rewrite of the other rows.
  if [ "${spec%%:*}" = 'manual' ]; then
    case "$component" in
      *' addon')
        # Addon builds are published per Kubernetes minor. When the table moves
        # the cluster, these pins belong to the old minor and nothing here can
        # list the new builds, so the report has to say so out loud.
        if [ -n "$K8S_TARGET" ] && [ -n "$ADDONS_MINOR" ] && [ "$K8S_TARGET" != "$ADDONS_MINOR" ]; then
          ROWS+=("$component|$pinned|-|manual: Kubernetes moves to $K8S_TARGET but addons are for $ADDONS_MINOR; pick its default build before merging")
          continue
        fi ;;
    esac
    ROWS+=("$component|$pinned|-|manual: ${spec#manual:}")
    continue
  fi

  latest="$(resolve_latest "$spec" "$pinned" || true)"
  if [ -z "$latest" ]; then
    ROWS+=("$component|$pinned|-|could not read upstream")
    BROKEN=1
    continue
  fi

  case "$component" in
    'EKS Kubernetes version') K8S_TARGET="$latest" ;;
    '`istiod` chart')         ISTIO_TARGET="$latest" ;;
  esac

  reason="$(frozen_reason "$component")"
  if [ "$pinned" = "$latest" ]; then
    ROWS+=("$component|$pinned|$latest|current")
  elif [ "$(bare "$pinned")" = "$(bare "$latest")" ]; then
    # Same release, different spelling. The tag is used verbatim, so 1.6.3 where
    # only v1.6.3 exists is an image pull that fails. Safe to rewrite: the
    # release does not change, only the string that names it.
    ROWS+=("$component|$pinned|$latest|respell: published as $latest")
    DRIFT=1
  elif [ -n "$reason" ]; then
    ROWS+=("$component|$pinned|$latest|frozen: $reason")
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

# A variable the module no longer declares makes the block fail on copy with
# "Unsupported argument", and nothing else would notice: the table can still
# read as current. Only top-level arguments count, so the keys of a map such as
# addon_versions are not mistaken for variables. Commented lines are skipped.
INVALID=()
UNMAPPED=" "
while read -r label var; do
  dirs="$(module_dirs_for "$label")"
  if [ -z "$dirs" ]; then
    case "$UNMAPPED" in *" $label "*) continue ;; esac
    UNMAPPED="$UNMAPPED$label "
    INVALID+=("module \"$label\" in the Ready-to-paste block is not mapped: add it to module_dirs_for()")
    continue
  fi
  for d in $dirs; do
    grep -qs "^variable \"$var\"" "$ROOT/$d"/*.tf ||
      INVALID+=("\`$var\` is set on module \"$label\" in the Ready-to-paste block but $d declares no such variable")
  done
done < <(awk '
  /^```hcl/ { inblock = 1; depth = 0; next }
  inblock && /^```/ { inblock = 0; next }
  !inblock || /^[[:space:]]*#/ { next }
  depth == 0 && match($0, /^module "[^"]+"/) { label = substr($0, 9, RLENGTH - 9) }
  depth == 1 && match($0, /^[[:space:]]+[a-z_]+[[:space:]]*=/) { print label, $1 }
  { depth += gsub(/[{[]/, "&") - gsub(/[]}]/, "&") }
' "$DOC")

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
  if [ "${#INVALID[@]}" -gt 0 ]; then
    echo
    for n in "${INVALID[@]}"; do echo "- **invalid:** $n"; done
  fi
else
  printf '%-38s %-10s %-10s %s\n' 'COMPONENT' 'PINNED' 'LATEST' 'STATUS'
  for row in "${ROWS[@]}"; do
    IFS='|' read -r c p l s <<<"$row"
    printf '%-38s %-10s %-10s %s\n' "$c" "$p" "$l" "$s"
  done
  for n in "${NOTES[@]-}"; do [ -n "$n" ] && echo "note: $n"; done
  for n in "${INVALID[@]-}"; do [ -n "$n" ] && echo "invalid: $n" >&2; done
fi

# A block that does not apply is fixed by hand first; bumping its versions
# would only make the broken block look maintained.
[ "${#INVALID[@]}" -eq 0 ] || exit 3

# Any unreadable or unmapped row leaves the table's real state uncertain, so no
# row gets rewritten until that is resolved.
if [ "$WRITE" = 1 ] && [ "$DRIFT" = 1 ] && [ "$BROKEN" = 0 ]; then
  for row in "${ROWS[@]}"; do
    IFS='|' read -r c p l s <<<"$row"
    case "$s" in behind | respell:*) ;; *) continue ;; esac
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
    # A ref carried inside a repository URL (url#ref), wherever it appears: the
    # table's variable cell and the agent_repo list, commented or not. Literal
    # match, since the URL is full of regex metacharacters.
    url="$(repo_url_for "$c")"
    if [ -n "$url" ]; then
      awk -v from="$url#$p\"" -v to="$url#$l\"" '
        { while ((i = index($0, from)) > 0) $0 = substr($0, 1, i - 1) to substr($0, i + length(from)) }
        { print }
      ' "$DOC" > "$DOC.tmp" && mv "$DOC.tmp" "$DOC"
    fi
  done
  awk -v d="$(date -u +%Y-%m-%d)" '/^Verified /{print "Verified " d "."; next} {print}' \
    "$DOC" > "$DOC.tmp" && mv "$DOC.tmp" "$DOC"
fi

[ "$DRIFT" = 0 ] && [ "$BROKEN" = 0 ]
