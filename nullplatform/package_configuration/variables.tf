################################################################################
# The place
################################################################################
variable "nrn" {
  description = "NRN of the place the package is configured for (an organization, account, namespace or application). The package must be installed there or above."
  type        = string
}

variable "package_slug" {
  description = "Slug of the installed package."
  type        = string
}

variable "dimensions" {
  description = "Dimensions of the place, e.g. { environment = \"production\" }. Empty configures everything under nrn."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for key, value in var.dimensions : !can(regex("[,=\\s]", "${key}${value}")) && key != "" && value != ""])
    error_message = "A dimension is a name and a value with no comma, equals sign or space, such as environment = \"production\"."
  }
}

################################################################################
# What the package gets there
################################################################################
variable "agent" {
  description = "Tags of the agent that serves this place, the same given to the agent as tags_selectors, e.g. { cluster = \"prod-eks\" }. Two places on one cluster give the same tags. Empty creates no channel: right for a package with no worker."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for key, value in var.agent : !can(regex("[,=\\s]", "${key}${value}")) && key != "" && value != ""])
    error_message = "An agent tag is a name and a value with no comma, equals sign or space, such as cluster = \"prod-eks\"."
  }
}

variable "values" {
  description = "The package's values for this place, as its configuration form asks for them: a domain, a role ARN, a namespace. A value left out may be made by the package's own post_configure lines, which run only when package_dir is given."
  type        = any
  default     = {}
}

variable "imports" {
  description = "Components already there that this configuration must use instead of creating, by their name in the package's manifest: { channel = \"<id>\" }. Each is used as it is and never written."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for name, id in var.imports : can(regex("^[A-Za-z0-9_./:-]+$", name)) && can(regex("^[A-Za-z0-9_./:-]+$", id))])
    error_message = "An import is a component name and an id made of letters, digits and . _ / : -"
  }
}

################################################################################
# How it runs
################################################################################
variable "package_version" {
  description = "Version of the package that is installed. It is not sent anywhere: when it changes, the configuration runs again, so what the new version's manifest creates on configure is created. Wire it to package_installation's installed_version."
  type        = string
  default     = null
}

variable "package_dir" {
  description = "Directory with the package's files, a checkout at the installed version. When given, the package's post_configure lines run there after the components are created, as whoever runs the apply (with their kubectl context). Null runs none of them."
  type        = string
  default     = null
}

variable "np_api_key" {
  description = "nullplatform API key for `np package configure`. Null uses the NP_API_KEY of the environment running the apply, and then the apply shows what the command did; with a key given here OpenTofu hides the command's output."
  type        = string
  default     = null
  sensitive   = true
}
