# IAM Modules

This directory contains IAM modules for managing AWS Identity and Access Management roles and policies for EKS workloads using IRSA (IAM Roles for Service Accounts).

## Modules

| Module | Description |
|--------|-------------|
| [agent](./agent/README.md) | IAM role for the Nullplatform agent with Route53, ELB, EKS, and AVP permissions |
| [aws_loadbalancer_controller_iam](./aws_loadbalancer_controller_iam/README.md) | IAM role and Kubernetes service account for the AWS Load Balancer Controller |
| [cert_manager](./cert_manager/README.md) | IAM role for cert-manager to manage Route53 DNS records for certificate validation |
| [external_dns](./external_dns/README.md) | IAM role for external-dns to manage Route53 DNS records in public and private hosted zones |
