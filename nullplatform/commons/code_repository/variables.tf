variable "group_path" {
  type = string

}

variable "access_token" {
  type      = string
  sensitive = true

}

variable "installation_url" {
  type = string

}

variable "np_api_key" {
  type      = string
  sensitive = true

}
variable "nrn" {
  type = string

}

variable "collaborators_config" {
  type = object({
    collaborators = list(object({
      id   = string
      role = string
      type = string
    }))
  })
}

variable "gitlab_repository_prefix" {
  type = string

}
variable "gitlab_name" {
  type = string

}

variable "repository_provider" {
  type = string

}
variable "gitlab_slug" {
  type = string

}

variable "git_provider" {
  type        = string
  description = "gitlab or github"
}
variable "organization" {
  type    = string
  default = ""

}
variable "organization_installation_id" {
  type    = string
  default = ""

}