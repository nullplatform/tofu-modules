locals {
  is_gitlab    = lower(var.git_provider) == "gitlab"
  is_github    = lower(var.git_provider) == "github"
  is_azure     = lower(var.git_provider) == "azure"
  is_bitbucket = lower(var.git_provider) == "bitbucket"
}
