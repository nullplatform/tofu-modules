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

Verified 2026-10-19.

| Component | Current | Variable | Module |
| --- | --- | --- | --- |
| `nullplatform-base` chart | `2.44.7` | `nullplatform_base_helm_version` | `nullplatform/base` |
| `nullplatform-agent` chart | `3.2.0` | `nullplatform_agent_helm_version` | `nullplatform/agent` |
| `cert-manager` chart | `v1.21.2` | `cert_manager_version` | `infrastructure/commons/cert_manager` |
| `prometheus` chart | `29.37.0` | `prometheus_version` | `infrastructure/commons/prometheus` |
| `istio-base` chart | `1.30.6` | `istio_base_version` | `infrastructure/commons/istio` |
| `istiod` chart | `1.30.6` | `istiod_version` | `infrastructure/commons/istio` |
| `gateway-api` CRDs | `v1.5.1` | `gateway_api_crd_ref` | `nullplatform/base` |
| `k8s-logs-controller` | `v1.6.3` | `logging_controller_image_tag` | `nullplatform/base` |
| `controlplane-agent` | `0.13.0` | `image_tag` | `nullplatform/agent` |
| `k8s-traffic-manager` | `1.8.1` | `agent_traffic_manager_tag` | `nullplatform/agent` |
| traffic manager (provider config) | `1.8.1` | `traffic_manager_version` | `container_orchestration/eks` |
| `scopes` repository | `v1.18.0` | `agent_repo` (as `"https://github.com/nullplatform/scopes.git#v1.18.0"`; only without packages) | `nullplatform/agent` |
| `scopes-lambda` repository | `v0.10.0` | `agent_repo` (as `"https://github.com/nullplatform/scopes-lambda.git#v0.10.0"`; only without packages) | `nullplatform/agent` |
| `scopes-static-files` repository | `v4.1.1` | `agent_repo` (as `"https://github.com/nullplatform/scopes-static-files.git#v4.1.1"`; only without packages) | `nullplatform/agent` |
| `external-dns` chart | `1.23.0` | `external_dns_version` | `infrastructure/commons/external_dns` |
| `aws-load-balancer-controller` chart | `3.6.0` | `aws_load_balancer_controller_version` | `infrastructure/aws/aws_load_balancer_controller` |
| `nullplatform-cert-manager-config` chart | `2.35.0` | `cert_manager_config_version` | `infrastructure/commons/cert_manager` |
| EKS Kubernetes version | `1.36` | `kubernetes_version` | `infrastructure/aws/eks` |
| EKS node AMI | `1.36.4-20261012` | `ami_release_version` (with `use_latest_ami_release_version = false`) | `infrastructure/aws/eks` |
| `vpc-cni` addon | `v1.22.4-eksbuild.3` | `addon_versions["vpc-cni"]` | `infrastructure/aws/eks` |
| `coredns` addon | `v1.14.7-eksbuild.10` | `addon_versions["coredns"]` | `infrastructure/aws/eks` |
| `kube-proxy` addon | `v1.36.0-eksbuild.25` | `addon_versions["kube-proxy"]` | `infrastructure/aws/eks` |
| `aws-ebs-csi-driver` addon | `v1.67.0-eksbuild.1` | `addon_versions["aws-ebs-csi-driver"]` | `infrastructure/aws/eks` |
| `eks-pod-identity-agent` addon | `v1.3.10-eksbuild.3` | `addon_versions["eks-pod-identity-agent"]` | `infrastructure/aws/eks` |

**Read your cluster before copying these.** The rule is to pin what you are already running,
so the change stays functionally inert. Four of these were previously unpinnable and resolved
at deploy time, so what you run may not match the table: `cert_manager_version`,
`prometheus_version`, `logging_controller_image_tag`, and `traffic_manager_version` on eks.

## Ready to paste

```hcl
module "base" {
  nullplatform_base_helm_version = "2.44.7"
  logging_controller_image_tag   = "v1.6.3"
  gateway_api_crd_ref            = "v1.5.1"
}

module "agent" {
  nullplatform_agent_helm_version = "3.2.0"
  image_tag                       = "0.13.0"
  agent_traffic_manager_tag       = "1.8.1"

  # Only for an install without packages (worker_orchestrator = false, the legacy
  # exec flow): the agent clones these repositories at startup. With packages the
  # scopes and services come from each package, so leave agent_repo unset.
  # agent_repo = [
  #   "https://github.com/nullplatform/scopes.git#v1.18.0",
  #   "https://github.com/nullplatform/scopes-lambda.git#v0.10.0",
  #   "https://github.com/nullplatform/scopes-static-files.git#v4.1.1",
  # ]
}

# eks, aks and gke all take this
module "container_orchestration" {
  traffic_manager_version = "1.8.1"
}

module "cert_manager" {
  cert_manager_version        = "v1.21.2"
  cert_manager_config_version = "2.35.0"
}

module "eks" {
  kubernetes_version             = "1.36"
  ami_release_version            = "1.36.4-20261012"
  use_latest_ami_release_version = false

  addon_versions = {
    vpc-cni                = "v1.22.4-eksbuild.3"
    coredns                = "v1.14.7-eksbuild.10"
    kube-proxy             = "v1.36.0-eksbuild.25"
    aws-ebs-csi-driver     = "v1.67.0-eksbuild.1"
    eks-pod-identity-agent = "v1.3.10-eksbuild.3"
  }
}

module "external_dns" {
  external_dns_version = "1.23.0"
}

module "aws_load_balancer_controller" {
  aws_load_balancer_controller_version = "3.6.0"
}

module "prometheus" {
  prometheus_version = "29.37.0"
}

module "istio" {
  istio_base_version = "1.30.6"
  istiod_version     = "1.30.6"
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

# EKS: cluster version, node group AMI, and each addon
aws eks describe-cluster --name <cluster> --query cluster.version
aws eks describe-nodegroup --cluster-name <cluster> --nodegroup-name <ng> --query nodegroup.releaseVersion
aws eks describe-addon --cluster-name <cluster> --addon-name vpc-cni --query addon.addonVersion
```

The traffic manager image is assembled from `agent_traffic_manager_tag` and published to the
agent as `TRAFFIC_CONTAINER_IMAGE`. `extra_envs` still takes precedence over it, so a digest
or a mirrored registry path can be passed the way it was before the tag was exposed.

## Caveats

**The scopes repositories follow their latest release.** `scopes`, `scopes-lambda` and
`scopes-static-files` are each bumped to their newest tag in the release pull request, whether an
install runs packages or the legacy flow, so the table names one current set for both. The
rewrite replaces the `url#ref` in the table and in the commented `agent_repo` list. Their tags
cross major versions freely (`scopes-static-files` went from `v0.4.0` to `v4.1.1`), so read the
release notes of a major bump before merging the release that carries it.

**The agent repositories only matter without packages.** `agent_repos_scope_tag` and
`agent_repos_extra` are gone; `agent_repo` replaced both, as one list of `url#ref`. The agent
clones it only in the legacy exec flow (`worker_orchestrator = false`). An install that runs
packages gets its scopes and services from each package and leaves `agent_repo` empty.

**cert-manager and prometheus were not pinnable at all.** `cert_manager_version` existed but
was never wired to its `helm_release`, and `prometheus` had no version argument, so both
tracked whatever their chart repository served.

**Not everything is covered yet.** The scopes and service-spec repositories are read through
eleven other paths, in `scope_definition`, `scope_definition_agent_association`,
`parameter_storage_definition` and `service_definition`, and those still default to a moving
branch. Pinning the scopes ref in `agent_repo` does not cover them: the agent clones the ref while the
definition modules read the branch. They are listed in
`scripts/version-pinning-baseline.txt` with the reason.

**The gateway-api CRD ref follows Istio, not its own latest.** `gateway_api_crd_ref` tracks the
`sigs.k8s.io/gateway-api` version in `istio/istio`'s `go.mod` at the pinned `istiod_version`:
Istio 1.30's release notes warn that upgrading these CRDs past what Istio builds against leaves
`TLSRoute` and `ReferenceGrant` invisible to istiod. The check reads it for the istiod version
the release is moving to, so an Istio bump carries its matching CRD ref in the same pull request.

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

**Kubernetes runs one minor behind the newest.** `kubernetes_version` tracks the EKS minor
before the newest one (per endoflife.date): `1.36` while `1.37` is the newest, moving to `1.37`
when `1.38` is released. The newest minor ships before addons and tooling settle; one behind
still has the full standard-support window ahead of it.

**The EKS rows move together.** The node AMI and every addon build are published per
Kubernetes minor. The AMI row is read for the minor the table is moving to, against the
`awslabs/amazon-eks-ami` release notes, so a minor bump carries a matching AMI and a patch bump
within the minor is an ordinary row update. The addon rows have no public source — the builds
are listed by the EKS API, which needs AWS credentials — so they are reported as manual and
never rewritten. When the minor moves, the release pull request reports every addon as
needing a build for the new minor and warns; merge it only after updating them. To pick them,
take the default build AWS marks for the minor:

```bash
aws eks describe-addon-versions --kubernetes-version 1.36 --addon-name vpc-cni \
  --query 'addons[].addonVersions[?compatibilities[?defaultVersion]].addonVersion' --output text
```

`ami_release_version` only holds with `use_latest_ami_release_version = false`: left at its
upstream default, the node group looks the AMI up from SSM on every plan instead.

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

The same script also checks that every variable the Ready-to-paste block sets is declared by the
module it names. A renamed or removed variable fails that workflow, and the release refresh
leaves the table alone until the block is fixed by hand: a block that does not apply should not
look maintained.

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

Copy the tag exactly as that list prints it. The same repositories mix spellings across
releases — `k8s-logs-controller` has `1.6.0` and `1.6.1` but `v1.6.2` and `v1.6.3` — and the
modules pull the tag verbatim, so `1.6.3` where only `v1.6.3` exists is an image that never
pulls. The check reports such a pin as `respell` and the release refresh corrects it.

