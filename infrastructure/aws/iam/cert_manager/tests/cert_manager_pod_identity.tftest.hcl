mock_provider "aws" {
  override_resource {
    target = aws_iam_policy.nullplatform_cert_manager_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform-test-cluster-cert-manager-policy"
    }
  }
  override_resource {
    target = aws_iam_role.pod_identity
    values = {
      arn = "arn:aws:iam::123456789012:role/nullplatform-test-cluster-cert-manager-role"
    }
  }
}

variables {
  cluster_name                        = "test-cluster"
  hosted_zone_private_id              = "Z0987654321DEF"
  aws_iam_openid_connect_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE"
  identity_mode                       = "pod_identity"
}

run "creates_pod_identity_role" {
  command = plan

  assert {
    condition     = length(aws_iam_role.pod_identity) == 1
    error_message = "Pod Identity mode should create exactly one native IAM role"
  }
  assert {
    condition     = strcontains(aws_iam_role.pod_identity[0].assume_role_policy, "pods.eks.amazonaws.com")
    error_message = "Pod Identity role trust must use the pods.eks.amazonaws.com principal"
  }
  assert {
    condition     = strcontains(aws_iam_role.pod_identity[0].assume_role_policy, "sts:TagSession")
    error_message = "Pod Identity role trust must allow sts:TagSession"
  }
}

run "creates_single_association" {
  command = plan

  assert {
    condition     = length(aws_eks_pod_identity_association.this) == 1
    error_message = "cert-manager should create exactly one Pod Identity association"
  }
  assert {
    condition     = aws_eks_pod_identity_association.this["cert-manager:cert-manager"].service_account == "cert-manager"
    error_message = "Association must target the cert-manager service account"
  }
  assert {
    condition     = aws_eks_pod_identity_association.this["cert-manager:cert-manager"].namespace == "cert-manager"
    error_message = "Association must target the cert-manager namespace"
  }
}

run "rejects_invalid_identity_mode" {
  command = plan

  variables {
    identity_mode = "wireguard"
  }

  expect_failures = [var.identity_mode]
}
