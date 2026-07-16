mock_provider "aws" {
  override_resource {
    target = aws_iam_policy.nullplatform_cloudwatch_policy
    values = {
      arn = "arn:aws:iam::123456789012:policy/nullplatform-test-cluster-cloudwatch-policy"
    }
  }
  override_resource {
    target = aws_iam_role.pod_identity
    values = {
      arn = "arn:aws:iam::123456789012:role/nullplatform-test-cluster-cloudwatch-role"
    }
  }
}

variables {
  cluster_name  = "test-cluster"
  identity_mode = "pod_identity"
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
  assert {
    condition     = length(aws_iam_role_policy_attachment.pod_identity) == 1
    error_message = "Pod Identity mode must create exactly one policy attachment"
  }
}

run "creates_single_association_for_logs_controller_sa" {
  command = plan

  assert {
    condition     = length(aws_eks_pod_identity_association.this) == 1
    error_message = "Pod Identity mode should create one association for the logs controller SA"
  }
  assert {
    condition     = aws_eks_pod_identity_association.this[0].service_account == "nullplatform-pod-metadata-reader-sa"
    error_message = "Association must target the logs controller service account"
  }
  assert {
    condition     = aws_eks_pod_identity_association.this[0].namespace == "nullplatform-tools"
    error_message = "Association must target the nullplatform-tools namespace"
  }
}

run "pod_identity_mode_does_not_create_irsa_module" {
  command = plan

  assert {
    condition     = length(module.nullplatform_cloudwatch_role) == 0
    error_message = "pod_identity mode must not instantiate the IRSA community module"
  }
  assert {
    condition     = output.nullplatform_cloudwatch_role_arn == "arn:aws:iam::123456789012:role/nullplatform-test-cluster-cloudwatch-role"
    error_message = "pod_identity mode must output the Pod Identity role ARN"
  }
}

run "pod_identity_does_not_require_oidc_arn" {
  command = plan

  variables {
    aws_iam_openid_connect_provider_arn = null
  }

  assert {
    condition     = length(aws_iam_role.pod_identity) == 1
    error_message = "Pod Identity mode must succeed without aws_iam_openid_connect_provider_arn"
  }
}
