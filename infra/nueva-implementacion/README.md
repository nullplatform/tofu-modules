# Nullplatform Implementation

Infrastructure as Code implementation for Nullplatform on AWS using OpenTofu.

## Architecture

| Component | Configuration |
|-----------|--------------|
| Cloud | AWS |
| Code Repository | GitHub |
| Networking | Istio (ALB + Istio + Cert Manager + External DNS) |
| Asset Repository | ECR |
| Scope Definitions | Containers |
| Backend | Existing S3 + DynamoDB |

## Structure

```
.
├── backend/                    # Existing S3 backend (already deployed)
├── infrastructure/             # VPC, EKS, Route53, ALB Controller, Istio, etc.
├── nullplatform/               # Scope definitions, Dimensions
├── nullplatform-bindings/      # Code repo, ECR, Cloud config, Associations
├── common.tfvars.example       # Shared variables template
└── README.md
```

## Prerequisites

- OpenTofu >= 1.0
- AWS CLI configured with a valid profile
- Nullplatform API key with appropriate permissions

## Setup

1. Copy example files:
   ```bash
   cp common.tfvars.example common.tfvars
   cp infrastructure/terraform.tfvars.example infrastructure/terraform.tfvars
   cp nullplatform/terraform.tfvars.example nullplatform/terraform.tfvars
   cp nullplatform-bindings/terraform.tfvars.example nullplatform-bindings/terraform.tfvars
   ```

2. Fill in the values in each `.tfvars` file

3. Update `backend.tf` in each layer with the existing S3 backend details

## Deployment Order

```bash
# 1. Infrastructure
cd infrastructure
tofu init
tofu plan -var-file=../common.tfvars -var-file=./terraform.tfvars
tofu apply -var-file=../common.tfvars -var-file=./terraform.tfvars

# 2. Nullplatform
cd ../nullplatform
tofu init
tofu plan -var-file=../common.tfvars -var-file=./terraform.tfvars
tofu apply -var-file=../common.tfvars -var-file=./terraform.tfvars

# 3. Nullplatform Bindings
cd ../nullplatform-bindings
tofu init
tofu plan -var-file=../common.tfvars -var-file=./terraform.tfvars
tofu apply -var-file=../common.tfvars -var-file=./terraform.tfvars
```

## Destroy Order (reverse)

```bash
# 1. Nullplatform Bindings
cd nullplatform-bindings
tofu destroy -var-file=../common.tfvars -var-file=./terraform.tfvars

# 2. Nullplatform
cd ../nullplatform
tofu destroy -var-file=../common.tfvars -var-file=./terraform.tfvars

# 3. Infrastructure
cd ../infrastructure
tofu destroy -var-file=../common.tfvars -var-file=./terraform.tfvars
```

## Modules Version

All modules use version `v1.34.0` from `github.com/nullplatform/tofu-modules`.
