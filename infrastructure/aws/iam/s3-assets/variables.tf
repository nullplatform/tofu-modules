variable "cluster_name" {
  description = "Name of the cluster, used to namespace IAM resource names"
  type        = string
}

variable "build_workflow_group_name" {
  description = "Name of the IAM group (from the ci-build-workflow-user module) to which the S3 assets policy is attached. The build workflow user is a member of this group."
  type        = string
}

variable "assets_bucket" {
  description = "Name of the S3 bucket where build assets (e.g. Lambda zips) are published. The bucket is managed elsewhere; this module only grants the build workflow group permission to write to it."
  type        = string
}
