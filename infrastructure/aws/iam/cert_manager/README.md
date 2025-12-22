# Module: Cert Manager IAM

This module creates the IAM role and policy required for Cert Manager to perform DNS01 challenges via Route 53.
It uses IRSA (IAM Roles for Service Accounts) to provide secure access from the Kubernetes service account to AWS resources.
Additionally, it creates the required Kubernetes ServiceAccount and RBAC resources for the DNS01 solver.

## Usage

```hcl
module "cert_manager_iam" {
  source                             = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/cert_manager?ref=v1.0.0"
  cluster_name                       = "my-cluster"
  aws_iam_openid_connect_provider_arn = module.eks.oidc_provider_arn
  hosted_zone_public_id              = "Z1234567890ABC"
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nullplatform_cert_manager_role"></a> [nullplatform\_cert\_manager\_role](#module\_nullplatform\_cert\_manager\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.nullplatform_cert_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [kubernetes_role_binding_v1.cert_manager_acme_dns01_route53_tokenrequest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding_v1) | resource |
| [kubernetes_role_v1.cert_manager_acme_dns01_route53_tokenrequest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |
| [kubernetes_service_account_v1.cert_manager_acme_dns01_route53](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_iam_openid_connect_provider_arn"></a> [aws\_iam\_openid\_connect\_provider\_arn](#input\_aws\_iam\_openid\_connect\_provider\_arn) | ARN of the AWS IAM OIDC provider for EKS service account authentication | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster where the policy runs | `string` | n/a | yes |
| <a name="input_hosted_zone_public_id"></a> [hosted\_zone\_public\_id](#input\_hosted\_zone\_public\_id) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nullplatform_cert_manager_role_arn"></a> [nullplatform\_cert\_manager\_role\_arn](#output\_nullplatform\_cert\_manager\_role\_arn) | ARN of the cert-manager role |
<!-- END_TF_DOCS -->
