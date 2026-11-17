variable "nrn" {
  description = "NRN of the publisher organization (e.g. organization=123). The specification, its links, their actions and the package are created here."
  type        = string
}

variable "release_tag" {
  description = "Release tag being published (vX.Y.Z, or vX.Y.Z-<prerelease>). It is the package revision's version, without the v: the same version the worker image is registered with. The release workflow passes it."
  type        = string

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+(-[0-9A-Za-z.-]+)?$", var.release_tag))
    error_message = "release_tag must look like vX.Y.Z or vX.Y.Z-<prerelease>."
  }
}

variable "image_digest" {
  description = "Digest of the worker image this release pushed (sha256:<64 hex>). The revision pins the artifact registered with it."
  type        = string

  validation {
    condition     = can(regex("^sha256:[0-9a-f]{64}$", var.image_digest))
    error_message = "image_digest must look like sha256:<64 hex chars>."
  }
}

variable "image_registry" {
  description = "Registry host of the worker image."
  type        = string
  default     = "public.ecr.aws"
}

variable "image_repository" {
  description = "Repository of the worker image inside the registry (e.g. nullplatform/services/s3)."
  type        = string
}

variable "artifact_name" {
  description = "Name of the image component in the package revision."
  type        = string
  default     = "worker-image"
}

variable "package_slug" {
  description = "Slug of the package, and of the service specification unless service_slug says otherwise. Keep it apart from the slug a copy of this service gets when an organization registers it with service_definition (agent channels route by specification slug): nullplatform's own packages take the np- prefix."
  type        = string
}

variable "service_name" {
  description = "Name of the service specification: what people read."
  type        = string
}

variable "service_slug" {
  description = "Slug of the service specification. Null uses package_slug."
  type        = string
  default     = null
}

variable "service_path" {
  description = "Path of the service inside its repository (e.g. aws-s3-bucket)."
  type        = string
}

variable "local_specs_path" {
  description = "Directory holding the service's specs/ in the checkout being published: the release workflow applies the stack at the release tag, so the revision pins exactly that tag's specs. Usually abspath(\"$${path.module}/..\") from a <service_path>/publish stack."
  type        = string
}

variable "available_links" {
  description = "Link specifications to publish, by template name under specs/links/."
  type        = list(string)
  default     = ["connect"]
}

variable "available_actions" {
  description = "Action specifications written as templates under specs/actions/, by name. Default actions (use_default_actions) need no entry: the platform creates them and the revision pins them."
  type        = list(string)
  default     = []
}

variable "link_slugs" {
  description = "Slug of each link specification, by template name. Omitted links take the slug the platform derives from their name."
  type        = map(string)
  default     = {}
}

variable "visible_to" {
  description = "Who can install the package and see its specification. The default publishes to every organization; only the platform organization may. Another publisher passes its own NRNs."
  type        = list(string)
  default     = ["organization=*"]
}

variable "promote_default" {
  description = "Whether the published revision becomes the package default, what an organization that installs without pinning a version is born with. Null (the default) promotes a stable release and leaves a prerelease (a version with a `-`) where it is; true or false forces it."
  type        = bool
  default     = null
}
