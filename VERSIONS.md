# Pinned versions

Every version these modules deploy — Helm charts, container images, and the git refs the agent
clones — is listed here with the value to pin.

For the version of *these modules*, see the
[releases](https://github.com/nullplatform/tofu-modules/releases).

## Why it matters

`latest` and branch names resolve at deploy time, not at apply time. A pod restart can pull a
different build with no change on your side and no diff to review. Every default below names
a specific release, so an upgrade is something someone decides.

## What to pin

Verified 2026-09-08.

| Component | Current | Variable | Module |
| --- | --- | --- | --- |
| `nullplatform-base` chart | `2.44.6` | `nullplatform_base_helm_version` | `nullplatform/base` |
| `nullplatform-agent` chart | `3.0.0` | `nullplatform_agent_helm_version` | `nullplatform/agent` |
| `cert-manager` chart | `v1.21.1` | `cert_manager_version` | `infrastructure/commons/cert_manager` |
| `prometheus` chart | `29.27.2` | `prometheus_version` | `infrastructure/commons/prometheus` |
| `istio-base` chart | `1.30.4` | `istio_base_version` | `infrastructure/commons/istio` |
| `istiod` chart | `1.30.4` | `istiod_version` | `infrastructure/commons/istio` |
| `gateway-api` CRDs | `v1.5.1` | `gateway_api_crd_ref` | `nullplatform/base` |
| `k8s-logs-controller` | `1.6.1` | `logging_controller_image_tag` | `nullplatform/base` |
| `k8s-traffic-manager` | `1.8.0` | `agent_traffic_manager_tag` | `nullplatform/agent` |
| traffic manager (provider config) | `1.8.0` | `traffic_manager_version` | `container_orchestration/eks` |
| `scopes` repository | `v1.15.1` | `agent_repo` (as `"https://github.com/nullplatform/scopes.git#v1.15.1"`) | `nullplatform/agent` |

**Read your cluster before copying these.** The rule is to pin what you are already running,
so the change stays functionally inert. Four of these were previously unpinnable and resolved
at deploy time, so what you run may not match the table: `cert_manager_version`,
`prometheus_version`, `logging_controller_image_tag`, and `traffic_manager_version` on eks.

## Ready to paste

```hcl
module "base" {
  nullplatform_base_helm_version = "2.44.6"
  logging_controller_image_tag   = "1.6.1"
  gateway_api_crd_ref            = "v1.5.1"
}

module "agent" {
  nullplatform_agent_helm_version = "3.0.0"
  image_tag                       = "0.9.2"
  agent_repos_scope_tag           = "v1.15.1"
  agent_traffic_manager_tag       = "1.8.0"

  agent_repos_extra = [
    "https://github.com/nullplatform/scopes-lambda.git#v0.3.1",
    "https://github.com/nullplatform/scopes-static-files.git#v0.4.0",
  ]
}

# eks, aks and gke all take this
module "container_orchestration" {
  traffic_manager_version = "1.8.0"
}

module "cert_manager" {
  cert_manager_version = "v1.21.1"
}

module "prometheus" {
  prometheus_version = "29.27.2"
}

module "istio" {
  istio_base_version = "1.30.4"
  istiod_version     = "1.30.4"
}

module "service_definition" {
  # No value listed: repository_org and repository_name are configurable, so which spec
  # repository you read is your choice and so is its ref.
  repository_branch = "..."
}
```

To find what an install is actually running before changing anything:

```bash
helm -n nullplatform-tools get values nullplatform-base
helm -n <ns> list -o json | jq -r '.[] | "\(.name)\t\(.chart)"'
kubectl -n nullplatform-tools get deploy \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.template.spec.containers[*].image}{"\n"}{end}'
```

The traffic manager image is assembled from `agent_traffic_manager_tag` and published to the
agent as `TRAFFIC_CONTAINER_IMAGE`. `extra_envs` still takes precedence over it, so a digest
or a mirrored registry path can be passed the way it was before the tag was exposed.

## Caveats

**The scopes ref steps back.** `agent_repos_scope` used to point at `scopes.git#main`, and
`main` has moved past `v1.15.1`. Pinning the tag is deliberate — it is the ref named in the
migration request — but it is not the same tree the branch tip pointed at.

**cert-manager and prometheus were not pinnable at all.** `cert_manager_version` existed but
was never wired to its `helm_release`, and `prometheus` had no version argument, so both
tracked whatever their chart repository served.

**Not everything is covered yet.** The scopes and service-spec repositories are read through
eleven other paths, in `scope_definition`, `scope_definition_agent_association`,
`parameter_storage_definition` and `service_definition`, and those still default to a moving
branch. Pinning `agent_repos_scope` does not cover them: the agent clones the ref while the
definition modules read the branch. They are listed in
`scripts/version-pinning-baseline.txt` with the reason.

**The gateway-api CRD ref follows Istio, not its own latest.** `gateway_api_crd_ref` is pinned to
the version Istio's own version-pinned docs document installing, so it is reported as frozen
rather than bumped: Istio 1.30's release notes warn that upgrading these CRDs without upgrading
Istio leaves `TLSRoute` and `ReferenceGrant` invisible to istiod. Bump it together with
`istio_base_version` and `istiod_version`, after re-reading istio.io for that release.

It is also applied on every install *and upgrade*, not only on first install: the base chart runs
`kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=<ref>" | kubectl apply
--server-side --force-conflicts`, so the ref is resolved against GitHub on each apply and the
cluster's CRDs are reconciled to it. A branch there would be followed silently on every upgrade.

**Two places set that ref, and they do not agree.** The `nullplatform/base` module always passes
its own value through (`locals.tf`), so a module user gets the `v1.5.1` in the table above. The
chart's own default is still `v1.3.0`, which is what Istio 1.27 documented — so installing
`nullplatform-base` directly, without the module, lands Gateway API `v1.3.0` CRDs under the Istio
`1.30.4` these modules deploy, which is the mismatch the paragraph above warns about. The table
tracks the module value; the chart default is a separate fix in `nullplatform/helm-charts`.

**A name cannot prove immutability.** The checks below reject `latest`, `main`, `master` and
`HEAD`. A tag called `beta` or a branch called `develop` passes. Nothing distinguishes a
mutable ref from a fixed one by name alone.

## Keeping this current

This table is refreshed the same way the module READMEs are, and for the same reason: it is
derived from state that lives outside this repository. The `generate-readmes` job in
`release.yml` runs `scripts/check-versions-upstream.sh --write` against the open release pull
request on every push to `main`, so the release carries an up-to-date table and merging it is
the decision. Nothing reaches `main` on its own.

What is automated is the typing, not the decision. A row held back on purpose is reported as
frozen and left unedited; a row whose upstream could not be read blocks the rewrite instead of
guessing; a newest build carrying a lower version number than the pin is reported rather than
written. Bumping a documented version to whatever is newest *unreviewed* is what would put the
drift back in documentation form, and would contradict the rule above about pinning what you
already run.

`.github/workflows/versions-drift.yml` reports the same comparison on each pull request and every
Monday, so drift is visible between releases without waiting for one.

The opposite direction is enforced rather than merely reported: `scripts/check-version-pinning.sh`
rejects a *new* moving default, a repository URL pinned to a branch, or a `helm_release` with no
`version`. It runs in pre-commit and again as a step in the `terraform-lint` workflow, so
skipping the local hook does not skip the check. Deliberately deferred violations live in
`scripts/version-pinning-baseline.txt` with the reason; that file should only ever shrink.

One trap worth knowing before bumping an image by hand: **`k8s-traffic-manager` publishes a
`v2.0.2` built 2026-02-09 while `1.8.0` was built 2026-07-29**, and `k8s-logs-controller` a
`v2.0.1` from that same February against a `1.6.0` from August. The higher version number is
the older build, from a line that was not continued. Compare build dates, not version numbers:

```bash
tag=1.8.0; repo=nullplatform/k8s-traffic-manager
t=$(curl -s "https://public.ecr.aws/token/?scope=repository:$repo:pull" | jq -r .token)
curl -s -H "Authorization: Bearer $t" "https://public.ecr.aws/v2/$repo/tags/list" | jq -r '.tags[]'
```

