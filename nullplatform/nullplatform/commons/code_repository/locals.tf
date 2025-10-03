locals {
  is_gitlab = lower(var.git_provider) == "gitlab"
  is_github = lower(var.git_provider) == "github"
}