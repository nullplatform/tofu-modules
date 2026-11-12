variable "nrn" {
  description = "NRN of the installing organization where the package is installed (an organization, account, namespace or application). The package is looked up as visible there."
  type        = string
}

variable "package_slug" {
  description = "Slug of the package to install."
  type        = string
}

variable "package_version" {
  description = "Exact semver of the package revision to install (X.Y.Z, without a leading v). New services and scopes are born with it."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.package_version))
    error_message = "package_version must be a semver X.Y.Z, without a leading v."
  }
}

variable "visible_to" {
  description = "Where inside the installing organization the package's specifications are usable: these NRNs and everything below them. Null uses [nrn]. Every entry must be under the installing organization."
  type        = list(string)
  default     = null
}
