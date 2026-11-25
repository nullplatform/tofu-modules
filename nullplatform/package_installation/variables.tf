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

################################################################################
# What the package's manifest creates on install
################################################################################
variable "apply_manifest" {
  description = "Also create what the package's manifest marks \"on\": \"install\", such as a scope type or the form of the package's values, by running `np package install` for this installation. Off by default: a package whose manifest marks nothing needs only the installation. The machine running the apply needs `np` and credentials, and `mise` when the package brings tasks of its own. Destroying the module then also removes what the manifest created."
  type        = bool
  default     = false
}

variable "manifest_imports" {
  description = "With apply_manifest: components already there that the installation must use instead of creating, by their name in the package's manifest, e.g. { scope-type = \"<id>\" }. Each is used as it is and never written."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for name, id in var.manifest_imports : can(regex("^[A-Za-z0-9_./:-]+$", name)) && can(regex("^[A-Za-z0-9_./:-]+$", id))])
    error_message = "An import is a component name and an id made of letters, digits and . _ / : -"
  }
}

variable "run_hooks" {
  description = "With apply_manifest: run the package's own tasks, the components its manifest says a task makes. They run on the machine running the apply, as whoever runs it, with mise, which installs the tools the package declares. False leaves those components out, when installing and when removing."
  type        = bool
  default     = true
}

variable "package_dir" {
  description = "With apply_manifest: directory with the package's files. Only for a package under development: the manifest a published version keeps carries its tasks and their files, so nothing of the package is needed where the apply runs."
  type        = string
  default     = null
}

variable "np_bin" {
  description = "With apply_manifest: the `np` command to run, a path when it is not on the PATH of the machine running the apply."
  type        = string
  default     = "np"
}

variable "np_api_key" {
  description = "With apply_manifest: nullplatform API key for `np package install`. Null uses the NP_API_KEY of the environment running the apply, and then the apply shows what the command did; with a key given here OpenTofu hides the command's output."
  type        = string
  default     = null
  sensitive   = true
}
