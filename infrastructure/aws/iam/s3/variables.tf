variable "cluster_name" {
  description = "Name of the cluster, used to namespace IAM resource names"
  type        = string
}

variable "build_workflow_group_name" {
  description = "Name of the IAM group (from the ci-build-workflow-user module) to which the S3 assets policy is attached. The build workflow user is a member of this group. Set this, build_workflow_role_name, or both while migrating from access keys to the role."
  type        = string
  default     = null
}

variable "build_workflow_role_name" {
  description = "Name of the IAM role (from the ci-build-workflow-role module) to which the S3 assets policy is attached. Set this, build_workflow_group_name, or both while migrating from access keys to the role."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the S3 bucket where build assets (e.g. Lambda zips) are published. The bucket is managed elsewhere; this module only grants the build workflow group permission to write to it."
  type        = string
}
