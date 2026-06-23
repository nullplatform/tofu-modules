resource "aws_iam_user" "nullplatform_build_workflow_user" {
  name = "nullplatform-${var.cluster_name}-build-workflow-user"
}

resource "aws_iam_access_key" "nullplatform_build_workflow_user_key" {
  user = aws_iam_user.nullplatform_build_workflow_user.name
}

resource "aws_iam_group" "asset_publishers" {
  name = "nullplatform-${var.cluster_name}-asset-publishers"
}

resource "aws_iam_user_group_membership" "asset_publishers" {
  user   = aws_iam_user.nullplatform_build_workflow_user.name
  groups = [aws_iam_group.asset_publishers.name]
}
