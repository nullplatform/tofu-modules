################################################################################
# S3 Bucket Policy — Secure Transport enforcement
#
# Rules enforced by this module:
#   1. No Principal "*" with Effect "Allow" (unrestricted public access is forbidden).
#   2. A Deny statement for aws:SecureTransport = false is always present,
#      ensuring the bucket rejects any non-HTTPS request.
################################################################################

# Mandatory: deny all S3 actions over plain HTTP
data "aws_iam_policy_document" "secure_transport" {
  statement {
    sid     = "DenyNonSecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]

    resources = [
      var.bucket_arn,
      "${var.bucket_arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# Merge the secure transport policy with any caller-supplied statements
data "aws_iam_policy_document" "merged" {
  source_policy_documents = compact([
    data.aws_iam_policy_document.secure_transport.json,
    var.additional_policy_json,
  ])
}

resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id
  policy = data.aws_iam_policy_document.merged.json
}
